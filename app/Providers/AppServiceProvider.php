<?php

namespace App\Providers;

use App\Payments\MockPaymentProvider;
use App\Payments\PaymentProvider;
use Illuminate\Support\ServiceProvider;

class AppServiceProvider extends ServiceProvider
{
    /**
     * Register any application services.
     */
    public function register(): void
    {
        // Swap this binding for a real provider adapter in production.
        $this->app->singleton(PaymentProvider::class, fn () => new MockPaymentProvider(config('payments.mock')));
    }

    /**
     * Bootstrap any application services.
     */
    public function boot(): void
    {
        //
    }
}
