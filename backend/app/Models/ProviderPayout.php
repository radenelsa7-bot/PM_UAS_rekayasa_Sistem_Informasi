<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class ProviderPayout extends Model
{
  use HasFactory;

  protected $table = 'provider_payouts';

  protected $casts = [
    'payment_ids' => 'array',
    'amount' => 'decimal:2',
  ];

  protected $fillable = [
    'provider_id',
    'amount',
    'payment_ids',
    'status',
    'sent_at'
  ];

  public function provider()
  {
    return $this->belongsTo(User::class, 'provider_id');
  }

  public function attempts()
  {
    return $this->hasMany(ProviderPayoutAttempt::class, 'provider_payout_id');
  }
}
