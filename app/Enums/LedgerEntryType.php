<?php

namespace App\Enums;

enum LedgerEntryType: string
{
    // Revenue allocation
    case InstructorEarning = 'instructor_earning';
    case PlatformFee = 'platform_fee';
    case UnattributedRevenue = 'unattributed_revenue';

    // Refunds
    case RefundClawback = 'refund_clawback';

    // Payouts (instructor accounts only)
    case PayoutDebit = 'payout_debit';
    case PayoutReversal = 'payout_reversal';

    /** Entry types that make up what an instructor has earned (net of refunds). */
    public static function earningTypes(): array
    {
        return [self::InstructorEarning->value, self::RefundClawback->value];
    }

    public function label(): string
    {
        return match ($this) {
            self::InstructorEarning => 'Earning',
            self::PlatformFee => 'Platform fee',
            self::UnattributedRevenue => 'Unattributed revenue',
            self::RefundClawback => 'Refund clawback',
            self::PayoutDebit => 'Payout',
            self::PayoutReversal => 'Payout reversal',
        };
    }
}
