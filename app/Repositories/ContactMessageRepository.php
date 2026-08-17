<?php
declare(strict_types=1);

namespace App\Repositories;

use App\Core\Db;

/** Genuinely table-backed (rulebook naming-honesty rule) — never a log file. */
final class ContactMessageRepository
{
    public function create(?int $userId, string $name, string $emailOrMobile, string $message): int
    {
        return Db::insert(
            "INSERT INTO contact_messages (user_id, name, email_or_mobile, message, status) VALUES (?, ?, ?, ?, 'new')",
            [$userId, $name, $emailOrMobile, $message]
        );
    }

    public function all(): array
    {
        return Db::all('SELECT * FROM contact_messages ORDER BY FIELD(status, "new", "read", "resolved"), created_at DESC');
    }

    public function find(int $id): ?array
    {
        return Db::first('SELECT * FROM contact_messages WHERE id = ?', [$id]);
    }

    public function setStatus(int $id, string $status): void
    {
        $resolvedAt = $status === 'resolved' ? 'NOW()' : 'NULL';
        Db::exec("UPDATE contact_messages SET status = ?, resolved_at = {$resolvedAt} WHERE id = ?", [$status, $id]);
    }
}
