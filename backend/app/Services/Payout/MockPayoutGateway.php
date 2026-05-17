<?php

namespace App\Services\Payout;

class MockPayoutGateway implements PayoutGatewayInterface
{
  public function send(array $payload): array
  {
    // deterministic success for now; can be randomized for testing
    $success = $payload['force_fail'] ?? false ? false : true;

    if ($success) {
      return [
        'success' => true,
        'transaction_reference' => 'MOCK-' . uniqid(),
        'error' => null,
        'meta' => ['mock' => true],
      ];
    }

    return [
      'success' => false,
      'transaction_reference' => null,
      'error' => 'Mock failure',
      'meta' => ['mock' => true],
    ];
  }
}
