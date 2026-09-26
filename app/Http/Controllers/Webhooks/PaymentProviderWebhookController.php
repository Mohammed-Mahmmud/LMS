<?php

namespace App\Http\Controllers\Webhooks;

use App\Http\Controllers\Controller;
use App\Payments\ProviderWebhookProcessor;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class PaymentProviderWebhookController extends Controller
{
    public function __invoke(Request $request, ProviderWebhookProcessor $processor): JsonResponse
    {
        $expected = hash_hmac('sha256', $request->getContent(), (string) config('payments.webhook_secret'));
        $signature = $request->header('X-Provider-Signature');

        if (! is_string($signature) || ! hash_equals($expected, $signature)) {
            return response()->json(['error' => 'invalid signature'], 401);
        }

        $event = $request->validate([
            'id' => ['required', 'string'],
            'type' => ['required', 'string'],
            'occurred_at' => ['required', 'date'],
            'data' => ['required', 'array'],
            'data.idempotency_key' => ['required', 'string'],
            'data.reference' => ['nullable', 'string'],
            'data.failure_reason' => ['nullable', 'string'],
        ]);

        $processor->process($event);

        return response()->json(['received' => true]);
    }
}
