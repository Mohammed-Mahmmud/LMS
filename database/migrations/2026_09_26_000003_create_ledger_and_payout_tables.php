<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('payouts', function (Blueprint $table) {
            $table->id();
            $table->foreignId('instructor_id')->constrained()->restrictOnDelete();
            $table->unsignedBigInteger('amount_cents');
            $table->string('status', 20)->default('pending')->index();
            // Sent to the provider on every attempt, so retries can never create a second transfer.
            $table->uuid('idempotency_key')->unique();
            $table->string('provider_reference')->nullable()->index();
            // Timestamp of the latest provider status we applied; older events are ignored.
            $table->dateTime('provider_updated_at')->nullable();
            $table->unsignedInteger('attempts')->default(0);
            $table->text('last_error')->nullable();
            $table->dateTime('requested_at');
            $table->dateTime('submitted_at')->nullable();
            $table->dateTime('completed_at')->nullable();
            $table->timestamps();
        });

        // Append-only. Balances are always SUM(amount_cents); rows are never updated or deleted.
        Schema::create('ledger_entries', function (Blueprint $table) {
            $table->id();
            // NULL instructor = the platform account.
            $table->foreignId('instructor_id')->nullable()->constrained()->restrictOnDelete();
            $table->string('type', 40);
            $table->bigInteger('amount_cents');
            $table->string('idempotency_key')->unique();
            $table->foreignId('subscription_id')->nullable()->constrained()->restrictOnDelete();
            $table->foreignId('revenue_allocation_id')->nullable()->constrained()->restrictOnDelete();
            $table->foreignId('refund_id')->nullable()->constrained()->restrictOnDelete();
            $table->foreignId('payout_id')->nullable()->constrained()->restrictOnDelete();
            $table->string('description')->nullable();
            $table->dateTime('created_at');
            $table->index(['instructor_id', 'type']);
        });

        Schema::create('provider_webhook_events', function (Blueprint $table) {
            $table->id();
            $table->string('event_id')->unique();
            $table->string('type');
            $table->json('payload');
            $table->dateTime('processed_at')->nullable();
            $table->dateTime('created_at');
        });

        // Owned by the MOCK provider, not by our system: it simulates the provider-side storage.
        Schema::create('mock_provider_transfers', function (Blueprint $table) {
            $table->id();
            $table->string('idempotency_key')->unique();
            $table->string('reference')->unique();
            $table->string('destination');
            $table->unsignedBigInteger('amount_cents');
            $table->string('status', 20);
            $table->string('failure_reason')->nullable();
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('mock_provider_transfers');
        Schema::dropIfExists('provider_webhook_events');
        Schema::dropIfExists('ledger_entries');
        Schema::dropIfExists('payouts');
    }
};
