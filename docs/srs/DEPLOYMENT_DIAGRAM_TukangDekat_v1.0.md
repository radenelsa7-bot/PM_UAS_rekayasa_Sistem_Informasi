# Deployment Diagram – TukangDekat
Version 1.0  
Date: 2026-03-23

## 1. Tujuan
Deployment diagram ini menggambarkan topologi pemasangan (deployment) sistem TukangDekat pada server/VPS menggunakan container Docker, serta koneksi ke layanan eksternal (Payment Gateway QRIS, WhatsApp/Email).

## 2. Node/Environment
### 2.1 Client
- **Android Device (Customer/Provider App)**  
  Menjalankan aplikasi Flutter dan mengakses Backend API melalui HTTPS.

### 2.2 Server
- **VPS/Cloud Server (Linux)**
  Menjalankan Docker Engine dan Docker Compose untuk menjalankan beberapa container:
  1) Nginx (reverse proxy / web server)
  2) Laravel API (PHP-FPM / app container)
  3) Database (MySQL/PostgreSQL)
  4) n8n (workflow automation)

## 3. Komponen dalam Server (Docker Containers)
### 3.1 nginx container
- Menerima request HTTPS dari internet (client).
- Meneruskan (reverse proxy) request API ke container Laravel.

### 3.2 laravel-api container
- Menyediakan REST API (auth, provider, order, payment, review).
- Mengakses database internal.
- Mengirim event webhook ke n8n.
- Menerima webhook callback dari payment gateway.

### 3.3 db container
- Menyimpan data aplikasi (users, provider_profiles, orders, payments, reviews, notification_logs).

### 3.4 n8n container
- Menerima event webhook dari backend (order_created, dp_paid, order_completed, final_paid).
- Mengirim notifikasi ke WhatsApp provider dan Email provider.

## 4. Layanan Eksternal
- **Payment Gateway QRIS**  
  Dipakai untuk membuat QRIS pembayaran dan mengirim callback webhook status pembayaran.
- **WhatsApp Provider** (via API)  
  Dipakai oleh n8n untuk mengirim pesan WA.
- **Email SMTP Provider**  
  Dipakai oleh n8n untuk mengirim email notifikasi.

## 5. Diagram Deployment (Mermaid)
```mermaid
flowchart TB
  %% Client
  subgraph CLIENT["Client (Android)"]
    APP[Flutter Mobile App]
  end

  %% Server
  subgraph VPS["VPS / Cloud Server (Linux)"]
    subgraph DOCKER["Docker Network (docker-compose)"]
      NGINX[nginx container\n:443 HTTPS Reverse Proxy]
      API[laravel-api container\nREST API]
      DB[(db container\nMySQL/PostgreSQL)]
      N8N[n8n container\nworkflow automation]
    end
  end

  %% External services
  PG[Payment Gateway (QRIS)]
  WA[WhatsApp Provider API]
  SMTP[Email SMTP Provider]

  %% Flows
  APP -- "HTTPS REST API" --> NGINX
  NGINX -- "proxy_pass /api" --> API
  API -- "DB connection" --> DB

  API -- "Create QRIS payment (HTTPS)" --> PG
  PG -- "Webhook callback (HTTPS)" --> NGINX
  NGINX -- "route /api/webhooks/*" --> API

  API -- "Webhook events (HTTPS)" --> N8N
  N8N -- "Send WhatsApp" --> WA
  N8N -- "Send Email" --> SMTP
```

## 6. Catatan Implementasi (untuk UAS)
- Semua komponen di server dijalankan menggunakan **Docker Compose**.
- Domain + SSL (HTTPS) dapat dikelola menggunakan konfigurasi Nginx (atau opsional pakai Traefik).
- Keamanan webhook payment gateway wajib menggunakan verifikasi signature/secret.
- Untuk skala tugas besar, deployment 1 server sudah cukup.
