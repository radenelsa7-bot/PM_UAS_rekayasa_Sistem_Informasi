<?php

namespace App\Services\Payout;

use Illuminate\Support\Facades\Http;

/**
 * Simple Xendit payout adapter scaffold.
 *
 * Notes:
 * - Requires XENDIT_API_KEY in environment to be useful.
 * - The exact endpoint/payload may need adjustment to match the provider API.
 */
class XenditPayoutGateway implements PayoutGatewayInterface
{
  protected string $apiKey;
  protected string $baseUrl;
  protected string $disbursementPath;

  public function __construct(string $apiKey, string $baseUrl = 'https://api.xendit.co')
  {
    $this->apiKey = $apiKey;
    $this->baseUrl = rtrim($baseUrl, '/');
    $this->disbursementPath = env('XENDIT_DISBURSEMENT_PATH', '/disbursements');
  }

  public function send(array $payload): array
  {
    // payload: provider_id, amount, payment_ids, force_fail
    if (!empty($payload['force_fail'])) {
      return [
        'success' => false,
        'error' => 'forced-failure',
        'meta' => ['mock' => 1]
      ];
    }

    // Basic disbursement example with endpoint fallback for compatibility.
    try {
      $requestBody = [
        // map fields as required by provider
        'external_id' => 'payout_' . time() . '_' . rand(1000, 9999),
        'bank_code' => $payload['bank_code'] ?? 'MANDIRI',
        'account_holder_name' => $payload['account_name'] ?? 'Provider',
        'account_number' => $payload['account_number'] ?? '0000000000',
        'amount' => (int) round($payload['amount'] ?? 0),
        'description' => $payload['description'] ?? 'Provider payout',
      ];

      $paths = [
        $this->disbursementPath,
        '/disbursements',
        '/v2/disbursements',
      ];
      $paths = array_values(array_unique(array_map(fn($path) => '/' . ltrim($path, '/'), $paths)));

      $res = null;
      foreach ($paths as $path) {
        $res = Http::withBasicAuth($this->apiKey, '')
          ->timeout(15)
          ->withHeaders([
            'X-IDEMPOTENCY-KEY' => 'idem_' . sha1(($requestBody['external_id'] ?? uniqid('', true)) . $path),
          ])
          ->post($this->baseUrl . $path, $requestBody);

        // Retry with next known path only for not found.
        if ($res->status() !== 404) {
          break;
        }
      }

      if ($res && $res->successful()) {
        $body = $res->json();
        return [
          'success' => true,
          'transaction_reference' => $body['id'] ?? ($body['reference'] ?? null),
          'meta' => $body,
        ];
      }

      return [
        'success' => false,
        'error' => $res ? $res->body() : 'No response from provider',
        'meta' => $res ? ($res->json() ?? null) : null,
      ];
    } catch (\Throwable $e) {
      return [
        'success' => false,
        'error' => $e->getMessage(),
      ];
    }
  }
}
