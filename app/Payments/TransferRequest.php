<?php

namespace App\Payments;

final readonly class TransferRequest
{
    public function __construct(
        public string $idempotencyKey,
        public string $destination,
        public int $amountCents,
        public string $currency,
    ) {}
}
