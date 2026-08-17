<?php
declare(strict_types=1);

namespace App\Gateways;

final readonly class ExecutionTestResult
{
    public function __construct(
        public int $testCaseId,
        public bool $passed,
        /** Only meaningful for non-hidden cases — hidden-case output is never surfaced. */
        public ?string $actualStdoutExcerpt,
    ) {
    }
}
