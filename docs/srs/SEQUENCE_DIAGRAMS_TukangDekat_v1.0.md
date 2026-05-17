# Sequence Diagrams – TukangDekat
Version 1.0  
Date: 2026-03-23

Dokumen ini berisi sequence diagram untuk proses utama TukangDekat.
Diagram disediakan dalam:
1) Urutan langkah (mudah digambar di StarUML/draw.io)
2) Mermaid sequence diagram (langsung tampil di GitHub)

---

## SD-01 – Login
### A) Langkah-langkah (untuk StarUML)
Aktor/Objek:
- User (Mobile App)
- Mobile App
- API (Laravel)
- Database

Urutan:
1. User mengisi email dan password di Mobile App.
2. Mobile App mengirim request `POST /api/auth/login` ke API.
3. API memvalidasi input.
4. API mengambil data user berdasarkan email dari Database.
5. API memverifikasi password.
6. Jika valid, API membuat token akses.
7. API mengembalikan response sukses + token.
8. Mobile App menyimpan token dan menampilkan dashboard sesuai role.

Alur gagal:
- Jika email/password salah → API mengembalikan error (401) → Mobile App menampilkan pesan error.

### B) Mermaid
```mermaid
sequenceDiagram
  autonumber
  actor U as User
  participant M as Mobile App
  participant A as API (Laravel)
  participant D as Database

  U->>M: Input email & password
  M->>A: POST /api/auth/login
  A->>A: Validate request
  A->>D: Query user by email
  D-->>A: user data (hash, role)
  A->>A: Verify password
  alt valid
    A-->>M: 200 OK + token
    M-->>U: Dashboard
  else invalid
    A-->>M: 401 Unauthorized
    M-->>U: Show error message
  end
```

---

## SD-02 – Create Order + Create DP (50%) Invoice
### A) Langkah-langkah (untuk StarUML)
Aktor/Objek:
- Customer (Mobile App)
- Mobile App
- API (Laravel)
- Database
- n8n (untuk notifikasi order dibuat) [opsional event]

Urutan:
1. Customer memilih provider dan mengisi form order (jadwal, alamat, catatan, estimasi harga).
2. Mobile App mengirim request `POST /api/orders` ke API dengan token.
3. API memvalidasi token dan request body.
4. API menyimpan Order ke Database dengan status `CREATED`.
5. API menghitung DP = 50% dari `estimated_price`.
6. API menyimpan Payment DP ke Database dengan status `UNPAID`.
7. (Opsional) API mengirim event ke n8n: order_created.
8. API mengembalikan response berisi data order dan dp_payment.

Alur gagal:
- Jika token invalid → 401.
- Jika data tidak valid → 422.

### B) Mermaid
```mermaid
sequenceDiagram
  autonumber
  actor C as Customer
  participant M as Mobile App
  participant A as API (Laravel)
  participant D as Database
  participant N as n8n

  C->>M: Isi form order + pilih provider
  M->>A: POST /api/orders (token + payload)
  A->>A: Auth + Validate
  A->>D: Insert Order (status=CREATED)
  D-->>A: Order id
  A->>A: Calculate DP = 50% estimated_price
  A->>D: Insert Payment (type=DP, status=UNPAID)
  D-->>A: Payment id
  opt notify
    A->>N: Webhook event order_created
    N-->>A: 200 OK
  end
  A-->>M: 201 Created (order + dp_payment)
  M-->>C: Tampilkan detail order + tombol bayar DP
```

---

## SD-03 – Pay DP with QRIS + Payment Callback (Webhook) + Order Start Allowed
### A) Langkah-langkah (untuk StarUML)
Aktor/Objek:
- Customer (Mobile App)
- Mobile App
- API (Laravel)
- Payment Gateway (QRIS)
- Database
- n8n (notifikasi DP paid)

Urutan utama:
1. Customer klik “Bayar DP”.
2. Mobile App mengirim request `POST /api/payments/{dp_id}/qris` ke API.
3. API meminta pembuatan transaksi QRIS ke Payment Gateway (charge/create payment).
4. Payment Gateway mengembalikan data QR (qr_url/qr_string) + expiry.
5. API mengubah status payment menjadi `PENDING` (opsional) dan menyimpan external id.
6. API mengembalikan QR ke Mobile App.
7. Customer membayar dengan scan QR.
8. Payment Gateway mengirim callback ke endpoint webhook `POST /api/webhooks/midtrans`.
9. API memverifikasi signature/secret callback.
10. API mengubah status Payment DP menjadi `PAID` dan menyimpan waktu bayar.
11. API mengirim event ke n8n: dp_paid (notifikasi WA/email ke customer & provider).
12. Provider sekarang diperbolehkan memulai order (cek DP paid saat start).

