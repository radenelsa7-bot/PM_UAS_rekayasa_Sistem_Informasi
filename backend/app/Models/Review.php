<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class Review extends Model
{
  use HasFactory;

  protected $fillable = [
    'order_id',
    'customer_id',
    'provider_id',
    'rating',
    'comment',
  ];

  protected $casts = [
    'rating' => 'integer',
  ];

  public function order(): BelongsTo
  {
    return $this->belongsTo(Order::class);
  }

  public function customer(): BelongsTo
  {
    return $this->belongsTo(User::class, 'customer_id');
  }

  public function provider(): BelongsTo
  {
    return $this->belongsTo(User::class, 'provider_id');
  }
}
