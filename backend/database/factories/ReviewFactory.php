<?php

namespace Database\Factories;

use App\Models\Review;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends Factory<Review>
 */
class ReviewFactory extends Factory
{
  protected $model = Review::class;

  public function definition(): array
  {
    return [
      'order_id' => null,
      'customer_id' => null,
      'provider_id' => null,
      'rating' => $this->faker->numberBetween(1, 5),
      'comment' => $this->faker->optional()->sentence(),
    ];
  }
}
