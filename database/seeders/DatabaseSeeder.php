<?php

namespace Database\Seeders;

use App\Models\Instructor;
use App\Models\User;
use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    /**
     * Seed the application's database.
     */
    public function run(): void
    {
        User::updateOrCreate(
            ['email' => env('ADMIN_EMAIL', 'admin@lms.test')],
            ['name' => 'Admin', 'password' => env('ADMIN_PASSWORD', 'Career180@Ledger')],
        );

        // Seed demo data once; re-running db:seed (e.g. on container restart) must not duplicate it.
        if (! Instructor::exists()) {
            $this->call(DemoLedgerSeeder::class);
        }
    }
}
