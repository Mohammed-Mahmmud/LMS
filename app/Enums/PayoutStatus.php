<?php

namespace App\Enums;

enum PayoutStatus: string
{
    case Pending = 'pending';
    case Processing = 'processing';
    case Succeeded = 'succeeded';
    case Failed = 'failed';

    public function isTerminal(): bool
    {
        return $this === self::Succeeded || $this === self::Failed;
    }

    /**
     * Succeeded -> Failed models a transfer the provider later returned.
     * Failed -> Succeeded models a late/authoritative success after we had given up
     * (e.g. reconciliation found nothing, then a delayed retry landed anyway).
     */
    public function canTransitionTo(self $to): bool
    {
        return match ($this) {
            self::Pending => in_array($to, [self::Processing, self::Succeeded, self::Failed], true),
            self::Processing => in_array($to, [self::Succeeded, self::Failed], true),
            self::Succeeded => $to === self::Failed,
            self::Failed => $to === self::Succeeded,
        };
    }

    public function color(): string
    {
        return match ($this) {
            self::Pending => 'gray',
            self::Processing => 'warning',
            self::Succeeded => 'success',
            self::Failed => 'danger',
        };
    }
}
