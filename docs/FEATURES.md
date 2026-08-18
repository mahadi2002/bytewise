# FEATURES.md — Bytewise

Maps BUILD-SPEC §6's content-model roles to what's actually built, and
records where the built behavior diverges from the original spec text.

| Role | Implementation | Status |
|---|---|---|
| Browsable catalog | `/explore` → 8 tracks → modules → lessons | Done |
| Diagnostic/matching engine | Placement test scores against `placement_questions` (weighted by `difficulty_weight`), recommends a starting module | Done for **C track only** — 7 other tracks have zero seed questions and show a "coming soon" state (TODO.md) |
| Time-based guidance | Daily coding challenge, one problem per track per day via `cron/_jobs/daily_challenge_rotate.php` | Done — verified job-guard idempotency |
| Guide library | Cheat sheets, summary (free) / full (gated) per track | Done for the 8 seeded tracks |
| User-generated content loop | Discussion threads on lessons/problems | Done — flat + one-level reply via `parent_post_id`; no admin moderation UI yet (`is_hidden_by_admin` column exists, no admin action wired — TODO.md) |
| Real contact/support feature | `contact_messages` table + `/admin/contact-messages`, honeypot spam handling | Done |
| Portfolio/capstone feature | Projects: self-reported link + admin review queue, XP on approve, hard-gated on required language(s) 100% complete | Done, verified end-to-end |

## Learning path & track gating (added post-launch, later reversed — see TODO.md)

A workflow-architecture review (grounded against freeCodeCamp, The Odin
Project, and CS50's actual live structure) found the original 8 tracks
were flat and ungated — a brand-new subscriber could open any track or
project regardless of progress, and the schema couldn't represent a
project needing more than one language at all. Two product decisions
(both explicit, not defaults) closed this: a hard-gated chain
(C → C++ → Java → Python → JavaScript → SQL, each requiring the previous
100% complete) and a "Data Structures/Algorithms needs any one language
100% complete" rule.

**This was later explicitly reversed** — product decision: every track
and every module within a track is now freely reachable to any logged-in
subscriber, no prerequisites at all. `TrackAccessService::check()` always
returns `unlocked: true` for a logged-in user; `SkillTreeService::build()`
no longer sequentially locks modules within a track. The schema columns
(`languages.prerequisite_language_id`, `languages.requires_any_language`)
still exist but are no longer read by any code — removing them would be a
migration + FK teardown for no behavioral benefit, so they're left in
place, inert.

Still in effect, unaffected by the reversal:
- **Hybrid projects**: `project_languages` (many-to-many) replaces the old
  single `projects.language_id`. A project can require more than one
  language; `ProjectEligibilityService` hard-gates the submission form
  until ALL required languages are 100% complete. One real example seeded
  (`contact-book-cli`: Python + Data Structures). This is a *submission*
  gate, not a *content-access* gate — unrelated to `TrackAccessService`.
- **`TrackAccessService`** is still the single source of truth for track
  access — consulted by `CourseController`, `LessonController` (show +
  quiz submit), `ProblemController`, and `SubmissionController` — it just
  no longer has any reason to say no to a logged-in user.
- Surfaced in the UI: `/dashboard` and `/explore` no longer show 🔒 or
  lock reasons for logged-in subscribers; every track/module renders its
  real completion state (✓/%/not-started) regardless of any other
  track/module's progress.

## Skill tree (signature UI element)

`SkillTreeService::build()` computes ✓ (complete) / N% (partial) / 🔒
(locked) per module at render time from `user_lesson_progress` — no stored
unlock flag. A visitor (`userId === null`) sees every node locked. Verified
against the exact JS-track shape from BUILD-SPEC §4 (Variables & Basics →
Functions → Arrays → Objects → Async JavaScript → React Basics).

## Code execution

`CodeExecutionGateway` abstraction with `MockExecutionGateway` (never
executes untrusted code — outcome is a fixture marker in the source, see
ARCHITECTURE.md) and `RemoteJudgeGateway` (real sandbox, blocked on
BLOCKER-2). Submissions are graded against `test_cases`; hidden-case output
is never returned to the client (verified: `output: null` in the JSON
response even for a passing hidden case). XP is awarded once per
(user, problem) — idempotent across repeat submissions to an
already-passed problem (a bug caught and fixed mid-build, see git history
around `SubmissionService::refreshStatus`).

Language-agnostic problems (`problems.language_id IS NULL`, Data
Structures/Algorithms tracks): a language picker appears on `/problems/{id}`;
track membership for daily-challenge eligibility is inferred through
`problems.lesson_id → lessons.module_id → modules.language_id` since
`problems.language_id` itself is NULL for these rows.

## Motion & materials pass (apple-design)

The dark terminal system was visually correct but static (near-zero motion,
unstyled headings, opaque flat nav). Applied Apple's fluid-interface
principles within this stack's constraints (no build step, no spring
library — CSS transitions/animations + vanilla JS only):

