<?php

namespace App\Support;

use InvalidArgumentException;

final class Money
{
    /**
     * Split an integer amount proportionally to integer weights using the largest
     * remainder method. The parts always sum exactly to $total; leftover cents go to
     * the largest fractional remainders, ties broken by key so results are deterministic.
     *
     * @param  array<int|string, int>  $weights
     * @return array<int|string, int>
     */
    public static function allocate(int $total, array $weights): array
    {
        if ($total < 0) {
            throw new InvalidArgumentException('Total must not be negative.');
        }

        foreach ($weights as $weight) {
            if ($weight < 0) {
                throw new InvalidArgumentException('Weights must not be negative.');
            }
        }

        $sum = array_sum($weights);

        if ($total === 0 || $sum === 0) {
            return array_map(fn () => 0, $weights);
        }

        $shares = [];
        $remainders = [];

        foreach ($weights as $key => $weight) {
            $shares[$key] = intdiv($total * $weight, $sum);
            $remainders[$key] = ($total * $weight) % $sum;
        }

        $leftover = $total - array_sum($shares);
        $keys = array_keys($remainders);

        usort($keys, fn ($a, $b) => [$remainders[$b], (string) $a] <=> [$remainders[$a], (string) $b]);

        foreach (array_slice($keys, 0, $leftover) as $key) {
            $shares[$key]++;
        }

        return $shares;
    }

    /**
     * Split an amount into $parts near-equal integer parts (earlier parts get the extra cents).
     *
     * @return array<int, int>
     */
    public static function split(int $total, int $parts): array
    {
        return self::allocate($total, array_fill(0, $parts, 1));
    }

    public static function format(int $cents, ?string $currency = null): string
    {
        $currency ??= config('ledger.currency');

        return ($cents < 0 ? '-' : '').number_format(abs($cents) / 100, 2).' '.$currency;
    }
}
