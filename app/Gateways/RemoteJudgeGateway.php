<?php
declare(strict_types=1);

namespace App\Gateways;

use App\Exceptions\GatewayException;

/**
 * Production driver — generic name per rulebook §3's vendor-neutrality rule
 * (never "Judge0Gateway"/"PistonGateway" even as a placeholder, since the
 * actual backend is a .env choice, not a build-time one). Fails loud
 * immediately while unconfigured. See TODO.md BLOCKER-2: self-hosted vs
 * third-party judge API is a cost/ops decision for the project owner, not
 * guessed at here — this stays a stub with a documented HTTP contract.
 */
final class RemoteJudgeGateway implements CodeExecutionGateway
{
    public function __construct()
    {
        if ((string) config('execution.remote_judge.base_url', '') === '') {
            throw new GatewayException(
                'RemoteJudgeGateway is not configured — REMOTE_JUDGE_BASE_URL is empty. '
                . 'Which service backs this (self-hosted Judge0/Piston vs. a paid third-party judge API) '
                . 'is an open hosting decision — see TODO.md BLOCKER-2.'
            );
        }
    }

    public function submit(
        string $languageCode,
        string $sourceCode,
        array $testCases,
        int $timeLimitMs,
        int $memoryLimitKb,
        ?SqlFixture $sqlFixture = null
    ): ExecutionSubmitResult {
        throw new GatewayException('RemoteJudgeGateway::submit is a stub — BLOCKER-2 must be resolved first.');
    }

    public function checkStatus(string $externalSubmissionRef): ExecutionStatusResult
    {
        throw new GatewayException('RemoteJudgeGateway::checkStatus is a stub — BLOCKER-2 must be resolved first.');
    }
}
