<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use App\Models\ProviderPayout;
use App\Jobs\SendProviderPayoutJob;

class ProcessPendingProviderPayouts extends Command
{
  protected $signature = 'payouts:process-pending {--limit=10}';
  protected $description = 'Process pending provider payouts (dispatch jobs)';

  public function handle()
  {
    $limit = (int) $this->option('limit');
    $list = ProviderPayout::where('status', 'PENDING')->limit($limit)->get();
    $this->info('Found ' . $list->count() . ' pending payouts');
    foreach ($list as $p) {
      SendProviderPayoutJob::dispatch($p->id, []);
      $this->info('Dispatched payout ' . $p->id);
    }
    return 0;
  }
}
