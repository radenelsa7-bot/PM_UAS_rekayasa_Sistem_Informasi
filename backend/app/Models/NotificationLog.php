<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class NotificationLog extends Model
{
  use HasFactory;

  protected $fillable = [
    'event_name',
    'channel',
    'payload_json',
    'status',
    'sent_at',
  ];

  protected $casts = [
    'sent_at' => 'datetime',
  ];
}
