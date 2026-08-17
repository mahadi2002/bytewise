<?php
declare(strict_types=1);

/**
 * Concrete verification for 03-ENV-AND-CONFIG.md §7: attempt a DDL statement
 * through the app's own runtime DB connection (bytewise_app, config('db'))
 * and confirm MySQL denies it. Run after every schema change.
 *
 *   php tests/ddl_denial_probe.php
 */

define('APP_ROOT', dirname(__DIR__));
require APP_ROOT . '/app/bootstrap.php';

use App\Core\Db;

try {
    Db::pdo()->exec('CREATE TABLE _privilege_probe (id INT)');
    fwrite(STDERR, "SECURITY FAILURE: runtime DB user (bytewise_app) can run DDL — privilege setup failed.\n");
    exit(1);
} catch (PDOException $e) {
    fwrite(STDOUT, "OK: DDL denied as expected — " . $e->getMessage() . "\n");
    exit(0);
}
