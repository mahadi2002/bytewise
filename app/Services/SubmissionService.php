<?php
declare(strict_types=1);

namespace App\Services;

use App\Exceptions\HttpException;
use App\Gateways\GatewayFactory;
use App\Repositories\ProblemRepository;
use App\Repositories\SubmissionRepository;
use App\Repositories\SubmissionTestResultRepository;
use App\Repositories\TestCaseRepository;

final class SubmissionService
{
    private const TERMINAL_STATUSES = [
        'passed', 'failed', 'compile_error', 'runtime_error',
        'time_limit_exceeded', 'memory_limit_exceeded', 'gateway_error',
    ];

    /**
     * Creates a submission and hands it to the gateway. $languageId is
     * validated against the problem's own language_id BEFORE this is ever
     * called (server-side, in the controller) for language-locked problems
     * — see BUILD-SPEC §9 / the anti-drift checklist item on this exact
     * point. This method assumes that validation already passed.
     */
    public static function submit(int $userId, array $problem, int $languageId, string $languageCode, string $sourceCode): int
    {
        $testCases = (new TestCaseRepository())->asGatewayTestCases((int) $problem['id']);

        // SQL fixture DDL/DML lives in the problem's own statement_md by
        // convention for this v1 build (see 02-SCHEMA-SEED.sql's note) — a
        // dedicated sql_fixture column is a documented future improvement,
        // not built here since only one SQL problem exists. Passing null
        // (not an empty-string SqlFixture) until that column exists, since
        // an empty fixture isn't a real fixture.
        $result = GatewayFactory::execution()->submit(
            $languageCode,
            $sourceCode,
            $testCases,
            (int) $problem['time_limit_ms'],
            (int) $problem['memory_limit_kb'],
            null
        );

        return (new SubmissionRepository())->create($userId, (int) $problem['id'], $languageId, $sourceCode, $result->externalSubmissionRef);
    }

    /** Polled by GET /submissions/{id} — pulls the latest gateway status and finalizes once. */
    public static function refreshStatus(array $submission): array
    {
        if (in_array($submission['status'], self::TERMINAL_STATUSES, true)) {
            return $submission; // already finalized, never re-finalize (idempotent XP award)
        }

        $live = GatewayFactory::execution()->checkStatus((string) $submission['gateway_submission_ref']);

        $repo = new SubmissionRepository();

        if ($live->status === 'queued' || $live->status === 'running') {
            $repo->updateStatus((int) $submission['id'], $live->status, 0, $live->totalCount, null, 0);
            return $repo->find((int) $submission['id']);
        }

        $xpAwarded = 0;
        if ($live->status === 'passed') {
            // Keyed by problem_id, NOT submission id — a student resubmitting
            // an already-passed problem must never farm XP again. XpService's
            // alreadyAwarded() check is what makes this idempotent per
            // problem per user, same pattern as the quiz's per-lesson award.
            $problem   = (new ProblemRepository())->find((int) $submission['problem_id']);
            $xpAwarded = XpService::award((int) $submission['user_id'], 'problem', (int) $submission['problem_id'], (int) ($problem['xp_reward'] ?? 0));
        }

        $repo->updateStatus((int) $submission['id'], $live->status, $live->passedCount, $live->totalCount, $live->stderrExcerpt, $xpAwarded);
        (new SubmissionTestResultRepository())->saveAll((int) $submission['id'], $live->testResults);

        return $repo->find((int) $submission['id']);
    }

    /**
     * Server-side language validation for a language-locked problem —
     * never trust submissions.language_id from the client alone. Throws a
     * 422-equivalent HttpException if the client tries to submit a
     * mismatched language for a locked problem.
     */
    public static function assertLanguageAllowed(array $problem, int $submittedLanguageId): void
    {
        if ($problem['language_id'] !== null && (int) $problem['language_id'] !== $submittedLanguageId) {
            throw new HttpException(422, 'এই প্রবলেমের জন্য নির্দিষ্ট ভাষা ব্যবহার করতে হবে।');
        }
    }
}
