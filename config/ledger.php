<?php

return [

    /*
    | All money is stored as integer minor units (cents) in a single currency.
    */
    'currency' => env('LEDGER_CURRENCY', 'USD'),

    /*
    | Platform cut in basis points (3000 = 30%). Snapshotted onto each
    | subscription at purchase time so later changes never rewrite history.
    */
    'platform_fee_bps' => (int) env('LEDGER_PLATFORM_FEE_BPS', 3000),

    /*
    | Smallest payout we are willing to send to the provider.
    */
    'min_payout_cents' => (int) env('LEDGER_MIN_PAYOUT_CENTS', 1000),

    /*
    | Payouts stuck in pending/processing longer than this are picked up by
    | `payouts:reconcile`.
    */
    'reconcile_after_minutes' => (int) env('LEDGER_RECONCILE_AFTER_MINUTES', 15),

];
