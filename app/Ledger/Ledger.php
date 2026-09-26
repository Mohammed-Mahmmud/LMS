<?php

namespace App\Ledger;

use App\Enums\LedgerEntryType;
use App\Models\LedgerEntry;

/**
 * The only place that writes ledger entries. Every entry carries a deterministic
 * idempotency key, so re-running any operation can never post the same movement twice.
 */
class Ledger
{
    /**
     * @param  array{subscription_id?: int, revenue_allocation_id?: int, refund_id?: int, payout_id?: int, description?: string}  $links
     */
    public function post(?int $instructorId, LedgerEntryType $type, int $amountCents, string $idempotencyKey, array $links = []): LedgerEntry
    {
        return LedgerEntry::firstOrCreate(
            ['idempotency_key' => $idempotencyKey],
            [
                'instructor_id' => $instructorId,
                'type' => $type,
                'amount_cents' => $amountCents,
                ...$links,
            ],
        );
    }
}
