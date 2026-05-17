<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use App\Models\ProviderPayoutAttempt;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Mail;

class ExportFailedPayouts extends Command
{
  protected $signature = 'payouts:export-failed {--since=60} {--webhook=} {--email=}';
  protected $description = 'Ekspor kegagalan payout ke CSV dan kirim ke webhook/email';

  public function handle()
  {
    $since = (int) $this->option('since');
    $cut = now()->subMinutes($since);

    $rows = ProviderPayoutAttempt::where('status', 'FAILED')
      ->where('created_at', '>=', $cut)
      ->with('providerPayout')
      ->get();

    if ($rows->isEmpty()) {
      $this->info('No failed attempts found');
      return 0;
    }

    $csv = "provider_payout_id,attempt_id,error,transaction_reference,created_at\n";
    foreach ($rows as $r) {
      $csv .= sprintf(
        "%d,%d,%s,%s,%s\n",
        $r->provider_payout_id,
        $r->id,
        str_replace(["\n", "\r", ","], [' ', ' ', ' '], $r->error_message ?? ''),
        $r->transaction_reference ?? '',
        $r->created_at->toDateTimeString()
      );
    }

    $path = 'exports/failed_payouts-' . now()->format('Ymd_His') . '.csv';
    Storage::disk('local')->put($path, $csv);
    $this->info('Wrote ' . $path);

    $webhook = $this->option('webhook') ?: env('PAYOUT_ALERT_WEBHOOK');
    if ($webhook) {
      try {
        Http::attach('file', $csv, basename($path))
          ->post($webhook, []);
        $this->info('Posted CSV to webhook');
      } catch (\Throwable $e) {
        $this->error('Webhook post failed: ' . $e->getMessage());
      }
    }

    $email = $this->option('email') ?: env('PAYOUT_ALERT_EMAIL');
    if ($email) {
      try {
        Mail::raw('See attached CSV for failed payouts', function ($m) use ($email, $path) {
          $m->to($email)->subject('Failed payouts export')
            ->attach(storage_path('app/' . $path));
        });
        $this->info('Emailed CSV to ' . $email);
      } catch (\Throwable $e) {
        $this->error('Email send failed: ' . $e->getMessage());
      }
    }

    return 0;
  }
}
