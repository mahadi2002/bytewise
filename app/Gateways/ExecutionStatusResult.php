<?php
declare(strict_types=1);

namespace App\Gateways;

final readonly class ExecutionStatusResult
{
    /** @param ExecutionTestResult[] $testResults */
    public function __construct(
        public string $status, // queued|running|passed|failed|compile_error|runtime_error|time_limit_exceeded|memory_limit_exceeded|gateway_error
        public int $passedCount,
        public int $totalCount,
        public ?string $stderrExcerpt,
        public array $testResults,
    ) {
    }
}
