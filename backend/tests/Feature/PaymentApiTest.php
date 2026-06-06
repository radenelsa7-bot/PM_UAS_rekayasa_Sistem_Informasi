<?php

namespace Tests\Feature;

use App\Models\Order;
use App\Models\Payment;
use App\Models\ServiceCategory;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class PaymentApiTest extends TestCase
{
    use RefreshDatabase;

    private User $customer;
    private User $provider;
    private Order $order;
    private Payment $payment;

    protected function setUp(): void
    {
        parent::setUp();

        $this->customer = User::create([
            'name' => 'Customer Test',
            'email' => 'customer@test.local',
            'phone' => '081100000000',
            'password' => bcrypt('secret123'),
            'role' => 'CUSTOMER',
            'status' => 'ACTIVE',
        ]);

        $this->provider = User::create([
            'name' => 'Provider Test',
            'email' => 'provider@test.local',
            'phone' => '081200000000',
            'password' => bcrypt('secret123'),
            'role' => 'PROVIDER',
            'status' => 'ACTIVE',
        ]);

        $category = ServiceCategory::create([
            'name' => 'Service Category',
            'description' => 'Test category',
            'icon' => 'default.svg',
        ]);

        $this->order = Order::create([
            'order_code' => Order::generateCode(),
            'customer_id' => $this->customer->id,
            'provider_id' => $this->provider->id,
            'category_id' => $category->id,
            'provider_service_id' => null,
            'schedule_at' => now()->addDay(),
            'address' => 'Test address',
            'notes' => 'Please do it well',
            'estimated_price' => 100000,
            'status' => 'CREATED',
        ]);

        $this->payment = Payment::create([
            'order_id' => $this->order->id,
            'payment_type' => 'DP',
            'amount' => 50000,
            'status' => 'UNPAID',
        ]);
    }

    public function test_customer_can_generate_qris_for_own_payment()
    {
        $loginResponse = $this->postJson('/api/auth/login', [
            'email' => $this->customer->email,
            'password' => 'secret123',
        ]);

        $token = $loginResponse->json('token') ?? $loginResponse->json('data.token');
        $this->assertNotEmpty($token, 'Customer login token should be returned');

        $response = $this->withHeaders([
            'Authorization' => "Bearer $token",
        ])->postJson("/api/payments/{$this->payment->id}/generate-qris");

        $response->assertStatus(200);
        $response->assertJsonStructure(['data' => ['qris_code', 'payment_id', 'provider']]);

        $this->assertDatabaseHas('payments', [
            'id' => $this->payment->id,
            'status' => 'PENDING',
        ]);
    }

    public function test_other_provider_cannot_access_payment_status_for_unrelated_order()
    {
        $otherProvider = User::create([
            'name' => 'Other Provider',
            'email' => 'other-provider@test.local',
            'phone' => '081300000000',
            'password' => bcrypt('secret123'),
            'role' => 'PROVIDER',
            'status' => 'ACTIVE',
        ]);

        $loginResponse = $this->postJson('/api/auth/login', [
            'email' => $otherProvider->email,
            'password' => 'secret123',
        ]);

        $token = $loginResponse->json('token') ?? $loginResponse->json('data.token');
        $this->assertNotEmpty($token, 'Other provider login token should be returned');

        $response = $this->withHeaders([
            'Authorization' => "Bearer $token",
        ])->getJson("/api/payments/{$this->payment->id}");

        $response->assertStatus(403);
        $response->assertJson(['message' => 'unauthorized']);
    }
}
