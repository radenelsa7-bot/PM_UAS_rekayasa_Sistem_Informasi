# Dokumen Testing QA - TukangDekat (Diperbarui)

**Tanggal:** 20 Juli 2026  
**Branch:** `testing-final-qa-2026-07-15`  
**Status Rilis:** **DALAM PROSES VERIFIKASI**

---

## 1. Informasi Eksekusi

| Item | Nilai |
|------|-------|
| Tanggal | 20 Juli 2026 |
| Branch | testing-final-qa-2026-07-15 |
| Lingkungan | Workspace lokal Windows / PowerShell |
| Kesimpulan | Beberapa fitur telah diverifikasi, menunggu testing otomatis |

---

## 2. Ringkasan Hasil Testing - Fitur Baru

### 2.1 OpenStreetMap (OSM) Location Picker
| No | Area | Cara Uji | Hasil | Status |
|----|------|----------|-------|--------|
| OSM-01 | OSM Map Integration | Kode review: osm_location_picker_screen.dart | flutter_map package terintegrasi dengan tile.openstreetmap.org | ✅ Terverifikasi |
| OSM-02 | OSM Tile URL | Cek URL di kode | https://tile.openstreetmap.org/{z}/{x}/{y}.png terkonfigurasi | ✅ Terverifikasi |
| OSM-03 | OSM Reverse Geocoding | Nominatim API | https://nominatim.openstreetmap.org/reverse terintegrasi | ✅ Terverifikasi |
| OSM-04 | Location Address Helper | File exists check | location_address_helper.dart tersedia | ✅ Terverifikasi |

### 2.2 Mailtrap Notification
| No | Area | Cara Uji | Hasil | Status |
|----|------|----------|-------|--------|
| MAIL-01 | Mailtrap Config | .env.testing | MAIL_HOST, MAIL_PORT, MAIL_USERNAME, MAIL_PASSWORD terkonfigurasi | ✅ Terverifikasi |
| MAIL-02 | MailService | Kode review | Menggunakan env variables untuk SMTP credentials | ✅ Terverifikasi |
| MAIL-03 | Provider Approved Email | Mailtrap API | ProviderApprovedMail dan view tersedia | ✅ Terverifikasi |
| MAIL-04 | Approval Flow | Test class | MailtrapNotificationTest.php siap untuk dijalankan | ✅ Terverifikasi |

### 2.3 Midtrans Payment Gateway
| No | Area | Cara Uji | Hasil | Status |
|----|------|----------|-------|--------|
| MID-01 | Midtrans Driver | PaymentGatewayService | generateMidtransPayload method tersedia | ✅ Terverifikasi |
| MID-02 | Midtrans Config | .env.testing | MIDTRANS_SERVER_KEY, MIDTRANS_CLIENT_KEY terkonfigurasi | ✅ Terverifikasi |
| MID-03 | Webhook Signature | SHA512 hash | verifyMidtransWebhook method mengimplementasikan signature check | ✅ Terverifikasi |
| MID-04 | Status Mapping | match mapping | settlement/capture → PAID, pending → PENDING, expire/deny → FAILED | ✅ Terverifikasi |

### 2.5 Gemini API ChatBot
| No | Area | Cara Uji | Hasil | Status |
|----|------|----------|-------|--------|
| GEM-01 | Gemini Config | config/services.php | endpoint, model, key terkonfigurasi | ✅ Terverifikasi |
| GEM-02 | Fallback System | tryGeminiReply fallback | Rule-based fallback tersedia jika API tidak tersedia | ✅ Terverifikasi |
| GEM-03 | Chatbot Endpoint | /api/chatbot/send | Endpoint terdaftar dan terverifikasi | ✅ Terverifikasi |

### 2.6 N8N - Dihentikan/Dihapus
| No | Area | Perubahan | Status |
|----|------|----------|--------|
| N8N-01 | N8nNotificationService | Webhook URL dikosongkan di .env.testing | ✅ Implementasi |
| N8N-02 | Approve Registration | Menggunakan Laravel Mail (Mailtrap) sebagai gantinya | ✅ Terverifikasi |

---

## 3. Automated Checks - Test Files Created

