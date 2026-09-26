<?php

namespace Tests\Concerns;

use App\Enums\LedgerEntryType;
use App\Ledger\Ledger;
use App\Models\Course;
use App\Models\Instructor;
use App\Models\LedgerEntry;
use App\Models\Plan;
use App\Models\Student;
use App\Models\Subscription;
use App\Models\WatchSession;
use App\Payments\MockPaymentProvider;
use App\Payments\PaymentProvider;
use Carbon\CarbonImmutable;

trait BuildsLedgerFixtures
{
    protected function subscribe(int $months, int $priceCents, string $startsAt = '2026-01-01 00:00:00', ?Student $student = null): Subscription
    {
        return Subscription::purchase(
            $student ?? Student::factory()->create(),
            Plan::factory()->months($months, $priceCents)->create(),
            CarbonImmutable::parse($startsAt),
        );
    }

    protected function courseBy(Instructor $instructor): Course
    {
        return Course::factory()->for($instructor)->create();
    }

    protected function watch(Subscription $subscription, Course $course, int $seconds, string $at): void
    {
        WatchSession::create([
            'student_id' => $subscription->student_id,
            'course_id' => $course->id,
            'seconds' => $seconds,
            'watched_at' => CarbonImmutable::parse($at),
        ]);
    }

    protected function credit(Instructor $instructor, int $cents): void
    {
        app(Ledger::class)->post($instructor->id, LedgerEntryType::InstructorEarning, $cents, 'test-credit:'.$instructor->id.':'.uniqid());
    }

    protected function useMockProvider(string $scenario = 'success'): MockPaymentProvider
    {
        $provider = new MockPaymentProvider(['scenario' => $scenario, 'webhook_mode' => 'manual', 'webhook_delay_seconds' => 5]);
        $this->app->instance(PaymentProvider::class, $provider);

        return $provider;
    }

    protected function subscriptionLedgerTotal(Subscription $subscription): int
    {
        return (int) LedgerEntry::where('subscription_id', $subscription->id)->sum('amount_cents');
    }

    protected function assertBalance(int $expected, Instructor $instructor): void
    {
        $this->assertSame($expected, $instructor->balanceCents(), "Unexpected balance for instructor #{$instructor->id}");
    }
}
