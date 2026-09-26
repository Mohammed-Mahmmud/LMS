<?php

namespace App\Payments;

use App\Jobs\DeliverMockWebhook;
use App\Models\MockProviderTransfer;
use App\Payments\Exceptions\ProviderRejectedException;
use App\Payments\Exceptions\ProviderTimeoutException;
use App\Payments\Exceptions\ProviderUnavailableException;
use Carbon\CarbonImmutable;
use Illuminate\Support\Str;
use InvalidArgumentException;

/**
 * A deliberately unreliable payment provider.
 *
 * Scenarios (chosen per new transfer, randomly by weight or scripted for tests):
 *  - success            transfer succeeds synchronously; webhook follows
 *  - async_success      API returns "processing"; success arrives later by webhook only
 *  - async_failure      API returns "processing"; failure arrives later by webhook only
 *  - decline            transfer fails synchronously; webhook follows
 *  - timeout_before     request times out and never reached the provider
 *  - timeout_after      transfer SUCCEEDED at the provider, but the response was lost
 *  - duplicate_webhook  success, and the webhook is delivered twice
 *  - unavailable        provider answers 503 without doing anything
 *
 * Like a real provider it honours idempotency keys: repeating a request returns the
 * original transfer instead of creating a second one.
 */
class MockPaymentProvider implements PaymentProvider
{
    public const SCENARIOS = [
        'success', 'async_success', 'async_failure', 'decline',
        'timeout_before', 'timeout_after', 'duplicate_webhook', 'unavailable',
    ];

    /** @var list<string> */
    private array $script = [];

    /** @var list<array<string, mixed>> */
    private array $outbox = [];

    public function __construct(private readonly array $config) {}

    /** Force the next transfers to follow these scenarios, in order. */
    public function script(string ...$scenarios): static
    {
        foreach ($scenarios as $scenario) {
            if (! in_array($scenario, self::SCENARIOS, true)) {
                throw new InvalidArgumentException("Unknown scenario [{$scenario}].");
            }
        }

        array_push($this->script, ...$scenarios);

        return $this;
    }

    public function createTransfer(TransferRequest $request): TransferResult
    {
        $existing = MockProviderTransfer::where('idempotency_key', $request->idempotencyKey)->first();

        if ($existing) {
            if ((int) $existing->amount_cents !== $request->amountCents || $existing->destination !== $request->destination) {
                throw new ProviderRejectedException('Idempotency key reused with different parameters.');
            }

            return $existing->toResult();
        }

        return match ($this->nextScenario()) {
            'timeout_before' => throw new ProviderTimeoutException('Timed out; request never reached the provider.'),
            'unavailable' => throw new ProviderUnavailableException('503 Service Unavailable.'),
            'success' => $this->settle($this->record($request, TransferResult::SUCCEEDED)),
            'duplicate_webhook' => $this->settle($this->record($request, TransferResult::SUCCEEDED), copies: 2),
            'decline' => $this->settle($this->record($request, TransferResult::FAILED, 'destination_account_closed')),
            'async_success' => $this->processLater($this->record($request, TransferResult::PROCESSING), TransferResult::SUCCEEDED),
            'async_failure' => $this->processLater($this->record($request, TransferResult::PROCESSING), TransferResult::FAILED, 'bank_rejected'),
            'timeout_after' => $this->timeoutAfter($this->record($request, TransferResult::SUCCEEDED)),
        };
    }

    public function findTransfer(string $idempotencyKey): ?TransferResult
    {
        return MockProviderTransfer::where('idempotency_key', $idempotencyKey)->first()?->toResult();
    }

    /**
     * Webhooks waiting in the outbox (manual webhook mode only).
     *
     * @return list<array<string, mixed>>
     */
    public function pendingWebhooks(): array
    {
        return $this->outbox;
    }

    /**
     * Deliver queued webhooks (manual mode). Pass a callback to reorder them, e.g. array_reverse.
     */
    public function deliverWebhooks(?callable $reorder = null): void
    {
        $events = $reorder ? $reorder($this->outbox) : $this->outbox;
        $this->outbox = [];

        foreach ($events as $event) {
            $this->deliver($event);
        }
    }

    /** Apply the provider-side state change carried by the event, then notify our app. */
    public function deliver(array $event): void
    {
        $status = $event['data']['status'];

        MockProviderTransfer::where('idempotency_key', $event['data']['idempotency_key'])
            ->where('status', TransferResult::PROCESSING)
            ->update(['status' => $status, 'failure_reason' => $event['data']['failure_reason'], 'updated_at' => CarbonImmutable::parse($event['occurred_at'])]);

        app(ProviderWebhookProcessor::class)->process($event);
    }

    private function record(TransferRequest $request, string $status, ?string $failureReason = null): MockProviderTransfer
    {
        return MockProviderTransfer::create([
            'idempotency_key' => $request->idempotencyKey,
            'reference' => 'tr_'.Str::lower(Str::random(20)),
            'destination' => $request->destination,
            'amount_cents' => $request->amountCents,
            'status' => $status,
            'failure_reason' => $failureReason,
        ]);
    }

    private function settle(MockProviderTransfer $transfer, int $copies = 1): TransferResult
    {
        $this->emit($transfer, $transfer->status, $transfer->failure_reason, CarbonImmutable::now(), $copies);

        return $transfer->toResult();
    }

    private function processLater(MockProviderTransfer $transfer, string $finalStatus, ?string $failureReason = null): TransferResult
    {
        $delay = (int) ($this->config['webhook_delay_seconds'] ?? 5);

        $this->emit($transfer, $finalStatus, $failureReason, CarbonImmutable::now()->addSeconds($delay), delaySeconds: $delay);

        return $transfer->toResult();
    }

    private function timeoutAfter(MockProviderTransfer $transfer): never
    {
        $this->emit($transfer, $transfer->status, null, CarbonImmutable::now());

        throw new ProviderTimeoutException('Timed out waiting for the provider response.');
    }

    private function emit(MockProviderTransfer $transfer, string $status, ?string $failureReason, CarbonImmutable $occurredAt, int $copies = 1, int $delaySeconds = 0): void
    {
        $event = [
            'id' => 'evt_'.Str::lower(Str::random(24)),
            'type' => 'transfer.'.$status,
            'occurred_at' => $occurredAt->toIso8601ZuluString('microsecond'),
            'data' => [
                'reference' => $transfer->reference,
                'idempotency_key' => $transfer->idempotency_key,
                'amount_cents' => (int) $transfer->amount_cents,
                'status' => $status,
                'failure_reason' => $failureReason,
            ],
        ];

        for ($i = 0; $i < $copies; $i++) {
            if (($this->config['webhook_mode'] ?? 'queue') === 'manual') {
                $this->outbox[] = $event;
            } else {
                DeliverMockWebhook::dispatch($event)->delay(now()->addSeconds($delaySeconds + $i));
            }
        }
    }

    private function nextScenario(): string
    {
        if ($this->script !== []) {
            return array_shift($this->script);
        }

        $scenario = $this->config['scenario'] ?? 'random';

        if ($scenario !== 'random') {
            return $scenario;
        }

        $weights = $this->config['weights'] ?? ['success' => 1];
        $roll = random_int(1, array_sum($weights));

        foreach ($weights as $name => $weight) {
            if (($roll -= $weight) <= 0) {
                return $name;
            }
        }

        return 'success';
    }
}
