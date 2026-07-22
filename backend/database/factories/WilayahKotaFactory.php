<?php

namespace Database\Factories;

use App\Models\WilayahKota;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends Factory<WilayahKota>
 */
class WilayahKotaFactory extends Factory
{
    protected $model = WilayahKota::class;

    public function definition(): array
    {
        return [
            'name' => $this->faker->unique()->city(),
        ];
    }
}