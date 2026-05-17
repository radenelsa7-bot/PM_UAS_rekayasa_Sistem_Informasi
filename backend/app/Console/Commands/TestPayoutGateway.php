<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use App\Services\Payout\PayoutGatewayInterface;

class TestPayoutGateway extends Command
{
  protected $signature = 'payouts:test-gateway {amount=10000} {--to=} {--force : Allow running in production}';
  protected $description = 'Kirim percobaan payout melalui gateway terkonfigurasi (sandbox/mock)';

  public function handle()
  {
    if (app()->environment('production') && !$this->option('force')) {
      $this->error('Tidak boleh menjalankan command ini di production tanpa --force');
      return 1;
    }

    $amount = (int) $this->argument('amount');
    $to = $this->option('to') ?: '0000000000';

    $gateway = app(PayoutGatewayInterface::class);

    $this->info(sprintf('Menggunakan gateway: %s', get_class($gateway)));

    $payload = [
      'account_number' => $to,
      'account_name' => 'Test Payout',
      'bank_code' => 'MANDIRI',
      'amount' => $amount,
      'description' => 'Test payout from artisan command',
      'force_fail' => false,
    ];

    $this->info('Mengirim request ke gateway...');
    $res = $gateway->send($payload);

    $this->info('Hasil:');
    $this->line(json_encode($res, JSON_PRETTY_PRINT | JSON_UNESCAPED_SLASHES));

    $errorCode = data_get($res, 'meta.error_code') ?: data_get($res, 'meta.errorCode');
    if ($errorCode === 'REQUEST_FORBIDDEN_ERROR') {
      $this->warn('Key valid, tapi akun/API key belum punya izin untuk endpoint payout/disbursement. Aktifkan akses disbursement di dashboard Xendit atau minta permission ke Xendit support.');
    } elseif ($errorCode === 'INVALID_API_KEY') {
      $this->warn('API key tidak valid. Pastikan yang dipakai adalah secret sandbox key, bukan public key.');
    }

    return 0;
  }
}
