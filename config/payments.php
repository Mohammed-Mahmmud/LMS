<?php

return [

    'webhook_secret' => env('PAYMENT_PROVIDER_WEBHOOK_SECRET', 'local-dev-webhook-secret'),

    'mock' => [
        /*
        | "random" picks a scenario per transfer using the weights below.
        | Any single scenario name forces that behaviour for every transfer.
        */
        'scenario' => env('PAYMENT_PROVIDER_MOCK_SCENARIO', 'random'),

        'weights' => [
            'success' => 45,
            'async_success' => 20,
            'async_failure' => 5,
            'decline' => 5,
            'timeout_before' => 10,
            'timeout_after' => 10,
            'duplicate_webhook' => 5,
        ],

        /*
        | "queue": webhooks are dispatched as delayed jobs (realistic).
        | "manual": webhooks are kept in an outbox until deliverWebhooks() (tests).
        */
        'webhook_mode' => env('PAYMENT_PROVIDER_MOCK_WEBHOOKS', 'queue'),

        'webhook_delay_seconds' => (int) env('PAYMENT_PROVIDER_MOCK_WEBHOOK_DELAY', 5),
    ],

];
