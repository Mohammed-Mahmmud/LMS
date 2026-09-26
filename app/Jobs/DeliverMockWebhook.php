<?php

namespace App\Jobs;

use App\Payments\MockPaymentProvider;
use App\Payments\PaymentProvider;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Queue\Queueable;

/**
 * Simulates the provider calling our webhook endpoint some time after a transfer.
 */
class DeliverMockWebhook implements ShouldQueue
{
    use Queueable;

    public function __construct(public array $event) {}

    public function handle(PaymentProvider $provider): void
    {
        if ($provider instanceof MockPaymentProvider) {
            $provider->deliver($this->event);
        }
    }
}
