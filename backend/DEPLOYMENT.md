# Deployment & Production Checklist

This document collects the minimal, practical steps to run this Laravel app in production and operate background workers and the scheduler.

## Preconditions

- PHP 8.1+ with required extensions (pdo_mysql, mbstring, openssl, json, curl, zip for XLSX generation if you need server-side Excel). Install `ext-zip` to enable server-side XLSX libraries.
- Composer installed
- A webserver (nginx / Apache) and a process supervisor (systemd or Supervisor) for queue workers.
- Database (MySQL/MariaDB) accessible and configured in `.env`

## Basic deploy steps

1. Clone repository on server into `/var/www/tukangdekat` (example).
2. Install PHP deps:

```bash
cd /var/www/tukangdekat/backend
composer install --no-dev --prefer-dist --optimize-autoloader
php artisan key:generate
cp .env.example .env
# update .env with DB, mail, and provider API keys
```

3. File permissions:

```bash
chown -R www-data:www-data storage bootstrap/cache
chmod -R 775 storage bootstrap/cache
```

4. Database migrations & seed (run after configuring `.env`):

```bash
php artisan migrate --force
php artisan db:seed --class=AdminSeeder --force   # if you have seeders to create admin/treasurer
```

5. Cache and config optimizations:

```bash
php artisan config:cache
php artisan route:cache
php artisan view:cache
./deploy/smoke-test.sh
# or alternatively run the Laravel smoke test command:
# php artisan deploy:smoke --url="http://127.0.0.1"
```

## Scheduler (cron)

This project registers scheduled commands in `bootstrap/app.php`. To run the scheduler every minute add this to the system's crontab:

```cron
* * * * * cd /var/www/tukangdekat/backend && php artisan schedule:run >> /dev/null 2>&1
```

This will execute the following entries configured by the app:

- `payouts:process` — daily at `01:00` (aggregate PAID payments into provider payouts)
- `payouts:process-pending --limit=25` — every 5 minutes (dispatch jobs for pending payouts)

## Queue worker (systemd example)

Create a systemd unit so queue workers run reliably and restart on failure. Example unit `/etc/systemd/system/laravel-queue.service`:

```ini
[Unit]
Description=Laravel Queue Worker
After=network.target

[Service]
User=www-data
Group=www-data
Restart=always
RestartSec=3
ExecStart=/usr/bin/php /var/www/tukangdekat/backend/artisan queue:work --sleep=3 --tries=3 --queue=default
SyslogIdentifier=laravel-queue
Environment=APP_ENV=production
Environment=QUEUE_CONNECTION=database

[Install]
WantedBy=multi-user.target
```

Commands to enable:

```bash
sudo systemctl daemon-reload
sudo systemctl enable --now laravel-queue.service
sudo journalctl -u laravel-queue -f
```

Alternatively use Supervisor (example):

```
[program:laravel-queue]
process_name=%(program_name)s_%(process_num)02d
command=php /var/www/tukangdekat/backend/artisan queue:work --sleep=3 --tries=3 --queue=default
autostart=true
autorestart=true
user=www-data
numprocs=1
redirect_stderr=true
stdout_logfile=/var/log/laravel-queue.log
```

## Web server

Use standard production nginx/Apache configuration. Ensure `public/` is the document root and PHP-FPM is configured for the `www-data` user.

## Operational commands

- Restart queue when deploying new code: `php artisan queue:restart`
- Manually trigger aggregation: `php artisan payouts:process`
- Manually dispatch pending payouts: `php artisan payouts:process-pending --limit=25`

## Notes & Security

- The development helper route `/test-login/{role}` was removed. Do not re-enable dev helper routes on production.
- Keep provider gateway credentials out of the repository and store in environment variables (`.env`) or secret manager.
- Monitor `provider_payout_attempts` table for failed attempts and retry via admin UI or `php artisan` commands.

If you want, I can also add the example `systemd` unit file above into the repo under `deploy/` for easy reference.
