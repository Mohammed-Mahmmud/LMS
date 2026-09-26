<?php

use App\Enums\LedgerEntryType;
use App\Enums\SubscriptionStatus;
use App\Ledger\RefundService;
use App\Ledger\RevenueAllocator;
use App\Models\Instructor;
use App\Models\LedgerEntry;
use App\Models\RevenueAllocation;
use App\Payments\PayoutException;
use App\Payments\PayoutService;
use Illuminate\Support\Facades\Queue;

beforeEach(function () {
    $this->refunds = app(RefundService::class);
});

it('keeps earned months and settles the partial month on a prorated refund', function () {
    $a = Instructor::factory()->create();
    $course = $this->courseBy($a);
    $subscription = $this->subscribe(12, 12000);

    foreach (['01', '02', '03', '04', '05'] as $month) {
        $this->watch($subscription, $course, 3600, "2026-{$month}-03");
    }

    // The allocator never ran: the refund must first recognise the 4 elapsed months.
    $this->travelTo('2026-05-15');
    $refund = $this->refunds->refund($subscription, 7500, 'refund-1');

    expect((int) $refund->unearned_cents)->toBe(7500)
        ->and((int) $refund->clawback_cents)->toBe(0)
        ->and(RevenueAllocation::count())->toBe(5)
        ->and(RevenueAllocation::where('period_index', 4)->value('is_settlement'))->toBeTruthy();

    // 4 full months (700 each to A) + settlement of the kept 500 (350 to A).
    $this->assertBalance(4 * 700 + 350, $a);
    expect($this->subscriptionLedgerTotal($subscription))->toBe(12000 - 7500)
        ->and($subscription->refresh()->status)->toBe(SubscriptionStatus::Refunded);

    // No more revenue is recognised after the refund.
    $this->travelTo('2027-06-01');
    expect(app(RevenueAllocator::class)->allocateDue())->toBe(0);
});

it('claws back earnings proportionally on a full refund', function () {
    [$a, $b] = Instructor::factory()->count(2)->create();
    $subscription = $this->subscribe(3, 6000);
    $this->watch($subscription, $this->courseBy($a), 3600, '2026-01-10');
    $this->watch($subscription, $this->courseBy($b), 3600, '2026-02-10');

    $this->travelTo('2026-03-15');
    $refund = $this->refunds->refund($subscription, 6000, 'refund-full');

    expect((int) $refund->unearned_cents)->toBe(2000)
        ->and((int) $refund->clawback_cents)->toBe(4000);
    $this->assertBalance(0, $a);
    $this->assertBalance(0, $b);
    expect((int) LedgerEntry::whereNull('instructor_id')->where('type', LedgerEntryType::RefundClawback)->sum('amount_cents'))->toBe(-1200)
        ->and($this->subscriptionLedgerTotal($subscription))->toBe(0);
});

it('leaves a negative balance that blocks payouts when a refund follows a payout', function () {
    Queue::fake();
    $this->useMockProvider('success');

    $a = Instructor::factory()->create();
    $subscription = $this->subscribe(1, 2000);
    $this->watch($subscription, $this->courseBy($a), 3600, '2026-01-10');

    $this->travelTo('2026-02-01');
    app(RevenueAllocator::class)->allocateDue();

    $payouts = app(PayoutService::class);
    $payouts->submit($payouts->request($a));
    $this->assertBalance(0, $a);

    $this->refunds->refund($subscription, 2000, 'chargeback');

    $this->assertBalance(-1400, $a);
    expect(fn () => $payouts->request($a))->toThrow(PayoutException::class);
});

it('applies the same refund only once', function () {
    $a = Instructor::factory()->create();
    $subscription = $this->subscribe(1, 2000);
    $this->watch($subscription, $this->courseBy($a), 3600, '2026-01-10');
    $this->travelTo('2026-02-10');

    $first = $this->refunds->refund($subscription, 1000, 'provider-refund-42');
    $entries = LedgerEntry::count();
    $second = $this->refunds->refund($subscription, 1000, 'provider-refund-42');

    expect($first->is($second))->toBeTrue()
        ->and(LedgerEntry::count())->toBe($entries)
        ->and((int) $subscription->fresh()->refunded_cents)->toBe(1000);
});

it('cannot refund more than was paid', function () {
    $subscription = $this->subscribe(1, 2000);
    $this->refunds->refund($subscription, 1500, 'r1');

    expect(fn () => $this->refunds->refund($subscription, 501, 'r2'))->toThrow(InvalidArgumentException::class);
});

it('treats a second partial refund as a pure clawback', function () {
    $a = Instructor::factory()->create();
    $subscription = $this->subscribe(1, 2000);
    $this->watch($subscription, $this->courseBy($a), 3600, '2026-01-10');
    $this->travelTo('2026-02-10');

    $this->refunds->refund($subscription, 1000, 'r1');
    $second = $this->refunds->refund($subscription, 1000, 'r2');

    expect((int) $second->unearned_cents)->toBe(0)
        ->and((int) $second->clawback_cents)->toBe(1000);
    $this->assertBalance(0, $a);
    expect($this->subscriptionLedgerTotal($subscription))->toBe(0);
});
