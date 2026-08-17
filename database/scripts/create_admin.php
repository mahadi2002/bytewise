<?php
declare(strict_types=1);

/**
 * Creates the first admin user (email + password + TOTP secret).
 *
 * Deliberately lives OUTSIDE database/seeds/ — migrate.php --seed
 * auto-requires every seeds/*.php file with no arguments, but this script
 * needs $argv[1]/$argv[2]; being auto-required would hit the "Usage:"
 * branch and exit(1) mid-seed, aborting migrate.php entirely even after
 * content.sql already applied successfully. Run this standalone instead:
 *
 *   php database/scripts/create_admin.php admin@bytewise.example "StrongPass123!"
 *
 * Idempotent on its own terms: skips if any admin_users row already
 * exists. Prints the TOTP secret + otpauth:// URI once — add it to an
 * authenticator app immediately, it is never shown again (only the
 * encrypted blob is stored).
 */

if (PHP_SAPI !== 'cli') {
    http_response_code(404);
    exit;
}

define('APP_ROOT', dirname(__DIR__, 2));
require APP_ROOT . '/app/bootstrap.php';

use App\Core\Crypto;
use App\Core\Db;
use App\Repositories\AdminUserRepository;
use App\Support\Totp;

$email    = $argv[1] ?? null;
$password = $argv[2] ?? null;

if ($email === null || $password === null) {
    fwrite(STDERR, "Usage: php database/seeds/001_admin.php <email> <password>\n");
    exit(1);
}

$existing = (int) Db::value('SELECT COUNT(*) FROM admin_users');
if ($existing > 0) {
    fwrite(STDOUT, "Skipped — admin_users already has {$existing} row(s). Use the admin CMS to add more (Phase 14).\n");
    exit(0);
}

$secret = Totp::generateSecret();
$id = (new AdminUserRepository())->create(
    strtolower($email),
    password_hash($password, PASSWORD_DEFAULT),
    Crypto::encrypt($secret),
    'admin'
);

fwrite(STDOUT, "Created admin_users.id={$id} ({$email})\n");
fwrite(STDOUT, "TOTP secret (add to an authenticator app now, shown only once): {$secret}\n");
fwrite(STDOUT, "otpauth URI: " . Totp::otpauthUri($secret, $email) . "\n");
