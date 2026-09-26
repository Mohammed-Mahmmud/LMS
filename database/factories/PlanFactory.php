<?php

namespace Database\Factories;

use App\Models\Plan;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends Factory<Plan>
 */
class PlanFactory extends Factory
{
    public function definition(): array
    {
        return [
            'name' => 'Monthly',
            'interval_months' => 1,
            'price_cents' => 2000,
        ];
    }

    public function months(int $months, int $priceCents): static
    {
        return $this->state([
            'name' => "{$months}-month",
            'interval_months' => $months,
            'price_cents' => $priceCents,
        ]);
    }
}
