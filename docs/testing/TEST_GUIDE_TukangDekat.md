# Testing Guide – TukangDekat

**Version:** 1.0  
**Last Updated:** June 2026  
**Author:** QA Team  

---

## Table of Contents

1. [Overview](#overview)
2. [Testing Strategy](#testing-strategy)
3. [Backend Testing](#backend-testing)
4. [Frontend/Mobile Testing](#frontendmobile-testing)
5. [E2E Testing](#e2e-testing)
6. [Performance Testing](#performance-testing)
7. [Security Testing](#security-testing)
8. [Test Execution](#test-execution)
9. [CI/CD Integration](#cicd-integration)
10. [Bug Reporting](#bug-reporting)

---

## Overview

TukangDekat is a service marketplace platform with the following main components:

- **Backend:** Laravel 11 REST API
- **Mobile:** Flutter (Android & iOS)
- **Payment:** Midtrans QRIS integration
- **Automation:** n8n for notifications
- **Database:** MySQL

**Testing Scope:**
- Unit Tests (Business Logic)
- Integration Tests (API, Database, External Services)
- Feature Tests (Endpoint Validation)
- E2E Tests (User Journeys)
- Performance Tests (Load, Response Time)
- Security Tests (Authentication, Authorization, Input Validation)

---

## Testing Strategy

### Test Pyramid

```
        △
       ╱ ╲
      ╱ E2E╲
     ╱──────╲
    ╱Integration╲
   ╱──────────────╲
  ╱    Unit Tests   ╲
 ╱────────────────────╲
```

- **Unit Tests:** 50% (Individual functions, services)
- **Integration Tests:** 30% (Database, external API calls)
- **E2E Tests:** 20% (Complete user journeys)

### Coverage Goals

| Component | Target Coverage | Current |
|-----------|-----------------|---------|
| Backend Services | 80% | TBD |
| Controllers | 70% | TBD |
| Models | 85% | TBD |
| Mobile UI | 60% | TBD |

---

## Backend Testing

### Setup

```bash
cd backend

# Install dependencies
composer install

# Create test database
cp .env.example .env.testing
php artisan migrate --database=testing --seed

# Run tests
php artisan test
```

### Test Structure

```
backend/tests/
├── Unit/
│   ├── XenditPayoutGatewayTest.php      # Payment gateway logic
│   ├── PayoutMonitoringTest.php         # Monitoring & alerts
│   └── ExampleTest.php
├── Feature/
│   ├── PaymentWebhookTest.php           # Webhook processing
│   ├── PayoutFlowTest.php               # Order → Payout flow
│   ├── TreasurerExportTest.php          # Treasurer reports
│   └── AuthTest.php
└── Integration/
    └── NetworkBackoffTest.php           # Retry & backoff logic
```

### Unit Tests

**Purpose:** Test isolated business logic without external dependencies.

#### Example: Payout Gateway Test

```php
// backend/tests/Unit/XenditPayoutGatewayTest.php
public function test_send_success_returns_transaction_reference()
{
    Http::fake([
        '*' => Http::response(['id' => 'tx-1'], 200)
    ]);

    $gateway = new XenditPayoutGateway('test_key', 'https://api.test');
    $res = $gateway->send([
        'amount' => 10000,
        'bank_code' => 'MANDIRI',
        'account_number' => '000111222333'
    ]);

    $this->assertTrue($res['success']);
    $this->assertSame('tx-1', $res['transaction_reference']);
}
```

**Run Unit Tests:**

```bash
php artisan test --filter=XenditPayoutGatewayTest
```

### Feature Tests

**Purpose:** Test API endpoints with database interactions.

#### Example: Payment Webhook Test

```php
// backend/tests/Feature/PaymentWebhookTest.php
public function test_midtrans_webhook_marks_payment_paid_and_closes_final_order()
{
    config([
        'services.payments.driver' => 'midtrans',
        'services.payments.midtrans_server_key' => 'midtrans-secret-key',
    ]);

    $customer = User::factory()->create(['role' => 'CUSTOMER']);
    $provider = User::factory()->create(['role' => 'PROVIDER']);

    $order = Order::create([
        'order_code' => 'ORD-' . now()->format('Ymd') . '-0001',
        'customer_id' => $customer->id,
        'provider_id' => $provider->id,
        'status' => 'CREATED',
    ]);

    $payment = Payment::create([
        'order_id' => $order->id,
        'payment_type' => 'FINAL',
        'amount' => 150000,
        'status' => 'PENDING',
    ]);

    $payload = [
        'order_id' => $payment->external_payment_id,
        'status_code' => '200',
        'transaction_status' => 'settlement',
        'signature_key' => hash('sha512', /* ... */),
    ];

    $response = $this->postJson('/api/webhooks/payment', $payload);

    $response->assertStatus(200);
    $this->assertSame('PAID', $payment->fresh()->status);
    $this->assertSame('CLOSED', $order->fresh()->status);
}
```

**Run Feature Tests:**

```bash
php artisan test --filter=PaymentWebhookTest
```

### Integration Tests

**Purpose:** Test retry logic, backoff, and network failures.

#### Example: Network Backoff Test

```php
// backend/tests/Integration/NetworkBackoffTest.php
public function test_retries_on_5xx_then_succeeds()
{
    Http::fakeSequence()
        ->push(['message' => 'server error'], 500)
        ->push(['id' => 'tx_123'], 200);

    $gateway = new XenditPayoutGateway('test_key', 'https://api.xendit.test');
    $res = $gateway->send(['amount' => 10000]);

    $this->assertTrue($res['success']);
    Http::assertSentCount(2);  // Verify retry happened
}
```

**Run Integration Tests:**

```bash
php artisan test tests/Integration/
```

### Key Test Scenarios

#### 1. Authentication & Authorization

- [ ] Register as CUSTOMER → get token
- [ ] Register as PROVIDER → get token
- [ ] Login with invalid credentials → 401
- [ ] Access protected endpoint without token → 401
- [ ] CUSTOMER accessing PROVIDER endpoint → 403
- [ ] Token expiry & refresh

#### 2. Order Lifecycle

- [ ] Create order → AUTO-CREATE DP 50% payment
- [ ] Receive order in provider dashboard
- [ ] Provider ACCEPT order
- [ ] Start order when DP is PAID (not before)
- [ ] Complete order → AUTO-CREATE FINAL payment
- [ ] Cannot CLOSE order until FINAL is PAID
- [ ] Cancel order (valid status transitions)

#### 3. Payment Flow

- [ ] Generate QRIS → get QR code
- [ ] Webhook: PAID → update Payment status + Order status
- [ ] Webhook: Invalid signature → 401
- [ ] Webhook: Duplicate event → idempotent
- [ ] Webhook: EXPIRED QR → expiry date tracked

#### 4. Treasurer Reports

- [ ] Treasurer GET /api/treasurer/payments/report
- [ ] Export CSV with proper headers
- [ ] Export XLS with data
- [ ] Non-treasurer access → 403
- [ ] Filter by date range

#### 5. Admin Functions

- [ ] ADMIN verify provider
- [ ] Provider becomes verified + searchable
- [ ] Provider profile visibility

### Run All Backend Tests

```bash
# Run all tests
php artisan test

# Run with coverage report
php artisan test --coverage

# Run specific test file
php artisan test tests/Feature/PaymentWebhookTest.php

# Run with detailed output
php artisan test --verbose

# Stop on first failure
php artisan test --stop-on-failure
```

---

## Frontend/Mobile Testing

### Setup

```bash
cd mobile

# Install dependencies
flutter pub get

# Run tests
flutter test
```

### Widget Tests

**Location:** `mobile/test/widget_test.dart`

**Purpose:** Test individual UI components in isolation.

```dart
void main() {
  testWidgets('Login screen validates email', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());

    // Find widgets
    expect(find.byType(EmailField), findsOneWidget);
    expect(find.byType(PasswordField), findsOneWidget);

    // Enter invalid email
    await tester.enterText(find.byType(EmailField), 'invalid');
    await tester.tap(find.byType(LoginButton));
    await tester.pump();

    // Expect error message
    expect(find.text('Invalid email'), findsOneWidget);
  });
}
```

### Integration Tests (Flutter)

**Location:** `mobile/integration_test/`

**Purpose:** Test app flows on actual device/emulator.

```dart
// mobile/integration_test/app_test.dart
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Complete order flow', (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();

    // Login
    await tester.enterText(find.byType(TextField).first, 'user@test.com');
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    // Search provider
    await tester.tap(find.byIcon(Icons.search));
    await tester.enterText(find.byType(SearchField), 'AC Repair');
    await tester.pumpAndSettle();

    // Create order
    await tester.tap(find.text('Order Now'));
    await tester.pumpAndSettle();

    expect(find.text('Order Created'), findsOneWidget);
  });
}
```

**Run Mobile Tests:**

```bash
# Widget tests
flutter test

# Integration tests on Android
flutter drive --target=integration_test/app_test.dart

# Integration tests on emulator
flutter test integration_test/
```

### Key Mobile Test Scenarios

- [ ] Register & login flow
- [ ] Search provider by category
- [ ] Filter providers (rating, distance, price)
- [ ] Create order with schedule picker
- [ ] Upload photo attachment
- [ ] View QRIS QR code
- [ ] Polling payment status
- [ ] Submit review & rating
- [ ] Provider-side: accept/reject order
- [ ] Provider-side: input final price & complete
- [ ] Navigation between screens
- [ ] Token refresh on 401
- [ ] Network error handling
- [ ] Offline mode (if applicable)

---

## E2E Testing

### Setup

```bash
cd backend/e2e

# Install Playwright
npm install @playwright/test

# Create .env
cp .env.example .env
# Set: TEST_TOKEN, API_BASE_URL
```

### Test Structure

```
backend/e2e/
├── tests/
│   ├── treasurer-export.spec.js
│   ├── payment-flow.spec.js
│   ├── order-lifecycle.spec.js
│   └── auth-flow.spec.js
├── playwright.config.js
└── README.md
```

### Example: Treasurer Export Test

```javascript
// backend/e2e/tests/treasurer-export.spec.js
const { test, expect } = require('@playwright/test');

test.describe('Treasurer export endpoint', () => {
  test('CSV export returns CSV when TEST_TOKEN provided', async ({ request }) => {
    const token = process.env.TEST_TOKEN;
    test.skip(!token, 'TEST_TOKEN not set');

    const res = await request.get('/api/treasurer/payments/report?export=csv', {
      headers: {
        'Authorization': `Bearer ${token}`,
        'Accept': 'text/csv'
      }
    });

    expect(res.status()).toBe(200);
    expect(res.headers()['content-type']).toContain('text/csv');
    
    const body = await res.text();
    expect(body).toContain('payment_id');
    expect(body.length).toBeGreaterThan(10);
  });

  test('XLS export with data', async ({ request }) => {
    const token = process.env.TEST_TOKEN;
    
    const res = await request.get('/api/treasurer/payments/report?export=xls', {
      headers: { 'Authorization': `Bearer ${token}` }
    });

    expect(res.status()).toBe(200);
    expect(res.headers()['content-disposition']).toContain('treasurer_payments_');
  });
});
```

### Run E2E Tests

```bash
cd backend/e2e

# Run all tests
npx playwright test

# Run specific test file
npx playwright test tests/treasurer-export.spec.js

# Run with UI mode
npx playwright test --ui

# Run with debugging
npx playwright test --debug

# Generate HTML report
npx playwright show-report
```

### E2E Test Coverage

- [ ] **Auth Flow**
  - Register CUSTOMER & PROVIDER
  - Login with valid/invalid credentials
  - Token persistence

- [ ] **Order Lifecycle**
  - Customer creates order
  - Provider receives order
  - Accept/reject order
  - Start work (when DP paid)
  - Complete work & input final price
  - Closed order status

- [ ] **Payment Flow**
  - Generate QRIS
  - Simulate webhook payment
  - Order status transitions
  - Final payment & order closure

- [ ] **Treasurer Reports**
  - Export CSV
  - Export XLS
  - Filter by date
  - Authorization check

---

## Performance Testing

### Load Testing (Apache JMeter)

**File:** `docs/testing/jmeter-tukangdekat.jmx`

#### Scenario: 100 concurrent users, 5-minute duration

```
Thread Group:
  - Number of Threads: 100
  - Ramp-up Time: 60 sec
  - Loop Count: 10

HTTP Requests:
  - GET /api/categories
  - POST /api/auth/login
  - GET /api/providers
  - POST /api/orders
```

**Run Load Test:**

```bash
jmeter -n -t docs/testing/jmeter-tukangdekat.jmx -l results.jtl -j jmeter.log
```

### Performance Targets (NFR-01)

| Endpoint | Target Response Time | Current |
|----------|----------------------|---------|
| GET /api/categories | < 500ms | TBD |
| GET /api/providers | < 1000ms | TBD |
| POST /api/orders | < 1500ms | TBD |
| POST /api/webhooks/payment | < 500ms | TBD |
| GET /api/treasurer/payments/report | < 2000ms | TBD |

### Profiling

```bash
# Backend profiling
php artisan tinker

# Use Laravel Debugbar
composer require barryvdh/laravel-debugbar --dev

# Slow query log
php artisan db:monitor

# Check N+1 queries
composer require barryvdh/laravel-query-detector --dev
```

---

## Security Testing

### OWASP Top 10 Checklist

- [ ] **A01: Broken Access Control**
  - CUSTOMER cannot access PROVIDER endpoints
  - PROVIDER cannot access ADMIN endpoints
  - Token expiry enforced

- [ ] **A02: Cryptographic Failures**
  - Passwords hashed with bcrypt (10+ rounds)
  - HTTPS enabled
  - Sensitive data not logged

- [ ] **A03: Injection**
  - SQL injection: use parameterized queries (Eloquent)
  - XSS: output encoding in Flutter
  - Command injection: avoid shell_exec

- [ ] **A04: Insecure Design**
  - Business rules enforced (e.g., start order only if DP PAID)
  - Rate limiting on sensitive endpoints

- [ ] **A05: Security Misconfiguration**
  - Remove debug mode in production
  - Disable directory listing
  - Set secure headers

- [ ] **A06: Vulnerable Components**
  - Keep Laravel, packages up-to-date
  - Use `composer audit`
  - Scan with `npm audit` (Node packages)

- [ ] **A07: Authentication Failures**
  - 2FA optional (future enhancement)
  - Login attempt throttling
  - Session timeout

- [ ] **A08: Software & Data Integrity Failures**
  - Webhook signature verification mandatory
  - Code review before deploy
  - Dependency pinning

- [ ] **A09: Logging & Monitoring Failures**
  - Log failed payment attempts
  - Log unauthorized access
  - Alert on repeated failures

- [ ] **A10: SSRF**
  - Validate payment gateway URLs
  - Whitelist external services

### Security Test Commands

```bash
# Check dependencies for vulnerabilities
composer audit
npm audit (if using Node packages)

# Run security linter
php artisan tinker
# Check for hardcoded secrets

# Test webhook signature validation
php tests/Feature/PaymentWebhookTest.php --filter=rejects_invalid_signature

# Test rate limiting
ab -n 100 -c 10 http://localhost:8000/api/auth/login

# Test CORS headers
curl -H "Origin: https://evil.com" http://localhost:8000/api/orders

# Test authentication
curl -H "Authorization: Bearer invalid_token" http://localhost:8000/api/orders
```

---

## Test Execution

### Before Each Sprint

```bash
# 1. Update test data
php artisan migrate:fresh --seed

# 2. Run all tests
php artisan test --coverage

# 3. Check coverage report
open storage/coverage/index.html

# 4. Run security audit
composer audit

# 5. Run mobile tests
cd mobile && flutter test

# 6. Update test documentation
# Update docs/testing/ if needed
```

### Daily Sanity Check

```bash
# Quick smoke test
php artisan test tests/Feature/AuthTest.php
php artisan test tests/Feature/PaymentWebhookTest.php

# Check for new bugs
gh issue list --repo radenelsa7-bot/PM_UAS_rekayasa_Sistem_Informasi \
  --state open --label "bug" --limit 10
```

### Before Release

```bash
# 1. Full test suite
php artisan test --coverage --stop-on-failure

# 2. E2E tests
npx playwright test --project=chromium

# 3. Load test (30 sec, 50 users)
jmeter -n -t docs/testing/jmeter-tukangdekat-quick.jmx

# 4. Security scan
composer audit
npm audit (if applicable)

# 5. Mobile build & test
flutter build apk --release
flutter test integration_test/

# 6. Smoke test on staging
bash backend/deploy/smoke-test.sh
```

---

## CI/CD Integration

### GitHub Actions Workflow

**File:** `.github/workflows/test.yml`

```yaml
name: Test Suite

on: [push, pull_request]

jobs:
  backend:
    runs-on: ubuntu-latest
    services:
      mysql:
        image: mysql:8.0
        env:
          MYSQL_ROOT_PASSWORD: root
          MYSQL_DATABASE: tukangdekat_test

    steps:
      - uses: actions/checkout@v3
      - uses: shivammathur/setup-php@v2
        with:
          php-version: '8.2'
          extensions: mysql, curl

      - name: Install dependencies
        run: |
          cd backend
          composer install --no-progress

      - name: Run tests
        run: |
          cd backend
          php artisan test --coverage

      - name: Upload coverage
        uses: codecov/codecov-action@v3

  mobile:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.10.0'

      - name: Run tests
        run: |
          cd mobile
          flutter test

  e2e:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-node@v3
        with:
          node-version: '18'

      - name: Install Playwright
        run: npx playwright install

      - name: Run E2E tests
        run: |
          cd backend/e2e
          npm install
          npx playwright test
        env:
          TEST_TOKEN: ${{ secrets.TEST_TOKEN }}
          API_BASE_URL: http://localhost:8000
```

---

## Bug Reporting

### Bug Report Template

**Title:** `[COMPONENT] Brief description`

**Example:** `[Payment] Webhook fails with 500 when signature invalid`

**Description:**

```
## Steps to Reproduce

1. Generate QRIS payment
2. Send webhook with invalid signature
3. Observe response

## Expected Behavior

Return 401 Unauthorized with clear error message

## Actual Behavior

Returns 500 Internal Server Error

## Environment

- Backend: Laravel 11 (commit abc1234)
- Database: MySQL 8.0
- OS: Ubuntu 22.04

## Logs

```
[2026-06-10 10:30:45] production.ERROR: Call to undefined method... in PaymentWebhookController.php:45
```

## Attachments

- Screenshot of error
- curl command to reproduce
```

### Create Bug Issue

```bash
gh issue create \
  --title "[Payment] Webhook fails with 500 when signature invalid" \
  --body "$(cat bug-report.md)" \
  --label "bug,priority: high,module: payment"
```

---

## Test Maintenance

### Monthly Tasks

- [ ] Review & update test data (seeders)
- [ ] Delete obsolete test files
- [ ] Update test documentation
- [ ] Archive old test results
- [ ] Analyze test coverage gaps
- [ ] Update performance baselines

### Quarterly Tasks

- [ ] Review & upgrade testing frameworks
- [ ] Evaluate new testing tools
- [ ] Conduct security testing audit
- [ ] Performance testing benchmarking
- [ ] Team training on new test patterns

---

## Resources

### Documentation

- [Laravel Testing Docs](https://laravel.com/docs/11.x/testing)
- [Flutter Testing Guide](https://flutter.dev/docs/testing)
- [Playwright Docs](https://playwright.dev)
- [OWASP Testing Guide](https://owasp.org/www-project-web-security-testing-guide/)

### Tools

- **Backend:** PHPUnit, Artisan
- **Mobile:** Flutter Test, Integration Testing
- **E2E:** Playwright, Postman
- **Load:** Apache JMeter
- **Security:** OWASP ZAP, Composer Audit

### CI/CD

- GitHub Actions (free for public repos)
- Codecov (coverage tracking)

---

## Contact & Support

**QA Lead:** aldyrmdny-lab  
**Questions?** Comment in GitHub Issues or DM on Slack.

---

**Last Updated:** June 2026  
**Next Review:** July 2026
