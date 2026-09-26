<?php

namespace App\Models;

use App\Payments\TransferResult;
use Carbon\CarbonImmutable;
use Illuminate\Database\Eloquent\Model;

/**
 * Storage of the simulated payment provider. Our application code never reads this
 * table directly; it only talks to the provider through the PaymentProvider interface.
 */
class MockProviderTransfer extends Model
{
    protected $guarded = [];

    public function toResult(): TransferResult
    {
        return new TransferResult(
            reference: $this->reference,
            idempotencyKey: $this->idempotency_key,
            status: $this->status,
            amountCents: (int) $this->amount_cents,
            failureReason: $this->failure_reason,
            updatedAt: CarbonImmutable::parse($this->updated_at),
        );
    }
}
