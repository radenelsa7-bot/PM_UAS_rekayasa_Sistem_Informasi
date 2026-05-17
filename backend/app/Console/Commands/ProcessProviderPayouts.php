<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use App\Models\Payment;
use App\Models\ProviderPayout;
use Illuminate\Support\Facades\DB;
use Carbon\Carbon;

class ProcessProviderPayouts extends Command
{
  protected $signature = 'payouts:process {--dry-run}';
  protected $description = 'Aggregate provider payouts for PAID payments and create payout records';

  public function handle()
  {
    $this->info('Starting provider payouts process...');

    // Find paid payments with provider_payout > 0 and not yet processed
    $payments = Payment::where('status', 'PAID')
      ->where('provider_payout', '>', 0)
      ->where(function ($q) {
        $q->whereNull('provider_payout_processed')->orWhere('provider_payout_processed', false);
      })->get();

    if ($payments->isEmpty()) {
      $this->info('No payouts to process.');
      return 0;
    }

    $grouped = $payments->groupBy('order.provider_id');

    DB::beginTransaction();
    try {
      foreach ($grouped as $providerId => $group) {
        $sum = $group->sum('provider_payout');
        $paymentIds = $group->pluck('id')->values()->all();

        $this->info("Creating payout for provider {$providerId} amount {$sum}");

        if (!$this->option('dry-run')) {
          $payout = ProviderPayout::create([
            'provider_id' => $providerId,
            'amount' => $sum,
            'payment_ids' => $paymentIds,
            'status' => 'PENDING',
          ]);

          // mark payments processed
          Payment::whereIn('id', $paymentIds)->update([
            'provider_payout_processed' => true,
            'provider_paid_at' => Carbon::now(),
          ]);
        }
      }

      DB::commit();
      $this->info('Provider payouts aggregated successfully.');
    } catch (\Exception $e) {
      DB::rollBack();
      $this->error('Error processing payouts: ' . $e->getMessage());
      return 1;
    }

    return 0;
  }
}
