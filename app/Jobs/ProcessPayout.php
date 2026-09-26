<?php

namespace App\Jobs;

use App\Models\Payout;
use App\Payments\PayoutService;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Queue\Queueable;
use Illuminate\Queue\Middleware\WithoutOverlapping;
use Illuminate\Support\Facades\Log;
use Throwable;

class ProcessPayout implements ShouldQueue
{
    use Queueable;

    public int $tries = 6;

    public function __construct(public int $payoutId)
    {
        $this->afterCommit();
    }

    /** @return list<int> */
    public function backoff(): array
    {
        return [10, 30, 60, 120, 300];
    }

    public function middleware(): array
    {
        return [(new WithoutOverlapping((string) $this->payoutId))->releaseAfter(30)->expireAfter(120)];
    }

    public function handle(PayoutService $payouts): void
    {
        if ($payout = Payout::find($this->payoutId)) {
            $payouts->submit($payout);
        }
    }

    public function failed(?Throwable $exception): void
    {
        // Deliberately NOT marking the payout failed: after a timeout we don't know whether the
        // money moved. `payouts:reconcile` asks the provider and settles it.
        Log::error('Payout submission exhausted its retries; left for reconciliation.', [
            'payout_id' => $this->payoutId,
            'error' => $exception?->getMessage(),
        ]);
    }
}
