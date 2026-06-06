<?php

namespace Database\Factories;

use App\Models\ProviderPayout;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends Factory<ProviderPayout>
 */
class ProviderPayoutFactory extends Factory
{
  protected $model = ProviderPayout::class;

  public function definition(): array
  {
    return [
      'provider_id' => null,
      'amount' => $this->faker->randomFloat(2, 100000, 1000000),
      'payment_ids' => [],
      'status' => 'pending',
      'sent_at' => null,
    ];
  }
}
