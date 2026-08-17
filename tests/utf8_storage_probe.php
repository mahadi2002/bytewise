<?php
declare(strict_types=1);

/**
 * Diagnostic: confirms Bangla text written directly in a PHP source file
 * (a path that never goes through the bash/curl terminal pipeline) is
 * stored and read back correctly via Db — isolates whether a prior mangled
 * insert was an application bug or a terminal/shell encoding artifact.
 */

define('APP_ROOT', dirname(__DIR__));
require APP_ROOT . '/app/bootstrap.php';

use App\Core\Db;

$original = 'এই লেসনটা খুব ভালো লাগলো! (utf8 probe)';

$id = Db::insert(
    'INSERT INTO discussion_posts (user_id, context_type, context_id, body_md) VALUES (?, ?, ?, ?)',
    [2, 'lesson', 1, $original]
);

$row = Db::first('SELECT body_md FROM discussion_posts WHERE id = ?', [$id]);

if ($row['body_md'] === $original) {
    fwrite(STDOUT, "OK: round-tripped correctly. Bytes match.\n");
    exit(0);
}

fwrite(STDERR, "MISMATCH:\n original: " . bin2hex($original) . "\n stored:   " . bin2hex((string) $row['body_md']) . "\n");
exit(1);
