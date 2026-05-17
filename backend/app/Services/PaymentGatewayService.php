<?php

namespace App\Services;

use App\Models\Payment;
use Illuminate\Http\Client\RequestException;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Str;

class PaymentGatewayService
{
  public function driver(): string
  {
    return (string) config('services.payments.driver', 'simulation');
  }

  public function generateQrisPayload(Payment $payment): array
  {
    $driver = $this->driver();

    if ($driver === 'simulation') {
      return $this->buildSimulationPayload($payment);
    }

    if ($driver === 'midtrans') {
      return $this->generateMidtransPayload($payment);
    }

    if (!config('services.payments.charge_url')) {
      return $this->buildSimulationPayload($payment, [
        'gateway_error' => true,
        'error_message' => 'payment gateway charge url belum dikonfigurasi',
      ]);
    }

    $payload = [
      'reference' => $this->paymentReference($payment),
      'amount' => $payment->amount,
      'currency' => 'IDR',
      'description' => sprintf('Payment %s for order %s', $payment->payment_type, $payment->order?->order_code ?? $payment->order_id),
      'customer' => [
        'name' => $payment->order?->customer?->name,
        'email' => $payment->order?->customer?->email,
      ],
      'metadata' => [
        'payment_id' => $payment->id,
        'order_id' => $payment->order_id,
        'payment_type' => $payment->payment_type,
      ],
      'callback_url' => url('/api/webhooks/payment'),
    ];

    try {
      $response = Http::timeout(15)
        ->acceptJson()
        ->withHeaders($this->requestHeaders())
        ->post(config('services.payments.charge_url'), $payload)
        ->throw()
        ->json();

      return [
        'provider' => strtoupper($driver),
        'reference' => $response['reference'] ?? $payload['reference'],
        'payment_id' => $payment->id,
        'amount' => $payment->amount,
        'payment_type' => $payment->payment_type,
        'qris_code' => $response['qris_code'] ?? $response['qr_string'] ?? null,
        'qris_image' => $response['qris_image'] ?? $response['qr_image'] ?? null,
        'checkout_url' => $response['checkout_url'] ?? null,
        'raw_response' => $response,
      ];
    } catch (RequestException $e) {
      return $this->buildSimulationPayload($payment, [
        'gateway_error' => true,
        'error_message' => $e->response?->body(),
      ]);
    } catch (\Throwable $e) {
      return $this->buildSimulationPayload($payment, [
        'gateway_error' => true,
        'error_message' => $e->getMessage(),
      ]);
    }
  }

  public function generateMidtransPayload(Payment $payment): array
  {
    $serverKey = (string) config('services.payments.midtrans_server_key', '');
    $isProduction = (bool) config('services.payments.midtrans_is_production', false);

    if ($serverKey === '') {
      return $this->buildSimulationPayload($payment, [
        'gateway_error' => true,
        'error_message' => 'MIDTRANS_SERVER_KEY belum diatur',
      ]);
    }

    $baseUrl = $isProduction
      ? 'https://app.midtrans.com/snap/v1/transactions'
      : 'https://app.sandbox.midtrans.com/snap/v1/transactions';

    $orderId = $this->paymentReference($payment);
    $payload = [
      'transaction_details' => [
        'order_id' => $orderId,
        'gross_amount' => (int) $payment->amount,
      ],
      'item_details' => [[
        'id' => 'payment-' . $payment->id,
        'price' => (int) $payment->amount,
        'quantity' => 1,
        'name' => sprintf('Pembayaran %s - %s', $payment->payment_type, $payment->order?->order_code ?? $payment->order_id),
      ]],
      'customer_details' => [
        'first_name' => $payment->order?->customer?->name ?? 'Customer',
        'email' => $payment->order?->customer?->email,
      ],
      'enabled_payments' => ['qris'],
      'callbacks' => [
        'finish' => url('/payment/finish'),
      ],
    ];

    try {
      $response = Http::withBasicAuth($serverKey, '')
        ->acceptJson()
        ->timeout(20)
        ->post($baseUrl, $payload)
        ->throw()
        ->json();

      return [
        'provider' => 'MIDTRANS',
        'reference' => $orderId,
        'payment_id' => $payment->id,
        'amount' => $payment->amount,
        'payment_type' => $payment->payment_type,
        'qris_code' => $response['token'] ?? null,
        'qris_image' => null,
        'checkout_url' => $response['redirect_url'] ?? null,
        'raw_response' => $response,
      ];
    } catch (RequestException $e) {
      return $this->buildSimulationPayload($payment, [
        'provider' => 'MIDTRANS',
        'gateway_error' => true,
        'error_message' => $e->response?->body(),
      ]);
    } catch (\Throwable $e) {
      return $this->buildSimulationPayload($payment, [
        'provider' => 'MIDTRANS',
        'gateway_error' => true,
        'error_message' => $e->getMessage(),
      ]);
    }
  }

