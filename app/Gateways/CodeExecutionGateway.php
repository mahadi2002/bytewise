<?php
declare(strict_types=1);

namespace App\Gateways;

/** Per 03-ENV-AND-CONFIG.md §5 — locked contract, do not change signatures. */
interface CodeExecutionGateway
{
    /**
     * @param string $languageCode languages.judge_language_code for the
     *                              language actually selected for this
     *                              submission — NOT necessarily
     *                              problems.language_id (see BUILD-SPEC §9).
     * @param TestCase[] $testCases hidden cases are sent the same as
     *                              visible ones — hiding is presentation-
     *                              layer only, the gateway grades all.
     * @param SqlFixture|null $sqlFixture ONLY set when $languageCode === 'sql'.
     */
    public function submit(
        string $languageCode,
        string $sourceCode,
        array $testCases,
        int $timeLimitMs,
        int $memoryLimitKb,
        ?SqlFixture $sqlFixture = null
    ): ExecutionSubmitResult;

    public function checkStatus(string $externalSubmissionRef): ExecutionStatusResult;
}
