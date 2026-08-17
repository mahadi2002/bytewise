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
       -> runs middleware pipeline (auth -> sub -> admin -> csrf -> rl:*)
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
  Services/            business logic (OtpService, SubscriptionService,
                        SkillTreeService, XpService, StreakService,
                        SubmissionService, PlacementService,
                        ProjectReviewService)
  Middleware/           auth, guest, csrf, rate-limit, subscription-gate,
                         admin, security-headers
  Gateways/              SubscriptionGateway/CarrierGateway/Mock,
                         CodeExecutionGateway/RemoteJudgeGateway/Mock
  Core/                  Router, Db, Session, Csrf, RateLimit, Crypto, Env,
                         Validator, View, Logger, Request, Response, Controller
  Exceptions/            HttpException, GatewayException, OtpException
  Support/               Operator (BTRC prefix map), Totp, Markdown
config/config.php         single config file, dot-path via config()
database/                 migrations/ (8 numbered files), seeds/, migrate.php
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

## Subscription access control

`RequireSubscription` middleware re-queries `SubscriptionService::hasAccess()`
(a live DB read of `subscriptions.status IN ('active','grace')`) on every
gated request — never a session-cached flag. A lapsed subscription loses
access on its very next gated request. Session is intentionally NOT
destroyed on unsubscribe (see `SubscriptionService::unsubscribe()` docblock)
since Bytewise, unlike a zero-free-tier app, has substantial free content a
non-subscribed student should keep browsing.

## Gateways

Both external integrations follow interface + Mock + generic-named-stub:

- `SubscriptionGateway` — `MockSubscriptionGateway` (always succeeds, logs
  to `storage/logs/otp-*.log`) / `CarrierGateway` (fails loud until
  `CARRIER_GATEWAY_BASE_URL` is set — BLOCKER-1).
- `CodeExecutionGateway` — `MockExecutionGateway` (never executes
  submitted code; file-backed simulated-async state under
  `storage/mock_executions/`, outcome controlled by a `// MOCK: fail`
  source marker) / `RemoteJudgeGateway` (fails loud until
  `REMOTE_JUDGE_BASE_URL` is set — BLOCKER-2, a hosting decision not yet
  made, see TODO.md).

## Storage timezone

Migration session sets `time_zone = '+06:00'` (Asia/Dhaka), so every
`DATETIME` column stores Dhaka wall-clock time directly. `Core\Db`
connects with the same session time_zone and `bootstrap.php` sets the PHP
process timezone to match — there is deliberately no UTC-storage/convert
layer (unlike some sibling apps in this series).
