# ARCHITECTURE.md — Bytewise

Hand-rolled PHP 8.2+ MVC, zero Composer dependencies, per
`BDApps-App-Series-Rulebook.txt` §2/§4.

## Request lifecycle

```
public/index.php (front controller)
  -> app/bootstrap.php (env, error handlers, storage dirs, startup guards)
  -> App\Core\Session::start()          (DB-backed sessions)
  -> App\Core\Router::dispatch()
       -> matches app/routes.php entry
       -> runs middleware pipeline (auth -> admin -> csrf)
       -> calls Controller@action
  -> App\Middleware\SecurityHeaders (global, wraps every response)
  -> Response::send()
```

`public/router-dev.php` is a thin static-file passthrough for `php -S`
only; Apache's `.htaccess` handles this natively in production.

## Directory layout

```
app/
  Controllers/        thin, one action = one method (Admin/ subdir for admin controllers)
  Repositories/        ONLY place raw SQL lives, one per aggregate
  Services/            business logic (SkillTreeService, XpService,
                        StreakService, SubmissionService, PlacementService,
                        ProjectReviewService, ProjectEligibilityService,
                        TrackAccessService)
  Middleware/           auth, admin, csrf (SecurityHeaders is applied
                        globally, not via the routes array — see the
                        request lifecycle above)
  Gateways/             CodeExecutionGateway/RemoteJudgeGateway/Mock,
                        switched by GatewayFactory via EXECUTION_GATEWAY
  Core/                  Router, Db, Session, Csrf, RateLimit, Crypto, Env,
                         Validator, View, Logger, Request, Response, Controller
  Exceptions/            HttpException
  Support/               Totp, Markdown
config/config.php         single config file, dot-path via config()
database/                 migrations/ (16 numbered files), seeds/, migrate.php
cron/                     run-jobs.php (single poller) + _jobs/
views/                    SIBLING of app/, plain-PHP templates + layouts
public/                   web root — index.php, assets/
```

## Content gating (the security-critical pattern)

Every gated content type (lessons, problems, projects, cheat sheets)
follows the same shape in its Repository:

- A `PUBLIC_COLUMNS` constant/query that never mentions the gated column
  (`body_md`, `statement_md`, `brief_md`/`rubric_md`, `full_md`).
- A `findForViewer($id, bool $isSubscriber)` method that branches which
  SQL string runs — the gated column is never fetched for a non-subscriber,
  not merely hidden in the template. Verified concretely in
  `tests/lesson_gating_column_test.php`.

## Access control

There is no subscription tier — `RequireAuth` (`auth` middleware) is the
only access gate on student-facing routes, and it's a plain session check
(`Session::userId() !== null`), not a re-query of any billing state. Gated
content (lessons/problems/projects/cheat sheets) still branches its SQL on
whether the viewer is logged in at all — see "Content gating" above — but
every logged-in user has access to everything; there's no active/grace/
expired state to re-check on each request.

## Gateways

One external integration, following interface + Mock + generic-named-stub:

- `CodeExecutionGateway` — `MockExecutionGateway` (never executes
  submitted code; file-backed simulated-async state under
  `storage/mock_executions/`, outcome controlled by a `// MOCK: fail`
  source marker) / `RemoteJudgeGateway` (fails loud until
  `REMOTE_JUDGE_BASE_URL` is set — BLOCKER-2, a hosting decision not yet
  made, see TODO.md). Switched by `GatewayFactory` via the single
  `EXECUTION_GATEWAY=mock|remote_judge` env var.

## Storage timezone

Migration session sets `time_zone = '+06:00'` (Asia/Dhaka), so every
`DATETIME` column stores Dhaka wall-clock time directly. `Core\Db`
connects with the same session time_zone and `bootstrap.php` sets the PHP
process timezone to match — there is deliberately no UTC-storage/convert
layer (unlike some sibling apps in this series).
