<?php
declare(strict_types=1);

namespace App\Repositories;

use App\Core\Crypto;
use App\Core\Db;

final class UserRepository
{
    public function find(int $id): ?array
    {
        return Db::first('SELECT * FROM users WHERE id = ?', [$id]);
    }

    public function findByMobile(string $mobile): ?array
    {
        return Db::first('SELECT * FROM users WHERE mobile_hash = ?', [Crypto::blindIndex($mobile)]);
    }

    public function create(string $mobile, string $operator): int
    {
        return Db::insert(
            'INSERT INTO users (mobile_encrypted, mobile_hash, operator, status) VALUES (?, ?, ?, ?)',
            [Crypto::encrypt($mobile), Crypto::blindIndex($mobile), $operator, 'active']
        );
    }

    public function touchLastSeen(int $userId): void
    {
        Db::exec('UPDATE users SET last_seen_at = NOW() WHERE id = ?', [$userId]);
    }

    /** Decrypted mobile number — call sites must be audit-logged (admin PII reveal, Phase 14). */
    public function decryptedMobile(array $user): ?string
    {
        return Crypto::decrypt((string) $user['mobile_encrypted']);
    }

    /** Admin list view — never decrypts mobile_encrypted here; reveal is a separate, audit-logged action. */
    public function all(): array
    {
        return Db::all('SELECT id, operator, display_name, status, created_at, last_seen_at FROM users ORDER BY created_at DESC');
    }
}
