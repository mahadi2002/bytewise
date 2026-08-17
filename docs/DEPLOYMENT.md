# DEPLOYMENT.md — Bytewise

Target: shared cPanel hosting by default (PHP-FPM/CGI, mod_rewrite, cron,
pdo_mysql, mbstring, openssl, curl, no root, no Composer, no Redis, no
`proc_open`), upgradeable to a VPS with zero application code changes —
per rulebook §2.

## First deploy

1. Upload everything EXCEPT `public/` contents to `/home/USER/bytewise/`
   (app code stays outside the web root).
2. Point the docroot at `bytewise/public/` (symlink, or if the host only
   allows `public_html`, copy `public/`'s contents into `public_html/` and
   set `define('APP_ROOT', '/home/USER/bytewise');` at the top of
   `public_html/index.php` — see that file's own comment).
3. Copy `.env.example` to `.env`, fill in real values:
   - `APP_ENV=production`, `APP_KEY`/`HASH_PEPPER` freshly generated
     (`php -r "echo base64_encode(random_bytes(32)), PHP_EOL;"` — run
     twice, they must differ).
   - `SESSION_SECURE_COOKIE=true` (requires HTTPS).
   - `SUBSCRIPTION_GATEWAY=carrier` + real `CARRIER_GATEWAY_*` values —
     **blocked until BLOCKER-1 is resolved** (bootstrap.php refuses to boot
     with `SUBSCRIPTION_GATEWAY=mock` under `APP_ENV=production`).
   - `EXECUTION_GATEWAY=remote_judge` + `REMOTE_JUDGE_BASE_URL` — **blocked
     until BLOCKER-2 is resolved** (same fail-loud rule).
   - `OTP_BYPASS_CODE` should stay unset or irrelevant in production — the
     guard is `APP_ENV === 'local'`, not the value's presence, but leaving
     it blank is one less thing to reason about.
4. Create the two MySQL users (see `database/migrations/`'s privilege
   setup in `03-ENV-AND-CONFIG.md` §7, or re-run the `CREATE USER`
   statements from this session):
   ```sql
   CREATE USER 'bytewise_app'@'localhost' IDENTIFIED BY '<strong-password>';
   GRANT SELECT, INSERT, UPDATE, DELETE ON bytewise.* TO 'bytewise_app'@'localhost';
   CREATE USER 'bytewise_migrate'@'localhost' IDENTIFIED BY '<different-strong-password>';
   GRANT ALL PRIVILEGES ON bytewise.* TO 'bytewise_migrate'@'localhost';
   FLUSH PRIVILEGES;
   ```
5. `php database/migrate.php --seed` — creates the DB, runs all 8
   migrations, and seeds every `database/seeds/*.sql` file (`content.sql`
   AND `002_placement.sql` both run automatically; this is a one-time
   operation — `content.sql`'s inserts are not idempotent, so `--seed`
   cannot be safely re-run against a DB that already has this data).
   Then create the first admin separately (deliberately NOT auto-run by
   `--seed` — see that script's own docblock for why):
   `php database/scripts/create_admin.php admin@yourdomain.com "<strong-password>"`.
6. Run the DDL-denial probe once against production credentials:
   `php tests/ddl_denial_probe.php` — must print `OK`.
7. Add exactly one crontab line:
   ```
   * * * * * php /home/USER/bytewise/cron/run-jobs.php >> /home/USER/bytewise/storage/logs/cron.log 2>&1
   ```
8. Confirm `/health` returns `{"status":"ok"}` over HTTPS.

## What's still blocked pre-launch

See `TODO.md` for the full list (BLOCKER-1 through BLOCKER-6). The two
that block a real production cutover specifically:

- **BLOCKER-1**: real BDApps/SDP carrier gateway credentials — without
  these, `SUBSCRIPTION_GATEWAY` cannot be set to `carrier` and the app
  cannot boot under `APP_ENV=production` at all (by design, fail-loud).
- **BLOCKER-2**: which service backs `RemoteJudgeGateway` — a hosting/cost
  decision. Until resolved, `EXECUTION_GATEWAY` must stay `mock`, which
  itself is blocked under `APP_ENV=production` — meaning code execution
  cannot go live in production until this is resolved, full stop.

## Font licensing

All three self-hosted font families (Hind Siliguri, Inter, JetBrains Mono)
are SIL OFL 1.1 — see `public/assets/fonts/FONT_LICENSE.md`. No attribution
requirement beyond keeping that file; OFL permits embedding/subsetting.
