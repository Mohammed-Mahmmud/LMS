<?php

namespace App\Payments;

use App\Enums\LedgerEntryType;
use App\Enums\PayoutStatus;
use App\Jobs\ProcessPayout;
use App\Ledger\Ledger;
use App\Models\Instructor;
use App\Models\Payout;
use App\Payments\Exceptions\ProviderRejectedException;
use App\Payments\Exceptions\ProviderTimeoutException;
use App\Payments\Exceptions\ProviderUnavailableException;
use Carbon\CarbonImmutable;
use Carbon\CarbonInterface;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Str;

/**
 * Payout lifecycle:
 *
 *   request()   locks the instructor, checks the balance and debits the ledger immediately
 *               (the money is reserved, so a second request cannot spend it again).
 *   submit()    sends the transfer with the payout's idempotency key. Timeouts are rethrown so
 *               the queue retries with the SAME key — the provider can never pay twice.
 *   transition() is the single state machine used by API responses, webhooks and reconciliation.
 *               A failure credits the money back; a late success re-debits it.
 */
class PayoutService
{
    public function __construct(
        private readonly PaymentProvider $provider,
        private readonly Ledger $ledger,
    ) {}

    public function request(Instructor $instructor, ?int $amountCents = null): Payout
    {
        $payout = DB::transaction(function () use ($instructor, $amountCents) {
            $instructor = Instructor::query()->lockForUpdate()->findOrFail($instructor->id);

            if (blank($instructor->payout_account)) {
                throw PayoutException::missingPayoutAccount();
            }

            $balance = $instructor->balanceCents();
            $amountCents ??= $balance;
            $minimum = (int) config('ledger.min_payout_cents');

            if ($amountCents < $minimum) {
                throw PayoutException::belowMinimum($amountCents, $minimum);
            }

            if ($amountCents > $balance) {
                throw PayoutException::insufficientBalance($amountCents, $balance);
            }

            $payout = Payout::create([
                'instructor_id' => $instructor->id,
                'amount_cents' => $amountCents,
                'status' => PayoutStatus::Pending,
                'idempotency_key' => (string) Str::uuid(),
                'requested_at' => now(),
            ]);

            $this->ledger->post($instructor->id, LedgerEntryType::PayoutDebit, -$amountCents, "payout:{$payout->id}:debit", [
                'payout_id' => $payout->id,
            ]);

            return $payout;
        });

        ProcessPayout::dispatch($payout->id);

        return $payout;
    }

    /**
     * @throws ProviderTimeoutException|ProviderUnavailableException rethrown so the job retries
     */
    public function submit(Payout $payout): void
    {
        $payout = DB::transaction(function () use ($payout) {
            $payout = Payout::query()->lockForUpdate()->findOrFail($payout->id);

            if ($payout->status->isTerminal()) {
                return null;
            }

            $payout->update([
                'status' => PayoutStatus::Processing,
                'attempts' => $payout->attempts + 1,
                'submitted_at' => $payout->submitted_at ?? now(),
            ]);

            return $payout;
        });

        if ($payout === null) {
            return;
        }

        $request = new TransferRequest(
            idempotencyKey: $payout->idempotency_key,
            destination: (string) $payout->instructor->payout_account,
            amountCents: (int) $payout->amount_cents,
            currency: config('ledger.currency'),
        );

        try {
            $result = $this->provider->createTransfer($request);
        } catch (ProviderTimeoutException|ProviderUnavailableException $e) {
            // Outcome unknown (timeout) or not attempted (503). Never mark as failed here:
            // the retry reuses the idempotency key, so it either finds or creates THE transfer.
            Payout::whereKey($payout->id)->update(['last_error' => $e->getMessage()]);

            throw $e;
        } catch (ProviderRejectedException $e) {
            $this->transition($payout, PayoutStatus::Failed, reason: $e->getMessage());

            return;
        }

        $this->applyResult($payout, $result);
    }

    public function applyResult(Payout $payout, TransferResult $result): bool
    {
        $status = match ($result->status) {
            TransferResult::SUCCEEDED => PayoutStatus::Succeeded,
            TransferResult::FAILED => PayoutStatus::Failed,
            default => PayoutStatus::Processing,
        };

        return $this->transition($payout, $status, $result->reference, $result->failureReason, $result->updatedAt);
    }

    /**
     * The one place a payout changes state. Idempotent and safe against stale/out-of-order input.
     */
    public function transition(
        Payout $payout,
        PayoutStatus $to,
        ?string $reference = null,
        ?string $reason = null,
        ?CarbonInterface $occurredAt = null,
    ): bool {
        return DB::transaction(function () use ($payout, $to, $reference, $reason, $occurredAt) {
            $payout = Payout::query()->lockForUpdate()->findOrFail($payout->id);

            if ($reference !== null && $payout->provider_reference === null) {
                $payout->provider_reference = $reference;
            }

            // An event older than the last provider status we applied is stale: ignore it.
            if ($occurredAt && $payout->provider_updated_at && $occurredAt->lessThan($payout->provider_updated_at)) {
                $payout->save();

                return false;
            }

            $from = $payout->status;

            if ($from === $to || ! $from->canTransitionTo($to)) {
                $payout->save();

                return false;
            }

            $sequence = $payout->ledgerEntries()->count();
            $links = ['payout_id' => $payout->id];

            if ($to === PayoutStatus::Failed) {
                // Covers pending/processing -> failed, and succeeded -> failed (funds returned).
                $this->ledger->post($payout->instructor_id, LedgerEntryType::PayoutReversal, (int) $payout->amount_cents, "payout:{$payout->id}:entry:{$sequence}", $links);
            }

            if ($from === PayoutStatus::Failed && $to === PayoutStatus::Succeeded) {
                // We had given the money back, but the transfer did go through. Take it again.
                $this->ledger->post($payout->instructor_id, LedgerEntryType::PayoutDebit, -(int) $payout->amount_cents, "payout:{$payout->id}:entry:{$sequence}", $links);

                Log::warning('Payout succeeded after being marked failed; re-debited instructor.', ['payout_id' => $payout->id]);
            }

            $payout->status = $to;
            $payout->provider_updated_at = $occurredAt ?? $payout->provider_updated_at;
            $payout->completed_at = $to->isTerminal() ? now() : null;
            $payout->last_error = $to === PayoutStatus::Failed ? ($reason ?? 'failed') : $payout->last_error;
            $payout->save();

            return true;
        });
    }

    /**
     * Ask the provider for the truth about a payout we have not heard back about.
     */
    public function reconcile(Payout $payout): void
    {
        $payout = $payout->fresh();

        if ($payout->status->isTerminal()) {
            return;
        }

        $result = $this->provider->findTransfer($payout->idempotency_key);

        if ($result !== null) {
            $this->applyResult($payout, $result);

            return;
        }

        if ($payout->status === PayoutStatus::Pending) {
            // Never sent (e.g. the job was lost): send it now.
            ProcessPayout::dispatch($payout->id);

            return;
        }

        // Submitted, but the provider never received it. Giving the money back is safe: if a
        // straggling retry lands later, its success webhook re-debits via Failed -> Succeeded.
        $this->transition($payout, PayoutStatus::Failed, reason: 'Provider has no record of this transfer.', occurredAt: CarbonImmutable::now());
    }
}
