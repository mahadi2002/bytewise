<?php
declare(strict_types=1);

namespace App\Services;

use App\Repositories\UserStreakRepository;

/**
 * Timezone-aware day boundary: since storage is Asia/Dhaka wall-clock time
 * directly (no UTC layer, see Core\Db docblock) and the PHP process
 * timezone is set to APP_TIMEZONE at boot, date('Y-m-d') here already IS
 * the Dhaka calendar day — no conversion needed, unlike a UTC-storage app.
 */
final class StreakService
{
    public static function recordActivity(int $userId): void
    {
        $repo  = new UserStreakRepository();
        $today = date('Y-m-d');
        $row   = $repo->find($userId);

        if ($row === null) {
            $repo->upsert($userId, 1, 1, $today);
            return;
        }

        $last = (string) $row['last_activity_date'];
        if ($last === $today) {
            return; // already recorded today, streak unchanged
        }

        $yesterday = date('Y-m-d', strtotime($today . ' -1 day'));
        $current   = $last === $yesterday ? (int) $row['current_streak_days'] + 1 : 1;
        $longest   = max($current, (int) $row['longest_streak_days']);

        $repo->upsert($userId, $current, $longest, $today);
    }

    public static function current(int $userId): array
    {
        $row = (new UserStreakRepository())->find($userId);
        return [
            'current_streak_days' => (int) ($row['current_streak_days'] ?? 0),
            'longest_streak_days' => (int) ($row['longest_streak_days'] ?? 0),
        ];
    }
}
