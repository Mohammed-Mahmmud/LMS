<?php

namespace App\Ledger;

use App\Enums\LedgerEntryType;
use App\Enums\SubscriptionStatus;
use App\Models\LedgerEntry;
use App\Models\Refund;
use App\Models\Subscription;
use App\Support\Money;
use Carbon\CarbonImmutable;
use Illuminate\Support\Facades\DB;
use InvalidArgumentException;

/**
 * Refund policy:
 *
 * 1. Any period that fully elapsed before the refund is allocated first — that money was earned.
 * 2. A refund ends the subscription. The refund is covered first by revenue not yet earned.
 * 3. Unearned money the student does NOT get back is recognised straight away as a final
 *    "settlement" period (last allocated period end -> refund time), split by what was watched.
 * 4. If the refund is bigger than the unearned revenue, the difference is clawed back from
 *    earnings already allocated for this subscription: platform keeps its fee ratio, and
 *    instructors give back in proportion to what they earned from it. An instructor balance
 *    may go negative; it is recovered from future earnings before any new payout.
 */
class RefundService
{
    public function __construct(
        private readonly Ledger $ledger,
        private readonly RevenueAllocator $allocator,
    ) {}

    public function refund(Subscription $subscription, int $amountCents, string $idempotencyKey, ?string $reason = null): Refund
    {
        return DB::transaction(function () use ($subscription, $amountCents, $idempotencyKey, $reason) {
            $subscription = Subscription::query()->lockForUpdate()->findOrFail($subscription->id);

            if ($existing = Refund::where('idempotency_key', $idempotencyKey)->first()) {
                return $existing;
            }

            $refundable = $subscription->amount_cents - $subscription->refunded_cents;

            if ($amountCents <= 0 || $amountCents > $refundable) {
                throw new InvalidArgumentException(
                    "Refund of {$amountCents} is invalid; refundable amount is {$refundable}."
                );
            }

            $now = CarbonImmutable::now();

            // (1) Recognise everything already earned before we compute what is unearned.
            if ($subscription->status === SubscriptionStatus::Active) {
                $this->allocator->allocateSubscription($subscription, $now);
            }

            $unearned = $subscription->amount_cents
                - (int) $subscription->allocations()->sum('gross_cents')
                - (int) $subscription->refunds()->sum('unearned_cents');

            $fromUnearned = min($amountCents, $unearned);
            $clawback = $amountCents - $fromUnearned;

            $refund = Refund::create([
                'subscription_id' => $subscription->id,
                'idempotency_key' => $idempotencyKey,
                'amount_cents' => $amountCents,
                'unearned_cents' => $fromUnearned,
                'clawback_cents' => $clawback,
                'reason' => $reason,
            ]);

            // (3) Settle the kept part of the current, partially used period.
            $kept = $unearned - $fromUnearned;

            if ($kept > 0) {
                $nextIndex = $subscription->allocations()->max('period_index');
                $nextIndex = $nextIndex === null ? 0 : $nextIndex + 1;
                $from = $subscription->periodStart($nextIndex);

                $this->allocator->allocatePeriod($subscription, $nextIndex, $from, $now->max($from), $kept, isSettlement: true);
            }

            // (4) Claw back from already allocated earnings.
            if ($clawback > 0) {
                $this->clawBack($subscription, $refund, $clawback);
            }

            $subscription->update([
                'status' => SubscriptionStatus::Refunded,
                'refunded_cents' => $subscription->refunded_cents + $amountCents,
                'refunded_at' => $subscription->refunded_at ?? $now,
            ]);

            return $refund;
        });
    }

    private function clawBack(Subscription $subscription, Refund $refund, int $clawbackCents): void
    {
        $instructorPart = $clawbackCents - intdiv($clawbackCents * $subscription->platform_fee_bps, 10_000);

        $earnedByInstructor = LedgerEntry::query()
            ->where('subscription_id', $subscription->id)
            ->whereNotNull('instructor_id')
            ->whereIn('type', LedgerEntryType::earningTypes())
            ->groupBy('instructor_id')
            ->orderBy('instructor_id')
            ->selectRaw('instructor_id, SUM(amount_cents) as total')
            ->pluck('total', 'instructor_id')
            ->map(fn ($total) => (int) $total)
            ->filter(fn ($total) => $total > 0)
            ->all();

        // Never take back more from instructors than they earned from this subscription.
        $fromInstructors = min($instructorPart, array_sum($earnedByInstructor));
        $links = ['subscription_id' => $subscription->id, 'refund_id' => $refund->id];

        foreach (Money::allocate($fromInstructors, $earnedByInstructor) as $instructorId => $cents) {
            if ($cents > 0) {
                $this->ledger->post((int) $instructorId, LedgerEntryType::RefundClawback, -$cents, "refund:{$refund->id}:instructor:{$instructorId}", $links);
            }
        }

        $fromPlatform = $clawbackCents - $fromInstructors;

        if ($fromPlatform > 0) {
            $this->ledger->post(null, LedgerEntryType::RefundClawback, -$fromPlatform, "refund:{$refund->id}:platform", $links);
        }
    }
}
