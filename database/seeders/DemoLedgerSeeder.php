<?php

namespace Database\Seeders;

use App\Ledger\RefundService;
use App\Ledger\RevenueAllocator;
use App\Models\Course;
use App\Models\Instructor;
use App\Models\Plan;
use App\Models\Student;
use App\Models\Subscription;
use App\Models\WatchSession;
use App\Payments\MockPaymentProvider;
use App\Payments\PaymentProvider;
use App\Payments\PayoutService;
use Carbon\CarbonImmutable;
use Illuminate\Database\Seeder;

/**
 * A year of realistic activity: subscriptions on all three plans, viewing history,
 * allocated revenue, a couple of refunds and a couple of payouts.
 */
class DemoLedgerSeeder extends Seeder
{
    public function run(): void
    {
        fake()->seed(180);
        $now = CarbonImmutable::now();

        $plans = collect([
            ['name' => 'Monthly', 'interval_months' => 1, 'price_cents' => 2000],
            ['name' => 'Quarterly', 'interval_months' => 3, 'price_cents' => 5400],
            ['name' => 'Annual', 'interval_months' => 12, 'price_cents' => 19200],
        ])->map(fn ($plan) => Plan::create($plan));

        $instructors = collect([
            ['Sara Hassan', 'sara@lms.test', 'acct_sara001'],
            ['Omar Nabil', 'omar@lms.test', 'acct_omar002'],
            ['Laila Mostafa', 'laila@lms.test', 'acct_laila03'],
            ['Youssef Adel', 'youssef@lms.test', null], // no payout account connected yet
        ])->map(fn ($row) => Instructor::create(['name' => $row[0], 'email' => $row[1], 'payout_account' => $row[2]]));

        $courses = $instructors->flatMap(fn (Instructor $instructor) => Course::factory()->count(2)->for($instructor)->create());

        for ($i = 0; $i < 30; $i++) {
            $student = Student::factory()->create();
            $startsAt = $now->subDays(fake()->numberBetween(20, 330))->startOfDay();
            $subscription = Subscription::purchase($student, $plans->random(), $startsAt);
            $favourites = $courses->random(fake()->numberBetween(1, 3));

            // Some students barely use the platform; their revenue stays with the platform.
            if (fake()->boolean(10)) {
                continue;
            }

            for ($day = $startsAt; $day->lessThan(min($subscription->ends_at, $now)); $day = $day->addDays(fake()->numberBetween(2, 9))) {
                WatchSession::create([
                    'student_id' => $student->id,
                    'course_id' => $favourites->random()->id,
                    'seconds' => fake()->numberBetween(5, 90) * 60,
                    'watched_at' => $day->addMinutes(fake()->numberBetween(8 * 60, 23 * 60)),
                ]);
            }
        }

        app(RevenueAllocator::class)->allocateDue($now);

        $refunds = app(RefundService::class);
        $active = Subscription::where('status', 'active')->where('ends_at', '>', $now)->orderBy('id')->get();

        if ($first = $active->first()) {
            $refunds->refund($first, intdiv($first->amount_cents, 2), 'seed-refund-partial', 'Customer asked to cancel');
        }
        if ($last = $active->last()) {
            $refunds->refund($last, $last->amount_cents, 'seed-refund-full', 'Chargeback');
        }

        // Two payouts: one settled instantly, one waiting for the provider webhook.
        $provider = app(PaymentProvider::class);
        if ($provider instanceof MockPaymentProvider) {
            $provider->script('success', 'async_success');
        }

        $payouts = app(PayoutService::class);
        foreach ($instructors->take(2) as $instructor) {
            if ($instructor->balanceCents() >= config('ledger.min_payout_cents')) {
                $payouts->submit($payouts->request($instructor, intdiv($instructor->balanceCents(), 2)));
            }
        }
    }
}
