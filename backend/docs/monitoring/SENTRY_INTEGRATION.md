Integrasi Sentry (Panduan Singkat)
=================================

Dokumen ini menjelaskan langkah minimal untuk mengaktifkan pelaporan error ke Sentry pada backend Laravel.

Langkah-langkah:

1) Tambahkan variabel lingkungan di sistem deployment (staging/production):

   - `SENTRY_LARAVEL_DSN` (JANGAN commit DSN ke repo)
   - `SENTRY_TRACES_SAMPLE_RATE` (opsional, contoh `0.0` untuk non-sampling)

2) Pasang paket Sentry di folder `backend`:

   ```bash
   cd backend
   composer require sentry/sentry-laravel
   ```

   - Setelah ini, commit perubahan `composer.json` dan `composer.lock` agar pipeline/deploy meng-install dependensi yang benar.

3) Publikasikan konfigurasi (opsional, disarankan):

   ```bash
   php artisan vendor:publish --provider="Sentry\\Laravel\\ServiceProvider"
   ```

   - Ini akan menambahkan `config/sentry.php` untuk mengatur opsi SDK.

4) Contoh pengaturan `.env` minimal:

   SENTRY_LARAVEL_DSN=${SENTRY_DSN}
   SENTRY_TRACES_SAMPLE_RATE=0.0

   (Opsional) tambahkan:
   SENTRY_ENVIRONMENT=production
   SENTRY_RELEASE=${GIT_COMMIT_SHA}

5) Integrasi di Exception Handler (direkomendasikan)

   Di `app/Exceptions/Handler.php`, tambahkan pemanggilan Sentry pada method `report()` agar exception dikirim ke Sentry jika DSN tersedia. Contoh:

   ```php
   <?php
   namespace App\\Exceptions;

   use Throwable;
   use Illuminate\\Foundation\\Exceptions\\Handler as ExceptionHandler;

   class Handler extends ExceptionHandler
   {
       public function report(Throwable $exception)
       {
           if (app()->bound('sentry') && env('SENTRY_LARAVEL_DSN')) {
               app('sentry')->captureException($exception);
           }

           parent::report($exception);
       }
   }
   ```

6) Logging channel (opsional)

   Anda dapat menambah channel `sentry` di `config/logging.php` dan mengarahkan level `error`/`critical` ke sana.

7) Verifikasi

   Di staging, verifikasi dengan memicu exception atau lewat Tinker:

   ```php
   app('sentry')->captureMessage('test');
   ```

Catatan Penting
- Jangan menyimpan DSN/secret di repo. Gunakan secret manager atau GitHub Actions secrets.
- Pastikan CI/deploy menjalankan `composer install` dan `composer.lock` sudah di-commit.

CI / Deploy (ringkasan)
- Commit `composer.json` + `composer.lock` setelah menambah paket.
- Pastikan pipeline menyuntikkan `SENTRY_LARAVEL_DSN` dari secrets dan menjalankan `composer install`.
Sentry integration (scaffold)
=============================

This document describes a minimal, non-invasive approach to enable Sentry error reporting for the Laravel backend.

Steps:

1. Add `SENTRY_DSN` to your environment (production/staging) — do NOT commit the DSN.

2. Install Sentry SDK on the deployment environment (example):

   composer require sentry/sentry-laravel

   Notes:
   - Run the command in the `backend` folder (where `composer.json` for the Laravel app lives):

     ```bash
     cd backend
     composer require sentry/sentry-laravel
     ```

   - Commit the updated `composer.json` and `composer.lock` so CI/deploy picks up the dependency.

3. Publish the Sentry configuration and (optionally) the logging channel:

     ```bash
     php artisan vendor:publish --provider="Sentry\Laravel\ServiceProvider"
     ```

   This will add `config/sentry.php` where you can further tune SDK settings.

3. Add configuration (example in `.env`):

   SENTRY_LARAVEL_DSN=${SENTRY_DSN}
   SENTRY_TRACES_SAMPLE_RATE=0.0

   Recommended additional env vars (optional):

    SENTRY_ENVIRONMENT=production
    SENTRY_RELEASE=${GIT_COMMIT_SHA}

4. Exception handler integration (recommended)

   In `app/Exceptions/Handler.php` inside the `report()` method you can forward exceptions to Sentry when the DSN is present:

   ```php
   public function report(Throwable $exception)
   {
       if (app()->bound('sentry') && env('SENTRY_LARAVEL_DSN')) {
           app('sentry')->captureException($exception);
       }

       parent::report($exception);
   }
   ```

5. Logging channel (optional)

   You can add a `sentry` logging channel in `config/logging.php` and route `critical`/`error` logs to Sentry. See Sentry Laravel docs for examples.

6. Verify on staging by throwing a test exception or using `Sentry\init([...])` or by calling `app('sentry')->captureMessage('test')` in tinker.

4. (Optional) Register Sentry in `config/logging.php` as a channel and ensure `report()` in exception handler uses `if (app()->bound('sentry') ) { app('sentry')->captureException($e); }`.

5. Verify on staging by throwing a test exception or using `Sentry\init([...])` in tinker.

Notes
- This repo does not add the Sentry package automatically to avoid modifying composer.lock here; installing must be done where you control deployment.
- The recommended minimal change is to call Sentry from the exception handler when `SENTRY_LARAVEL_DSN` is present.

CI / Deploy notes
- Ensure that CI runs `composer install --no-dev` (or the project-specific install command) and that `composer.lock` is updated after running `composer require` locally.
- Do not store DSNs or private keys in the repository; use secrets in GitHub Actions / your deployment system.