Alur gagal:
- Callback tidak valid signature → tolak callback.
- Pembayaran gagal/expired → status payment `FAILED/EXPIRED` → customer diminta generate QR ulang.

### B) Mermaid
```mermaid
sequenceDiagram
  autonumber
  actor C as Customer
  participant M as Mobile App
  participant A as API (Laravel)
  participant P as Payment Gateway (QRIS)
  participant D as Database
  participant N as n8n

  C->>M: Klik bayar DP
  M->>A: POST /api/payments/{dp_id}/qris
  A->>A: Auth + Validate payment
  A->>P: Create QRIS payment (amount, order_id)
  P-->>A: QR data + expiry + external_id
  A->>D: Update Payment(status=PENDING, external_id)
  D-->>A: OK
  A-->>M: 200 OK + qr_url/qr_string
  M-->>C: Tampilkan QR untuk dibayar

  Note over C,P: Customer scan QR dan bayar di aplikasi pembayaran

  P->>A: POST /api/webhooks/midtrans (payment result)
  A->>A: Verify signature/secret
  alt paid
    A->>D: Update Payment(status=PAID, paid_at)
    D-->>A: OK
    A->>N: Webhook event dp_paid (WA/email)
    N-->>A: 200 OK
    A-->>P: 200 OK
  else failed/expired
    A->>D: Update Payment(status=FAILED/EXPIRED)
    D-->>A: OK
    A-->>P: 200 OK
  end
```

---

## SD-04 – Complete Order + Create Final Payment + Pay Final + Close Order
### A) Langkah-langkah (untuk StarUML)
Aktor/Objek:
- Provider (Mobile App)
- Customer (Mobile App)
- API (Laravel)
- Database
- Payment Gateway (QRIS)
- n8n

Urutan:
1. Provider mengubah order menjadi selesai dan mengirim `final_price` melalui `POST /api/orders/{id}/complete`.
2. API memvalidasi role provider dan status order.
3. API mengubah status order menjadi `COMPLETED` dan menyimpan `final_price`.
4. API menghitung `final_amount = final_price - dp_amount`.
5. API membuat Payment FINAL status `UNPAID`.
6. API mengirim event n8n: order_completed (minta customer bayar pelunasan).
7. Customer generate QRIS pelunasan `POST /api/payments/{final_id}/qris`.
8. Payment Gateway callback webhook pelunasan PAID.
9. API update Payment FINAL menjadi `PAID`.
10. API update status order menjadi `CLOSED`.
11. API mengirim event n8n: final_paid (order closed).

### B) Mermaid
```mermaid
sequenceDiagram
  autonumber
  actor PR as Provider
  actor CU as Customer
  participant M as Mobile App
  participant A as API (Laravel)
  participant D as Database
  participant P as Payment Gateway (QRIS)
  participant N as n8n

  PR->>M: Complete order + input final_price
  M->>A: POST /api/orders/{id}/complete
  A->>A: Auth(role=PROVIDER) + Validate status
  A->>D: Update Order(status=COMPLETED, final_price)
  D-->>A: OK
  A->>D: Create Payment(type=FINAL, status=UNPAID)
  D-->>A: final_payment_id
  A->>N: Webhook event order_completed
  N-->>A: 200 OK
  A-->>M: 200 OK (order + final_payment)

  CU->>M: Generate QR pelunasan
  M->>A: POST /api/payments/{final_id}/qris
  A->>P: Create QRIS payment (final amount)
  P-->>A: QR data + external_id
  A->>D: Update Payment(status=PENDING, external_id)
  D-->>A: OK
  A-->>M: 200 OK (QR)

  P->>A: POST /api/webhooks/midtrans (final payment result)
  A->>A: Verify signature/secret
  A->>D: Update Payment FINAL(status=PAID)
  D-->>A: OK
  A->>D: Update Order(status=CLOSED)
  D-->>A: OK
  A->>N: Webhook event final_paid
  N-->>A: 200 OK
  A-->>P: 200 OK
```
