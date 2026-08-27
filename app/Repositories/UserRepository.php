<?php
declare(strict_types=1);

namespace App\Repositories;

use App\Core\Db;

final class UserRepository
{
    public function find(int $id): ?array
    {
        return Db::first('SELECT * FROM users WHERE id = ?', [$id]);
    }

    public function findByEmail(string $email): ?array
    {
        return Db::first('SELECT * FROM users WHERE email = ?', [$email]);
    }

    public function emailExists(string $email): bool
    {
        return Db::value('SELECT 1 FROM users WHERE email = ?', [$email]) !== null;
    }

    public function create(string $email, string $passwordHash): int
    {
        return Db::insert(
            'INSERT INTO users (email, password_hash, status) VALUES (?, ?, ?)',
            [$email, $passwordHash, 'active']
        );
    }

    public function updatePassword(int $userId, string $passwordHash): void
    {
        Db::exec('UPDATE users SET password_hash = ? WHERE id = ?', [$passwordHash, $userId]);
    }

    public function touchLastSeen(int $userId): void
    {
        Db::exec('UPDATE users SET last_seen_at = NOW() WHERE id = ?', [$userId]);
    }

    /** Admin list view. */
    public function all(): array
    {
        return Db::all('SELECT id, email, display_name, status, created_at, last_seen_at FROM users ORDER BY created_at DESC');
    }
}
