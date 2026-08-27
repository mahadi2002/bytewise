# ROUTES.md — Bytewise

Source of truth is `app/routes.php`; this is a human-readable mirror, kept
current per the Documentation-Currency Rule (any route change updates this
file in the same session). `[F]` free/ungated, `[G]` gated (auth — login-or-
registered access only, no subscription tier), `[A]` admin, `[P]`
state-changing (csrf).

## Public

| Method | Path | Middleware | Notes |
|---|---|---|---|
| GET | `/` | — | Landing page; logged-in users redirect to `/dashboard` instead |
| GET | `/health` | — | Real `SELECT 1`, uptime monitor target |
| GET | `/faq`, `/privacy-policy`, `/terms` | — | Static pages |
| GET/POST | `/contact` | csrf (POST) | Honeypot field (`website`), rate-limited 3/hour |
| GET | `/explore`, `/explore/{track}` | — | Catalog + per-track skill tree, all nodes locked for visitors; a logged-in user hitting `/explore/{track}` redirects to their real `/courses/{track}` instead of the locked teaser |
| GET | `/lesson/{slug}` | — | Full if `is_free_preview=1`, else locked teaser |
| GET/POST | `/placement-test` | csrf (POST) | Pre-auth/session-keyed, free |
| GET | `/cheatsheets/{track}` | — | Summary only |

## Auth — email + password

| Method | Path | Middleware | Notes |
|---|---|---|---|
| GET/POST | `/register` | csrf (POST) | Email + password (min 8 chars); rate-limited 5/15min per IP. Creates the `users` row and logs in immediately — no verification step |
| GET/POST | `/login` | csrf (POST) | Rate-limited 5/15min, keyed on email+IP |
| POST | `/logout` | auth, csrf | |
| GET/POST | `/forgot-password` | csrf (POST) | Rate-limited 3/hour, keyed on email+IP. Always shows the same success message regardless of whether the email exists, to avoid enumeration |
| GET/POST | `/reset-password/{token}` | csrf (POST) | Token is single-use, 1-hour TTL, hashed at rest (`password_resets.token_hash`) |
| GET | `/dashboard` | auth | Skill tree per track, XP, streak, today's challenges |
| GET | `/account` | auth | |

Every rate-limited action in the app follows the same one-call-site pattern
inside its own controller (login/register: email+IP, admin login: email+IP,
contact: IP, discussion: user, code submit: user) — there's no separate
`RateLimiter` middleware; see `config('rate_limits')` for the full
action → limit map.

## Admin auth

| Method | Path | Middleware |
|---|---|---|
| GET/POST | `/admin/login` | csrf (POST) — password + TOTP, rate-limited 5/15min per email+IP |
| POST | `/admin/logout` | admin, csrf |
| GET | `/admin/dashboard` | admin |

## Gated (logged-in user)

| Method | Path | Middleware | Notes |
|---|---|---|---|
| GET | `/courses/{track}` | auth | Real skill tree, no prerequisites — every track and module is reachable to any logged-in user (see FEATURES.md, "Learning path & track gating"). Each module node links to `/courses/{track}/{module_slug}` |
| GET | `/courses/{track}/{module_slug}` | auth | Lesson list for one module (status icon + link to `/lessons/{id}` per lesson) |
| GET | `/lessons/{id}` | auth | Marks `in_progress` |
| POST | `/lessons/{id}/complete` | auth, csrf | The only place a lesson is marked `completed` — no quiz required. Advances to the next lesson, or back to the track page with a module-complete notice if it was the module's last lesson |
| POST | `/lessons/{id}/quiz` | auth, csrf | Optional bonus practice only — grades server-side, awards XP once on a fully-correct submission (tracked independently of completion status); never marks the lesson completed and never blocks `/complete` |
| GET | `/cheatsheets/{track}/full` | auth | |
| GET | `/daily-challenge` | auth | Card grid shows all 8 tracks, all reachable |
| GET | `/problems/{id}` | auth | Language picker for agnostic (DS/Algo) problems; `TrackAccessService::isUnlocked()` gates on login status only |
| POST | `/problems/{id}/submit` | auth, csrf | `language_id` validated server-side against `problems.language_id` |
| GET | `/submissions/{id}` | auth | Poll endpoint (JSON via `Accept: application/json`) |
| GET | `/projects`, `/projects/{id}` | auth | Multi-language chips + readiness badge via `ProjectEligibilityService` |
| POST | `/projects/{id}/submit` | auth, csrf | Self-report link, admin-reviewed; **hard-gated 403** unless ALL of the project's required languages (`project_languages`) are 100% complete |
| GET | `/leaderboard` | auth | |
| GET/POST | `/discussion/{context_type}/{id}` | auth (+csrf) | rl:discussion_post 10/hour |

## Admin

| Method | Path | Middleware | Notes |
|---|---|---|---|
| GET | `/admin/languages` | admin | List (8 fixed tracks) |
| GET/POST | `/admin/languages/{id}/edit`, `/admin/languages/{id}`, `/admin/languages/{id}/delete` | admin, csrf | Edit / update / delete |
| GET/POST | `/admin/modules` | admin (+csrf) | List + create |
| GET/POST | `/admin/modules/{id}/edit`, `/admin/modules/{id}`, `/admin/modules/{id}/delete` | admin, csrf | Edit / update / delete |
| GET/POST | `/admin/content/lessons`, `/admin/content/lessons/new` | admin (+csrf) | Full CRUD |
| GET/POST | `/admin/content/lessons/{id}/edit`, `/admin/content/lessons/{id}`, `/admin/content/lessons/{id}/delete` | admin, csrf | Edit / update / delete |
| GET/POST | `/admin/content/problems`, `/admin/content/projects` | admin (+csrf) | List + create |
| GET/POST | `/admin/content/problems/{id}/edit`, `/admin/content/problems/{id}`, `/admin/content/problems/{id}/delete` | admin, csrf | Edit / update / delete |
| GET/POST | `/admin/content/projects/{id}/edit`, `/admin/content/projects/{id}`, `/admin/content/projects/{id}/delete` | admin, csrf | Edit / update / delete |
| GET/POST | `/admin/content-import` | admin (+csrf) | CSV bulk import for lessons |
| GET | `/admin/project-submissions` | admin | Review queue |
| POST | `/admin/project-submissions/{id}/approve`, `/{id}/changes` | admin, csrf | Awards XP on approve |
| GET/POST | `/admin/contact-messages`, `/{id}` | admin (+csrf) | new→read→resolved |
| GET | `/admin/users` | admin | Plain user list — email/password auth has no encrypted PII to reveal, so there's no reveal action or audit-log entry the way the old mobile-number storage needed |
| GET | `/admin/audit-log` | admin | |

## Not yet built

- `/daily-challenge` cron rotation exists; there is no student-facing
  "solve today's challenge counts toward leaderboard" wiring beyond the
  normal problem-submit flow (`counted_for_daily_challenge` column exists
  but is never set — a documented gap, see TODO.md).
