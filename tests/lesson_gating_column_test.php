<?php
declare(strict_types=1);

/**
 * Concrete verification for 04-AI-BUILD-PLAYBOOK.md Phase 6 acceptance
 * criterion (b): lessons.body_md is ABSENT from the SQL result set (not
 * merely hidden in the view) for a gated lesson requested by a
 * non-subscriber. Inspects the actual returned array's keys.
 *
 *   php tests/lesson_gating_column_test.php
 */

define('APP_ROOT', dirname(__DIR__));
require APP_ROOT . '/app/bootstrap.php';

use App\Core\Db;
use App\Repositories\LessonRepository;

$repo = new LessonRepository();

$gatedLessonId = (int) Db::value(
    "SELECT id FROM lessons WHERE is_free_preview = 0 AND slug = 'input-output'"
);
if ($gatedLessonId === 0) {
    fwrite(STDERR, "ABORT: fixture lesson 'input-output' not found — run migrate.php --seed first.\n");
    exit(2);
}

// Non-subscriber requesting a gated (non-free-preview) lesson.
$row = $repo->findForViewer($gatedLessonId, isSubscriber: false);

$failures = [];
if ($row === null) {
    $failures[] = 'row unexpectedly null';
}
if (array_key_exists('body_md', $row ?? [])) {
    $failures[] = 'body_md key IS present in the result set for a non-subscriber — SQL-level gating failed';
}
if (array_key_exists('code_sample', $row ?? [])) {
    $failures[] = 'code_sample key IS present in the result set for a non-subscriber';
}

if ($failures !== []) {
    fwrite(STDERR, "FAILED:\n - " . implode("\n - ", $failures) . "\n");
    exit(1);
}

fwrite(STDOUT, "OK: non-subscriber SELECT for a gated lesson returns keys [" . implode(', ', array_keys($row)) . "] — no body_md/code_sample.\n");

// Sanity check the opposite: a subscriber's SELECT DOES include them.
$rowSub = $repo->findForViewer($gatedLessonId, isSubscriber: true);
if (!array_key_exists('body_md', $rowSub ?? [])) {
    fwrite(STDERR, "FAILED: subscriber SELECT is missing body_md — over-gating.\n");
    exit(1);
}

fwrite(STDOUT, "OK: subscriber SELECT for the same lesson includes body_md (" . strlen((string) $rowSub['body_md']) . " chars).\n");
exit(0);
