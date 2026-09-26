<?php

use App\Http\Controllers\Webhooks\PaymentProviderWebhookController;
use Illuminate\Support\Facades\Route;

Route::redirect('/', '/admin');

Route::post('/webhooks/payment-provider', PaymentProviderWebhookController::class)
    ->name('webhooks.payment-provider');
