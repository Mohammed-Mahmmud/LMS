# Architecture — Instructor Revenue Ledger

## 1. The problem in one paragraph

Students pay upfront for 1, 3 or 12 months. Instructors are paid a share of that money based on what
students actually watched, after the platform takes its cut. Money is paid out through an external
provider that times out, fails, and sends webhooks late, twice, or out of order. At any moment we must
be able to answer, to the cent: **how much has each instructor earned, how much have we paid them, how
much is on its way, and how much do we still owe?** Refunds can arrive at any time, including after
the instructor has already been paid.

## 2. Core decisions

| Decision | Why |
|---|---|
| **Append-only ledger** (`ledger_entries`), balances = `SUM(amount_cents)` | History is never rewritten. Every number on screen can be traced to entries, and corrections (refunds, reversals) are new rows. The model refuses updates and deletes. |
| **Integer cents everywhere**, largest-remainder rounding (`App\Support\Money`) | No floats. Every split sums *exactly* to its total, and leftover cents go deterministically to the largest remainders. |
| **Deterministic idempotency key on every entry** (unique index) | Re-running any operation (allocator, refund, webhook, retry) can never post the same movement twice. |
| **Revenue is recognised per elapsed month** | Viewing is only known once the month is over, and an annual plan isn't earned on day 1. Upfront cash ≠ earned revenue. |
| **Payout money is reserved at request time** | The debit is posted in the same transaction as the payout row, under a lock on the instructor, so it can't be paid twice. A failure credits it back. |
| **Idempotency key sent to the provider on every attempt** | Retrying after a timeout either finds the original transfer or creates it, never a second one. |
| **One state machine for all provider input** (`PayoutService::transition`) | API responses, webhooks and reconciliation all go through the same guarded, locked, idempotent transition. |
| **Snapshots on the subscription** (`amount_cents`, `platform_fee_bps`, `periods`) | Changing plan prices or the platform fee later never changes what past subscriptions owe. |

## 3. Data model

```
instructors ─< courses ─< watch_sessions >─ students ─< subscriptions >─ plans
     │                                                      │
     │                                   ┌──────────────────┼───────────────┐
     │                          revenue_allocations       refunds            │
     │                         (one row per period,     (unearned vs         │
     │                          unique sub+period)       clawback split)     │
     │                                   │                  │                │
     └──────────────< ledger_entries >───┴──────────────────┴────────────────┘
     │                 (append-only; instructor_id NULL = platform account)
     └─< payouts ─────────┘
          │  idempotency_key (uuid, unique) ──► provider
          └─ provider_webhook_events (unique event_id: dedupe)

mock_provider_transfers  ← belongs to the simulated provider, not to us
```

### Ledger entry types

| Type | Account | Sign | Posted when |
|---|---|---|---|
| `instructor_earning` | instructor | + | a period is allocated |
| `platform_fee` | platform | + | a period is allocated |
| `unattributed_revenue` | platform | + | a period is allocated but the student watched nothing |
| `refund_clawback` | instructor / platform | − | a refund exceeds the revenue not yet earned |
| `payout_debit` | instructor | − | a payout is requested (or a late success re-debits) |
| `payout_reversal` | instructor | + | a payout fails or is returned |

### The four numbers on the Filament screen

```
Earned (net)  = Σ instructor_earning + Σ refund_clawback
Paid out      = Σ payouts where status = succeeded
In flight     = Σ payouts where status ∈ {pending, processing}
Owed now      = Σ all ledger entries for the instructor

Invariant:  Earned (net) = Paid out + In flight + Owed now
```

The invariant holds by construction, because every payout movement is also a ledger entry. The chaos test checks it
after hundreds of random provider outcomes.

## 4. Revenue allocation (`App\Ledger\RevenueAllocator`)

For a subscription of `N` months costing `A`:

1. Split `A` into `N` period amounts (`Money::split`, so 10000/3 → 3334, 3333, 3333).
2. A period `k` covers `[start + k months, start + k+1 months)`. It is allocated **only after it ends**.
3. `fee = floor(gross × fee_bps / 10000)`, `pool = gross − fee`.
4. The pool is split between instructors **in proportion to the seconds the student watched their
   courses during that period** (largest remainder).
5. If the student watched nothing, the pool goes to the platform as `unattributed_revenue`.
6. Guarded by `UNIQUE(subscription_id, period_index)` and a row lock on the subscription, so running it
   twice, concurrently, or after a crash is harmless. It is scheduled hourly (`ledger:allocate`).

Per-subscription invariant (checked in tests): `Σ entries linked to the subscription = amount − refunded`.

