<?php

namespace Database\Factories;

use App\Models\ProviderPayoutAttempt;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends Factory<ProviderPayoutAttempt>
 */
class ProviderPayoutAttemptFactory extends Factory
{
  protected $model = ProviderPayoutAttempt::class;

  public function definition(): array
  {
    return [
      'provider_payout_id' => null,
      'status' => 'attempted',
      'transaction_reference' => $this->faker->uuid(),
      'error_message' => null,
      'meta' => [],
    ];
  }
}
