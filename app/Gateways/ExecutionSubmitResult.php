<?php
declare(strict_types=1);

namespace App\Gateways;

/** Returned immediately — grading is async, the caller polls checkStatus(). */
final readonly class ExecutionSubmitResult
{
    public function __construct(
        public string $externalSubmissionRef,
    ) {
    }
}