## 5. Refunds (`App\Ledger\RefundService`)

A refund arrives with the provider's idempotency key and an amount. Under a lock on the subscription:

1. **Catch up**: allocate every period that already fully elapsed, because that money was earned.
2. `unearned = amount − allocated − previously refunded unearned`.
3. The refund is covered **first by unearned revenue** (no instructor is affected).
4. The unearned money the student **keeps paying for** (e.g. the used half of the current month) is
   allocated immediately as a **settlement period** (period start → refund time), by viewing in that window.
5. Anything beyond the unearned part is a **clawback**. The platform gives back its fee ratio, and
   instructors give back the rest in proportion to what they earned from that subscription (never more
   than they earned from it).
6. The subscription becomes `refunded` and no further revenue is recognised.

A clawback after the instructor was already paid leaves a **negative balance**. It is recovered from future
earnings, and no payout can be created until the balance is positive and above the minimum again. We
never try to pull money back from the instructor's bank.

## 6. Payouts

### Lifecycle

```
             request()                submit()
 (balance) ──────────► PENDING ─────────────► PROCESSING ──► SUCCEEDED
  debit posted,          │                        │              │
  money reserved         │                        ▼              │ provider returns funds
                         └──────────────────►  FAILED  ◄─────────┘ (reversal credit)
                                                  │
                                                  └──► SUCCEEDED  (late success: re-debit)
```

* `request()` locks the instructor row, checks `amount ≤ balance` and `≥ minimum`, and creates the payout
  with a fresh UUID idempotency key. It posts `payout_debit` in the **same transaction**, then queues
  `ProcessPayout` after commit.
* `ProcessPayout` (6 tries, backoff 10s→5min, `WithoutOverlapping` per payout) calls `submit()`:
  * success or failure in the response → `transition()`
  * `processing` → keep waiting for the webhook
  * **timeout** → outcome unknown. **Never marked failed.** The exception is rethrown and the retry sends the
    **same idempotency key**, so the provider returns the original transfer if it exists.
  * **503** → rethrown, retried.
  * **4xx rejected** → failed, money credited back.
  * payout already terminal → nothing is sent (protects against duplicated jobs).
* If all retries fail, the payout stays `processing` and `payouts:reconcile` (every 10 minutes) asks the
  provider `findTransfer(idempotencyKey)`:
  * found → apply its status
  * not found and never submitted → re-dispatch
  * not found after submission → failed, money credited back. If a straggling request lands later anyway,
    its success webhook moves `failed → succeeded` and **re-debits**. The books are right either way.

### `transition()` guarantees

* Runs in a transaction with `SELECT … FOR UPDATE` on the payout.
* **Idempotent**: the same status twice is a no-op.
* **Rejects illegal moves** (e.g. `succeeded → processing`).
* **Ignores stale events**: if `occurred_at` is older than the last provider status we applied
  (`provider_updated_at`), the event is dropped. Out-of-order webhooks can't undo newer state.
* Ledger postings use keys `payout:{id}:entry:{n}`, so a transition can't post twice.

### Webhooks

`POST /webhooks/payment-provider`

1. HMAC-SHA256 signature over the raw body (`X-Provider-Signature`), constant-time comparison, `401` otherwise.
   CSRF is disabled for this route only.
2. `INSERT IGNORE` into `provider_webhook_events` on the unique `event_id` makes duplicates, including
   concurrent ones, a no-op. An event is only skipped if it was *processed*, so a crash mid-processing is
   retried on the provider's next delivery.
3. Routed through `transition()`, so ordering and idempotency are handled in one place.
4. Unknown payouts are acknowledged with `200` and logged, so the provider doesn't retry forever.

## 7. Failure scenarios and where they are tested

