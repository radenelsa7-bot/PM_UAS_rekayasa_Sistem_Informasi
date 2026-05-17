<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use App\Models\ProviderPayoutAttempt;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Mail;

class AlertFailedPayouts extends Command
{
  protected $signature = 'payouts:alert {--since=60 : minutes to look back}';
  protected $description = 'Alert if there are failed payout attempts in the recent window';

  public function handle()
  {
    $since = (int) $this->option('since');
    $cut = now()->subMinutes($since);

    $count = ProviderPayoutAttempt::where('status', 'FAILED')
      ->where('created_at', '>=', $cut)
      ->count();

    if ($count === 0) {
      $this->info('No recent failed payouts');
      return 0;
    }

    $this->info("Found {$count} failed attempts in last {$since} minutes");

    $webhook = config('services.payouts.alert_webhook') ?? env('PAYOUT_ALERT_WEBHOOK');
    $email = env('PAYOUT_ALERT_EMAIL');

    $payload = ['failed_count' => $count, 'window_minutes' => $since, 'timestamp' => now()->toDateTimeString()];

    if ($webhook) {
      try {
        Http::timeout(5)->post($webhook, $payload);
        $this->info('Posted to webhook');
      } catch (\Throwable $e) {
        $this->error('Webhook post failed: ' . $e->getMessage());
      }
    }

    if ($email) {
      try {
        Mail::raw('Failed payouts: ' . json_encode($payload), function ($m) use ($email) {
          $m->to($email)->subject('Alert: failed provider payouts');
        });
        $this->info('Email sent to ' . $email);
      } catch (\Throwable $e) {
        $this->error('Email send failed: ' . $e->getMessage());
      }
    }

    return 0;
  }
}
