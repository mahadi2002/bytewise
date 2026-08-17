<?php
declare(strict_types=1);

/**
 * [method, path, 'Controller@action', [middleware]]
 *
 * Convention (BUILD-SPEC §5): [F] free/ungated, [G] gated (sub), [A] admin,
 * [P] POST/PATCH/DELETE (csrf). Routes are appended here phase by phase as
 * each build phase's controllers land — see 04-AI-BUILD-PLAYBOOK.md.
 */

return [
    // ── Public (Phase 1) ────────────────────────────────────────────────
    ['GET', '/', 'HomeController@index', []],
    ['GET', '/health', 'HomeController@health', []],
    ['GET', '/faq', 'HomeController@faq', []],
    ['GET', '/privacy-policy', 'HomeController@privacy', []],
    ['GET', '/terms', 'HomeController@terms', []],
    ['GET', '/contact', 'ContactController@show', []],
    ['POST', '/contact', 'ContactController@submit', ['csrf']],

    // ── Subscribe / Auth — OTP-only (Phase 3) ───────────────────────────
    ['POST', '/otp/request', 'AuthController@requestOtp', ['csrf']],
    ['GET',  '/otp/verify',  'AuthController@verifyForm', []],
    ['POST', '/otp/verify',  'AuthController@verify',     ['csrf']],
    ['POST', '/otp/resend',  'AuthController@resend',     ['csrf']],
    ['POST', '/logout',      'AuthController@logout',     ['auth', 'csrf']],

    // ── Student dashboard ────────────────────────────────────────────────
    ['GET', '/dashboard', 'DashboardController@index', ['auth', 'sub']],

    // ── Admin auth (Phase 4) ────────────────────────────────────────────
    ['GET',  '/admin/login',     'Admin/AdminAuthController@loginForm', []],
    ['POST', '/admin/login',     'Admin/AdminAuthController@login',     ['csrf']],
    ['POST', '/admin/logout',    'Admin/AdminAuthController@logout',    ['csrf', 'admin']],
    ['GET',  '/admin/dashboard', 'Admin/DashboardController@index',     ['admin']],

    // ── Subscription state / unsubscribe (Phase 5) — no `sub` gate ──────
    ['GET',  '/account',     'AccountController@index',            ['auth']],
    ['GET',  '/unsubscribe', 'AccountController@unsubscribeForm',  ['auth']],
    ['POST', '/unsubscribe', 'AccountController@unsubscribe',      ['auth', 'csrf']],

    // ── Content catalog (Phase 6) ────────────────────────────────────────
    ['GET', '/explore',           'ExploreController@index',    []],
    ['GET', '/explore/{track}',   'ExploreController@show',     []],
    ['GET', '/lesson/{slug}',     'LessonController@showFree',  []],
    ['GET', '/courses/{track}',   'CourseController@show',      ['auth', 'sub']],
    ['GET', '/courses/{track}/{slug}', 'CourseController@module', ['auth', 'sub']],
    ['GET', '/lessons/{id}',      'LessonController@showGated', ['auth', 'sub']],
    ['POST', '/lessons/{id}/complete', 'LessonController@complete', ['auth', 'sub', 'csrf']],

    // ── Quizzes / XP / Streaks (Phase 7) — optional, XP-only, never gates progression ──
    ['POST', '/lessons/{id}/quiz', 'LessonController@submitQuiz', ['auth', 'sub', 'csrf']],

    // ── Placement test & cheat sheets (Phase 8) ──────────────────────────
    ['GET',  '/placement-test',            'PlacementTestController@show',   []],
    ['POST', '/placement-test',            'PlacementTestController@submit', ['csrf']],
    ['GET',  '/cheatsheets/{track}',       'CheatsheetController@summary',   []],
    ['GET',  '/cheatsheets/{track}/full',  'CheatsheetController@full',      ['auth', 'sub']],

    // ── Code execution: problems & submissions (Phase 9) ─────────────────
    ['GET',  '/problems/{id}',         'ProblemController@show',      ['auth', 'sub']],
    ['POST', '/problems/{id}/submit',  'SubmissionController@submit', ['auth', 'sub', 'csrf']],
    ['GET',  '/submissions/{id}',      'SubmissionController@show',   ['auth', 'sub']],

    // ── Daily challenge, leaderboard, discussion (Phase 12) ──────────────
    ['GET',  '/daily-challenge', 'DailyChallengeController@index', ['auth', 'sub']],
    ['GET',  '/leaderboard',     'LeaderboardController@index',    ['auth', 'sub']],
    ['GET',  '/discussion/{context_type}/{id}', 'DiscussionController@index', ['auth', 'sub']],
    ['POST', '/discussion/{context_type}/{id}', 'DiscussionController@store', ['auth', 'sub', 'csrf']],

    // ── Projects (Phase 13) ───────────────────────────────────────────────
    ['GET',  '/projects',          'ProjectController@index',  ['auth', 'sub']],
    ['GET',  '/projects/{id}',     'ProjectController@show',   ['auth', 'sub']],
    ['POST', '/projects/{id}/submit', 'ProjectController@submit', ['auth', 'sub', 'csrf']],

    ['GET',   '/admin/project-submissions',                  'Admin/ProjectSubmissionController@index',          ['admin']],
    ['POST',  '/admin/project-submissions/{id}/approve',     'Admin/ProjectSubmissionController@approve',        ['admin', 'csrf']],
    ['POST',  '/admin/project-submissions/{id}/changes',     'Admin/ProjectSubmissionController@requestChanges', ['admin', 'csrf']],

    // ── Admin CMS & content import (Phase 14) ────────────────────────────
    ['GET',  '/admin/languages',            'Admin/ContentController@languages',   ['admin']],
    ['GET',  '/admin/modules',              'Admin/ContentController@modules',     ['admin']],
    ['POST', '/admin/modules',              'Admin/ContentController@storeModule', ['admin', 'csrf']],
    ['GET',  '/admin/content/lessons',      'Admin/ContentController@lessons',       ['admin']],
    ['GET',  '/admin/content/lessons/new',  'Admin/ContentController@createLesson',  ['admin']],
    ['POST', '/admin/content/lessons',      'Admin/ContentController@storeLesson',   ['admin', 'csrf']],
    ['GET',  '/admin/content/lessons/{id}/edit', 'Admin/ContentController@editLesson',   ['admin']],
    ['POST', '/admin/content/lessons/{id}',      'Admin/ContentController@updateLesson', ['admin', 'csrf']],
    ['POST', '/admin/content/lessons/{id}/delete', 'Admin/ContentController@deleteLesson', ['admin', 'csrf']],
    ['GET',  '/admin/content/problems',     'Admin/ContentController@problems',    ['admin']],
    ['POST', '/admin/content/problems',     'Admin/ContentController@storeProblem',['admin', 'csrf']],
    ['GET',  '/admin/content/projects',     'Admin/ContentController@projects',    ['admin']],
    ['POST', '/admin/content/projects',     'Admin/ContentController@storeProject',['admin', 'csrf']],

    ['GET',  '/admin/content-import',  'Admin/ContentImportController@show',   ['admin']],
    ['POST', '/admin/content-import',  'Admin/ContentImportController@import', ['admin', 'csrf']],

    ['GET',  '/admin/contact-messages',      'Admin/ContactMessageController@index',        ['admin']],
    ['POST', '/admin/contact-messages/{id}', 'Admin/ContactMessageController@updateStatus',  ['admin', 'csrf']],

    ['GET',  '/admin/users',           'Admin/UserController@index',  ['admin']],
    ['POST', '/admin/users/{id}/reveal', 'Admin/UserController@reveal', ['admin', 'csrf']],

    ['GET',  '/admin/audit-log', 'Admin/AuditLogController@index', ['admin']],
];
