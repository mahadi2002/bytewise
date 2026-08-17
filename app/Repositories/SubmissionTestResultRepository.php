<?php
declare(strict_types=1);

namespace App\Repositories;

use App\Core\Db;
use App\Gateways\ExecutionTestResult;

final class SubmissionTestResultRepository
{
    /** @param ExecutionTestResult[] $results */
    public function saveAll(int $submissionId, array $results): void
    {
        foreach ($results as $r) {
            Db::exec(
                'INSERT INTO submission_test_results (submission_id, test_case_id, passed, actual_stdout_excerpt) VALUES (?, ?, ?, ?)',
                [$submissionId, $r->testCaseId, $r->passed ? 1 : 0, $r->actualStdoutExcerpt]
            );
        }
    }

    /** Never includes hidden-case output — only pass/fail, per BUILD-SPEC §9. */
    public function forSubmissionPublic(int $submissionId): array
    {
        return Db::all(
            'SELECT str.test_case_id, str.passed,
                    IF(tc.is_hidden = 1, NULL, str.actual_stdout_excerpt) AS actual_stdout_excerpt,
                    tc.is_hidden
             FROM submission_test_results str
             JOIN test_cases tc ON tc.id = str.test_case_id
             WHERE str.submission_id = ?
             ORDER BY tc.sort_order ASC',
            [$submissionId]
        );
    }
}
