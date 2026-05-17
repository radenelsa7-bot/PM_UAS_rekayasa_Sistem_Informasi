<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use App\Models\ProviderPayoutAttempt;
use Illuminate\Support\Facades\Storage;

class MonitorFailedPayouts extends Command
{
  protected $signature = 'payouts:monitor {--export= : export CSV to storage/exports}';
  protected $description = 'List recent failed provider payout attempts and optionally export to CSV';

  public function handle()
  {
    $rows = ProviderPayoutAttempt::where('status', 'FAILED')
      ->latest()
      ->limit(200)
      ->get();

    if ($rows->isEmpty()) {
      $this->info('No failed payout attempts');
      return 0;
    }

    $this->table(['id', 'provider_payout_id', 'error_message', 'created_at'], $rows->map(function ($r) {
      return [$r->id, $r->provider_payout_id, substr((string)$r->error_message, 0, 120), $r->created_at];
    })->toArray());

    $export = $this->option('export');
    if ($export !== null) {
      $path = 'exports/failed_payouts_' . date('Ymd_His') . '.csv';
      $lines = [];
      $lines[] = "id,provider_payout_id,error_message,meta,created_at";
      foreach ($rows as $r) {
        $meta = json_encode($r->meta ?? []);
        $err = str_replace(["\n", "\r", ","], [' ', ' ', ';'], (string)$r->error_message);
        $lines[] = implode(',', [$r->id, $r->provider_payout_id, '"' . $err . '"', '"' . addslashes($meta) . '"', $r->created_at]);
      }
      if (!Storage::exists('exports')) Storage::makeDirectory('exports');
      Storage::put($path, implode("\n", $lines));
      $this->info('Exported to storage/' . $path);
    }

    return 0;
  }
}
