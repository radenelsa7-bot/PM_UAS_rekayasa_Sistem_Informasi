# Class Diagram Specification – TukangDekat
Version 1.0  
Date: 2026-03-23

## 1. Daftar Kelas (Classes) dan Atribut Utama

### 1) User
- id (UUID/INT)
- name (string)
- email (string, unique)
- phone (string)
- password_hash (string)
- role (enum: CUSTOMER, PROVIDER, ADMIN, TREASURER)
- status (enum: ACTIVE, INACTIVE)
- created_at, updated_at (datetime)

### 2) ProviderProfile
- id
- user_id (FK → User.id)
- business_name (string)
- description (text)
- area (string)  // contoh: Bojongloa Kaler
- address (text)
- is_verified (boolean)
- avg_rating (decimal, computed/denormalized optional)
- created_at, updated_at

### 3) ServiceCategory
- id
- name (string) // Listrik, Plumbing, AC, Bangunan Ringan, Servis Elektronik Rumah
- description (text, optional)
- is_active (boolean)

### 4) ProviderService
- id
- provider_profile_id (FK → ProviderProfile.id)
- category_id (FK → ServiceCategory.id)
- name (string) // contoh: “Service AC”
- base_price (integer)
- price_unit (string) // contoh: “per unit”, “per kunjungan”
- is_active (boolean)

### 5) Order
- id
- order_code (string, unique)
- customer_id (FK → User.id)
- provider_id (FK → User.id)
- category_id (FK → ServiceCategory.id) // atau provider_service_id (opsional)
- provider_service_id (FK → ProviderService.id, nullable)
- schedule_at (datetime)
- address (text)
- notes (text, nullable)
- estimated_price (integer)
- final_price (integer, nullable)
- status (enum: CREATED, ACCEPTED, IN_PROGRESS, COMPLETED, CANCELLED, CLOSED)
- created_at, updated_at

### 6) OrderAttachment (opsional tapi bagus buat foto kerusakan)
- id
- order_id (FK → Order.id)
- file_url (string)
- file_type (string) // image/jpeg, dll
- created_at

### 7) Payment
- id
- order_id (FK → Order.id)
- payment_type (enum: DP, FINAL)
- amount (integer)
- status (enum: UNPAID, PENDING, PAID, FAILED, EXPIRED)
- provider (enum: MIDTRANS, XENDIT, OTHER)
- external_payment_id (string, nullable)
- paid_at (datetime, nullable)
- created_at, updated_at

### 8) Review
- id
- order_id (FK → Order.id, unique) // 1 order maksimal 1 review
- customer_id (FK → User.id)
- provider_id (FK → User.id)
- rating (int 1..5)
- comment (text, nullable)
- created_at

### 9) NotificationLog (untuk audit notifikasi)
- id
- event_name (string) // order_created, dp_paid, final_paid, dll
- channel (enum: WA, EMAIL)
- payload_json (text)
- status (enum: SENT, FAILED)
- sent_at (datetime)
- created_at

## 2. Relasi Antar Kelas (Associations)
- User (1) —— (0..1) ProviderProfile
- ProviderProfile (1) —— (0..*) ProviderService
- ServiceCategory (1) —— (0..*) ProviderService
- User (Customer) (1) —— (0..*) Order
- User (Provider) (1) —— (0..*) Order
- Order (1) —— (0..*) Payment
- Order (1) —— (0..*) OrderAttachment
- Order (1) —— (0..1) Review
- User (Customer) (1) —— (0..*) Review
- User (Provider) (1) —— (0..*) Review

## 3. Catatan Desain
- Payment untuk setiap Order minimal 2 record: DP dan FINAL.
- Order tidak boleh masuk IN_PROGRESS jika Payment(DP) belum PAID (aturan bisnis).
