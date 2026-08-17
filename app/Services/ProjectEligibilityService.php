<?php
declare(strict_types=1);

namespace App\Services;

use App\Repositories\ProjectRepository;
use App\Repositories\UserLessonProgressRepository;

/**
 * Hard-gates a project's submission form on ALL of its required languages
 * being 100% complete (project decision, see docs/FEATURES.md) — a hybrid
 * project requiring Python + SQL needs BOTH finished, not just one. Reuses
 * the same 100%-complete signal as TrackAccessService, but this is a
 * stricter, separate check: a track being merely UNLOCKED (reachable) is
 * not enough to attempt the project it feeds into — it must be finished.
 */
final class ProjectEligibilityService
{
    /** @return array{ready: bool, languages: array<int,array{language: array, complete: bool, percent: int}>} */
    public static function check(int $projectId, int $userId): array
    {
        $languages = (new ProjectRepository())->languagesForProject($projectId);
        $progressRepo = new UserLessonProgressRepository();

        $result = [];
        $ready  = true;

        foreach ($languages as $language) {
            [$total, $done] = $progressRepo->languageCounts($userId, (int) $language['id']);
            $percent  = $total > 0 ? (int) round(($done / $total) * 100) : 0;
            $complete = $total > 0 && $done === $total;

            if (!$complete) {
                $ready = false;
            }

            $result[] = ['language' => $language, 'complete' => $complete, 'percent' => $percent];
        }

        return ['ready' => $ready, 'languages' => $result];
    }
}
