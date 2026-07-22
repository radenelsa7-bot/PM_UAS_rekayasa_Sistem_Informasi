<?php

namespace Database\Factories;

use App\Models\WilayahKecamatan;
use App\Models\WilayahKota;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends Factory<WilayahKecamatan>
 */
class WilayahKecamatanFactory extends Factory
{
    protected $model = WilayahKecamatan::class;

    public function definition(): array
    {
        return [
            'kota_id' => WilayahKota::factory(),
            'name' => $this->faker->unique()->citySuffix(),
        ];
    }
}