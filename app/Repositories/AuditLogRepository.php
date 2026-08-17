<?php
declare(strict_types=1);

namespace App\Repositories;

use App\Core\Db;

final class AuditLogRepository
{
    public function log(string $actorType, ?int $actorId, string $action, ?string $targetType, ?int $targetId, array $meta, ?string $ip): int
    {
        return Db::insert(
            'INSERT INTO audit_log (actor_type, actor_id, action, target_type, target_id, meta_json, ip_address)
             VALUES (?, ?, ?, ?, ?, ?, INET6_ATON(?))',
            [$actorType, $actorId, $action, $targetType, $targetId, json_encode($meta, JSON_UNESCAPED_UNICODE), $ip]
        );
    }

    public function recent(int $limit = 100): array
    {
        return Db::all('SELECT * FROM audit_log ORDER BY occurred_at DESC LIMIT ?', [$limit]);
    }
}
