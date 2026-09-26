<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('subscriptions', function (Blueprint $table) {
            $table->id();
            $table->foreignId('student_id')->constrained()->restrictOnDelete();
            $table->foreignId('plan_id')->constrained()->restrictOnDelete();
            // Snapshots taken at purchase: later plan/fee changes never rewrite history.
            $table->unsignedBigInteger('amount_cents');
            $table->unsignedSmallInteger('platform_fee_bps');
            $table->unsignedTinyInteger('periods');
            $table->dateTime('starts_at');
            $table->dateTime('ends_at');
            $table->string('status', 20)->default('active')->index();
            $table->unsignedBigInteger('refunded_cents')->default(0);
            $table->dateTime('refunded_at')->nullable();
            $table->timestamps();
        });

        Schema::create('watch_sessions', function (Blueprint $table) {
            $table->id();
            $table->foreignId('student_id')->constrained()->cascadeOnDelete();
            $table->foreignId('course_id')->constrained()->cascadeOnDelete();
            $table->unsignedInteger('seconds');
            $table->dateTime('watched_at');
            $table->index(['student_id', 'watched_at']);
        });

        Schema::create('revenue_allocations', function (Blueprint $table) {
            $table->id();
            $table->foreignId('subscription_id')->constrained()->restrictOnDelete();
            $table->unsignedTinyInteger('period_index');
            $table->dateTime('period_starts_at');
            $table->dateTime('period_ends_at');
            $table->unsignedBigInteger('gross_cents');
            $table->unsignedBigInteger('platform_cents');
            $table->unsignedBigInteger('instructor_cents');
            $table->boolean('is_settlement')->default(false);
            $table->timestamps();
            // The core idempotency guarantee: a period can only ever be allocated once.
            $table->unique(['subscription_id', 'period_index']);
        });

        Schema::create('refunds', function (Blueprint $table) {
            $table->id();
            $table->foreignId('subscription_id')->constrained()->restrictOnDelete();
            $table->string('idempotency_key')->unique();
            $table->unsignedBigInteger('amount_cents');
            // Portion covered by revenue not yet earned vs. portion clawed back from earnings.
            $table->unsignedBigInteger('unearned_cents');
            $table->unsignedBigInteger('clawback_cents');
            $table->string('reason')->nullable();
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('refunds');
        Schema::dropIfExists('revenue_allocations');
        Schema::dropIfExists('watch_sessions');
        Schema::dropIfExists('subscriptions');
    }
};