- **Typography**: a real scale for h1/h2/h3 — negative tracking + tight
  leading on large headings (`clamp()`-sized), unstyled before this.
- **Materials**: nav (public + admin) is now a translucent sticky layer
  (`backdrop-filter: blur() saturate()`) with content scrolling under it,
  instead of an opaque static bar.
- **Motion tokens**: `--ease-out` (critically damped, no overshoot) is the
  default for all routine hover/press/focus transitions;
  `--ease-spring` (slight overshoot) is reserved for reward-flavored
  moments only — XP/streak count-up, quiz-passed badge, submission-passed
  status, placement-test recommendation card — never for ordinary UI, per
  Apple's damping guidance.
- **Response**: every button gets `:active` press feedback (scale down)
  instead of feedback only on click resolution; cards lift + glow on hover.
- **The accent-gold pulse BUILD-SPEC §4 specified but never implemented**:
  the token table literally says accent-gold is for "current staircase
  step (pulse)" — the skill tree's `.skill-icon-partial` (the in-progress
  module) now actually pulses; it never did before this pass.
- **Terminal-theme reinforcement**: a blinking text-cursor after the brand
  wordmark, macOS-style traffic-light dots on every code block — cheap,
  on-brand, and the single highest-recognition change for "this LOOKS like
  a terminal" rather than just "this is dark mode."
- **`prefers-reduced-motion: reduce`**: every animation/transition above
  degrades to instant or near-instant — verified via media query presence,
  not assumed.

## Post-launch fixes (found via ponytail-audit + impeccable audit)

- **`/dashboard` was never built** despite being in the locked BUILD-SPEC
  route table — the nav bar had zero links for a logged-in user, so a
  freshly-subscribed student landed on `/account` with nowhere else to go.
  Fixed: `DashboardController` (skill tree per track, XP, streak, today's
  daily challenges) + a real `nav.php` with authenticated vs. visitor link
  sets. Student `/logout` didn't exist either (only admin had one) — added.
- **CSP silently killed 3 interactive elements**: `script-src 'self'`
  (correctly, no `unsafe-inline`) blocks inline `onchange`/`onsubmit`
  attributes, which `/placement-test`'s track picker, the admin contact
  status dropdown, and the admin lesson-delete confirmation all used. The
  delete button's failure mode was worse than "inert" — it deleted
  immediately with **no confirmation** since the confirm dialog never
  fired. Fixed via `public/assets/js/app.js` (`data-auto-submit`,
  `data-confirm` attributes + delegated listeners), CSP-clean. Also found
  and fixed the same `style-src 'self'` issue on 3 `style="display:inline"`
  attributes (admin project-submissions, lesson delete) — replaced with an
  `.inline-form` class.
- **No visible focus state, no accessible label on skill-tree status
  icons, sub-44px touch targets on text inputs** — all from the impeccable
  accessibility audit, fixed (`:focus-visible` ring in
  `--accent-terminal`, `aria-label`s on ✓/%/🔒, global 44px min-height on
  text-entry controls).
- **XP could be farmed by resubmitting an already-passed problem** — see
  git history around `SubmissionService::refreshStatus` (was keyed by
  submission id, fixed to key by problem id, matching the quiz pattern).

## Known gaps (see TODO.md for the full blocker list)

- `submissions.counted_for_daily_challenge` column exists but is never set
  — there's no distinct "this submission was your daily-challenge attempt"
  bookkeeping beyond the normal submit flow.
- Admin content CRUD is full (create/edit/delete) for **lessons** only;
  languages/modules/problems/projects have list + create, no edit/delete
  UI yet.
- Real sandbox integration (Phase 10) is blocked on BLOCKER-2 — a
  self-hosted-vs-third-party judge hosting decision.
