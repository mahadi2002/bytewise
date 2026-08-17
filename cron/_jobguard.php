<?php
declare(strict_types=1);

/**
 * Daily-or-slower job guard backed by the `jobs` table (UNIQUE(job_name,
 * run_date)) — lets every granularity of job share the single crontab line
 * without a second cron entry (rulebook §2).
 */

use App\Core\Db;

function job_already_ran_today(string $jobName): bool
{
    return Db::value(
        "SELECT COUNT(*) FROM jobs WHERE job_name = ? AND run_date = CURDATE() AND status = 'done'",
        [$jobName]
    ) > 0;
}

function job_start(string $jobName): int
{
    return Db::insert(
        "INSERT INTO jobs (job_name, run_date, status) VALUES (?, CURDATE(), 'running')",
        [$jobName]
    );
}

function job_finish(int $jobId, bool $success, ?string $error = null): void
{
    Db::exec(
        'UPDATE jobs SET status = ?, finished_at = NOW(), error_message = ? WHERE id = ?',
        [$success ? 'done' : 'failed', $error, $jobId]
    );
}
