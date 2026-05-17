<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class TestWebhookSeeder extends Seeder
{
  public function run()
  {
    $cid = DB::table('users')->insertGetId([
      'name' => 'Customer Test',
      'email' => 'cust-test@example.test',
      'password' => bcrypt('secret'),
      'created_at' => now(),
      'updated_at' => now(),
    ]);

    $pid = DB::table('users')->insertGetId([
      'name' => 'Provider Test',
      'email' => 'prov-test@example.test',
      'password' => bcrypt('secret'),
      'created_at' => now(),
      'updated_at' => now(),
    ]);

    $oid = DB::table('orders')->insertGetId([
      'order_code' => 'ORDER-TEST-2',
      'customer_id' => $cid,
      'provider_id' => $pid,
      'category_id' => null,
      'provider_service_id' => null,
      'schedule_at' => now(),
      'address' => 'Test address',
      'notes' => null,
      'estimated_price' => 100000,
      'created_at' => now(),
      'updated_at' => now(),
    ]);

    $payId = DB::table('payments')->insertGetId([
      'order_id' => $oid,
      'payment_type' => 'DP',
      'amount' => 100000,
      'status' => 'UNPAID',
      'provider' => 'midtrans',
      'external_payment_id' => null,
      'created_at' => now(),
      'updated_at' => now(),
    ]);

    $this->command->info("Test data created: order_id={$oid}, payment_id={$payId}");
  }
}
