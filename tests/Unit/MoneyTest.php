<?php

use App\Support\Money;

it('never loses or creates a cent when allocating', function () {
    $shares = Money::allocate(1400, [1 => 7200, 2 => 3600]);

    expect($shares)->toBe([1 => 933, 2 => 467])
        ->and(array_sum($shares))->toBe(1400);
});

it('assigns leftover cents deterministically', function () {
    expect(Money::allocate(100, [1, 1, 1]))->toBe([0 => 34, 1 => 33, 2 => 33])
        ->and(Money::split(10000, 3))->toBe([3334, 3333, 3333]);
});

it('allocates nothing when all weights are zero', function () {
    expect(Money::allocate(1000, [5 => 0, 6 => 0]))->toBe([5 => 0, 6 => 0])
        ->and(Money::allocate(1000, []))->toBe([]);
});

it('always sums exactly to the total', function (int $total, array $weights) {
    expect(array_sum(Money::allocate($total, $weights)))->toBe($total);
})->with(function () {
    mt_srand(180);

    for ($i = 0; $i < 25; $i++) {
        $weights = [];
        for ($j = 0, $n = mt_rand(1, 8); $j < $n; $j++) {
            $weights[] = mt_rand(1, 100_000);
        }

        yield "case {$i}" => [mt_rand(0, 10_000_000), $weights];
    }
});

it('rejects negative totals and weights', function () {
    expect(fn () => Money::allocate(-1, [1]))->toThrow(InvalidArgumentException::class)
        ->and(fn () => Money::allocate(10, [1, -1]))->toThrow(InvalidArgumentException::class);
});