  public function verifyWebhook(Request $request): bool
  {
    if ($this->driver() === 'midtrans') {
      return $this->verifyMidtransWebhook($request);
    }

    $secret = (string) config('services.payments.webhook_secret', '');

    if ($secret === '') {
      return true;
    }

    $headerName = config('services.payments.webhook_signature_header', 'X-Payment-Signature');
    $signature = (string) $request->header($headerName, '');

    if ($signature === '') {
      return false;
    }

    $expected = hash_hmac('sha256', $request->getContent(), $secret);

    return hash_equals($expected, $signature);
  }

  public function verifyMidtransWebhook(Request $request): bool
  {
    $serverKey = (string) config('services.payments.midtrans_server_key', '');
    if ($serverKey === '') {
      return false;
    }

    $orderId = (string) $request->input('order_id', '');
    $statusCode = (string) $request->input('status_code', '');
    $grossAmount = (string) $request->input('gross_amount', '');
    $signatureKey = (string) $request->input('signature_key', '');

    if ($orderId === '' || $statusCode === '' || $grossAmount === '' || $signatureKey === '') {
      return false;
    }

    $expected = hash('sha512', $orderId . $statusCode . $grossAmount . $serverKey);

    return hash_equals($expected, $signatureKey);
  }

  public function mapStatus(?string $status): string
  {
    if ($this->driver() === 'midtrans') {
      return match (strtolower((string) $status)) {
        'settlement', 'capture', 'paid' => 'PAID',
        'pending', 'authorize' => 'PENDING',
        'expire', 'expired', 'cancel', 'deny', 'failure' => 'FAILED',
        default => 'PENDING',
      };
    }

    return match (strtolower((string) $status)) {
      'success', 'paid', 'settlement', 'capture', 'completed' => 'PAID',
      'expired', 'cancel', 'failed', 'deny', 'failure' => 'FAILED',
      'pending', 'authorize' => 'PENDING',
      default => 'PENDING',
    };
  }

  public function paymentReference(Payment $payment): string
  {
    return sprintf('PAY-%s-%s', $payment->id, Str::upper(Str::random(6)));
  }

  public function isConfigured(): bool
  {
    return (string) config('services.payments.driver', 'simulation') !== 'simulation'
      && (string) config('services.payments.charge_url', '') !== '';
  }

  private function requestHeaders(): array
  {
    $headers = [
      'X-Requested-By' => config('app.name'),
    ];

    $token = config('services.payments.api_token');

    if ($token) {
      $headers['Authorization'] = 'Bearer ' . $token;
    }

    return $headers;
  }

  private function buildSimulationPayload(Payment $payment, array $extra = []): array
  {
    return array_merge([
      'provider' => 'SIMULATION',
      'reference' => $this->paymentReference($payment),
      'payment_id' => $payment->id,
      'amount' => $payment->amount,
      'payment_type' => $payment->payment_type,
      'qris_code' => url('/api/webhooks/payment?payment_id=' . $payment->id),
      'qris_image' => 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNk+M9QDwADhgGAWjR9awAAAABJRU5ErkJggg==',
      'checkout_url' => null,
    ], $extra);
  }
}
