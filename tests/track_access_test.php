<?php
declare(strict_types=1);

/**
 * Verifies TrackAccessService's current rule: every track is open to any
 * logged-in user, no prerequisites (product decision reversed the earlier
 * hard-gated chain — see FEATURES.md "Learning path & track gating").
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

$langC   = (int) Db::value("SELECT id FROM languages WHERE slug = 'c'");
$langCpp = (int) Db::value("SELECT id FROM languages WHERE slug = 'cpp'");
$langJava = (int) Db::value("SELECT id FROM languages WHERE slug = 'java'");
$langDs  = (int) Db::value("SELECT id FROM languages WHERE slug = 'data-structures'");

// Fresh user with zero progress anywhere.
$freshUserId = (int) Db::insert(
    "INSERT INTO users (mobile_encrypted, mobile_hash, operator, status) VALUES (?, ?, 'robi', 'active')",
    ['test-blob-' . uniqid(), 'test-hash-' . uniqid()]
);

check('C unlocked for a brand-new user', TrackAccessService::isUnlocked($langC, $freshUserId), true, $failures);
check('C++ unlocked for a brand-new user (no prerequisite)', TrackAccessService::isUnlocked($langCpp, $freshUserId), true, $failures);
check('Java unlocked for a brand-new user (no prerequisite)', TrackAccessService::isUnlocked($langJava, $freshUserId), true, $failures);
check('Data Structures unlocked for a brand-new user (no prerequisite)', TrackAccessService::isUnlocked($langDs, $freshUserId), true, $failures);
check('Visitor (null user) sees everything locked', TrackAccessService::isUnlocked($langC, null), false, $failures);

$unknownLanguageId = (int) Db::value('SELECT COALESCE(MAX(id), 0) + 1000 FROM languages');
check('Unknown language id is locked', TrackAccessService::isUnlocked($unknownLanguageId, $freshUserId), false, $failures);

// Cleanup.
Db::exec('DELETE FROM users WHERE id = ?', [$freshUserId]);

if ($failures !== []) {
    fwrite(STDERR, "\nFAILED: " . implode(', ', $failures) . "\n");
    exit(1);
}
fwrite(STDOUT, "\nAll TrackAccessService checks passed.\n");
exit(0);
