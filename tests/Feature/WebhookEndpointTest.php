<?php

use App\Enums\PayoutStatus;
use App\Models\Instructor;
use App\Models\ProviderWebhookEvent;
use App\Payments\PayoutService;
use Illuminate\Support\Facades\Queue;

function webhookEvent(string $key, string $type = 'transfer.succeeded'): array
{
    return [
        'id' => 'evt_123',
        'type' => $type,
        'occurred_at' => now()->toIso8601ZuluString(),
        'data' => ['idempotency_key' => $key, 'reference' => 'tr_abc', 'failure_reason' => null],
    ];
}

function sendWebhook(array $event, ?string $signature = null)
{
    $body = json_encode($event);
    $signature ??= hash_hmac('sha256', $body, config('payments.webhook_secret'));

    return test()->call('POST', '/webhooks/payment-provider', [], [], [], [
        'CONTENT_TYPE' => 'application/json',
        'HTTP_ACCEPT' => 'application/json',
        'HTTP_X_PROVIDER_SIGNATURE' => $signature,
    ], $body);
}

it('rejects unsigned or forged webhooks', function () {
    sendWebhook(webhookEvent('whatever'), 'forged')->assertStatus(401);

    expect(ProviderWebhookEvent::count())->toBe(0);
});

it('applies a signed webhook and ignores its duplicate', function () {
    Queue::fake();
    $instructor = Instructor::factory()->create();
    $this->credit($instructor, 5000);
    $payout = app(PayoutService::class)->request($instructor);

    sendWebhook(webhookEvent($payout->idempotency_key))->assertOk();
    sendWebhook(webhookEvent($payout->idempotency_key))->assertOk();

    expect($payout->fresh()->status)->toBe(PayoutStatus::Succeeded)
        ->and($payout->fresh()->provider_reference)->toBe('tr_abc')
        ->and(ProviderWebhookEvent::count())->toBe(1);
    $this->assertBalance(0, $instructor);
});

it('acknowledges a webhook for an unknown payout', function () {
    sendWebhook(webhookEvent('00000000-0000-0000-0000-000000000000'))->assertOk();

    expect(ProviderWebhookEvent::first()->processed_at)->not->toBeNull();
});