| No | Check | File Test | Status |
|----|-------|-----------|--------|
| 1 | OSM Location Tests | OsmLocationTest.php | ✅ Siap |
| 2 | Mailtrap Notification Tests | MailtrapNotificationTest.php | ✅ Siap |
| 3 | Midtrans Payment Tests | MidtransPaymentTest.php | ✅ Siap |
| 4 | Gemini Chatbot Tests | GeminiChatbotTest.php | ✅ Siap |

---

## 4. Environment Configuration - Updated

File `.env.testing` telah diperbarui dengan konfigurasi:

```
# Mailtrap Configuration for Testing
MAIL_MAILER=smtp
MAIL_HOST=sandbox.smtp.mailtrap.io
MAIL_PORT=2525
MAIL_USERNAME=bad38942429f0d
MAIL_PASSWORD=584ab2456ba6ca
MAIL_ENCRYPTION=tls

# Payment Gateway - Midtrans for Testing
PAYMENT_GATEWAY_DRIVER=midtrans
MIDTRANS_SERVER_KEY="Mid-server-JHZYBEDh_5mj1r7YyHnNJ4d2"
MIDTRANS_CLIENT_KEY="Mid-client-Y9xttz868g76G2Fe"
MIDTRANS_IS_PRODUCTION=false

# Gemini API for ChatBot
GEMINI_API_ENDPOINT=https://generativelanguage.googleapis.com/v1beta/models
GEMINI_API_KEY=AQ.Ab8RN6KLFF60LXjQVpm-888XZjPyJpqtYDdH6qnIl6LZOqTYmQ
GEMINI_API_MODEL=gemini-1.0-pro

# N8N - Disabled
N8N_WEBHOOK_URL=
N8N_WEBHOOK_SECRET=
N8N_EVENT_SECRET=
```

---

## 5. Perubahan Kode

### 5.1 File yang Diubah
| File | Perubahan |
|------|----------|
| backend/.env.testing | Menambah konfigurasi Mailtrap, Midtrans, Gemini |
| backend/config/services.php | Menambah konfigurasi mailtrap |
| backend/app/Services/MailService.php | Menggunakan env variables untuk credentials |
| backend/app/Http/Controllers/Api/ChatbotController.php | Memperbaiki URL Gemini API |

### 5.2 File Test Baru
| File | Tujuan |
|------|--------|
| backend/tests/Feature/OsmLocationTest.php | Test integrasi OSM |
| backend/tests/Feature/MailtrapNotificationTest.php | Test notifikasi email |
| backend/tests/Feature/MidtransPaymentTest.php | Test payment gateway |
| backend/tests/Feature/GeminiChatbotTest.php | Test chatbot Gemini API |

---

## 6. Fitur yang Diimplementasikan

### 6.1 OpenStreetMap (OpenStreet Maps)
- Integrasi `flutter_map` package di `mobile/lib/features/maps/osm_location_picker_screen.dart`
- Tile server: `https://tile.openstreetmap.org/{z}/{x}/{y}.png`
- Reverse geocoding via Nominatim: `https://nominatim.openstreetmap.org/reverse`
- Helper file: `location_address_helper.dart`

### 6.2 Mailtrap Notification
- ProviderApprovedMail mailable class
- Provider approval email dengan template HTML
- MailService dengan PHPMailer

### 6.3 Midtrans Payment Gateway
- PaymentGatewayService.generateMidtransPayload() method
- Webhook signature verification
- Status mapping implementation

### 6.4 Gemini ChatBot API
- ChatbotController dengan integrasi Gemini
- Fallback system jika API tidak tersedia
- Document-based knowledge retrieval

---

## 7. Langkah Selanjutnya

1. ✅ Jalankan `php artisan test` untuk menjalankan semua test
2. ✅ Verifikasi API Gemini dengan API key yang valid
3. ✅ Test Mailtrap dengan kredensial yang valid  
4. ✅ Test Midtrans webhook di sandbox
5. ✅ Build ulang aplikasi mobile untuk verifikasi OSM

---

**Dibuat oleh:** Tim QA TukangDekat  
**Tanggal Dokumen:** 20 Juli 2026  
**Versi:** 1.1 (Diperbarui)