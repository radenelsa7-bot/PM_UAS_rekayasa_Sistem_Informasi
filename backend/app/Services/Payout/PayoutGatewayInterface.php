<?php

namespace App\Services\Payout;

interface PayoutGatewayInterface
{
  /**
   * Execute payout and return array with keys: success(bool), transaction_reference|null, error|null, meta(array)
   */
  public function send(array $payload): array;
}
