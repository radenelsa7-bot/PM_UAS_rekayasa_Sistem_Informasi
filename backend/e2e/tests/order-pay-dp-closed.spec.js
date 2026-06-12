const fs = require('fs');
const path = require('path');
const { test, expect } = require('@playwright/test');

function loadToken() {
  if (process.env.TEST_TOKEN) return process.env.TEST_TOKEN;

  const envPath = path.resolve(__dirname, '..', '.env');
  if (!fs.existsSync(envPath)) return '';

  const content = fs.readFileSync(envPath, 'utf8');
  const match = content.match(/^TEST_TOKEN=(.+)$/m);
  return match ? match[1].trim() : '';
}

// This test requires a TEST_TOKEN (see backend/e2e/README.md -> test:make-token)
test.describe('Order end-to-end: pay DP, start, complete, pay final -> CLOSED', () => {
  test('customer creates order, pays DP; provider completes and final paid -> order CLOSED', async ({ request }) => {
    const token = loadToken();
    test.skip(!token, 'TEST_TOKEN not set in environment');

    const authHeader = { Authorization: `Bearer ${token}` };

    // 1) Create order (customer)
    const createRes = await request.post('/api/orders', {
      headers: { ...authHeader, 'Content-Type': 'application/json' },
      data: {
        provider_user_id: 10,
        category_id: 1,
        provider_service_id: 100,
        schedule_at: new Date(Date.now() + 24 * 60 * 60 * 1000).toISOString(),
        address: 'Jl. Test E2E 1',
        notes: 'E2E order for DP flow',
        estimated_price: 200000
      }
    });

    expect(createRes.status()).toBe(201);
    const createBody = await createRes.json();
    const order = createBody.data.order;
    const dpPayment = createBody.data.dp_payment;
    expect(order).toBeTruthy();
    expect(dpPayment).toBeTruthy();

    const orderId = order.id;
    const dpPaymentId = dpPayment.id;

    // 2) Generate QRIS for DP payment
    const genRes = await request.post(`/api/payments/${dpPaymentId}/generate-qris`, { headers: authHeader });
    expect(genRes.status()).toBe(200);
    const genBody = await genRes.json();
    expect(genBody.data).toBeTruthy();

    // 3) Simulate payment gateway callback for DP
    const webhookDp = await request.post('/webhooks/payment', {
      headers: { 'Content-Type': 'application/json' },
      data: {
        payment_id: dpPaymentId,
        transaction_id: `SIM-DP-${dpPaymentId}`,
        status: 'success'
      }
    });
    expect([200, 201, 204]).toContain(webhookDp.status());

    // 4) Provider starts the order (should be allowed after DP paid)
    const startRes = await request.post(`/api/orders/${orderId}/start`, { headers: authHeader });
    expect([200, 201]).toContain(startRes.status());

    // 5) Provider completes the order and submits final_price (creates final payment)
    const finalPrice = 150000;
    const completeRes = await request.post(`/api/orders/${orderId}/complete`, {
      headers: { ...authHeader, 'Content-Type': 'application/json' },
      data: { final_price: finalPrice }
    });
    expect([200, 201]).toContain(completeRes.status());
    const completeBody = await completeRes.json();
    // Expect final_payment in response
    const finalPayment = completeBody.data?.final_payment || completeBody.data?.payment || null;
    expect(finalPayment).toBeTruthy();

    const finalPaymentId = finalPayment?.id;
    expect(finalPaymentId).toBeTruthy();

    // 6) Generate QRIS for final payment (optional, but keep parity)
    const genFinalRes = await request.post(`/api/payments/${finalPaymentId}/generate-qris`, { headers: authHeader });
    expect([200, 201]).toContain(genFinalRes.status());

    // 7) Simulate payment callback for final payment
    const webhookFinal = await request.post('/webhooks/payment', {
      headers: { 'Content-Type': 'application/json' },
      data: {
        payment_id: finalPaymentId,
        transaction_id: `SIM-FINAL-${finalPaymentId}`,
        status: 'success'
      }
    });
    expect([200, 201, 204]).toContain(webhookFinal.status());

    // 8) Verify order is CLOSED
    const getOrder = await request.get(`/api/orders/${orderId}`, { headers: authHeader });
    expect(getOrder.status()).toBe(200);
    const getOrderBody = await getOrder.json();
    const refreshedOrder = getOrderBody.data;
    expect(refreshedOrder).toBeTruthy();
    expect(refreshedOrder.status).toBe('CLOSED');
  });
});
