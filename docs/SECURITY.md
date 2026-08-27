# SECURITY.md — Bytewise

Every item below has a concrete verification step actually run during the
build (not just implemented).

| Item | Verification | Result |
|---|---|---|
| `Crypto::encrypt()`/`decrypt()` called against `admin_users.totp_secret_encrypted` | `grep -rn "Crypto::encrypt\|Crypto::decrypt" app/` | Call sites: `AdminAuthController::login`, `database/scripts/create_admin.php` — the mobile-number encryption call sites this used to also cover (`UserRepository::create`/`decryptedMobile`) no longer exist; email is stored in the clear under email+password auth |
| Runtime DB user (`bytewise_app`) denied DDL | `php tests/ddl_denial_probe.php` | Exit 0 — MySQL error 1142 CREATE denied |
| Passwords hashed, never stored/compared in plaintext | `AuthController::register`/`login` use `password_hash()`/`password_verify()` | Confirmed by reading the controller — see `app/Controllers/AuthController.php` |
| Login/register don't leak whether an email exists | `AuthController::register` returns the same generic message on a duplicate email as the unique-index race path; `login` always runs `password_verify()` against a real bcrypt hash (`DUMMY_PASSWORD_HASH`) even when no user was found, so a missing-user response takes the same time as a wrong-password response | Confirmed by reading the controller's own inline comments explaining each choice |
| Self-hosted fonts are real files, not just named in CSS | `find public/assets/fonts -name '*.woff2'` + magic-byte check (`wOF2`) | 8 real files (Hind Siliguri ×6, Inter ×1 variable, JetBrains Mono ×1 variable), all confirmed genuine woff2; `@font-face` rules reference them by exact path |
| CSRF on every POST/PATCH/DELETE route | `grep "'POST'" app/routes.php \| grep -v csrf` | Empty output — every POST route carries `csrf` |
| `submissions.language_id` validated server-side for language-locked problems | `SubmissionService::assertLanguageAllowed()` called before `CodeExecutionGateway::submit()`; tested a forged mismatched `language_id` via curl | HTTP 422, submission never created |
| Gated columns excluded from the SQL SELECT for a logged-out viewer | `tests/lesson_gating_column_test.php` inspects the actual returned array's keys | Logged-out result set has no `body_md`/`code_sample` keys at all |
| Hidden test-case output never returned to the client | Inspected the JSON response body of a passing submission with hidden cases | `"output": null` for `is_hidden: true` entries |
| Admin login rate limiting (5/15min) | Triggered 6 rapid wrong-credential POSTs | HTTP 429 from the configured threshold onward |
| RemoteJudgeGateway network isolation | **Not verifiable** — Phase 10 (real sandbox) is blocked on BLOCKER-2; `RemoteJudgeGateway` is a fail-loud stub with no real backend to test against yet | Blocked, see TODO.md |
| SQL submissions isolated from Bytewise's own schema | **Not verifiable** — same Phase 10 blocker; the mock gateway never touches any real DB at all (never executes code), so this specific isolation property has no real judge service to test | Blocked, see TODO.md |

There is no PII-reveal action to audit-log anymore — the old encrypted
`users.mobile_encrypted`/`mobile_hash` columns (and the admin-facing reveal
control for them) were dropped along with phone+OTP auth; see
`docs/DATABASE.md` migration 016. `audit_log`/`AuditLogRepository` still
exist and are viewable at `/admin/audit-log`, but nothing currently writes
to that table.

## Encryption details

- `admin_users.totp_secret_encrypted`: AES-256-GCM via `Core\Crypto::encrypt()`, key = `APP_KEY`.
- Student and admin passwords: `password_hash()` (Argon2id-capable via PHP's default), verified with `password_verify()`.
- Password-reset tokens (`password_resets.token_hash`): SHA-256 hash of a random token, never the raw token stored.
- `HASH_PEPPER` (`Core\Crypto::blindIndex()`) is still required (`bootstrap.php` fails loud if unset or not exactly 32 bytes) and still used, just for a different purpose than before: it blind-indexes email/IP into rate-limit bucket keys (`AuthController::login/register`, `AdminAuthController::login`, `Request::ipHash()`) rather than the old `users.mobile_hash` DB lookup column, which was dropped in migration 016.

## Rate limits (MySQL-backed `rate_limits` table, fixed-window)

| Action | Limit |
|---|---|
| `login` | 5/15min per email+IP |
| `register` | 5/15min per IP |
| `password_reset_request` | 3/hour per email+IP |
| `admin_login` | 5/15min per email+IP |
| `contact_form` | 3/hour per IP |
| `code_submit` | 20/hour + 100/day per user |
| `discussion_post` | 10/hour per user |

## Session model

DB-backed (`sessions` table), 120-minute inactivity lifetime
(`SESSION_LIFETIME_MINUTES`). One row can carry `user_id` (student) or
`admin_user_id` (admin), never meaningfully both. `session.use_strict_mode`
is on, so an expired/unknown session id is never silently re-adopted — PHP
issues a fresh anonymous session instead (observed directly during testing
when a test session outlived the 120-minute window).

## No subscription/billing surface

Bytewise is a free, login-only app — there is no subscription state, no
gateway, and no unsubscribe flow to reason about. Once a user is logged
in, `RequireAuth` (a plain session check) is the only gate on the routes
listed as gated in `docs/ROUTES.md`; there's no re-query of any billing
status on each request the way a paid-tier app would need. See
`docs/ARCHITECTURE.md` "Access control".
