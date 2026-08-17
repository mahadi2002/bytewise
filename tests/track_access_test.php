<?php
declare(strict_types=1);

/**
 * Verifies TrackAccessService's two rule shapes against real DB state.
 *
 *   php tests/track_access_test.php
 */

define('APP_ROOT', dirname(__DIR__));
require APP_ROOT . '/app/bootstrap.php';

use App\Core\Db;
use App\Services\TrackAccessService;

$failures = [];

function check(string $label, bool $actual, bool $expected, array &$failures): void
{
    $ok = $actual === $expected;
    fwrite(STDOUT, ($ok ? 'OK  ' : 'FAIL') . " {$label} (expected " . var_export($expected, true) . ', got ' . var_export($actual, true) . ")\n");
    if (!$ok) {
        $failures[] = $label;
    }
}

$langC    = (int) Db::value("SELECT id FROM languages WHERE slug = 'c'");
$langCpp  = (int) Db::value("SELECT id FROM languages WHERE slug = 'cpp'");
$langDs   = (int) Db::value("SELECT id FROM languages WHERE slug = 'data-structures'");

// Fresh user with zero progress anywhere.
$freshUserId = (int) Db::insert(
    "INSERT INTO users (mobile_encrypted, mobile_hash, operator, status) VALUES (?, ?, 'robi', 'active')",
    ['test-blob-' . uniqid(), 'test-hash-' . uniqid()]
);

check('C unlocked for a brand-new user (no prerequisite)', TrackAccessService::isUnlocked($langC, $freshUserId), true, $failures);
check('C++ LOCKED for a brand-new user (C not complete)', TrackAccessService::isUnlocked($langCpp, $freshUserId), false, $failures);
check('Data Structures LOCKED for a brand-new user (no language complete)', TrackAccessService::isUnlocked($langDs, $freshUserId), false, $failures);
check('Visitor (null user) sees everything locked', TrackAccessService::isUnlocked($langC, null), false, $failures);

// Complete every C lesson for this user, then re-check.
$cLessonIds = Db::all(
    'SELECT l.id FROM lessons l JOIN modules m ON m.id = l.module_id WHERE m.language_id = ?',
    [$langC]
);
foreach ($cLessonIds as $row) {
    Db::exec(
        "INSERT INTO user_lesson_progress (user_id, lesson_id, status, completed_at) VALUES (?, ?, 'completed', NOW())",
        [$freshUserId, $row['id']]
    );
}

check('C++ UNLOCKED once C is 100% complete', TrackAccessService::isUnlocked($langCpp, $freshUserId), true, $failures);
check('Data Structures UNLOCKED once at least one language is 100% complete', TrackAccessService::isUnlocked($langDs, $freshUserId), true, $failures);

$reason = TrackAccessService::check((int) Db::value("SELECT id FROM languages WHERE slug = 'java'"), $freshUserId);
check('Java still locked (needs C++, not just C)', $reason['unlocked'], false, $failures);
fwrite(STDOUT, 'Java lock reason: ' . json_encode($reason['reason']) . "\n");

// Cleanup.
Db::exec('DELETE FROM user_lesson_progress WHERE user_id = ?', [$freshUserId]);
Db::exec('DELETE FROM users WHERE id = ?', [$freshUserId]);

if ($failures !== []) {
    fwrite(STDERR, "\nFAILED: " . implode(', ', $failures) . "\n");
    exit(1);
}
fwrite(STDOUT, "\nAll TrackAccessService checks passed.\n");
exit(0);
