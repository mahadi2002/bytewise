<?php
declare(strict_types=1);

namespace App\Gateways;

/**
 * Dev/test-only. NEVER actually compiles or executes the submitted source
 * on the app server, even in mock mode — doing so would defeat the entire
 * point of the sandboxing requirement and turn "mock mode" into a real
 * vulnerability if APP_ENV is ever misconfigured (03-ENV-AND-CONFIG.md §5).
 *
 * Since it genuinely cannot run the code, it can't judge real correctness.
 * Outcome is controllable via a fixture marker in the source, the same
 * pattern MockSubscriptionGateway's sibling apps use (a mobile-number
 * suffix convention) to get deterministic, testable behavior without a
 * real backend: a line containing exactly `// MOCK: fail` (or the
 * language's line-comment equivalent — `#`/`--`) anywhere in the source
 * fails every test case; anything else passes every test case. State is
 * persisted to storage/mock_executions/<ref>.json so a later checkStatus()
 * request (a separate PHP process under php -S) can read back what submit()
 * decided, and a short simulated delay makes the first poll or two show
 * 'running' before resolving, mirroring real async judge UX.
 */
final class MockExecutionGateway implements CodeExecutionGateway
{
    private const SIMULATED_DELAY_SECONDS = 2;

    public function submit(
        string $languageCode,
        string $sourceCode,
        array $testCases,
        int $timeLimitMs,
        int $memoryLimitKb,
        ?SqlFixture $sqlFixture = null
    ): ExecutionSubmitResult {
        $ref = 'MOCKEXEC-' . bin2hex(random_bytes(8));

        $forcedFail = (bool) preg_match('/(?:\/\/|#|--)\s*MOCK:\s*fail/i', $sourceCode);

        $results = [];
        foreach ($testCases as $tc) {
            $results[] = [
                'test_case_id' => $tc->id,
                'passed'       => !$forcedFail,
                'actual_stdout_excerpt' => $tc->isHidden
                    ? null
                    : ($forcedFail ? '(mock: no output — forced failure)' : $tc->expectedStdout),
            ];
        }

        $passedCount = $forcedFail ? 0 : count($testCases);

        $this->writeState($ref, [
            'status'        => $forcedFail ? 'failed' : 'passed',
            'passed_count'  => $passedCount,
            'total_count'   => count($testCases),
            'stderr_excerpt' => $forcedFail ? 'MockExecutionGateway: forced failure via `// MOCK: fail` marker.' : null,
            'test_results'  => $results,
            'ready_at'      => time() + self::SIMULATED_DELAY_SECONDS,
        ]);

        return new ExecutionSubmitResult(externalSubmissionRef: $ref);
    }

    public function checkStatus(string $externalSubmissionRef): ExecutionStatusResult
    {
        $state = $this->readState($externalSubmissionRef);
        if ($state === null) {
            return new ExecutionStatusResult('gateway_error', 0, 0, 'Unknown submission reference.', []);
        }

        if (time() < (int) $state['ready_at']) {
            return new ExecutionStatusResult('running', 0, (int) $state['total_count'], null, []);
        }

        $testResults = array_map(
            static fn(array $r): ExecutionTestResult => new ExecutionTestResult(
                (int) $r['test_case_id'],
                (bool) $r['passed'],
                $r['actual_stdout_excerpt']
            ),
            $state['test_results']
        );

        return new ExecutionStatusResult(
            (string) $state['status'],
            (int) $state['passed_count'],
            (int) $state['total_count'],
            $state['stderr_excerpt'],
            $testResults
        );
    }

    private function stateDir(): string
    {
        $dir = APP_ROOT . '/storage/mock_executions';
        if (!is_dir($dir)) {
            @mkdir($dir, 0750, true);
        }
        return $dir;
    }

    private function writeState(string $ref, array $state): void
    {
        file_put_contents($this->stateDir() . '/' . $ref . '.json', json_encode($state));
    }

    private function readState(string $ref): ?array
    {
        $file = $this->stateDir() . '/' . basename($ref) . '.json';
        if (!is_file($file)) {
            return null;
        }
        $decoded = json_decode((string) file_get_contents($file), true);
        return is_array($decoded) ? $decoded : null;
    }
}
