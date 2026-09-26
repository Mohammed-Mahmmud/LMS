# Instructor Revenue Ledger

A Laravel 11 + Filament v3 back office that turns student subscription payments into instructor
earnings, pays instructors through an unreliable payment provider, and always knows, to the cent,
what each instructor has **earned**, been **paid**, has **in flight**, and is still **owed**.

* Design, allocation strategy, idempotency, timeout handling, scaling, limitations: **[docs/ARCHITECTURE.md](docs/ARCHITECTURE.md)**
* How AI was used: **[docs/AI_USAGE.md](docs/AI_USAGE.md)**

## Tech stack

| Brief | Used |
|---|---|
| Laravel 11 | Laravel **11.56.1** (see the [security note](#security-note-laravel-11)) |
| Livewire v3 | Livewire **3.8.9** |
| Alpine.js | Alpine.js (bundled with Livewire/Filament) |
| Filament v3 | Filament **3.3.55** |
| Pest for testing | Pest **3.8** (+ Laravel and Livewire plugins) |
| MySQL | MySQL 8 (tests run on in-memory SQLite by default, and also pass on MySQL) |
| Docker (optional) | `docker compose` with app, queue worker, scheduler and MySQL |

PHP 8.2+, database queue driver.

## Setup

### Option A: Laragon / local PHP

```bash
composer install
cp .env.example .env        # MySQL database "lms", root with no password (Laragon default)
php artisan key:generate
php artisan migrate --seed  # creates the admin user + a year of demo data
```

On Laragon, click **Reload** so `http://lms.test` is created, then open **http://lms.test/admin**.
Without Laragon, run `php artisan serve` and open http://127.0.0.1:8000/admin.

Payouts and provider webhooks run on the queue, and allocation and reconciliation run on the scheduler:

```bash
php artisan queue:work        # processes payouts + simulated provider webhooks
php artisan schedule:work     # hourly allocation, 10-minute reconciliation, monthly payout run
```

### Option B: Docker

```bash
docker compose up -d --build
```

Open **http://localhost:8000/admin**. The `app` container migrates and seeds on first start, and `queue`
and `scheduler` run the background processes. MySQL is internal to the compose network, so it doesn't clash
with a local MySQL. `docker compose down -v` removes everything, including the database.

### Login

`admin@lms.test` / `Career180@Ledger` (override with `ADMIN_EMAIL` / `ADMIN_PASSWORD` before seeding).

## How to run tests

```bash
./vendor/bin/pest            # or: composer test / php artisan test
```

66 Pest tests / 168 assertions:

| File | Covers |
|---|---|
| `tests/Unit/MoneyTest.php` | largest-remainder allocation, exact sums (randomised dataset), invalid input |
| `tests/Feature/RevenueAllocationTest.php` | fee + watch-time split, only elapsed months, no-viewing months, idempotent re-runs, uneven splits |
| `tests/Feature/RefundTest.php` | prorated refund + settlement, full refund clawback, refund after payout (negative balance), duplicate refunds, over-refunds |
| `tests/Feature/PayoutTest.php` | reservation, double-spend, timeout after/before payment, 503, duplicate jobs, declines, async webhooks, duplicate and out-of-order webhooks, returned funds, reconciliation, late success, **chaos test** |
| `tests/Feature/WebhookEndpointTest.php` | HMAC signature, duplicate events, unknown payouts |
| `tests/Feature/InstructorScreenTest.php` | Filament screen: auth, balances, view page, Pay out action, visibility rule |

The **chaos test** runs dozens of payouts against a randomly failing provider (timeouts, declines, duplicate
and shuffled webhooks), then asserts for every instructor that *earned = still owed + actually transferred*.

To run the suite on MySQL instead of SQLite, point it at a scratch database (it will be wiped):
`DB_CONNECTION=mysql DB_DATABASE=lms_testing ./vendor/bin/pest`

## Assumptions made

The brief left several rules open on purpose. These are the decisions I made. The reasoning is in
[docs/ARCHITECTURE.md §8](docs/ARCHITECTURE.md).

1. Instructors are paid **by watch time**: each month, a student's money is split between instructors in
   proportion to the seconds that student watched their courses.
2. The platform takes **30%** (configurable), snapshotted on each subscription at purchase.
3. Revenue is **earned month by month, once the month ends**. An annual plan is not earned on day 1.
4. If a student watches nothing in a month, that month's pool **stays with the platform** (recorded as `unattributed_revenue`).
5. A refund **ends the subscription**, is covered first by revenue not yet earned, and only beyond that
   is **clawed back** from instructors, in proportion to what they earned from that subscription.
6. Clawbacks after a payout can leave an instructor **negative**. That's recovered from future earnings, not reversed at the bank.
7. Minimum payout is **10.00 USD**, single currency, full balance by default.
8. The **payment provider is the source of truth** for whether money moved.

## Commands

| Command | What it does |
|---|---|
| `php artisan ledger:allocate` | Recognise revenue for every elapsed subscription month (idempotent) |
| `php artisan ledger:refund {subscription} {amount_cents} [--key=] [--reason=]` | Refund part or all of a subscription |
| `php artisan payouts:run` | Request a full-balance payout for every eligible instructor |
| `php artisan payouts:reconcile [--minutes=15]` | Ask the provider about payouts stuck in pending/processing |

## The mock payment provider

`App\Payments\MockPaymentProvider` implements the same `PaymentProvider` interface a real adapter
would. It honours idempotency keys and misbehaves on purpose:

| Scenario | Behaviour |
|---|---|
| `success` | Pays immediately, webhook follows |
| `async_success` / `async_failure` | Answers "processing", the result arrives only by webhook |
| `decline` | Fails immediately |
| `timeout_before` | Times out, never received the request |
| `timeout_after` | **Paid**, but the response is lost |
| `duplicate_webhook` | Pays, sends the webhook twice |
| `unavailable` | 503 |

`PAYMENT_PROVIDER_MOCK_SCENARIO=random` (default) picks scenarios by weight (`config/payments.php`).
Set a single scenario name to force it, e.g. `PAYMENT_PROVIDER_MOCK_SCENARIO=timeout_after`.

The real webhook endpoint is `POST /webhooks/payment-provider`, signed with HMAC-SHA256 in the
`X-Provider-Signature` header (`PAYMENT_PROVIDER_WEBHOOK_SECRET`).

## Security note: Laravel 11

The brief requires Laravel 11, which reached end of life in March 2026. Every 11.x release, including the
latest (11.56.1), is affected by two advisories that were only fixed in Laravel 12.60+/13.10+:

* CRLF injection in the default `email` validation rule (CVE-2026-48019)
* temporary signed URL path confusion

Composer blocks packages with known advisories, so `composer.json` ignores exactly these advisory IDs
(`config.audit.ignore`, with the reason recorded) and pins `laravel/framework: ^11.56`, so no older,
more vulnerable 11.x release can be installed. Every other advisory is still enforced.

**Impact here:** this app doesn't send email built from user input, and it doesn't use temporary signed URLs.
In production I would upgrade to Laravel 12. The domain code needs no changes for that, and it was originally
built and tested on Laravel 12.

## Where things are

```
app/
  Ledger/          Ledger (the only writer), RevenueAllocator, RefundService
  Payments/        PaymentProvider interface, MockPaymentProvider, PayoutService (state machine),
                   ProviderWebhookProcessor, DTOs and exceptions
  Jobs/            ProcessPayout (retries), DeliverMockWebhook
  Http/Controllers/Webhooks/PaymentProviderWebhookController.php
  Filament/Resources/InstructorResource.php (+ Pages/, RelationManagers/)   the balances screen
  Filament/Support/RequestPayout.php         the Pay out action (table row + page header)
  Support/Money.php                          integer money + largest-remainder allocation
config/ledger.php, config/payments.php
database/migrations/2026_09_26_*             schema
routes/console.php                           commands + schedule
tests/Unit, tests/Feature                    Pest
Dockerfile, docker-compose.yml, docker/entrypoint.sh
```
