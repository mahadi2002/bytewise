<?php
declare(strict_types=1);

namespace App\Repositories;

use App\Core\Db;

final class PlacementAttemptRepository
{
    public function create(?int $userId, ?string $sessionId, int $languageId, ?int $recommendedModuleId, int $rawScore): int
    {
        return Db::insert(
            'INSERT INTO placement_attempts (user_id, session_id, language_id, recommended_module_id, raw_score)
             VALUES (?, ?, ?, ?, ?)',
            [$userId, $sessionId, $languageId, $recommendedModuleId, $rawScore]
        );
    }
}
