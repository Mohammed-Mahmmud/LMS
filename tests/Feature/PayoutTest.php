<?php

use App\Enums\LedgerEntryType;
use App\Enums\PayoutStatus;
use App\Jobs\ProcessPayout;
use App\Models\Instructor;
use App\Models\MockProviderTransfer;
use App\Models\Payout;
use App\Models\ProviderWebhookEvent;
use App\Payments\Exceptions\ProviderTimeoutException;
use App\Payments\Exceptions\ProviderUnavailableException;
use App\Payments\PayoutException;
use App\Payments\PayoutService;
use App\Payments\TransferRequest;
use App\Payments\TransferResult;
use Carbon\CarbonImmutable;
use Illuminate\Support\Facades\Queue;

beforeEach(function () {
    Queue::fake();
    $this->provider = $this->useMockProvider('success');
    $this->payouts = app(PayoutService::class);
    $this->instructor = Instructor::factory()->create();
    $this->credit($this->instructor, 5000);
});

/** Submit and swallow the given exception, like a queue attempt that fails. */
function attempt(PayoutService $payouts, Payout $payout, string $expected): void
{
    try {
        $payouts->submit($payout);
    } catch (Throwable $e) {
        expect($e)->toBeInstanceOf($expected);

        return;
    }

    test()->fail("Expected {$expected}.");
}

// --- Requesting ---------------------------------------------------------------------------

it('reserves the money immediately when a payout is requested', function () {
    $payout = $this->payouts->request($this->instructor, 3000);

    expect($payout->status)->toBe(PayoutStatus::Pending);
    $this->assertBalance(2000, $this->instructor);
    Queue::assertPushed(ProcessPayout::class, fn ($job) => $job->payoutId === $payout->id);
});

it('cannot pay out more than the balance, even across requests', function () {
    $this->payouts->request($this->instructor, 3000);

    expect(fn () => $this->payouts->request($this->instructor, 3000))->toThrow(PayoutException::class);
});

it('cannot pay out below the minimum or without a payout account', function () {
    expect(fn () => $this->payouts->request($this->instructor, 999))->toThrow(PayoutException::class);

    $this->instructor->update(['payout_account' => null]);

    expect(fn () => $this->payouts->request($this->instructor))->toThrow(PayoutException::class);
});

// --- Happy path ---------------------------------------------------------------------------

it('records a successful payout and its webhook once', function () {
    $payout = $this->payouts->request($this->instructor);
    $this->payouts->submit($payout);
    $this->provider->deliverWebhooks();

    $payout->refresh();
    expect($payout->status)->toBe(PayoutStatus::Succeeded)
        ->and($payout->provider_reference)->not->toBeNull()
        ->and($payout->ledgerEntries()->count())->toBe(1);
    $this->assertBalance(0, $this->instructor);
});

// --- Timeouts & retries -------------------------------------------------------------------

it('does not pay twice when the provider paid but the response timed out', function () {
    $this->provider->script('timeout_after', 'success');
    $payout = $this->payouts->request($this->instructor);

    attempt($this->payouts, $payout, ProviderTimeoutException::class);

    expect($payout->fresh()->status)->toBe(PayoutStatus::Processing);
    $this->assertBalance(0, $this->instructor); // money stays reserved while the outcome is unknown

    $this->payouts->submit($payout); // queue retry, same idempotency key

    expect($payout->fresh()->status)->toBe(PayoutStatus::Succeeded)
        ->and(MockProviderTransfer::count())->toBe(1)
        ->and($payout->fresh()->attempts)->toBe(2);
    $this->assertBalance(0, $this->instructor);
});

it('retries safely when the request never reached the provider', function () {
    $this->provider->script('timeout_before', 'unavailable', 'success');
    $payout = $this->payouts->request($this->instructor);

    attempt($this->payouts, $payout, ProviderTimeoutException::class);
    attempt($this->payouts, $payout, ProviderUnavailableException::class);
    $this->payouts->submit($payout);

    expect($payout->fresh()->status)->toBe(PayoutStatus::Succeeded)
        ->and(MockProviderTransfer::count())->toBe(1);
});

it('never resubmits a finished payout', function () {
    $payout = $this->payouts->request($this->instructor);
    $this->payouts->submit($payout);
    $this->payouts->submit($payout); // e.g. a duplicated job

    expect($payout->fresh()->attempts)->toBe(1);
});

// --- Failures -----------------------------------------------------------------------------

it('returns the money to the instructor when the provider declines', function () {
    $this->provider->script('decline');
    $payout = $this->payouts->request($this->instructor);
    $this->payouts->submit($payout);
    $this->provider->deliverWebhooks(); // the failure webhook must not reverse twice

    $payout->refresh();
    expect($payout->status)->toBe(PayoutStatus::Failed)
        ->and($payout->last_error)->toBe('destination_account_closed')
        ->and($payout->ledgerEntries()->where('type', LedgerEntryType::PayoutReversal)->count())->toBe(1);
    $this->assertBalance(5000, $this->instructor);
});

// --- Webhooks -----------------------------------------------------------------------------

it('completes an async success by webhook', function () {
    $this->provider->script('async_success');
    $payout = $this->payouts->request($this->instructor);
    $this->payouts->submit($payout);

    expect($payout->fresh()->status)->toBe(PayoutStatus::Processing);

    $this->provider->deliverWebhooks();

    expect($payout->fresh()->status)->toBe(PayoutStatus::Succeeded);
    $this->assertBalance(0, $this->instructor);
});

