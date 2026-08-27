# Starting Bytewise locally (Windows / XAMPP)

## Two terminal tabs

```powershell
# Tab 1 — MySQL (background, leave running; shared with the other 4 sites in this workspace)
Start-Process "C:\xampp\mysql\bin\mysqld.exe" -ArgumentList "--defaults-file=C:\xampp\mysql\bin\my.ini","--standalone"

# Tab 2 — the app (blocks this tab, that's expected)
cd W:\Websites\bytewise\public
C:\xampp\php\php.exe -S 127.0.0.1:8040 router-dev.php
```

Open `http://127.0.0.1:8040`.

**Use `router-dev.php`, never `index.php` directly**, with `php -S` — the
front controller doesn't fall through to a static file, so CSS/JS/fonts
404 otherwise.

**Leave both processes running across sessions** — don't `taskkill`
`php.exe`/`mysqld.exe` just because a task finished. Port 8040 is
Bytewise's — the other four apps in this workspace use 8000/8010/8020/8030.
Or just run `W:\Websites\start-all.ps1`, which already knows about all five.

## First time only

```bash
cp .env.example .env
php -r "echo base64_encode(random_bytes(32)), PHP_EOL;"   # run twice → APP_KEY, HASH_PEPPER
```
Paste each output into `.env`. Create the `bytewise_app`/`bytewise_migrate`
MySQL users (see `docs/DEPLOYMENT.md` step 4) and fill their passwords in.

```bash
php database/migrate.php --seed
php database/scripts/create_admin.php you@example.com "YourPassword123!"
php tests/ddl_denial_probe.php
```

## Seeded credentials

| Role | Login | Credential |
|---|---|---|
| Admin | `/admin/login` | Whatever email/password you passed to `create_admin.php` — plus the printed TOTP secret, added to an authenticator app |
| Student | `/register` | Any email + password (min 8 chars) — registration logs you straight in, no verification step |

## Auth flow

Both students and admins are plain email + password (`AuthController.php` /
`Admin/AdminAuthController.php`) — no OTP, no phone number, no carrier
subscription of any kind. `/register` creates a `users` row and logs you in
immediately; `/login` checks the password hash. Admin login additionally
requires a TOTP code from an authenticator app (see `create_admin.php`
below). Password resets go through `/forgot-password` → emailed link; in
`APP_ENV=local` (no real mail transport configured) the reset link is also
written to `storage/logs/password-reset-dev-links-YYYY-MM-DD.log` instead of
actually being emailed.

## Mock code execution

`MockExecutionGateway` never compiles/runs submitted code. Every test case
passes by default; put a line containing `// MOCK: fail` (or `#`/`--`
equivalent) anywhere in the submitted source to force a failing verdict.
Results resolve after a ~2s simulated delay (state lives in
`storage/mock_executions/*.json`).

## Running the background jobs manually

```bash
php cron/run-jobs.php
```

Safe to run repeatedly — daily jobs self-guard via the `jobs` table
(`job_already_ran_today()`).

## If it won't load

- **500 on every page** — check `.env` has `APP_KEY`/`HASH_PEPPER` set and
  each decodes to exactly 32 bytes; check `storage/logs/app-*.log`.
- **CSS/JS/fonts 404** — you're running `index.php` directly instead of
  `router-dev.php` with `php -S`.
- **"Unknown database 'bytewise'"** — run `php database/migrate.php`.
- **Session keeps logging you out** — `SESSION_LIFETIME_MINUTES` (default
  120) is enforced for real; not a bug, just re-login.
