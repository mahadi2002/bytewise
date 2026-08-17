<?php
declare(strict_types=1);

namespace App\Gateways;

/**
 * Only set when the submission's language is 'sql'. setup_sql is
 * admin-authored, trusted DDL/DML (never student input) — see
 * 03-ENV-AND-CONFIG.md §5. The judge loads it into a disposable database
 * before running the student's query, never Bytewise's own MySQL.
 */
final readonly class SqlFixture
{
    public function __construct(
        public string $setupSql,
        public ?string $queryColumnName,
    ) {
    }
}
