<?php
declare(strict_types=1);

namespace App\Repositories;

use App\Core\Db;
use PDOException;

/** Append-only — a user's total is always SUM(xp_amount), never a mutable counter (02-SCHEMA.sql). */
final class XpLedgerRepository
{
    /**
     * Idempotent per (user, source_type, source_id) — relies on migration
     * 011's UNIQUE(user_id, source_type, source_id) to close the race a
     * check-then-insert can't: two concurrent calls for the same source
     * both attempt the insert, but only one can win the constraint.
     * Returns true if this call performed the award, false if it had
     * already been awarded (by this call or a concurrent one).
     */
    public function addOnce(int $userId, string $sourceType, ?int $sourceId, int $amount): bool
    {
        try {
            Db::insert(
                'INSERT INTO xp_ledger (user_id, source_type, source_id, xp_amount) VALUES (?, ?, ?, ?)',
                [$userId, $sourceType, $sourceId, $amount]
            );
            return true;
        } catch (PDOException $e) {
            if ($e->getCode() === '23000') {
                return false;
            }
            throw $e;
        }
    }

    public function total(int $userId): int
    {
        return (int) Db::value('SELECT COALESCE(SUM(xp_amount), 0) FROM xp_ledger WHERE user_id = ?', [$userId]);
    }
}
