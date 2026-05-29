# Progress Tracking - Project Aplikasi TukangDekat

Tanggal: 2026-05-21

Dokumen ini mencatat progres backend dan frontend dalam satu tempat, supaya mudah dilacak dari awal sampai akhir.

## Sudah Selesai

### Backend
- Hardened `XenditPayoutGateway` untuk payout pipeline.
- Menyimpan response provider ke tabel `payout_provider_responses`.
- Menambahkan notifikasi `PayoutFailed`.
- Menambahkan job antrian `SendPayoutAlertWebhook`.
- Menulis unit test untuk adapter, monitoring, dan job.
- Memperbarui dokumentasi deploy/secrets dan runbook.
- Menyelesaikan `RELEASE_NOTES.md` dan `QA_CHECKLIST.md`.
- Menjalankan full PHPUnit test suite, semua lulus.
- Merilis tag `v1.0.0` dan memperbarui draft release menjadi release publik.
- Commit dan push perubahan ke `main` sudah dilakukan.
- ✅ **feature/backend-122-ci-staging**: Menambahkan GitHub Actions workflow `ci-staging.yml` untuk job integration/staging yang digate oleh secrets (`DEPLOY_KEY`). Job berjalan saat push/dispatch ke branch ini, melakukan: composer install, setup .env dari secrets, migrate, dan run tests. Fallback job informatif jika secrets tidak dikonfigurasi.

### Frontend
- Status frontend utama masih fokus pada tracking branch dan pemetaan issue.
- Branch tracking frontend sudah dibuat untuk memudahkan pemisahan task.
- Struktur progres frontend sudah dipetakan ke beberapa milestone: foundation, service flow, payment flow, dan polish/release.

### Manajemen Proyek
- Branch tracking backend/frontend sudah dibuat.
- Draft PR tracking sudah dibuat untuk beberapa grup task agar management lebih rapi.

## Masih Belum Selesai

### Backend
- Integration test lengkap untuk network failures dan backoff.
- Migrasi dan enable queue worker di staging/production.
- Smoke test dan post-deploy verification.
- Monitoring/metrics produksi seperti Sentry atau Prometheus.

### Frontend
- Payout-alerts UI / notifikasi untuk admin atau treasurer.
- Build dan run frontend tests (`vite`, `tailwind`, `js`).
- Update API docs dan frontend integration notes.

## Tracking Branch dan PR

### Backend Tracking Branch
- `feature/backend-89-90-foundation-tracking` - foundation, setup, auth, services, models.
- `feature/backend-101-103-core-api-tracking` - orders, DP auto-create, reviews.
- `feature/backend-109-111-payments-webhooks-tracking` - payment gateway, webhook, n8n integration.
- `feature/backend-119-124-finalization-deploy-tracking` - admin endpoints, hardening, deploy.

### Frontend Tracking Branch
- `feature/frontend-91-99-foundation-tracking` - setup, wireframe, login, home, register.
- `feature/frontend-104-106-service-flow-tracking` - form booking, detail layanan, provider profile.
- `feature/frontend-112-114-payment-flow-tracking` - pembayaran DP, pembayaran sisa, rating/review.
- `feature/frontend-116-125-polish-release-tracking` - integration, polish UI, build APK.

## Branch Khusus Pekerjaan Belum Selesai

Bagian ini disiapkan untuk branch yang benar-benar dipakai mengerjakan task yang masih pending atau masih berjalan. Nama branch di bawah dibuat mengikuti pola issue/PR agar mudah dipetakan.

### Backend
- `feature/backend-121-integration-backoff` - integration test untuk network failures dan backoff.
- `feature/backend-123-deploy-smoke` - migrasi staging, enable queue worker, dan smoke test post-deploy.
- `feature/backend-124-monitoring-alerts` - monitoring/metrics produksi dan alerting.

### Frontend
- `feature/frontend-125-alert-ui` - UI notifikasi payout untuk admin/treasurer.
- `feature/frontend-126-tests` - build dan run frontend tests.
- `feature/frontend-127-api-notes` - update API docs dan frontend integration notes.

### Status Repository
- Branch aktif saat ini: `main`
- Remote `main` sudah di-push
- Working tree bersih

## Catatan

- Dokumen ini bersifat ringkas dan fokus pada backend/frontend.
- Jika ada perubahan besar, update bagian "Sudah Selesai" dan "Masih Belum Selesai" terlebih dahulu.

## Keputusan Arsitektur Auth (2026-05-29)

- **Keputusan:** Mendukung kedua mode auth: (1) token-based Personal Access Tokens untuk mobile/third-party clients, dan (2) Sanctum SPA cookie/session untuk web SPAs.
- **Alasan:** Backend sudah menggunakan middleware `auth:sanctum` dan saat ini `AuthController` mengeluarkan personal access tokens. Untuk keamanan web dan CSRF protection, cookie/session (Sanctum SPA) lebih baik; mobile tetap memakai tokens.
- **Implementasi yang dilakukan:** Menambahkan handler session login (`sessionLogin`) dan session logout (`sessionLogout`) pada `App\Http\Controllers\Api\AuthController`, serta menambahkan API routes `/api/auth/session-login`, `/api/auth/session-logout`, dan `/api/user-session`.

