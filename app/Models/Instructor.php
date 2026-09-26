<?php

namespace App\Models;

use App\Enums\LedgerEntryType;
use App\Enums\PayoutStatus;
use App\Models\Course;
use App\Models\LedgerEntry;
use App\Models\Payout;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;

class Instructor extends Model
{
    use HasFactory;

    protected $guarded = [];

    public function courses(): HasMany
    {
        return $this->hasMany(Course::class);
    }

    public function ledgerEntries(): HasMany
    {
        return $this->hasMany(LedgerEntry::class);
    }

    public function payouts(): HasMany
    {
        return $this->hasMany(Payout::class);
    }

    /** What we currently owe: every ledger movement, including reserved (in-flight) payouts. */
    public function balanceCents(): int
    {
        return (int) $this->ledgerEntries()->sum('amount_cents');
    }

    /** Lifetime earnings net of refund clawbacks. */
    public function earnedCents(): int
    {
        return (int) $this->ledgerEntries()->whereIn('type', LedgerEntryType::earningTypes())->sum('amount_cents');
    }

    public function paidCents(): int
    {
        return (int) $this->payouts()->where('status', PayoutStatus::Succeeded)->sum('amount_cents');
    }

    public function inFlightCents(): int
    {
        return (int) $this->payouts()
            ->whereIn('status', [PayoutStatus::Pending, PayoutStatus::Processing])
            ->sum('amount_cents');
    }
}
