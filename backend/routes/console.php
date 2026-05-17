<?php

use Illuminate\Foundation\Inspiring;
use Illuminate\Support\Facades\Artisan;
use Illuminate\Support\Facades\Http;

Artisan::command('inspire', function () {
    $this->comment(Inspiring::quote());
})->purpose('Display an inspiring quote');

Artisan::command(
    'midtrans:send-webhook {url?} {--order=PAY-1-EXAMPLE} {--status=200} {--gross=100000} {--payment=1} {--transaction-status=settlement}',
    function () {
        $url = $this->argument('url') ?? $this->ask('Webhook URL (eg https://abcd.ngrok.io/api/webhooks/payment)');

        $orderId = $this->option('order');
        $statusCode = (string) $this->option('status');
        $gross = (string) $this->option('gross');
        $paymentId = (int) $this->option('payment');
        $transactionStatus = $this->option('transaction-status');

        $serverKey = config('services.payments.midtrans_server_key') ?: $this->ask('MIDTRANS_SERVER_KEY');

        $signature = hash('sha512', $orderId . $statusCode . $gross . $serverKey);

        $payload = [
            'order_id' => $orderId,
            'status_code' => $statusCode,
            'gross_amount' => $gross,
            'transaction_status' => $transactionStatus,
            'signature_key' => $signature,
            'transaction_id' => 'TX-CLI-' . time(),
            'metadata' => ['payment_id' => $paymentId],
        ];

        $this->info('Sending webhook to: ' . $url);
        $this->info('Payload: ' . json_encode($payload));

        try {
            $response = Http::timeout(10)->post($url, $payload);

            $this->info('HTTP ' . $response->status());
            $this->line((string) $response->body());
        } catch (\Throwable $e) {
            $this->error('Request failed: ' . $e->getMessage());
        }
    }
)->purpose('Send a test Midtrans webhook payload to the specified URL');
