<?php
declare(strict_types=1);

namespace App\Repositories;

use App\Core\Db;

final class SubmissionRepository
{
    public function find(int $id): ?array
    {
        return Db::first('SELECT * FROM submissions WHERE id = ?', [$id]);
    }

    /** Ownership-checked lookup — a submission is only ever visible to the student who made it. */
    public function findForUser(int $id, int $userId): ?array
    {
        return Db::first('SELECT * FROM submissions WHERE id = ? AND user_id = ?', [$id, $userId]);
    }

    public function create(int $userId, int $problemId, int $languageId, string $sourceCode, string $gatewaySubmissionRef): int
    {
        return Db::insert(
            "INSERT INTO submissions (user_id, problem_id, language_id, source_code, gateway_submission_ref, status)
             VALUES (?, ?, ?, ?, ?, 'queued')",
            [$userId, $problemId, $languageId, $sourceCode, $gatewaySubmissionRef]
        );
    }

    public function updateStatus(int $id, string $status, int $passedCount, int $totalCount, ?string $stderrExcerpt, int $xpAwarded): void
    {
        $completedAt = in_array($status, ['passed', 'failed', 'compile_error', 'runtime_error', 'time_limit_exceeded', 'memory_limit_exceeded', 'gateway_error'], true)
            ? 'NOW()' : 'NULL';

        Db::exec(
            "UPDATE submissions SET status = ?, passed_count = ?, total_count = ?, stderr_excerpt = ?, xp_awarded = ?, completed_at = {$completedAt} WHERE id = ?",
            [$status, $passedCount, $totalCount, $stderrExcerpt !== null ? substr($stderrExcerpt, 0, 2000) : null, $xpAwarded, $id]
        );
    }

    public function markCountedForDailyChallenge(int $id): void
    {
        Db::exec('UPDATE submissions SET counted_for_daily_challenge = 1 WHERE id = ?', [$id]);
    }

    public function hasPassedProblem(int $userId, int $problemId): bool
    {
        return Db::value(
            "SELECT COUNT(*) FROM submissions WHERE user_id = ? AND problem_id = ? AND status = 'passed'",
            [$userId, $problemId]
        ) > 0;
    }
}
