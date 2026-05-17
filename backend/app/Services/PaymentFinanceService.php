<?php

namespace App\Services;

use App\Models\Order;
use App\Models\Payment;

class PaymentFinanceService
{
  public function commissionPercent(): int
  {
    return (int) config('services.payments.platform_commission_percent', 10);
  }

  public function refundPercent(): int
  {
    return (int) config('services.payments.dp_refund_percent', 100);
  }

  public function calculatePlatformFee(Payment $payment): int
  {
    $percent = max(0, $this->commissionPercent());

    return (int) round(($payment->amount * $percent) / 100);
  }

  public function calculateProviderPayout(Payment $payment): int
  {
    return max(0, $payment->amount - $this->calculatePlatformFee($payment));
  }

  public function applySettlementSnapshot(Payment $payment): array
  {
    return [
      'commission_percent' => $this->commissionPercent(),
      'platform_fee' => $this->calculatePlatformFee($payment),
      'provider_payout' => $this->calculateProviderPayout($payment),
      'settlement_status' => 'READY',
    ];
  }

  public function applyRefundPolicy(Payment $payment, Order $order, string $reason = 'order_cancelled'): array
  {
    $refundAmount = (int) round(($payment->amount * max(0, $this->refundPercent())) / 100);

    return [
      'refund_amount' => $refundAmount,
      'refund_status' => 'REQUESTED',
      'refund_reason' => $reason,
      'refund_requested_at' => now(),
      'settlement_status' => 'REFUND_REQUESTED',
      'platform_fee' => 0,
      'provider_payout' => 0,
      'commission_percent' => $this->commissionPercent(),
    ];
  }
}
