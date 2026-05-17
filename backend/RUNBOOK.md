# Runbook — Quick Production Steps

This runbook lists concrete commands to perform a production deploy and to operate the payout system.

1) Pull code & install dependencies

```bash
cd /var/www/tukangdekat/backend
git pull origin main
composer install --no-dev --prefer-dist --optimize-autoloader
```

2) Environment

Edit `.env` with production values. Add payout provider credentials:

```
APP_ENV=production
APP_DEBUG=false
DB_HOST=...
DB_DATABASE=...
DB_USERNAME=...
DB_PASSWORD=...

# Payout provider (example Xendit)
PAYOUT_GATEWAY=xendit
XENDIT_API_KEY=sk_prod_.....
XENDIT_BASE_URL=https://api.xendit.co
```

3) Migrate and seed

```bash
php artisan migrate --force
php artisan db:seed --class=AdminSeeder --force
```

4) Cache & optimize

```bash
php artisan config:cache
php artisan route:cache
php artisan view:cache
```

5) Start scheduler & queue workers

Cron entry (one-liner):

```cron
* * * * * cd /var/www/tukangdekat/backend && php artisan schedule:run >> /dev/null 2>&1
```

Enable systemd worker (example):

```bash
sudo cp deploy/laravel-queue.service /etc/systemd/system/laravel-queue.service
sudo systemctl daemon-reload
sudo systemctl enable --now laravel-queue.service
sudo journalctl -u laravel-queue -f

Alerting:

- Configure `PAYOUT_ALERT_WEBHOOK` or `PAYOUT_ALERT_EMAIL` in `.env` to receive alerts when failed payouts occur frequently.
- The app schedules `payouts:alert --since=60` every 10 minutes by default.
```

6) Manual operations

- Run aggregation manually: `php artisan payouts:process`
- Dispatch pending payouts manually: `php artisan payouts:process-pending --limit=25`
- Restart queue workers after deploy: `php artisan queue:restart`

7) Monitoring & retries

- Check `provider_payout_attempts` for failures:

```sql
SELECT * FROM provider_payout_attempts WHERE status = 'FAILED' ORDER BY created_at DESC LIMIT 50;
```

- Retry failed payout from admin UI or via `SendProviderPayoutJob` dispatch.

- Export failed attempts to CSV: `php artisan payouts:export-failed --since=60 --email=ops@example.com`

8) Rollback

- If a deploy causes issues, revert to previous git tag/commit and run migrations rollback only if safe.

If you want, I can also add automated health checks or a small management script to export failed attempts and email alerts.
