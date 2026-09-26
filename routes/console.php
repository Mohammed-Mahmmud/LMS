<?php

use App\Enums\PayoutStatus;
use App\Ledger\RefundService;
use App\Ledger\RevenueAllocator;
use App\Models\Instructor;
use App\Models\Payout;
use App\Models\Subscription;
use App\Payments\PayoutException;
use App\Payments\PayoutService;
use App\Support\Money;
use Illuminate\Support\Facades\Artisan;
use Illuminate\Support\Facades\Schedule;
use Illuminate\Support\Str;

Artisan::command('ledger:allocate', function (RevenueAllocator $allocator) {
    $count = $allocator->allocateDue();
    $this->info("Allocated {$count} subscription period(s).");
})->purpose('Recognise revenue for every elapsed subscription period (idempotent)');

Artisan::command('ledger:refund {subscription} {amount_cents} {--key=} {--reason=}', function (RefundService $refunds) {
    $subscription = Subscription::findOrFail($this->argument('subscription'));
    $refund = $refunds->refund(
        $subscription,
        (int) $this->argument('amount_cents'),
        $this->option('key') ?: 'cli:'.Str::uuid(),
        $this->option('reason'),
    );
    $this->info('Refund #'.$refund->id.': '.Money::format($refund->amount_cents).' (unearned '.Money::format($refund->unearned_cents).', clawback '.Money::format($refund->clawback_cents).')');
})->purpose('Refund part or all of a subscription');

Artisan::command('payouts:run', function (PayoutService $payouts) {
    Instructor::query()->whereNotNull('payout_account')->each(function (Instructor $instructor) use ($payouts) {
        try {
            $payout = $payouts->request($instructor);
            $this->line("Payout #{$payout->id} for {$instructor->name}: ".Money::format($payout->amount_cents));
        } catch (PayoutException $e) {
            $this->line("Skipped {$instructor->name}: {$e->getMessage()}");
        }
    });
})->purpose('Request a payout of the full balance for every eligible instructor');

Artisan::command('payouts:reconcile {--minutes=}', function (PayoutService $payouts) {
    $minutes = (int) ($this->option('minutes') ?? config('ledger.reconcile_after_minutes'));

    $stuck = Payout::query()
        ->whereIn('status', [PayoutStatus::Pending, PayoutStatus::Processing])
        ->where('updated_at', '<=', now()->subMinutes($minutes))
        ->get();

    foreach ($stuck as $payout) {
        $payouts->reconcile($payout);
        $this->line("Payout #{$payout->id}: {$payout->fresh()->status->value}");
    }

    $this->info("Reconciled {$stuck->count()} payout(s).");
})->purpose('Ask the provider about payouts stuck in pending/processing');

Schedule::command('ledger:allocate')->hourly()->withoutOverlapping();
Schedule::command('payouts:reconcile')->everyTenMinutes()->withoutOverlapping();
Schedule::command('payouts:run')->monthlyOn(1, '06:00')->withoutOverlapping();
