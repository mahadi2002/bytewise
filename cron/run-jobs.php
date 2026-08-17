<?php
declare(strict_types=1);

/**
 * Single crontab entry for the whole app (rulebook §2):
 *   * * * * * php /home/USER/bytewise/cron/run-jobs.php >> /home/USER/bytewise/storage/logs/cron.log 2>&1
 *
 * Runs minute-granularity jobs unconditionally (none in v1 beyond what the
 * rulebook already assumes), then each daily-or-slower job guarded by
 * job_already_ran_today() so a second cron entry is never needed.
 */

if (PHP_SAPI !== 'cli') {
    http_response_code(404);
    exit;
}

define('APP_ROOT', dirname(__DIR__));
require APP_ROOT . '/app/bootstrap.php';
require APP_ROOT . '/cron/_lock.php';
require APP_ROOT . '/cron/_jobguard.php';

$lock = cron_lock();

$dailyJobs = [
    'subscription_grace_sweep' => APP_ROOT . '/cron/_jobs/subscription_grace_sweep.php',
    'daily_challenge_rotate'   => APP_ROOT . '/cron/_jobs/daily_challenge_rotate.php',
];

foreach ($dailyJobs as $name => $file) {
    if (!is_file($file)) {
        continue; // not built yet (added phase by phase)
    }
    if (job_already_ran_today($name)) {
        continue;
    }

    $jobId = job_start($name);
    try {
        require $file;
        job_finish($jobId, true);
        fwrite(STDOUT, "[$name] done\n");
    } catch (Throwable $e) {
        job_finish($jobId, false, $e->getMessage());
        \App\Core\Logger::exception($e, ['job' => $name]);
        fwrite(STDERR, "[$name] FAILED: " . $e->getMessage() . "\n");
    }
}

flock($lock, LOCK_UN);
fclose($lock);
