# Backend API - TukangDekat
## Setup & Running

### Prerequisites
- PHP 8.1+
- MySQL 8.0+
- Composer
- Laravel 11

### Installation & Setup
```bash
# 1. Install dependencies
composer install

# 2. Configure .env
cp .env.example .env
# Update DB_* variables:
# DB_DATABASE=db_tukangdekat
# DB_USERNAME=root
# DB_PASSWORD=

# 3. Generate app key
php artisan key:generate

# 4. Run migrations & seeding
php artisan migrate:fresh --seed

# 5. Start server
php artisan serve --host=0.0.0.0 --port=8000
```

## API Endpoints

### 1. Authentication (Public)
```
POST   /api/auth/register     - Register user baru (CUSTOMER/PROVIDER)
POST   /api/auth/login        - Login & get token
POST   /api/auth/logout       - Logout (require token)
```

### 2. Catalog (Public)
```
GET    /api/catalog/categories                    - Get all categories
GET    /api/catalog/categories/{categoryId}/providers  - Get providers by category
GET    /api/catalog/providers/{providerId}       - Get provider detail
GET    /api/catalog/providers/search?q=...       - Search providers
```

### 3. Orders (Protected - auth:sanctum)
```
POST   /api/orders                      - Create order (CUSTOMER only)
GET    /api/orders/my-orders            - Get my orders
GET    /api/orders/{orderId}            - Get order detail
POST   /api/orders/{orderId}/respond    - Provider accept/reject order
POST   /api/orders/{orderId}/start-work - Provider start work
POST   /api/orders/{orderId}/complete   - Provider complete order
```

### 4. Payments (Protected)
```
GET    /api/payments/order/{orderId}         - Get payments for order
GET    /api/payments/{paymentId}             - Get payment status
POST   /api/payments/{paymentId}/generate-qris  - Generate QRIS
POST   /api/webhooks/payment                 - Payment gateway callback (webhook)
```

### 5. Reviews (Protected)
```
POST   /api/reviews/order/{orderId}      - Create review (CUSTOMER only)
GET    /api/reviews/provider/{providerId} - Get provider reviews
GET    /api/reviews/order/{orderId}       - Get order review
```

## Sample Requests

### Register
```bash
curl -X POST http://localhost:8000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Fajar",
    "email": "fajar@mail.com",
    "phone": "08xxxx",
    "password": "secret123",
    "role": "CUSTOMER"
  }'
```

### Login
```bash
curl -X POST http://localhost:8000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "fajar@mail.com",
    "password": "secret123"
  }'
```

### Create Order (with token)
```bash
curl -X POST http://localhost:8000/api/orders \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer TOKEN_HERE" \
  -d '{
    "provider_id": 1,
    "category_id": 1,
    "schedule_at": "2026-05-15 14:00:00",
    "address": "Jl. Raya No. 123",
    "notes": "Ada kerusakan di saklar",
    "estimated_price": 300000
  }'
```

## Test Accounts

**Customer:**
- Email: fajar@example.com
- Password: password123

**Provider:**
- Email: andi.listrik@example.com (Listrik)
- Email: budi.plumbing@example.com (Plumbing)
- Email: citra.ac@example.com (AC)
- Password: password123 (semua)

## Database Schema

### Tables Created
- users
- provider_profiles
- service_categories
- provider_services
- orders
- order_attachments
- payments
- reviews
- notification_logs

## Architecture

- **Controller**: Handle HTTP requests & validation
- **Models**: Database entities dengan relationships
- **Routes**: RESTful API endpoints
- **Middleware**: Authentication (Sanctum)

## Key Features Implemented

✅ User Registration & Login (Sanctum tokens)
✅ Role-based access control (CUSTOMER, PROVIDER, ADMIN, TREASURER)
✅ Service Catalog & Search
✅ Order Lifecycle (CREATED → ACCEPTED → IN_PROGRESS → COMPLETED → CLOSED)
✅ Payment management (DP 50% + Final settlement)
✅ Review & Rating system
✅ Notification logging
✅ Error handling & validation

## Next Steps

1. Implement Provider Management panel (admin)
2. Integrate payment gateway (Midtrans/Xendit)
3. Setup n8n workflow for notifications
4. Add file upload for order attachments
5. Implement Treasurer reporting dashboard
6. Add order history & filtering
7. Setup Docker compose for deployment
