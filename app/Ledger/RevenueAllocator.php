<?php

namespace App\Ledger;

use App\Enums\LedgerEntryType;
use App\Enums\SubscriptionStatus;
use App\Ledger\Ledger;
use App\Models\RevenueAllocation;
use App\Models\Subscription;
use App\Models\WatchSession;
use App\Support\Money;
use Carbon\CarbonImmutable;
use Carbon\CarbonInterface;
use Illuminate\Support\Facades\DB;

/**
 * Turns subscription money into instructor earnings.
 *
 * - A subscription is split into equal monthly periods (the plan length).
 * - A period is recognised only after it has fully elapsed, so we know what the student watched.
 * - The platform fee comes off first; the rest (the pool) is split between instructors
 *   in proportion to the seconds the student watched their courses during that period.
 * - If the student watched nothing that period, the pool stays with the platform.
 */
class RevenueAllocator
{
    public function __construct(private readonly Ledger $ledger) {}

    /** Allocate every period that has elapsed as of $asOf. Safe to run any number of times. */
    public function allocateDue(?CarbonInterface $asOf = null): int
    {
        $asOf = CarbonImmutable::instance($asOf ?? now());
        $created = 0;

        Subscription::query()
            ->where('status', SubscriptionStatus::Active)
            ->where('starts_at', '<=', $asOf)
            ->chunkById(200, function ($subscriptions) use ($asOf, &$created) {
                foreach ($subscriptions as $subscription) {
                    $created += $this->allocateSubscription($subscription, $asOf);
                }
            });

        return $created;
    }

    public function allocateSubscription(Subscription $subscription, CarbonInterface $asOf): int
    {
        $created = 0;

        for ($index = 0; $index < $subscription->periods; $index++) {
            if ($subscription->periodEnd($index)->greaterThan($asOf)) {
                break;
            }

            $created += DB::transaction(function () use ($subscription, $index) {
                // Serialises with refunds and with other allocator runs for this subscription.
                $locked = Subscription::query()->lockForUpdate()->findOrFail($subscription->id);

                if ($locked->status !== SubscriptionStatus::Active) {
                    return 0;
                }

                if ($locked->allocations()->where('period_index', $index)->exists()) {
                    return 0;
                }

                $gross = Money::split($locked->amount_cents, $locked->periods)[$index];

                $this->allocatePeriod($locked, $index, $locked->periodStart($index), $locked->periodEnd($index), $gross);

                return 1;
            });
        }

        return $created;
    }

    /**
     * Must be called inside a transaction holding a lock on the subscription.
     */
    public function allocatePeriod(
        Subscription $subscription,
        int $index,
        CarbonImmutable $from,
        CarbonImmutable $until,
        int $grossCents,
        bool $isSettlement = false,
    ): RevenueAllocation {
        $feeCents = intdiv($grossCents * $subscription->platform_fee_bps, 10_000);
        $poolCents = $grossCents - $feeCents;

        $watchedSeconds = $this->watchedSecondsByInstructor($subscription->student_id, $from, $until);
        $instructorShares = Money::allocate($poolCents, $watchedSeconds);
        $instructorTotal = array_sum($instructorShares);

        $allocation = RevenueAllocation::create([
            'subscription_id' => $subscription->id,
            'period_index' => $index,
            'period_starts_at' => $from,
            'period_ends_at' => $until,
            'gross_cents' => $grossCents,
            'platform_cents' => $grossCents - $instructorTotal,
            'instructor_cents' => $instructorTotal,
            'is_settlement' => $isSettlement,
        ]);

        $links = ['subscription_id' => $subscription->id, 'revenue_allocation_id' => $allocation->id];
        $key = "allocation:{$allocation->id}";

        if ($feeCents > 0) {
            $this->ledger->post(null, LedgerEntryType::PlatformFee, $feeCents, "{$key}:fee", $links);
        }

        if ($instructorTotal === 0 && $poolCents > 0) {
            $this->ledger->post(null, LedgerEntryType::UnattributedRevenue, $poolCents, "{$key}:unattributed", $links);
        }

        foreach ($instructorShares as $instructorId => $shareCents) {
            if ($shareCents > 0) {
                $this->ledger->post((int) $instructorId, LedgerEntryType::InstructorEarning, $shareCents, "{$key}:instructor:{$instructorId}", $links);
            }
        }

        return $allocation;
    }

    /**
     * @return array<int, int> instructor_id => seconds watched
     */
    private function watchedSecondsByInstructor(int $studentId, CarbonImmutable $from, CarbonImmutable $until): array
    {
        return WatchSession::query()
            ->join('courses', 'courses.id', '=', 'watch_sessions.course_id')
            ->where('watch_sessions.student_id', $studentId)
            ->where('watch_sessions.watched_at', '>=', $from)
            ->where('watch_sessions.watched_at', '<', $until)
            ->groupBy('courses.instructor_id')
            ->orderBy('courses.instructor_id')
            ->selectRaw('courses.instructor_id as instructor_id, SUM(watch_sessions.seconds) as seconds')
            ->pluck('seconds', 'instructor_id')
            ->map(fn ($seconds) => (int) $seconds)
            ->all();
    }
}
