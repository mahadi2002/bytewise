# DEVELOPMENT.md — Bytewise

## Local setup

1. `cp .env.example .env`, generate `APP_KEY`/`HASH_PEPPER`:
   `php -r "echo base64_encode(random_bytes(32)), PHP_EOL;"` (run twice —
   they must differ).
2. Create the two MySQL users (see `DEPLOYMENT.md` step 4) and fill their
   passwords into `.env`.
3. `php database/migrate.php --seed`
4. `php database/scripts/create_admin.php you@example.com "YourPassword123!"`
   — copy the printed TOTP secret into an authenticator app (Google
   Authenticator, Authy, etc.), or compute codes ad hoc for local testing:
   `php -r 'define("APP_ROOT", getcwd()); require APP_ROOT."/app/bootstrap.php"; echo \App\Support\Totp::code("<secret>");'`
5. `php -S 127.0.0.1:8040 -t public public/router-dev.php` (or use
   `W:\Websites\start-all.ps1`, which already knows about this site on
   port 8040).
6. Confirm `http://127.0.0.1:8040/health` returns `{"status":"ok"}`.

## Local-dev conveniences (all gated on `APP_ENV=local`, checked at the
point of use, never on a debug flag alone)

- **Password reset links** are also written to
  `storage/logs/password-reset-dev-links-*.log` (`email => link`) since no
  real mail transport is typically configured on a dev machine — see
  `AuthController::issuePasswordReset()`.
- **MockExecutionGateway** never runs your code — put a line containing
  `// MOCK: fail` (or `#`/`--` equivalents) anywhere in a submission's
  source to force a failing verdict, otherwise every test case passes. See
  `MockExecutionGateway`'s docblock.

## Tests / verification scripts

These are standalone PHP scripts, not a test framework (no Composer
dependency for one) — run each with `php tests/<name>.php`:

| Script | Verifies |
|---|---|
| `tests/ddl_denial_probe.php` | Runtime DB user can't run DDL |
| `tests/lesson_gating_column_test.php` | `body_md`/`code_sample` absent from a logged-out viewer's SELECT |
| `tests/track_access_test.php` | Direct-URL bypass attempts on locked lessons/problems correctly redirect |
| `tests/utf8_storage_probe.php` | Diagnostic: Bangla text round-trips through `Db` correctly (used to rule out an app bug vs. a Windows/git-bash terminal encoding artifact during this build) |

## Known local-environment quirks (not app bugs)

- **mingw64 curl + `-F` file uploads**: `curl -F "file=@/tmp/x.csv"` fails
  with `curl: (26) Failed to open/read local data` on Windows git-bash —
  the MSYS `/tmp/...` path isn't translated for multipart file args (it IS
  translated for `-o`/plain URLs). Use the Windows-style path instead:
  `cygpath -w /tmp/x.csv`.
- **Bangla text typed directly as a bash command-line argument** can get
  mangled before curl/PHP ever see it, on this Windows/git-bash setup —
  confirmed via `tests/utf8_storage_probe.php` that the actual storage
  layer round-trips real UTF-8 correctly. Prefer writing test fixtures to
  a file (which preserves encoding) over inlining non-ASCII text in a
  shell command.
- **DB-backed sessions expire for real** — `SESSION_LIFETIME_MINUTES=120`
  is enforced by `Session::read()`'s `last_activity_at` check, not just
  documented. A long-idle terminal session testing an authenticated flow
  will need to re-login; this was observed directly during this build (not
  a bug, PHP's `session.use_strict_mode` correctly starts a fresh
  anonymous session rather than silently reusing an expired one).

## Coding conventions

- Raw SQL lives ONLY in `app/Repositories/*.php`.
- Every echoed variable goes through `e()` (or `Markdown::toHtml()` for
  admin-authored Markdown fields, which escapes first, then layers markup
  on top — never raw HTML from the DB).
- New POST/PATCH/DELETE routes always carry `'csrf'` in their middleware
  array — checked mechanically before any release: `grep "'POST'"
  app/routes.php | grep -v csrf` should be empty.
- Any new gated content column follows the `PUBLIC_COLUMNS`/`findForViewer()`
  branch-the-SELECT pattern (see `LessonRepository`) — never fetch-then-hide.
