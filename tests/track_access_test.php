<?php
declare(strict_types=1);

/**
 * Verifies TrackAccessService's current rule: every track is open to any
 * logged-in user, no prerequisites (product decision reversed the earlier
 * hard-gated chain — see FEATURES.md "Learning path & track gating"). The
 * service no longer takes a language id at all — unlocked is purely a
 * function of whether a user is logged in.
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

// Fresh user with zero progress anywhere.
$freshUserId = (int) Db::insert(
    "INSERT INTO users (mobile_encrypted, mobile_hash, operator, status) VALUES (?, ?, 'robi', 'active')",
    ['test-blob-' . uniqid(), 'test-hash-' . uniqid()]
);

check('Every track unlocked for a brand-new user (no prerequisite)', TrackAccessService::isUnlocked($freshUserId), true, $failures);
check('Visitor (null user) sees everything locked', TrackAccessService::isUnlocked(null), false, $failures);

// Cleanup.
Db::exec('DELETE FROM users WHERE id = ?', [$freshUserId]);

if ($failures !== []) {
    fwrite(STDERR, "\nFAILED: " . implode(', ', $failures) . "\n");
    exit(1);
}
fwrite(STDOUT, "\nAll TrackAccessService checks passed.\n");
exit(0);
