<?php
declare(strict_types=1);

/**
 * Whole-run flock lock so overlapping cron invocations (e.g. a slow run
 * still executing when the next minute fires) never run concurrently.
 */

function cron_lock(): mixed
{
    $lockFile = APP_ROOT . '/storage/logs/.cron.lock';
    $handle   = fopen($lockFile, 'c');

    if ($handle === false || !flock($handle, LOCK_EX | LOCK_NB)) {
        fwrite(STDERR, "Another run-jobs.php instance holds the lock — exiting.\n");
        exit(0);
    }

    return $handle;
}
