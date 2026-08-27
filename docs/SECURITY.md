# SECURITY.md — Bytewise

Every item below has a concrete verification step actually run during the
build (not just implemented) — per `03-ENV-AND-CONFIG.md` §10.

| Item | Verification | Result |
|---|---|---|
| `Crypto::encrypt()`/`decrypt()` called against `users.mobile_encrypted` and `admin_users.totp_secret_encrypted` | `grep -rn "Crypto::encrypt\|Crypto::decrypt" app/` | 4 real call sites: `UserRepository::create/decryptedMobile`, `AdminAuthController::login`, `database/seeds/001_admin.php` |
| Runtime DB user (`bytewise_app`) denied DDL | `php tests/ddl_denial_probe.php` | Exit 0 — MySQL error 1142 CREATE denied |
| Unsubscribe reachable from every subscription state | Drove a subscription through pending→active→grace→expired→unsubscribed, checked `/account` at each state; grepped views for the control | `views/account/show.php` (the one view rendered at every state) always includes `partials/unsubscribe-control.php`, unconditionally |
| Self-hosted fonts are real files, not just named in CSS | `find public/assets/fonts -name '*.woff2'` + magic-byte check (`wOF2`) | 8 real files (Hind Siliguri ×6, Inter ×1 variable, JetBrains Mono ×1 variable), all confirmed genuine woff2; `@font-face` rules reference them by exact path |
| CSRF on every POST/PATCH/DELETE route | `grep "'POST'" app/routes.php \| grep -v csrf` | Empty output — every POST route carries `csrf` |
| `OTP_BYPASS_CODE` unreachable when `APP_ENV != local` | Swapped in a production-flavored `.env` (own credentials, no shared secrets), ran `tests/otp_bypass_denied_production_test.php` | Bypass code correctly falls through to the real hash check and is rejected |
| `submissions.language_id` validated server-side for language-locked problems | `SubmissionService::assertLanguageAllowed()` called before `CodeExecutionGateway::submit()`; tested a forged mismatched `language_id` via curl | HTTP 422, submission never created |
| Gated columns excluded from the SQL SELECT for non-subscribers | `tests/lesson_gating_column_test.php` inspects the actual returned array's keys | Non-subscriber result set has no `body_md`/`code_sample` keys at all |
| Hidden test-case output never returned to the client | Inspected the JSON response body of a passing submission with hidden cases | `"output": null` for `is_hidden: true` entries |
| PII reveal (`/admin/users/{id}/reveal`) is audit-logged | Triggered a real reveal, queried `audit_log` | Row with `action='user.pii_reveal'`, `actor_id`, `target_id`, `meta_json` |
| Admin login rate limiting (5/15min) | Triggered 6 rapid wrong-credential POSTs | HTTP 429 from the configured threshold onward |
| RemoteJudgeGateway network isolation | **Not verifiable** — Phase 10 (real sandbox) is blocked on BLOCKER-2; `RemoteJudgeGateway` is a fail-loud stub with no real backend to test against yet | Blocked, see TODO.md |
| SQL submissions isolated from Bytewise's own schema | **Not verifiable** — same Phase 10 blocker; the mock gateway never touches any real DB at all (never executes code), so this specific isolation property has no real judge service to test | Blocked, see TODO.md |

## Encryption details

- `users.mobile_encrypted`: AES-256-GCM via `Core\Crypto::encrypt()`, key = `APP_KEY`.
- `users.mobile_hash`: HMAC-SHA256 blind index via `Core\Crypto::blindIndex()`, key = `HASH_PEPPER` (a separate secret from `APP_KEY`) — the only column ever used in a `WHERE` clause for mobile lookups.
- `admin_users.totp_secret_encrypted`: same `Crypto` class/`APP_KEY`.
- OTP codes (`otp_requests.otp_hash`): `password_hash()`, never plaintext.
- Admin passwords: `password_hash()` (Argon2id-capable via PHP's default).

## Rate limits (MySQL-backed `rate_limits` table, fixed-window)

| Action | Limit |
|---|---|
| `otp_request` | 3/hour + 8/day per mobile |
| `otp_verify` | 5/15min per mobile |
| `otp_resend` | 1 per cooldown (60s) |
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

## Deliberate deviation from the sibling-app pattern

Unlike prior apps in this series (which destroy the whole session on
unsubscribe), `SubscriptionService::unsubscribe()` does NOT kill the
student's session(s). Bytewise has substantial free content
(free-preview lessons, placement test, `/account` itself) a non-subscribed
student must keep browsing, so forcing a full logout would be an unrelated
side effect. The actual security guarantee (gated content stops being
reachable on the very next request) already comes from
`RequireSubscription` re-querying the DB every time — see ARCHITECTURE.md.