| Scenario | What happens | Pest test (`tests/Feature`) |
|---|---|---|
| Allocator runs twice / concurrently | Unique `(subscription, period)` + lock → no-op | RevenueAllocationTest › *changes nothing when the allocator runs again* |
| Timeout **after** provider paid | Stays processing, retry with same key returns the original transfer | PayoutTest › *does not pay twice when the provider paid but the response timed out* |
| Timeout before / 503 | Retried with the same key, one transfer total | PayoutTest › *retries safely when the request never reached the provider* |
| Duplicated job | Terminal payouts are not resubmitted | PayoutTest › *never resubmits a finished payout* |
| Provider declines | Failed + reversal, once, even with the failure webhook | PayoutTest › *returns the money to the instructor when the provider declines* |
| Success only via webhook | Processing → succeeded on webhook | PayoutTest › *completes an async success by webhook* |
| Duplicate webhook | Stored once, applied once | PayoutTest › *processes duplicate webhooks once*; WebhookEndpointTest › *applies a signed webhook and ignores its duplicate* |
| Out-of-order webhook / stale API response | Ignored via `provider_updated_at` | PayoutTest › *ignores stale events arriving out of order* |
| Funds returned after success | Reversal credit | PayoutTest › *credits back funds returned after a success* |
| Job gave up, provider has the transfer | Reconcile → succeeded | PayoutTest › *reconciles a payout whose response was lost as succeeded* |
| Job gave up, provider has nothing, straggler lands later | Reconcile → failed/credited, then late success re-debits | PayoutTest › *fails a payout the provider never received, and re-debits if a late success lands* |
| Two payout requests racing for one balance | Instructor row lock, second fails | PayoutTest › *cannot pay out more than the balance, even across requests* |
| Refund after payout | Negative balance, payouts blocked | RefundTest › *leaves a negative balance that blocks payouts when a refund follows a payout* |
| Refund delivered twice | Same refund returned, no new entries | RefundTest › *applies the same refund only once* |
| Everything at once, random | Earned = owed + actually transferred, for every instructor | PayoutTest › *conserves money under random provider behaviour* |
| Forged webhook | 401, nothing stored | WebhookEndpointTest › *rejects unsigned or forged webhooks* |

## 8. Assumptions (rules the brief left open, on purpose)

1. **Revenue share basis** = watch time per instructor, per student, per month. It's fair to instructors
   who keep students engaged, and hard to game compared with "courses opened".
2. **Platform fee** = 30% (configurable), snapshotted per subscription and rounded down (the extra cent
   goes to the instructor pool).
3. **No viewing in a month** → the pool stays with the platform (recorded as `unattributed_revenue`, so it's
   visible and could be redistributed later if the business decides to).
4. **Revenue is earned when the month ends**, not at purchase.
5. **Refunds** end the subscription, come out of unearned revenue first, and claw back from earnings only
   beyond that. The unrefunded part of the current month is settled immediately by viewing.
6. **Negative balances** are allowed and recovered from future earnings. No reverse payouts.
7. **Minimum payout** = 10.00. One currency (USD).
8. **The provider is the source of truth** for whether money moved. Our records follow it, never the reverse.
9. A payout pays the **full balance** by default. An operator can choose a smaller amount.

## 9. Idempotency approach

Every operation that moves money can safely run more than once:

