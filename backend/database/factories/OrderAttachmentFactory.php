<?php

namespace Database\Factories;

use App\Models\OrderAttachment;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends Factory<OrderAttachment>
 */
class OrderAttachmentFactory extends Factory
{
  protected $model = OrderAttachment::class;

  public function definition(): array
  {
    return [
      'order_id' => null,
      'file_url' => $this->faker->imageUrl(640, 480, 'technics'),
      'file_type' => 'image/jpeg',
    ];
  }
}
