<?php

namespace App\Services\Payout;

use App\Models\ProviderPayout;
use App\Models\ProviderPayoutAttempt;

class ProviderPayoutService
{
  protected PayoutGatewayInterface $gateway;

  public function __construct(PayoutGatewayInterface $gateway)
  {
    $this->gateway = $gateway;
  }

  /**
   * Process one payout: create attempt, call gateway, update records
   */
  public function process(ProviderPayout $payout, array $options = []): ProviderPayoutAttempt
  {
    // Prevent processing if max attempts reached
    $max = (int) config('payout.max_attempts', 3);
    $existing = $payout->attempts()->count();
    if ($existing >= $max) {
      $payout->status = 'FAILED';
      $payout->error_message = 'max attempts reached';
      $payout->save();

      // create a final failed attempt record
      return ProviderPayoutAttempt::create([
        'provider_payout_id' => $payout->id,
        'status' => 'FAILED',
        'error_message' => 'max attempts reached',
      ]);
    }

    // create attempt record
    $attempt = ProviderPayoutAttempt::create([
      'provider_payout_id' => $payout->id,
      'status' => 'PENDING',
      'meta' => $options['meta'] ?? null,
    ]);

    $payload = [
      'provider_id' => $payout->provider_id,
      'amount' => $payout->amount,
      'payment_ids' => $payout->payment_ids,
      'force_fail' => $options['force_fail'] ?? false,
    ];

    $res = $this->gateway->send($payload);

    if ($res['success']) {
      $attempt->status = 'SENT';
      $attempt->transaction_reference = $res['transaction_reference'] ?? null;
      $attempt->meta = $res['meta'] ?? null;
      $attempt->save();

      $payout->status = 'SENT';
      $payout->transaction_reference = $res['transaction_reference'] ?? null;
      $payout->sent_at = now();
      $payout->error_message = null;
      $payout->save();
    } else {
      $attempt->status = 'FAILED';
      $attempt->error_message = $res['error'] ?? 'failed';
      $attempt->meta = $res['meta'] ?? null;
      $attempt->save();

      // If reached max attempts, mark payout as permanently failed
      $total = $payout->attempts()->count();
      if ($total >= $max) {
        $payout->status = 'FAILED';
        $payout->error_message = $res['error'] ?? null;
        $payout->save();
        return $attempt;
      }

      // Otherwise keep payout PENDING so job retries can attempt again.
      $payout->status = 'PENDING';
      $payout->error_message = $res['error'] ?? null;
      $payout->save();

      // Throw to let the queue worker retry according to job backoff/tries
      throw new \RuntimeException('Gateway send failed: ' . ($res['error'] ?? 'failed'));
    }

    return $attempt;
  }
}
