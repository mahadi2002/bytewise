<?php
declare(strict_types=1);

namespace App\Repositories;

use App\Core\Db;

final class UserStreakRepository
{
    public function find(int $userId): ?array
    {
        return Db::first('SELECT * FROM user_streaks WHERE user_id = ?', [$userId]);
    }

    public function upsert(int $userId, int $currentDays, int $longestDays, string $lastActivityDate): void
    {
        Db::exec(
            'INSERT INTO user_streaks (user_id, current_streak_days, longest_streak_days, last_activity_date)
             VALUES (?, ?, ?, ?)
             ON DUPLICATE KEY UPDATE
                current_streak_days = VALUES(current_streak_days),
                longest_streak_days = VALUES(longest_streak_days),
                last_activity_date = VALUES(last_activity_date)',
            [$userId, $currentDays, $longestDays, $lastActivityDate]
        );
    }
}
