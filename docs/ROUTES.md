# ROUTES.md — Bytewise

Source of truth is `app/routes.php`; this is a human-readable mirror, kept
current per the Documentation-Currency Rule (any route change updates this
file in the same session). `[F]` free, `[G]` gated (auth+sub), `[A]` admin,
`[P]` state-changing (csrf).

## Public

| Method | Path | Middleware | Notes |
|---|---|---|---|
| GET | `/` | — | Landing page, subscribe box; logged-in users redirect to `/dashboard` instead |
| GET | `/health` | — | Real `SELECT 1`, uptime monitor target |
| GET | `/faq`, `/privacy-policy`, `/terms` | — | Static pages |
| GET/POST | `/contact` | csrf (POST) | Honeypot field (`website`), rate-limited 3/hour |
| GET | `/explore`, `/explore/{track}` | — | Catalog + per-track skill tree, all nodes locked for visitors; a subscriber hitting `/explore/{track}` redirects to their real `/courses/{track}` instead of the locked teaser |
| GET | `/lesson/{slug}` | — | Full if `is_free_preview=1`, else locked teaser |
| GET/POST | `/placement-test` | csrf (POST) | Pre-auth/session-keyed, free |
| GET | `/cheatsheets/{track}` | — | Summary only |

## Subscribe / Auth (OTP-only)

| Method | Path | Middleware |
|---|---|---|
| POST | `/otp/request` | csrf, rl:otp_request |
| GET | `/otp/verify` | — |
| POST | `/otp/verify` | csrf, rl:otp_verify — signs in + activates subscription; redirects to `/dashboard` on an active subscription, `/account` otherwise (e.g. gateway confirmed but not yet active) |
| POST | `/otp/resend` | csrf |
| POST | `/logout` | auth, csrf |
| GET | `/dashboard` | auth, sub — skill tree per track, XP, streak, today's challenges |
| GET | `/account` | auth — reachable in every subscription state |
| GET/POST | `/unsubscribe` | auth (+csrf on POST) — **no `sub` gate** |

OTP rate limits (`otp_request`/`otp_verify`/`otp_resend`) are enforced inside
`OtpService` itself, keyed on mobile+IP together (BUILD-SPEC §5's "per
number+IP" wording) — there's no separate `RateLimiter` middleware; every
rate-limited action in the app follows this same one-call-site pattern
(admin login: email+ip, contact: ip, discussion: user, submissions: user).

## Admin auth

| Method | Path | Middleware |
|---|---|---|
| GET/POST | `/admin/login` | csrf (POST) — password + TOTP, rate-limited 5/15min per email+IP |
| POST | `/admin/logout` | admin, csrf |
| GET | `/admin/dashboard` | admin |

## Gated (student, active subscription)

| Method | Path | Middleware | Notes |
|---|---|---|---|
| GET | `/courses/{track}` | auth, sub | Real skill tree, no prerequisites — every track and module is reachable to any logged-in subscriber (see FEATURES.md, "Learning path & track gating"). Each module node links to `/courses/{track}/{module_slug}` |
| GET | `/courses/{track}/{module_slug}` | auth, sub | Lesson list for one module (status icon + link to `/lessons/{id}` per lesson) |
| GET | `/lessons/{id}` | auth, sub | Marks `in_progress` |
| POST | `/lessons/{id}/complete` | auth, sub, csrf | The only place a lesson is marked `completed` — no quiz required. Advances to the next lesson, or back to the track page with a module-complete notice if it was the module's last lesson |
| POST | `/lessons/{id}/quiz` | auth, sub, csrf | Optional bonus practice only — grades server-side, awards XP once on a fully-correct submission (tracked independently of completion status); never marks the lesson completed and never blocks `/complete` |
| GET | `/cheatsheets/{track}/full` | auth, sub | |
| GET | `/daily-challenge` | auth, sub | Card grid shows all 8 tracks, all reachable |
| GET | `/problems/{id}` | auth, sub | Language picker for agnostic (DS/Algo) problems; `TrackAccessService::checkProblem()` resolves the owning language (direct or via lesson→module) |
| POST | `/problems/{id}/submit` | auth, sub, csrf | `language_id` validated server-side against `problems.language_id` |
| GET | `/submissions/{id}` | auth, sub | Poll endpoint (JSON via `Accept: application/json`) |
| GET | `/projects`, `/projects/{id}` | auth, sub | Multi-language chips + readiness badge via `ProjectEligibilityService` |
| POST | `/projects/{id}/submit` | auth, sub, csrf | Self-report link, admin-reviewed; **hard-gated 403** unless ALL of the project's required languages (`project_languages`) are 100% complete |
| GET | `/leaderboard` | auth, sub | |
| GET/POST | `/discussion/{context_type}/{id}` | auth, sub (+csrf) | rl:discussion_post 10/hour |

## Admin

| Method | Path | Middleware | Notes |
|---|---|---|---|
| GET | `/admin/languages` | admin | Read-only list (8 fixed tracks) |
| GET/POST | `/admin/modules` | admin (+csrf) | List + create |
| GET/POST | `/admin/content/lessons`, `/admin/content/lessons/new` | admin (+csrf) | Full CRUD |
| GET/POST | `/admin/content/lessons/{id}/edit`, `/admin/content/lessons/{id}`, `/admin/content/lessons/{id}/delete` | admin, csrf | Edit / update / delete |
| GET/POST | `/admin/content/problems`, `/admin/content/projects` | admin (+csrf) | List + create only (edit/delete: TODO.md follow-up) |
| GET/POST | `/admin/content-import` | admin (+csrf) | CSV bulk import for lessons |
| GET | `/admin/project-submissions` | admin | Review queue |
| POST | `/admin/project-submissions/{id}/approve`, `/{id}/changes` | admin, csrf | Awards XP on approve |
| GET/POST | `/admin/contact-messages`, `/{id}` | admin (+csrf) | new→read→resolved |
| GET/POST | `/admin/users`, `/{id}/reveal` | admin (+csrf) | PII reveal is audit-logged |
| GET | `/admin/audit-log` | admin | |

## Not yet built

- `/daily-challenge` cron rotation exists; there is no student-facing
  "solve today's challenge counts toward leaderboard" wiring beyond the
  normal problem-submit flow (`counted_for_daily_challenge` column exists
  but is never set — a documented gap, see TODO.md).
