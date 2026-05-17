<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class ProviderPayoutAttempt extends Model
{
  use HasFactory;

  protected $table = 'provider_payout_attempts';

  protected $casts = [
    'meta' => 'array',
  ];

  protected $fillable = ['provider_payout_id', 'status', 'transaction_reference', 'error_message', 'meta'];

  public function payout()
  {
    return $this->belongsTo(ProviderPayout::class, 'provider_payout_id');
  }
}
