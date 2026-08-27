# TODO.md — Bytewise pre-launch blockers

Genuinely blocked on a decision or resource only the project owner can
provide — not implementation work. See `03-ENV-AND-CONFIG.md` §9 for full
context on each (source: `C:\Users\mahad\Downloads\03-ENV-AND-CONFIG.md`).

- [ ] BLOCKER-1: Real BDApps/SDP carrier gateway API docs + credentials.
      `CarrierGateway` stays a typed stub (throws `GatewayNotConfiguredException`)
      until these exist.
- [ ] BLOCKER-2: Which service backs `RemoteJudgeGateway` (self-hosted
      Judge0/Piston on a dedicated VPS, vs. a paid third-party judge API) —
      a cost/ops decision, not a coding task. Phase 10 is blocked on this.
- [ ] BLOCKER-3: BTRC operator prefix map (018/016) independent verification
      before launch — prefixes can change.
- [ ] BLOCKER-4: VAT/SD/SC wording verification against current
      BDApps-mandated tax copy.
- [x] BLOCKER-5a (lessons — DONE, 3 expansion rounds): Every module in all 8
      tracks now has real, original lessons with a code sample and a
      1-question quiz each — **73 modules, 298 lessons, 298 quiz questions,
      1192 options** across the whole app, every question has an
      `explanation_bn`. The old "every module has exactly 4 lessons, every
      track has exactly 6 modules" cap was an artificial early-build
      simplification, not a real constraint — removed across rounds 2-3.
      Module/lesson counts now vary by how much a topic genuinely needs
      (Python: 10 modules/42 lessons; Data Structures: 8/32), grounded in
      GfG/W3Schools' real per-language structure (see `docs/CONTENT-PLAN.md`
      "Curriculum expansion" sections for the full per-track rationale, 3
      rounds: Error/Exception Handling + File Handling + language-specific
      containers like Java Collections/C++ STL, then a deeper tier —
      Enums/Unions, Dynamic Memory Management, Generics, Iterators/Lambda/
      Comprehensions, DOM Basics, ES6+ Features, Stored Procedures, AVL
      Trees, Backtracking). Authored in `database/seeds/004`, `006`–`030`
      (one file per track/expansion round + explanation backfills + two
      module-structure files), following the pattern in
      `docs/CONTENT-PLAN.md`. Verified: DB-level integrity checks
      (every module has ≥1 lesson, every lesson exactly 1 quiz question with
      exactly 4 options and exactly 1 correct answer, zero missing
      explanations, zero UTF-8 corruption) and a full live run — every one
      of C's 40 lessons (now 10 modules) completed via the real HTTP
      endpoint, C reached 100%, and C++ auto-unlocked with its own new
      modules visible on the skill tree.
      Every seeded row still has `content_verified = 0` — genuinely new
      content should be reviewed by someone with subject-matter expertise
      per language before being marketed as expert-reviewed, but the
      curriculum itself is no longer a stub.
- [x] Lesson completion decoupled from the quiz (product decision, not a
      bug fix): a lesson is marked complete by an explicit, always-available
      "পরবর্তী লেসনে যান" action (`POST /lessons/{id}/complete`) regardless
      of whether the quiz was ever attempted — teaching is meant to be
      gentle, not gated behind a test. The quiz is now purely optional bonus
      practice: grades server-side and awards XP once per lesson on a
      fully-correct submission, but never blocks and never itself marks
      anything complete. See `docs/CONTENT-PLAN.md` "completion/progression
      flow" section.
- [ ] BLOCKER-5b (problems — still open): The judge-graded coding
      **problems** (separate from lesson quizzes; `problems` table, used by
      `/problems/{id}` + submissions) are still just 1 per track (8 total,
      e.g. C's BMI Calculator, C++'s two-number sum) — this is unrelated to
      the lesson-content work above and remains a real gap. More problems
      per track, ideally scaled to match each track's now-larger lesson
      count, is future authoring work.
      Additionally, `database/seeds/002_placement.sql` (assistant-authored,
      added during the build since 02-SCHEMA-SEED.sql shipped zero
      placement questions) only covers the C track (5 questions) — the
      other 7 tracks' `/placement-test` shows a graceful "coming soon"
      state, not real questions, until authored.
- [ ] BLOCKER-6: "BDApps" footer/legal-line wording conflict between this
      Claude Project's stored custom instructions and the rulebook's later
      override (2026-08-16, no-BDApps-anywhere) — needs the project owner to
      reconcile the Project's custom instructions directly; not resolvable
      from inside a build session. This build follows the rulebook (no
      "BDApps" anywhere in user-facing copy).

## Build progress (updated as phases complete)

