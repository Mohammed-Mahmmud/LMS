<?php

use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\Concerns\BuildsLedgerFixtures;
use Tests\TestCase;

/*
|--------------------------------------------------------------------------
| Test Case
|--------------------------------------------------------------------------
|
| Feature tests run against a fresh in-memory SQLite database and get the
| ledger fixture helpers (subscribe, watch, credit, useMockProvider, ...).
|
*/

pest()->extend(TestCase::class)
    ->use(RefreshDatabase::class)
    ->use(BuildsLedgerFixtures::class)
    ->in('Feature');
