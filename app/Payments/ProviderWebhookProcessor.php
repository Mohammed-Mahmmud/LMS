<?php

namespace App\Payments;

use App\Enums\PayoutStatus;
use App\Models\Payout;
use App\Models\ProviderWebhookEvent;
use App\Payments\PayoutService;
use Carbon\CarbonImmutable;
use Illuminate\Support\Facades\Log;

class ProviderWebhookProcessor
{
    public function __construct(private readonly PayoutService $payouts) {}

    /**
     * @param  array{id: string, type: string, occurred_at: string, data: array<string, mixed>}  $event
     */
    public function process(array $event): void
    {
        // The unique event_id makes duplicate deliveries a no-op, even when they arrive concurrently.
        ProviderWebhookEvent::insertOrIgnore([
            'event_id' => $event['id'],
            'type' => $event['type'],
            'payload' => json_encode($event),
            'created_at' => now(),
        ]);

        $record = ProviderWebhookEvent::where('event_id', $event['id'])->firstOrFail();

        if ($record->processed_at !== null) {
            return;
        }

        $status = match ($event['type']) {
            'transfer.succeeded' => PayoutStatus::Succeeded,
            'transfer.failed' => PayoutStatus::Failed,
            default => null,
        };

        $payout = Payout::where('idempotency_key', $event['data']['idempotency_key'] ?? null)->first();

        if ($payout === null) {
            Log::warning('Webhook for unknown payout.', ['event_id' => $event['id']]);
        } elseif ($status !== null) {
            $this->payouts->transition(
                $payout,
                $status,
                $event['data']['reference'] ?? null,
                $event['data']['failure_reason'] ?? null,
                CarbonImmutable::parse($event['occurred_at']),
            );
        }

        $record->update(['processed_at' => now()]);
    }
}
