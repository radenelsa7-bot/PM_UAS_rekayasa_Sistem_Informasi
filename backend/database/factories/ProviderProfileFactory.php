<?php

namespace Database\Factories;

use App\Models\ProviderProfile;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends Factory<ProviderProfile>
 */
class ProviderProfileFactory extends Factory
{
  protected $model = ProviderProfile::class;

  public function definition(): array
  {
    return [
      'user_id' => null,
      'business_name' => $this->faker->company(),
      'description' => $this->faker->paragraph(),
      'area' => $this->faker->city(),
      'address' => $this->faker->address(),
      'is_verified' => true,
      'avg_rating' => 0,
    ];
  }
}
