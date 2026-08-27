<?php
declare(strict_types=1);

/**
 * [method, path, 'Controller@action', [middleware]]
 *
 * Convention: [F] free/ungated, [G] gated (auth — login-or-registered
 * access only, no subscription tier), [A] admin, [P] POST/PATCH/DELETE
 * (csrf).
 */

return [
    // ── Public ──────────────────────────────────────────────────────────
    ['GET', '/', 'HomeController@index', []],
    ['GET', '/health', 'HomeController@health', []],
    ['GET', '/faq', 'HomeController@faq', []],
    ['GET', '/privacy-policy', 'HomeController@privacy', []],
    ['GET', '/terms', 'HomeController@terms', []],
    ['GET', '/contact', 'ContactController@show', []],
    ['POST', '/contact', 'ContactController@submit', ['csrf']],

    // ── Auth — email + password ─────────────────────────────────────────
    ['GET',  '/register', 'AuthController@registerForm', []],
    ['POST', '/register', 'AuthController@register',     ['csrf']],
    ['GET',  '/login',    'AuthController@loginForm',    []],
    ['POST', '/login',    'AuthController@login',        ['csrf']],
    ['POST', '/logout',   'AuthController@logout',       ['auth', 'csrf']],
    ['GET',  '/forgot-password',      'AuthController@forgotPasswordForm', []],
    ['POST', '/forgot-password',      'AuthController@forgotPassword',     ['csrf']],
    ['GET',  '/reset-password/{token}', 'AuthController@resetPasswordForm', []],
    ['POST', '/reset-password/{token}', 'AuthController@resetPassword',     ['csrf']],

    // ── Student dashboard ────────────────────────────────────────────────
    ['GET', '/dashboard', 'DashboardController@index', ['auth']],

    // ── Admin auth ───────────────────────────────────────────────────────
    ['GET',  '/admin/login',     'Admin/AdminAuthController@loginForm', []],
    ['POST', '/admin/login',     'Admin/AdminAuthController@login',     ['csrf']],
    ['POST', '/admin/logout',    'Admin/AdminAuthController@logout',    ['csrf', 'admin']],
    ['GET',  '/admin/dashboard', 'Admin/DashboardController@index',     ['admin']],

    // ── Account ──────────────────────────────────────────────────────────
    ['GET',  '/account',     'AccountController@index',            ['auth']],

    // ── Content catalog ──────────────────────────────────────────────────
    ['GET', '/explore',           'ExploreController@index',    []],
    ['GET', '/explore/{track}',   'ExploreController@show',     []],
    ['GET', '/lesson/{slug}',     'LessonController@showFree',  []],
    ['GET', '/courses/{track}',   'CourseController@show',      ['auth']],
    ['GET', '/courses/{track}/{slug}', 'CourseController@module', ['auth']],
    ['GET', '/lessons/{id}',      'LessonController@showGated', ['auth']],
    ['POST', '/lessons/{id}/complete', 'LessonController@complete', ['auth', 'csrf']],

    // ── Quizzes / XP / Streaks — optional, XP-only, never gates progression ──
    ['POST', '/lessons/{id}/quiz', 'LessonController@submitQuiz', ['auth', 'csrf']],

    // ── Placement test & cheat sheets ────────────────────────────────────
    ['GET',  '/placement-test',            'PlacementTestController@show',   []],
    ['POST', '/placement-test',            'PlacementTestController@submit', ['csrf']],
    ['GET',  '/cheatsheets/{track}',       'CheatsheetController@summary',   []],
    ['GET',  '/cheatsheets/{track}/full',  'CheatsheetController@full',      ['auth']],

    // ── Code execution: problems & submissions ───────────────────────────
    ['GET',  '/problems/{id}',         'ProblemController@show',      ['auth']],
    ['POST', '/problems/{id}/submit',  'SubmissionController@submit', ['auth', 'csrf']],
    ['GET',  '/submissions/{id}',      'SubmissionController@show',   ['auth']],

    // ── Daily challenge, leaderboard, discussion ─────────────────────────
    ['GET',  '/daily-challenge', 'DailyChallengeController@index', ['auth']],
    ['GET',  '/leaderboard',     'LeaderboardController@index',    ['auth']],
    ['GET',  '/discussion/{context_type}/{id}', 'DiscussionController@index', ['auth']],
    ['POST', '/discussion/{context_type}/{id}', 'DiscussionController@store', ['auth', 'csrf']],

    // ── Projects ─────────────────────────────────────────────────────────
    ['GET',  '/projects',          'ProjectController@index',  ['auth']],
    ['GET',  '/projects/{id}',     'ProjectController@show',   ['auth']],
    ['POST', '/projects/{id}/submit', 'ProjectController@submit', ['auth', 'csrf']],

    ['GET',   '/admin/project-submissions',                  'Admin/ProjectSubmissionController@index',          ['admin']],
    ['POST',  '/admin/project-submissions/{id}/approve',     'Admin/ProjectSubmissionController@approve',        ['admin', 'csrf']],
    ['POST',  '/admin/project-submissions/{id}/changes',     'Admin/ProjectSubmissionController@requestChanges', ['admin', 'csrf']],

    // ── Admin CMS & content import ───────────────────────────────────────
    ['GET',  '/admin/languages',            'Admin/ContentController@languages',   ['admin']],
    ['GET',  '/admin/languages/{id}/edit',  'Admin/ContentController@editLanguage',   ['admin']],
    ['POST', '/admin/languages/{id}',       'Admin/ContentController@updateLanguage', ['admin', 'csrf']],
    ['POST', '/admin/languages/{id}/delete','Admin/ContentController@deleteLanguage', ['admin', 'csrf']],
    ['GET',  '/admin/modules',              'Admin/ContentController@modules',     ['admin']],
    ['POST', '/admin/modules',              'Admin/ContentController@storeModule', ['admin', 'csrf']],
    ['GET',  '/admin/modules/{id}/edit',    'Admin/ContentController@editModule',   ['admin']],
    ['POST', '/admin/modules/{id}',         'Admin/ContentController@updateModule', ['admin', 'csrf']],
    ['POST', '/admin/modules/{id}/delete',  'Admin/ContentController@deleteModule', ['admin', 'csrf']],
    ['GET',  '/admin/content/lessons',      'Admin/ContentController@lessons',       ['admin']],
    ['GET',  '/admin/content/lessons/new',  'Admin/ContentController@createLesson',  ['admin']],
    ['POST', '/admin/content/lessons',      'Admin/ContentController@storeLesson',   ['admin', 'csrf']],
    ['GET',  '/admin/content/lessons/{id}/edit', 'Admin/ContentController@editLesson',   ['admin']],
    ['POST', '/admin/content/lessons/{id}',      'Admin/ContentController@updateLesson', ['admin', 'csrf']],
    ['POST', '/admin/content/lessons/{id}/delete', 'Admin/ContentController@deleteLesson', ['admin', 'csrf']],
    ['GET',  '/admin/content/problems',     'Admin/ContentController@problems',    ['admin']],
    ['POST', '/admin/content/problems',     'Admin/ContentController@storeProblem',['admin', 'csrf']],
    ['GET',  '/admin/content/problems/{id}/edit', 'Admin/ContentController@editProblem',   ['admin']],
    ['POST', '/admin/content/problems/{id}',      'Admin/ContentController@updateProblem', ['admin', 'csrf']],
    ['POST', '/admin/content/problems/{id}/delete', 'Admin/ContentController@deleteProblem', ['admin', 'csrf']],
    ['GET',  '/admin/content/projects',     'Admin/ContentController@projects',    ['admin']],
    ['POST', '/admin/content/projects',     'Admin/ContentController@storeProject',['admin', 'csrf']],
    ['GET',  '/admin/content/projects/{id}/edit', 'Admin/ContentController@editProject',   ['admin']],
    ['POST', '/admin/content/projects/{id}',      'Admin/ContentController@updateProject', ['admin', 'csrf']],
    ['POST', '/admin/content/projects/{id}/delete', 'Admin/ContentController@deleteProject', ['admin', 'csrf']],

    ['GET',  '/admin/content-import',  'Admin/ContentImportController@show',   ['admin']],
    ['POST', '/admin/content-import',  'Admin/ContentImportController@import', ['admin', 'csrf']],

    ['GET',  '/admin/contact-messages',      'Admin/ContactMessageController@index',        ['admin']],
    ['POST', '/admin/contact-messages/{id}', 'Admin/ContactMessageController@updateStatus',  ['admin', 'csrf']],

    ['GET',  '/admin/users', 'Admin/UserController@index', ['admin']],

    ['GET',  '/admin/audit-log', 'Admin/AuditLogController@index', ['admin']],
];
