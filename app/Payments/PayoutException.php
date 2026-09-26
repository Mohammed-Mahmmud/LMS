<?php

namespace App\Payments;

use DomainException;

class PayoutException extends DomainException
{
    public static function belowMinimum(int $amount, int $minimum): self
    {
        return new self("Payout of {$amount} is below the minimum of {$minimum}.");
    }

    public static function insufficientBalance(int $amount, int $balance): self
    {
        return new self("Payout of {$amount} exceeds the available balance of {$balance}.");
    }

    public static function missingPayoutAccount(): self
    {
        return new self('Instructor has no payout account.');
    }
}
