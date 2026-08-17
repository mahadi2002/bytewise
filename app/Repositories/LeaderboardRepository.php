<?php
declare(strict_types=1);

namespace App\Repositories;

use App\Core\Db;

final class LeaderboardRepository
{
    public function top(int $limit = 20): array
    {
        return Db::all(
            'SELECT u.id, u.display_name, COALESCE(SUM(x.xp_amount), 0) AS total_xp
             FROM users u JOIN xp_ledger x ON x.user_id = u.id
             WHERE u.status = "active"
             GROUP BY u.id, u.display_name
             ORDER BY total_xp DESC
             LIMIT ?',
            [$limit]
        );
    }
}
