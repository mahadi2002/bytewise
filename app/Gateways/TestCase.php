<?php
declare(strict_types=1);

namespace App\Gateways;

/** One test_cases row, passed through to CodeExecutionGateway::submit(). */
final readonly class TestCase
{
    public function __construct(
        public int $id,
        public ?string $stdin,
        public string $expectedStdout,
        public bool $isHidden,
    ) {
    }
}