- [x] Phase 1 — Scaffolding & Core
- [x] Phase 2 — Database & Migrations
- [x] Phase 3 — Auth: Student OTP flow
- [x] Phase 4 — Auth: Admin login
- [x] Phase 5 — Subscription State Machine & Unsubscribe
- [x] Phase 6 — Content Catalog (Browsable + Skill Tree)
- [x] Phase 7 — Quizzes, XP, Streaks
- [x] Phase 8 — Placement Test & Cheat Sheets
- [x] Phase 9 — Code Execution: Problems & Submissions
- [ ] Phase 10 — Real Execution Sandbox Integration (blocked on BLOCKER-2)
- [x] Phase 11 — Data Structures / Algorithms language-agnostic problems
- [x] Phase 12 — Daily Challenge, Leaderboard, Discussion
- [x] Phase 13 — Projects (Portfolio Capstones)
- [x] Phase 14 — Admin CMS & Content Import (lessons: full CRUD + CSV import;
      languages/modules/problems/projects: now full create/edit/delete too,
      following the same repository find()/update()/delete() +
      editX/updateX/deleteX controller pattern lessons established)
- [x] Phase 15 — Docs (7 files in docs/), Security Sweep, Launch Readiness.
      Fonts were a real gap (none existed) — fixed: 8 genuine self-hosted
      woff2 files downloaded (Hind Siliguri/Inter/JetBrains Mono, all OFL),
      verified by magic bytes and by serving through the live app. Full
      security checklist run with evidence recorded in docs/SECURITY.md.

## Post-launch: learning-path & hybrid-project architecture

Not in the original 15 phases — added after a workflow review (grounded
against freeCodeCamp/Odin/CS50's live structure) found the 8 tracks were
flat/ungated and the schema couldn't represent a multi-language project.
Two explicit product decisions: hard-gate (not soft-recommend), and
enforce the full C→...→SQL chain (not just the DS/Algorithms rule).

**Reversed (later product decision):** every track and every module is
now freely reachable to any logged-in subscriber, no prerequisites at
all — see `app/Services/TrackAccessService.php`,
`app/Services/SkillTreeService.php`, and FEATURES.md's "Learning path &
track gating" section. The chain/any-language rules described in the
items below are historical context for how the code got here, not the
current behavior. The hybrid-project schema and gating
(`project_languages`, `ProjectEligibilityService`) are unaffected — that's
a submission gate, not a content-access gate.

- [x] `project_languages` junction table (migration 009) — projects can
      now require more than one language; `projects.language_id` dropped.
- [x] `languages.prerequisite_language_id`/`requires_any_language` +
      `TrackAccessService` — track content (courses/lessons/problems, not
      just projects) is gated on prior-track completion. Verified via
      `tests/track_access_test.php` and live HTTP requests (direct-URL
      bypass attempts on locked lessons/problems correctly redirect).
- [x] `ProjectEligibilityService` — hard-gates project submission on ALL
      required languages 100% complete; verified a locked project's direct
      POST returns 403.
- [x] One real hybrid project seeded (`contact-book-cli`: Python + Data
      Structures) — `database/seeds/003_hybrid_project.sql`.
- [ ] Only ONE hybrid project exists. Same content-authoring gap as
      BLOCKER-5b (problems/projects, not lessons — those are done) — more
      hybrid projects (ideally later-chain-language pairings now that more
      lesson content exists, e.g. JavaScript+SQL for a small
      full-stack-flavored capstone) are future authoring work, not a code
      change.
- [ ] The daily-challenge grid (`/daily-challenge`) intentionally still
      shows all 8 tracks' cards regardless of lock state (kept as a
      motivator/preview) — clicking through to a locked track's problem
      redirects same as any other locked problem. Revisit if this proves
      confusing in practice (e.g. graying out locked cards there too).

## Post-launch: lesson completion flow & full curriculum authoring

Two more gaps found and closed after the architecture work above shipped:
the skill tree had no navigation at all (nothing linked a module to its
lessons), and lesson "completion" didn't check quiz correctness.

- [x] `CourseController::module()` + `/courses/{track}/{slug}` route +
      `views/courses/module.php` — the skill tree previously had zero `<a>`
      tags anywhere; there was no page listing a module's lessons.
- [x] `quiz_questions.explanation_bn` (migration 010) + rewritten
      `LessonController::submitQuiz()` — a lesson only reaches `completed`
      when every question is answered correctly (previously any submission
      marked it complete regardless of score); wrong answers show a
      per-question breakdown with explanation and no XP; a pass shows a
      next-lesson link or a module-complete banner. See `docs/DATABASE.md`
      §010 and `docs/CONTENT-PLAN.md`.
- [x] Full curriculum authored for all 8 tracks — see BLOCKER-5a above.
