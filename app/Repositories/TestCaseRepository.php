<?php
declare(strict_types=1);

namespace App\Repositories;

use App\Core\Db;
use App\Gateways\TestCase as GatewayTestCase;

final class TestCaseRepository
{
    public function forProblem(int $problemId): array
    {
        return Db::all('SELECT * FROM test_cases WHERE problem_id = ? ORDER BY sort_order ASC', [$problemId]);
    }

    /** @return GatewayTestCase[] */
    public function asGatewayTestCases(int $problemId): array
    {
        return array_map(
            static fn(array $row): GatewayTestCase => new GatewayTestCase(
                (int) $row['id'],
                $row['stdin'],
                (string) $row['expected_stdout'],
                (bool) $row['is_hidden']
            ),
            $this->forProblem($problemId)
        );
    }
}
