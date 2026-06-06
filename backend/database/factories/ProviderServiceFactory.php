<?php

namespace Database\Factories;

use App\Models\ProviderService;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends Factory<ProviderService>
 */
class ProviderServiceFactory extends Factory
{
  protected $model = ProviderService::class;

  public function definition(): array
  {
    return [
      'provider_profile_id' => null,
      'category_id' => null,
      'name' => $this->faker->word() . ' Service',
      'base_price' => $this->faker->numberBetween(50000, 200000),
      'price_unit' => 'per_hour',
      'is_active' => true,
    ];
  }
}