it('completes an async failure by webhook', function () {
    $this->provider->script('async_failure');
    $payout = $this->payouts->request($this->instructor);
    $this->payouts->submit($payout);
    $this->provider->deliverWebhooks();

    expect($payout->fresh()->status)->toBe(PayoutStatus::Failed);
    $this->assertBalance(5000, $this->instructor);
});

it('processes duplicate webhooks once', function () {
    $this->provider->script('duplicate_webhook');
    $payout = $this->payouts->request($this->instructor);
    $this->payouts->submit($payout);

    expect($this->provider->pendingWebhooks())->toHaveCount(2);

    $this->provider->deliverWebhooks();

    expect(ProviderWebhookEvent::count())->toBe(1)
        ->and($payout->ledgerEntries()->count())->toBe(1);
    $this->assertBalance(0, $this->instructor);
});

it('ignores stale events arriving out of order', function () {
    $payout = $this->payouts->request($this->instructor);
    $t = CarbonImmutable::parse('2026-03-01 12:00:00');

    $this->payouts->transition($payout, PayoutStatus::Succeeded, 'tr_1', occurredAt: $t->addMinute());
    // An older "failed" event and an older "processing" API response arrive late.
    $this->payouts->transition($payout, PayoutStatus::Failed, 'tr_1', 'bank_rejected', $t);
    $this->payouts->applyResult($payout, new TransferResult('tr_1', $payout->idempotency_key, TransferResult::PROCESSING, 5000, null, $t));

    expect($payout->fresh()->status)->toBe(PayoutStatus::Succeeded);
    $this->assertBalance(0, $this->instructor);
});

it('credits back funds returned after a success', function () {
    $payout = $this->payouts->request($this->instructor);
    $t = CarbonImmutable::parse('2026-03-01 12:00:00');

    $this->payouts->transition($payout, PayoutStatus::Succeeded, 'tr_1', occurredAt: $t);
    $this->payouts->transition($payout, PayoutStatus::Failed, 'tr_1', 'returned_by_bank', $t->addDay());

    expect($payout->fresh()->status)->toBe(PayoutStatus::Failed);
    $this->assertBalance(5000, $this->instructor);
});

// --- Reconciliation -----------------------------------------------------------------------

it('reconciles a payout whose response was lost as succeeded', function () {
    $this->provider->script('timeout_after');
    $payout = $this->payouts->request($this->instructor);

    attempt($this->payouts, $payout, ProviderTimeoutException::class); // imagine every retry failed too

    $this->payouts->reconcile($payout);

    expect($payout->fresh()->status)->toBe(PayoutStatus::Succeeded);
    $this->assertBalance(0, $this->instructor);
});

it('fails a payout the provider never received, and re-debits if a late success lands', function () {
    $this->provider->script('timeout_before');
    $payout = $this->payouts->request($this->instructor);

    attempt($this->payouts, $payout, ProviderTimeoutException::class);

    $this->payouts->reconcile($payout);
    expect($payout->fresh()->status)->toBe(PayoutStatus::Failed);
    $this->assertBalance(5000, $this->instructor);

    // A straggling request (e.g. from a zombie worker) reaches the provider afterwards.
    $this->travel(1)->minutes();
    $this->provider->script('success');
    $this->provider->createTransfer(new TransferRequest($payout->idempotency_key, $this->instructor->payout_account, 5000, 'USD'));
    $this->provider->deliverWebhooks();

    expect($payout->fresh()->status)->toBe(PayoutStatus::Succeeded);
    $this->assertBalance(0, $this->instructor);
});

it('re-dispatches a payout that was never sent', function () {
    $payout = $this->payouts->request($this->instructor);
    Queue::fake(); // forget the original dispatch

    $this->payouts->reconcile($payout);

    Queue::assertPushed(ProcessPayout::class, fn ($job) => $job->payoutId === $payout->id);
    expect($payout->fresh()->status)->toBe(PayoutStatus::Pending);
});

// --- Chaos --------------------------------------------------------------------------------

it('conserves money under random provider behaviour', function () {
    $provider = $this->useMockProvider('random');
    $payouts = app(PayoutService::class);
    $instructors = Instructor::factory()->count(5)->create();

    for ($round = 0; $round < 8; $round++) {
        foreach ($instructors as $instructor) {
            $this->credit($instructor, random_int(1000, 20000));
            $payout = $payouts->request($instructor);

            for ($try = 0; $try < 3; $try++) {
                try {
                    $payouts->submit($payout);
                    break;
                } catch (ProviderTimeoutException|ProviderUnavailableException) {
                }
            }
        }

        $provider->deliverWebhooks(fn (array $events) => collect($events)->shuffle()->all());
    }

    Payout::whereNotIn('status', [PayoutStatus::Succeeded, PayoutStatus::Failed])
        ->each(fn (Payout $payout) => $payouts->reconcile($payout));
    $provider->deliverWebhooks();

    expect(Payout::whereNotIn('status', [PayoutStatus::Succeeded, PayoutStatus::Failed])->count())->toBe(0);

    foreach ($instructors as $instructor) {
        $sent = (int) MockProviderTransfer::whereIn('idempotency_key', $instructor->payouts()->pluck('idempotency_key'))
            ->where('status', TransferResult::SUCCEEDED)->sum('amount_cents');

        // What we owe + what the provider actually sent == what was earned. Never more, never less.
        expect($instructor->balanceCents() + $sent)->toBe($instructor->earnedCents())
            ->and($instructor->paidCents())->toBe($sent);
    }
});
