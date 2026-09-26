<?php

namespace App\Payments;

use Carbon\CarbonImmutable;

final readonly class TransferResult
{
    public const PROCESSING = 'processing';

    public const SUCCEEDED = 'succeeded';

    public const FAILED = 'failed';

    public function __construct(
        public string $reference,
        public string $idempotencyKey,
        public string $status,
        public int $amountCents,
        public ?string $failureReason,
        public CarbonImmutable $updatedAt,
    ) {}
}
