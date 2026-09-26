<?php

use App\Enums\LedgerEntryType;
use App\Ledger\RevenueAllocator;
use App\Models\Instructor;
use App\Models\LedgerEntry;
use App\Models\RevenueAllocation;

beforeEach(function () {
    $this->allocator = app(RevenueAllocator::class);
});

it('splits the pool by watch time after the platform fee', function () {
    [$a, $b] = Instructor::factory()->count(2)->create();
    $subscription = $this->subscribe(1, 2000);
    $this->watch($subscription, $this->courseBy($a), 7200, '2026-01-05');
    $this->watch($subscription, $this->courseBy($b), 3600, '2026-01-20');

    $this->travelTo('2026-02-01 00:00:00');

    expect($this->allocator->allocateDue())->toBe(1);
    $this->assertBalance(933, $a);
    $this->assertBalance(467, $b);
    expect((int) LedgerEntry::where('type', LedgerEntryType::PlatformFee)->sum('amount_cents'))->toBe(600)
        ->and($this->subscriptionLedgerTotal($subscription))->toBe(2000);
});

it('allocates nothing before the period ends', function () {
    $subscription = $this->subscribe(1, 2000);
    $this->watch($subscription, $this->courseBy(Instructor::factory()->create()), 600, '2026-01-02');

    $this->travelTo('2026-01-31 23:59:59');

    expect($this->allocator->allocateDue())->toBe(0)
        ->and(LedgerEntry::count())->toBe(0);
});

it('keeps the pool for the platform when nothing was watched', function () {
    $subscription = $this->subscribe(1, 2000);

    $this->travelTo('2026-02-01');
    $this->allocator->allocateDue();

    expect((int) LedgerEntry::where('type', LedgerEntryType::UnattributedRevenue)->sum('amount_cents'))->toBe(1400)
        ->and(LedgerEntry::whereNotNull('instructor_id')->count())->toBe(0)
        ->and($this->subscriptionLedgerTotal($subscription))->toBe(2000);
});

it('recognises an annual plan month by month using that month\'s viewing', function () {
    [$a, $b] = Instructor::factory()->count(2)->create();
    $subscription = $this->subscribe(12, 12000);
    $this->watch($subscription, $this->courseBy($a), 3600, '2026-01-10');          // period 0 -> A
    $this->watch($subscription, $this->courseBy($b), 3600, '2026-02-10');          // period 1 -> B
    $this->watch($subscription, $this->courseBy($b), 3600, '2026-03-31 23:59:59'); // still period 2

    $this->travelTo('2026-04-15');

    expect($this->allocator->allocateDue())->toBe(3);
    $this->assertBalance(700, $a);
    $this->assertBalance(1400, $b);
    expect($this->subscriptionLedgerTotal($subscription))->toBe(3000);
});

it('changes nothing when the allocator runs again', function () {
    $a = Instructor::factory()->create();
    $subscription = $this->subscribe(3, 5400);
    $this->watch($subscription, $this->courseBy($a), 3600, '2026-01-10');

    $this->travelTo('2026-05-01');
    expect($this->allocator->allocateDue())->toBe(3);
    $entries = LedgerEntry::count();

    expect($this->allocator->allocateDue())->toBe(0)
        ->and($this->allocator->allocateDue())->toBe(0)
        ->and(LedgerEntry::count())->toBe($entries)
        ->and(RevenueAllocation::count())->toBe(3);
});

it('fully allocates uneven amounts across periods', function () {
    $subscription = $this->subscribe(3, 10000);

    $this->travelTo('2026-04-01');
    $this->allocator->allocateDue();

    expect(RevenueAllocation::orderBy('period_index')->pluck('gross_cents')->map(fn ($c) => (int) $c)->all())->toBe([3334, 3333, 3333])
        ->and($this->subscriptionLedgerTotal($subscription))->toBe(10000);
});
