<?php
declare(strict_types=1);

namespace App\Repositories;

use App\Core\Db;

final class DiscussionPostRepository
{
    public function forContext(string $contextType, int $contextId): array
    {
        return Db::all(
            "SELECT dp.*, u.display_name
             FROM discussion_posts dp JOIN users u ON u.id = dp.user_id
             WHERE dp.context_type = ? AND dp.context_id = ? AND dp.is_hidden_by_admin = 0
             ORDER BY dp.is_pinned DESC, dp.created_at ASC",
            [$contextType, $contextId]
        );
    }

    public function create(int $userId, string $contextType, int $contextId, ?int $parentPostId, string $bodyMd): int
    {
        return Db::insert(
            'INSERT INTO discussion_posts (user_id, context_type, context_id, parent_post_id, body_md) VALUES (?, ?, ?, ?, ?)',
            [$userId, $contextType, $contextId, $parentPostId, $bodyMd]
        );
    }

    public function setHidden(int $id, bool $hidden): void
    {
        Db::exec('UPDATE discussion_posts SET is_hidden_by_admin = ? WHERE id = ?', [$hidden ? 1 : 0, $id]);
    }
}
