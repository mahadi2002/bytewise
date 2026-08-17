<?php
declare(strict_types=1);

namespace App\Repositories;

use App\Core\Db;

final class AdminUserRepository
{
    public function findByEmail(string $email): ?array
    {
        return Db::first('SELECT * FROM admin_users WHERE email = ?', [$email]);
    }

    public function find(int $id): ?array
    {
        return Db::first('SELECT * FROM admin_users WHERE id = ?', [$id]);
    }

    public function touchLastLogin(int $id): void
    {
        Db::exec('UPDATE admin_users SET last_login_at = NOW() WHERE id = ?', [$id]);
    }

    public function create(string $email, string $passwordHash, string $totpSecretEncrypted, string $role = 'admin'): int
    {
        return Db::insert(
            'INSERT INTO admin_users (email, password_hash, totp_secret_encrypted, role, status) VALUES (?, ?, ?, ?, ?)',
            [$email, $passwordHash, $totpSecretEncrypted, $role, 'active']
        );
    }
}
