<?php
declare(strict_types=1);

namespace App\Services;

use App\Repositories\XpLedgerRepository;

final class XpService
{
    /**
     * Awards XP once per (userId, sourceType, sourceId) — a retried quiz or
     * a re-viewed completed lesson never pays out twice. Returns the amount
     * actually awarded (0 if already awarded).
     */
    public static function award(int $userId, string $sourceType, int $sourceId, int $amount): int
    {
        $awarded = (new XpLedgerRepository())->addOnce($userId, $sourceType, $sourceId, $amount);
        if (!$awarded) {
            return 0;
        }

        StreakService::recordActivity($userId);

        return $amount;
    }

    public static function total(int $userId): int
    {
        return (new XpLedgerRepository())->total($userId);
    }
}
