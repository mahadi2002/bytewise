<?php
declare(strict_types=1);

namespace App\Repositories;

use App\Core\Db;

final class PasswordResetRepository
{
    public function create(int $userId, string $tokenHash, int $ttlSeconds): int
    {
        return Db::insert(
            'INSERT INTO password_resets (user_id, token_hash, expires_at) VALUES (?, ?, DATE_ADD(NOW(), INTERVAL ? SECOND))',
            [$userId, $tokenHash, $ttlSeconds]
        );
    }

    /** Only a live (unconsumed, unexpired) row — never returns a spent or stale token. */
    public function findValidByTokenHash(string $tokenHash): ?array
    {
        return Db::first(
            'SELECT * FROM password_resets WHERE token_hash = ? AND consumed_at IS NULL AND expires_at > NOW()',
            [$tokenHash]
        );
    }

    public function markConsumed(int $id): void
    {
        Db::exec('UPDATE password_resets SET consumed_at = NOW() WHERE id = ?', [$id]);
    }

    /** Invalidate any earlier outstanding reset request once a new one is issued or used. */
    public function invalidatePendingForUser(int $userId): void
    {
        Db::exec('UPDATE password_resets SET consumed_at = NOW() WHERE user_id = ? AND consumed_at IS NULL', [$userId]);
    }
}