| Layer | Mechanism |
|---|---|
| Ledger | Every entry has a deterministic `idempotency_key` with a unique index (`allocation:{id}:instructor:{id}`, `refund:{id}:platform`, `payout:{id}:entry:{n}`). The `Ledger::post()` call uses `firstOrCreate` on that key. |
| Allocation | `UNIQUE(subscription_id, period_index)`, plus a `FOR UPDATE` lock on the subscription and a re-check inside the transaction. |
| Refunds | `refunds.idempotency_key` (the provider's refund id) is unique. A replay returns the original refund. |
| Payout creation | Balance check and debit happen in one transaction under a lock on the instructor row, so two requests can't spend the same balance. |
| Provider call | The payout's UUID `idempotency_key` is sent on **every** attempt, and the provider returns the existing transfer for a known key. |
| Queue job | Terminal payouts are skipped, and `WithoutOverlapping` per payout prevents two workers submitting at once. |
| Webhooks | Unique `event_id` (`INSERT IGNORE`), plus an idempotent state machine that ignores stale events. |

## 10. Provider timeout handling

A timeout means **"we don't know"**, not "it failed". Marking it failed and crediting the instructor
would risk paying twice. So:

1. The payout stays `processing` and the money stays reserved. `last_error` records the timeout.
2. The exception is rethrown, and the queue retries with backoff (10s, 30s, 1m, 2m, 5m) using the **same idempotency key**.
   * If the first request did reach the provider, the retry gets the original transfer back, and there's still only one transfer.
   * If it didn't, the retry creates it.
3. If every retry times out, the job gives up **without** failing the payout. `payouts:reconcile` (every 10 minutes)
   calls `findTransfer(key)` and applies whatever the provider says. The payout is only failed and credited back when
   the provider confirms it has no record of the transfer.
4. If a delayed request still lands after that, its success webhook moves the payout `failed → succeeded` and
   re-debits, so the books match reality either way.

The "timeout after the provider paid" case is the dangerous one. It's covered by
the Pest tests *does not pay twice when the provider paid but the response timed out* and *reconciles a payout whose response was lost as succeeded*.

## 11. Scaling considerations

* **Balances are computed with `SUM()`** over indexed `(instructor_id, type)`. That's fine to millions of rows. Beyond that,
  I'd add a `instructor_balances` projection updated in the same transaction as each entry, keeping the ledger as the source of truth
  so the projection can always be rebuilt.
* **The allocator** works in chunks (`chunkById(200)`) with a short transaction per period, so it never holds long locks.
  It can be sharded by subscription id across workers, because the unique constraint makes overlap harmless.
* **Webhooks** are processed inside the request. At volume: store and acknowledge `200` immediately, then process from a queue
  (the `processed_at` column already supports this).
* **Payouts** run as independent queue jobs, so throughput scales with workers. The provider's rate limits are the real ceiling,
  and Laravel's `RateLimited` job middleware would enforce them.
* **Hot rows**: the locks are per instructor and per subscription, never global, so contention stays local.
* `ledger_entries` can be partitioned by month in MySQL. Old partitions are read-only anyway.

## 12. Known limitations

* **Laravel 11 is end-of-life** (required by the brief). Two unpatched framework advisories are explicitly ignored in
  `composer.json`, and neither affected feature (email built from user input, temporary signed URLs) is used here. See README › Security note.
  The upgrade path is a supported Laravel release, with no domain code changes.
* **Single-entry ledger with a platform account**, not full double-entry (cash, receivables, payables). It's enough to prove
  conservation here. With a finance team I'd move to proper double-entry and add a clearing account for the provider.
* **Monthly periods**, not daily proration. Simpler to explain. Daily granularity would be a change to `periodStart/periodEnd`.
* **Single currency** (USD). No tax withholding (1099/VAT), no per-instructor revenue-share overrides.
* **Reconciliation is per payout.** A daily full match against the provider's settlement report would also catch webhooks
  we never received for payouts we believe are finished.
* **Instructors without a payout account** accumulate a balance until they connect one.
* **Negative balances** are only recovered from future earnings. There's no collection process if an instructor stops earning.
* **The mock provider shares our database** (its own table) and delivers webhooks in-process rather than over HTTP. The HTTP
  endpoint and its signature check are tested separately.
* No audit log of operator actions in the admin panel, and no role-based permissions. Every admin user can trigger payouts.

## 13. Senior bonus — a student changing plans mid-term (discussion only, not built)

**Example:** a student bought Monthly-Basic, or is 4.5 months into an Annual plan, and upgrades to a
more expensive plan.

### How the current design copes

The pieces are already here, because an upgrade is essentially **"end the old subscription early without
paying cash back, and use its unearned value as a credit on the new one."** That is the refund
flow with the refund going to a **credit** instead of the card.

1. **Lock and catch up** the old subscription: allocate every fully elapsed month (earned money stays earned).
2. **Settle the partial month** exactly like a refund settlement. The used share of the current month
   (by time: `(t − periodStart) / periodLength × periodGross`) is allocated now, by what the student watched
   between the period start and the switch.
3. **Credit** `C = amount − allocated − settled`, which is the value of the unused time. The old subscription
   gets status `switched` and `switched_out_cents = C`. Nothing already allocated or paid changes, and no
   clawback happens because the student isn't getting money back.
4. **New subscription**, priced for its term with a fresh fee snapshot: `amount_cents = P_new`,
   `credit_cents = C`, charged `P_new − C` to the card. Revenue recognition runs on the full `P_new`,
   so instructors are paid on the whole value of the new plan going forward, and the old money is
   neither lost nor double-counted.
5. **Conservation still holds**: old = allocated + switched_out, new = paid + credit, and ledger
   totals equal cash in minus cash refunded.

### Schema additions

* `subscriptions`: `previous_subscription_id`, `credit_cents`, `switched_out_cents`, status `switched`.
* `plan_changes`: `from_subscription_id`, `to_subscription_id`, `credit_cents`, `charged_cents`,
  `effective_at`, `idempotency_key` (unique, so a double-clicked upgrade or a retried payment webhook applies once).

### Edge cases to agree with the business

* **Downgrade where credit > new price**: carry the excess as a student wallet balance (a new
  `student_credit` account in the ledger) or refund it through the existing refund path.
* **Charge for the difference fails**: the plan change stays `pending` and the old subscription keeps running.
  Switch only when the payment succeeds (same idempotent pattern as payouts).
* **Refund after an upgrade**: cash is refundable up to `charged_cents`. The credit part goes back to the
  old subscription's unearned bucket, or is forfeited. This is a policy decision, and the ledger supports either.
* **Proration basis**: time-based (above) is standard and predictable. Usage-based proration ("you
  watched a lot this month") is possible with the same data but harder to explain to students.
* **Fee changes**: the new subscription snapshots the current fee. The old one keeps its original fee.
