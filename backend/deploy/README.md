Deployment Quick-Guide — Laravel queue + scheduler

1) Copy systemd unit (example)

```bash
sudo cp deploy/laravel-queue.service /etc/systemd/system/laravel-queue.service
sudo systemctl daemon-reload
sudo systemctl enable --now laravel-queue.service
sudo journalctl -u laravel-queue -f
```

2) Or use Supervisor (example)

```bash
sudo cp deploy/supervisor.conf /etc/supervisor/conf.d/laravel-queue.conf
sudo supervisorctl reread
sudo supervisorctl update
sudo supervisorctl start laravel-queue:*
tail -f /var/log/laravel-queue.log
```

3) Ensure cron runs scheduler every minute:

```cron
* * * * * cd /var/www/tukangdekat/backend && php artisan schedule:run >> /dev/null 2>&1
```

4) Environment variables
- Place `XENDIT_API_KEY`, `PAYOUT_GATEWAY`, `PAYOUT_ALERT_WEBHOOK`, and `PAYOUT_ALERT_EMAIL` in your server's environment or `.env` (use secret manager when possible).

5) Test pipeline

```bash
php artisan migrate --force
php artisan payouts:test-gateway 10000 --to=08123456789
php artisan payouts:process
php artisan payouts:process-pending --limit=25
```

6) Smoke test

Run the deploy smoke test script after deploy and worker restart:

```bash
./deploy/smoke-test.sh
```

Or run the Laravel command directly:

```bash
php artisan deploy:smoke --url="http://127.0.0.1"
```

7) Monitoring
- `php artisan payouts:alert --since=60` and `php artisan payouts:export-failed --since=60 --email=ops@example.com`

Notes
- Adjust paths to your deployment layout. These are example snippets for `/var/www/tukangdekat/backend`.

Environment injection examples

- systemd (set env in unit file): edit `deploy/laravel-queue.service` and add `Environment=` lines with your secrets. Example:

```
[Service]
Environment=APP_ENV=production
Environment=PAYOUT_GATEWAY=xendit
Environment=XENDIT_API_KEY=sk_prod_....
ExecStart=/usr/bin/php /var/www/tukangdekat/backend/artisan queue:work --sleep=3 --tries=3 --queue=default
```

- supervisor (export env for program): in `deploy/supervisor.conf` you can add `environment=`. Example:

```
[program:laravel-queue]
command=php /var/www/tukangdekat/backend/artisan queue:work --sleep=3 --tries=3 --queue=default
environment=APP_ENV="production",PAYOUT_GATEWAY="xendit",XENDIT_API_KEY="sk_prod_..."
user=www-data
```

Security note: prefer injecting secrets from a secure secret store (Vault, AWS SSM/Secrets Manager) and not embedding them in files. When using systemd or supervisor, ensure unit/config files are readable only by root and not committed to git.
