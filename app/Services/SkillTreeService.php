<?php
declare(strict_types=1);

namespace App\Services;

use App\Repositories\ModuleRepository;
use App\Repositories\UserLessonProgressRepository;

/**
 * Computes per-module ✓/%/🔒 for one track, per BUILD-SPEC §4. Sequential,
 * computed at render time from user_lesson_progress — no stored
 * is_unlocked column anywhere (§9's deliberate "don't cache derived state"
 * decision, same principle as never session-caching subscription status).
 *
 * Rendering rule: a module is 'complete' when every lesson in it is
 * completed; 'locked' when the PREVIOUS module (by sort_order) is not yet
 * fully complete; otherwise 'partial' with a rounded percent — or
 * 'not_started' at 0%.
 */
final class SkillTreeService
{
    /**
     * @return array<int,array{module: array, state: string, percent: int}>
     *         state: 'complete'|'partial'|'not_started'|'locked'
     */
    public static function build(int $languageId, ?int $userId): array
    {
        $modules = (new ModuleRepository())->forLanguage($languageId);
        $progressRepo = new UserLessonProgressRepository();

        $tree = [];
        $previousComplete = true; // first module is always unlockable

        foreach ($modules as $module) {
            $moduleId = (int) $module['id'];

            if ($userId === null) {
                // Visitor: every node renders locked (BUILD-SPEC §3 free-vs-gated matrix).
                $tree[] = ['module' => $module, 'state' => 'locked', 'percent' => 0];
                continue;
            }

            [$total, $done] = $progressRepo->moduleCounts($userId, $moduleId);
            $percent = $total > 0 ? (int) round(($done / $total) * 100) : 0;
            $isComplete = $total > 0 && $done === $total;

            if (!$previousComplete) {
                $tree[] = ['module' => $module, 'state' => 'locked', 'percent' => 0];
                // A locked module's own completion never unlocks the next one.
                $previousComplete = false;
                continue;
            }

            $state = match (true) {
                $isComplete   => 'complete',
                $done > 0     => 'partial',
                default       => 'not_started',
            };

            $tree[] = ['module' => $module, 'state' => $state, 'percent' => $percent];
            $previousComplete = $isComplete;
        }

        return $tree;
    }
}
