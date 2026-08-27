# DATABASE.md — Bytewise

Schema source of truth: `database/migrations/001..008_*.sql` (matches
`02-SCHEMA.sql` from the build spec, split into the 8 numbered files below).
Runtime connection uses the low-privilege `bytewise_app` user (SELECT/INSERT/
UPDATE/DELETE only); `database/migrate.php` uses the separate
`bytewise_migrate` admin credential. DDL-denial verified via
`tests/ddl_denial_probe.php` (exit 0, MySQL error 1142 CREATE denied).

Storage note: the migration session sets `time_zone = '+06:00'` (Asia/Dhaka),
so every `DATETIME`/`TIMESTAMP` column stores Dhaka wall-clock time directly
— `App\Core\Db` sets the same session time_zone on every connection, and
`bootstrap.php` sets the PHP process timezone to match. There is no UTC
storage/conversion layer in this app.

## 001_core_auth.sql
- **users** — mobile number is never stored in plaintext: `mobile_encrypted`
  (AES-256-GCM via `Core\Crypto::encrypt`) + `mobile_hash` (HMAC-SHA256 blind
  index via `Core\Crypto::blindIndex`, keyed by `HASH_PEPPER` — separate from
  `APP_KEY`) for lookups. `operator` is `robi`|`airtel` only.
- **otp_requests** — `otp_hash` is `password_hash()`, never plaintext. 5-min
  TTL, attempt cap, `purpose` distinguishes `subscribe` vs `admin_2fa_recovery`.
- **sessions** — DB-backed (`App\Core\Session`), one row can carry either
  `user_id` (student) or `admin_user_id` (admin), never both meaningfully at
  once. Lapsed subscription revokes access on the next request because
  `RequireSubscription` re-reads `subscriptions.status` from the DB every
  time, never from session state.
- **rate_limits** — fixed-window buckets keyed by `(bucket_key, action,
  window_started_at)`. See `App\Core\RateLimit::buckets()` for the action ->
  limit/window map (mirrors `config('rate_limits')`).
- **admin_users** — separate auth path from students (password + TOTP 2FA,
  no SMS OTP). `totp_secret_encrypted` uses the same `Crypto` class/`APP_KEY`.

## 002_subscription_billing.sql
- **subscriptions** — state machine `pending -> active -> grace -> expired`,
  plus `unsubscribed` reachable from any state. `gateway_external_ref` is the
  opaque `SubscriptionGateway` reference, never a raw carrier identifier.
- **billing_events** — append-only log of gateway events (`charge_success`,
  `otp_confirmed`, `unsubscribed`, etc.), `amount_paisa` avoids float rounding.
- **jobs** — cron task-guard table. `cron/run-jobs.php` checks
  `UNIQUE(job_name, run_date)` before running a daily-or-slower job, so the
  single crontab line can safely run every minute.

## 003_content_catalog.sql
- **languages** — doubles as the general "track" table: 6 real executable
  languages (`is_meta_track=0`, `judge_language_code` set) + Data Structures
  and Algorithms (`is_meta_track=1`, `judge_language_code NULL`,
  `chk_languages_judge_code` CHECK enforces this pairing).
  **`prerequisite_language_id`/`requires_any_language`** (added in
  migration 009, dropped in migration 014) originally enforced the
  learning-path order — see migration 009's and 014's own notes below.
  Product decision reversed the hard-gate (all tracks are now
  prerequisite-free) and, once confirmed unread by any code, the columns
  were torn out rather than left as permanent dead schema.
- **modules**, **lessons** — `lessons.body_md`/`code_sample` are the GATED
  columns: `LessonRepository::findForViewer()` must exclude them from the
  SELECT entirely for non-subscribers on non-free-preview lessons, not just
  hide them in the template (verified in Phase 6).
- **cheatsheets** — `summary_md` free, `full_md` gated, one row per language.

## 004_quiz_placement.sql
- **quiz_questions**/**quiz_options**/**quiz_attempts** — inline lesson
  quizzes, MCQ, `xp_awarded` on the attempt row (source-of-truth is still
  `xp_ledger`, this is a denormalized convenience column).
- **placement_questions**/**placement_options**/**placement_attempts** — the
  free, pre-auth-or-session-keyed placement test (`user_id` nullable).

