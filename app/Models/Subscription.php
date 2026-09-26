<?php

namespace App\Models;

use App\Enums\SubscriptionStatus;
use App\Models\LedgerEntry;
use App\Models\Plan;
use App\Models\Refund;
use App\Models\RevenueAllocation;
use App\Models\Student;
use Carbon\CarbonImmutable;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

class Subscription extends Model
{
    use HasFactory;

    protected $guarded = [];

    protected function casts(): array
    {
        return [
            'status' => SubscriptionStatus::class,
            'starts_at' => 'immutable_datetime',
            'ends_at' => 'immutable_datetime',
            'refunded_at' => 'immutable_datetime',
        ];
    }

    /** Create a paid subscription, snapshotting price and platform fee. */
    public static function purchase(Student $student, Plan $plan, ?CarbonImmutable $startsAt = null): self
    {
        $startsAt ??= CarbonImmutable::now();

        return self::create([
            'student_id' => $student->id,
            'plan_id' => $plan->id,
            'amount_cents' => $plan->price_cents,
            'platform_fee_bps' => config('ledger.platform_fee_bps'),
            'periods' => $plan->interval_months,
            'starts_at' => $startsAt,
            'ends_at' => $startsAt->addMonthsNoOverflow($plan->interval_months),
            'status' => SubscriptionStatus::Active,
        ]);
    }

    public function student(): BelongsTo
    {
        return $this->belongsTo(Student::class);
    }

    public function plan(): BelongsTo
    {
        return $this->belongsTo(Plan::class);
    }

    public function allocations(): HasMany
    {
        return $this->hasMany(RevenueAllocation::class);
    }

    public function refunds(): HasMany
    {
        return $this->hasMany(Refund::class);
    }

    public function ledgerEntries(): HasMany
    {
        return $this->hasMany(LedgerEntry::class);
    }

    /** Periods are whole months from the start date. */
    public function periodStart(int $index): CarbonImmutable
    {
        return $this->starts_at->addMonthsNoOverflow($index);
    }

    public function periodEnd(int $index): CarbonImmutable
    {
        return $this->starts_at->addMonthsNoOverflow($index + 1);
    }
}
