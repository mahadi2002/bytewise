<?php
declare(strict_types=1);

namespace App\Repositories;

use App\Core\Db;

/** Append-only — a user's total is always SUM(xp_amount), never a mutable counter (02-SCHEMA.sql). */
final class XpLedgerRepository
{
    public function add(int $userId, string $sourceType, ?int $sourceId, int $amount): int
    {
        return Db::insert(
            'INSERT INTO xp_ledger (user_id, source_type, source_id, xp_amount) VALUES (?, ?, ?, ?)',
            [$userId, $sourceType, $sourceId, $amount]
        );
    }

    public function total(int $userId): int
    {
        return (int) Db::value('SELECT COALESCE(SUM(xp_amount), 0) FROM xp_ledger WHERE user_id = ?', [$userId]);
    }

    /** Guards against double-award on a source that should only ever pay out once (e.g. one lesson). */
    public function alreadyAwarded(int $userId, string $sourceType, int $sourceId): bool
    {
        return Db::value(
            'SELECT COUNT(*) FROM xp_ledger WHERE user_id = ? AND source_type = ? AND source_id = ?',
            [$userId, $sourceType, $sourceId]
        ) > 0;
    }
}