## 010_quiz_explanations.sql
- **quiz_questions.explanation_bn** (`TEXT NULL`) — shown only on the
  post-submission result view (`views/lessons/quiz-result.php`), never on
  the pre-submission quiz form (`QuizQuestionRepository::forLesson()` still
  never selects `is_correct`/`explanation_bn` — that view's answer-leak
  guarantee is unchanged).

**Completion model (revised — the quiz never gates progress):** the quiz is
optional, purely for bonus XP. `user_lesson_progress.status = 'completed'`
is written in exactly one place, `LessonController::complete()` (POST
`/lessons/{id}/complete`), regardless of whether the quiz was ever
attempted or passed. `submitQuiz()` only grades and awards XP on a
fully-correct submission — once per lesson, tracked via
`QuizAttemptRepository::hasBeenRewarded()` (`quiz_attempts.xp_awarded > 0`)
rather than lesson-completed status, since the two are now independent.

## 005_execution.sql
- **problems** — `language_id NULL` = language-agnostic (Data Structures /
  Algorithms only). `statement_md`/`starter_code` are gated columns.
- **test_cases** — `is_hidden=1` rows are graded but never returned to the
  client (verified in Phase 9: inspect the actual JSON response body).
- **submissions** — `language_id` is the language THIS attempt used,
  independent of `problems.language_id`; `SubmissionService` must validate
  it server-side against `problems.language_id` for language-locked problems
  before ever calling `CodeExecutionGateway::submit()`.
- **submission_test_results** — `actual_stdout_excerpt` only stored for
  non-hidden cases.
- **daily_challenges** — `UNIQUE(language_id, challenge_date)`, one row per
  track per day via `cron/_jobs/daily_challenge_rotate.php`.

## 006_engagement.sql
- **user_lesson_progress** — single source of truth for lesson completion;
  `SkillTreeService` computes per-module ✓/%/🔒 from this at render time, no
  stored `is_unlocked` column anywhere (BUILD-SPEC §9).
- **xp_ledger** — append-only; a user's total XP is always `SUM(xp_amount)`,
  never a mutable counter.
- **user_streaks** — timezone-aware day boundary using `APP_TIMEZONE`
  (Asia/Dhaka) since storage is already Dhaka-local, not UTC.
- **discussion_posts** — soft-hide moderation (`is_hidden_by_admin`), never a
  hard delete of user-generated content.

## 007_support_audit.sql
- **contact_messages** — real table-backed (per naming-honesty rule: the
  repository is genuinely `ContactMessageRepository`, not a log writer).
  `honeypot_tripped=1` rows are never actually inserted (BUILD-SPEC §8).
- **audit_log** — every admin PII-reveal action (`user.pii_reveal`) and
  billing/security-relevant admin action lands here.

