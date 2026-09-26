<?php

namespace App\Payments;

use App\Payments\Exceptions\ProviderRejectedException;
use App\Payments\Exceptions\ProviderTimeoutException;
use App\Payments\Exceptions\ProviderUnavailableException;

interface PaymentProvider
{
    /**
     * Create (or return the existing) transfer for this idempotency key.
     *
     * @throws ProviderTimeoutException the outcome is UNKNOWN — the transfer may or may not exist
     * @throws ProviderUnavailableException the provider refused to handle the request right now; safe to retry
     * @throws ProviderRejectedException the request is invalid and will never succeed
     */
    public function createTransfer(TransferRequest $request): TransferResult;

    /** Look a transfer up by our idempotency key; null if the provider never received it. */
    public function findTransfer(string $idempotencyKey): ?TransferResult;
}