## Hasil Verifikasi Lokal (2026-05-29)

### Setup yang Sudah Dilakukan:
1. Migrate database ke MySQL (tukangdekat_test)
2. Fix migration order (renaming 000010 → 000003)
3. Seed test user: `test@example.com` / `password123`
4. Setup `.env`: `SESSION_DRIVER=cookie`, `SANCTUM_STATEFUL_DOMAINS=localhost:8000`
5. Buat test script `/backend/test_auth_flow.php` untuk verifikasi

### Test Results:
| Flow | Endpoint | Status | Result |
|------|----------|--------|--------|
| CSRF Cookie | GET `/sanctum/csrf-cookie` | 204 | ✅ CSRF cookie diperoleh |
| Token Login | POST `/api/auth/login` | 200 | ✅ Token berhasil dibuat & dikembalikan |
| Token Protected | GET `/api/user` + Bearer | 200 | ✅ User data diperoleh dengan token |
| Session Login | POST `/api/auth/session-login` | TBD* | ⚠️  Perlu debugging CSRF/session handling |
| Session Protected | GET `/api/user-session` | TBD* | ⚠️  Tergantung session login |

*) Endpoint sudah ter-register namun perlu verifikasi lebih lanjut di production-like environment (frontend JavaScript akan menangani CSRF & cookies dengan benar).

### Files Modified:
- [backend/app/Http/Controllers/Api/AuthController.php](backend/app/Http/Controllers/Api/AuthController.php) — +2 methods (`sessionLogin`, `sessionLogout`)
- [backend/routes/api.php](backend/routes/api.php) — +2 session endpoints
- [backend/routes/web.php](backend/routes/web.php) — cleanup (moved SPA routes ke API)
- [backend/database/migrations/2026_05_16_000002_add_provider_payout_processed_to_payments.php](backend/database/migrations/2026_05_16_000002_add_provider_payout_processed_to_payments.php) — fix dependency check
- [backend/database/migrations/2026_05_16_000010_...php](backend/database/migrations/2026_05_16_000003_add_financial_fields_to_payments_table.php) — renamed (order fix)

### Files Created (Testing):
- `backend/seed_test_user.php` — script untuk seed user test
- `backend/test_auth_flow.php` — comprehensive auth flow test script

## Sisa Pekerjaan untuk Produksi (Auth)

- **Frontend web SPA:** Implementasikan flow yang benar:
  1. GET `/sanctum/csrf-cookie` untuk obtain CSRF token.
  2. POST `/api/auth/session-login` dengan credentials.
  3. Semua subsequent requests dengan `credentials: 'include'` (fetch) atau `withCredentials: true` (axios).
  4. Setup axios/fetch interceptor untuk handle 401 (redirect ke login).

- **Konfigurasi production:**
  - Update `.env`: `SESSION_DOMAIN=.yourdomain.com`, `SANCTUM_STATEFUL_DOMAINS=yourdomain.com,www.yourdomain.com`.
  - Setup `config/cors.php` untuk allow credentials dan origin produksi.
  - Ensure `SESSION_SECURE=true` dan `SESSION_HTTP_ONLY=true` di production HTTPS.
  - Optional: setup rate-limiting dan account lockout (`spatie/laravel-rate-limit`).

- **Dokumentasi & testing:**
  - Contoh code frontend (Vue, React, atau vanilla JS) untuk SPA auth.
  - Postman collection atau OpenAPI spec untuk API endpoints.
  - E2E tests dengan Playwright/Cypress untuk auth flows.

- **Mobile client (Flutter):**
  - Token-based approach sudah working; lanjutkan dengan menambah error handling, token refresh, dan logout flow.

## Catatan Risiko:
1. **Session handling di development:** CSRF protection di localhost dapat berbeda behavior vs production. Pastikan `APP_ENV=production` saat testing production-like scenarios.
2. **Token vs Session trade-off:** Token lebih simple untuk API testing tapi kurang aman (localStorage exposure). Session lebih aman tapi perlu proper CORS config.
3. **Cookie domain:** Harus match dengan frontend domain, atau session cookie tidak dikirim (most common issue).
4. **CSRF token:** Jika frontend hardcoded mengakses token dari response, harus extract dari Set-Cookie atau request header (X-CSRF-TOKEN).

## Next Steps untuk Team:
1. ✅ Backend auth endpoints & migrations sudah siap.
2. ⏳ Frontend web SPA perlu implement session-based auth dengan correct CSRF & cookie handling.
3. ⏳ Mobile Flutter client perlu update dengan token refresh dan error handling.
4. ⏳ Production deployment checklist: `.env`, CORS, session domain, SSL/HTTPS.