## 008_projects.sql
- **projects**/**project_submissions** — portfolio capstones, deliberately
  NOT wired to `CodeExecutionGateway`/`submissions`. Self-reported (link or
  upload) + admin-reviewed (`review_status`, `reviewer_admin_id`, manual
  `xp_awarded`). Do not build an auto-grader for these — see BUILD-SPEC §9.
  **`projects.language_id` was dropped in migration 009** — see below.

## 009_project_languages_and_prerequisites.sql

Added after the initial 15-phase build, when a workflow-architecture
review found two real gaps: the schema couldn't represent a project
needing more than one language, and nothing gated track content on
prior-track completion despite the landing copy implying a learning order.
**The prerequisite half was later explicitly reversed** — see the note
below and FEATURES.md, "Learning path & track gating". The two columns
this introduced were dropped outright in migration 014 once reversal was
confirmed permanent and the columns confirmed unread; this history stays
documented here even though the schema no longer carries them.

- **project_languages** (`project_id`, `language_id`, `is_primary`) — a
  many-to-many replacing the single `projects.language_id` FK. A project
  can now require more than one language ("hybrid" — e.g. Python + Data
  Structures). `is_primary` only drives card display order, never a
  gating distinction; `ProjectEligibilityService` requires ALL listed
  languages at 100% complete before the submission form unlocks. Still
  active — unrelated to the prerequisite reversal below.
- **languages.prerequisite_language_id** (self-FK, dropped in migration
  014) — originally enforced C → C++ → Java → Python → JavaScript → SQL:
  each of the last 5 requires the previous 100% complete. This was a
  **pedagogical** ordering decision, not a technical dependency (nothing
  about Python requires C).
- **languages.requires_any_language** (dropped in migration 014) —
  originally set on Data Structures and Algorithms: their content required
  ANY ONE real language track 100% complete.
- **Reversed (product decision):** every track and every module is now
  freely reachable to any logged-in subscriber, no prerequisites.
  `TrackAccessService::isUnlocked()` always returns `true` for a
  logged-in user and no longer reads either column — migration 014
  dropped both, along with the FK and its supporting index, once that was
  confirmed safe; `SkillTreeService::build()` no longer sequentially locks
  modules within a track either. `CourseController`, `LessonController`,
  `ProblemController`, `SubmissionController`, `ExploreController`, and
  `DashboardController` still delegate to `TrackAccessService` (still the
  one place the rule is defined), it just never says no to a logged-in
  user anymore.

## Seed content scope
`database/seeds/001_content.sql` (from `02-SCHEMA-SEED.sql`; numbered `001`
so it sorts — and loads — before every other seed file, since it's the one
that actually inserts the `languages` rows the rest depend on) is a **structural
starting point, not a complete curriculum** — see that file's own scope note
and `TODO.md` BLOCKER-5. Every row it inserts sets `content_verified = 0`.

`database/seeds/002_placement.sql` is a supplementary, assistant-authored
seed added mid-build (the original seed file shipped zero
`placement_questions` rows, which would have made `/placement-test`
untestable) — covers the C track only (5 questions), same unverified-content
flag applies.

`database/seeds/003_hybrid_project.sql` adds one genuinely hybrid project
("Contact Book" — Python + Data Structures) so the `project_languages`
junction table (migration 009) has a real example beyond the original 3
single-language projects. Deliberately paired with a meta-track rather
than another chain language: pairing two of the six chain languages would
make the pairing partly redundant (finishing the later one already implies
the earlier one, per the enforced prerequisite chain), so it wouldn't
actually exercise "two independent requirements" the way this one does.

All three `.sql` seed files run automatically via
`php database/migrate.php --seed`.

`database/scripts/create_admin.php` creates the first admin user — run
standalone (`php database/scripts/create_admin.php <email> <password>`),
deliberately NOT part of the `--seed` auto-glob (see that script's own
docblock: it expects CLI args that `--seed`'s no-argument auto-require
wouldn't supply, which would abort the whole seed run).

## 011_xp_ledger_uniqueness.sql

`xp_ledger` gets `UNIQUE(user_id, source_type, source_id)`. Found by
`/code-review`: `XpService::award()` was a check-then-insert
(`alreadyAwarded()` then `add()`) with nothing at the DB level backing the
"once per source" guarantee, so two concurrent requests for the same
lesson's quiz (double-click, two tabs) could both pass the check before
either row existed and both get paid. `XpLedgerRepository::addOnce()` now
attempts the insert directly and treats a duplicate-key error (SQLSTATE
`23000`) as "already awarded" — verified by firing 5 concurrent identical
`/lessons/{id}/quiz` submissions: 5 `quiz_attempts` rows (every attempt is
still logged) but exactly 1 `xp_ledger` row and 10 XP total, not 50. Safe
for existing usage: every current `XpService::award()` call site
(`'quiz'`, `'problem'`, `'project'`) always passes a concrete `source_id`;
`'daily_challenge'`/`'streak_bonus'` are unused so far (TODO.md), so the
NULL-distinctness quirk of MySQL unique indexes never comes into play yet.

Same review also found `LessonController::complete()`/`submitQuiz()` using
`LessonRepository::find()`, which — unlike `findForViewer()` and
`nextInModule()` — doesn't filter `is_published`. (Left as-is on purpose:
`find()` is also what the admin edit-lesson form uses to load drafts, so
the fix is an explicit `is_published` check at the two student-facing call
sites, not a filter on the shared method.) An unpublished lesson's `done`
count wasn't excluded from `UserLessonProgressRepository::moduleCounts()`
either, so completing one could push `done` past the published-only
`total` and permanently block that module from ever showing 100% (no
admin "un-complete" exists) — fixed by 404ing on an unpublished lesson in
both actions before anything is written.
