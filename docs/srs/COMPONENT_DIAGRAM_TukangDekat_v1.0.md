# Component Diagram – TukangDekat
Version 1.0  
Date: 2026-03-23

## 1. Deskripsi Singkat
Dokumen ini mendeskripsikan komponen utama sistem TukangDekat dan hubungan antar komponen.

## 2. Daftar Komponen
1) **Mobile App (Flutter)**
   - Menyediakan UI untuk Customer dan Provider.
   - Mengakses backend melalui REST API.

2) **Backend API (Laravel)**
   - Mengelola autentikasi, katalog provider, order, pembayaran, review.
   - Mengirim event notifikasi ke n8n.
   - Menerima webhook dari payment gateway.

3) **Database (MySQL/PostgreSQL)**
   - Menyimpan data user, provider profile, order, payment, review, notification log.

4) **Payment Gateway (QRIS)**
   - Membuat QRIS untuk DP dan pelunasan.
   - Mengirim webhook callback status pembayaran ke backend.

5) **n8n (Workflow Automation)**
   - Menerima event dari backend.
   - Mengirim notifikasi ke WhatsApp dan Email.

6) **WhatsApp Provider**
   - Layanan pihak ketiga untuk pengiriman pesan WhatsApp (melalui n8n).

7) **Email SMTP Provider**
   - Layanan SMTP untuk pengiriman email notifikasi (melalui n8n).

## 3. Interface Antar Komponen
- Mobile App → Backend API: HTTPS REST (JSON)
- Backend API → Database: koneksi DB internal
- Backend API → Payment Gateway: HTTPS API (create payment/QRIS)
- Payment Gateway → Backend API: webhook HTTPS (payment status callback)
- Backend API → n8n: webhook/event HTTPS
- n8n → WhatsApp Provider: HTTPS API
- n8n → Email SMTP Provider: SMTP/HTTPS (tergantung konfigurasi)

## 4. Diagram (Mermaid)
```mermaid
flowchart LR
  M[Mobile App (Flutter)]
  A[Backend API (Laravel)]
  D[(Database)]
  PG[Payment Gateway (QRIS)]
  N[n8n Automation]
  WA[WhatsApp Provider]
  EM[Email SMTP Provider]

  M -- "HTTPS REST (JSON)" --> A
  A -- "DB connection" --> D

  A -- "Create QRIS Payment (HTTPS)" --> PG
  PG -- "Webhook Callback (HTTPS)" --> A

  A -- "Event/Webhook (HTTPS)" --> N
  N -- "Send WhatsApp" --> WA
  N -- "Send Email" --> EM
```

## 5. Catatan
- Component diagram menunjukkan hubungan logis antar komponen, bukan detail server/container.
- Detail penempatan server/container akan dijelaskan pada Deployment Diagram.
