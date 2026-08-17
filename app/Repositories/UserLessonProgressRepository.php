<?php
declare(strict_types=1);

namespace App\Repositories;

use App\Core\Db;

final class UserLessonProgressRepository
{
    /** @return array<int,array> keyed by lesson_id, for one module's worth of lessons */
    public function forModule(int $userId, int $moduleId): array
    {
        $rows = Db::all(
            'SELECT ulp.* FROM user_lesson_progress ulp
             JOIN lessons l ON l.id = ulp.lesson_id
             WHERE ulp.user_id = ? AND l.module_id = ?',
            [$userId, $moduleId]
        );

        $byLesson = [];
        foreach ($rows as $row) {
            $byLesson[(int) $row['lesson_id']] = $row;
        }
        return $byLesson;
    }

    public function find(int $userId, int $lessonId): ?array
    {
        return Db::first('SELECT * FROM user_lesson_progress WHERE user_id = ? AND lesson_id = ?', [$userId, $lessonId]);
    }

    public function markInProgress(int $userId, int $lessonId): void
    {
        Db::exec(
            "INSERT INTO user_lesson_progress (user_id, lesson_id, status) VALUES (?, ?, 'in_progress')
             ON DUPLICATE KEY UPDATE status = IF(status = 'completed', status, 'in_progress')",
            [$userId, $lessonId]
        );
    }

    public function markCompleted(int $userId, int $lessonId): void
    {
        Db::exec(
            "INSERT INTO user_lesson_progress (user_id, lesson_id, status, completed_at) VALUES (?, ?, 'completed', NOW())
             ON DUPLICATE KEY UPDATE status = 'completed', completed_at = NOW()",
            [$userId, $lessonId]
        );
    }

    /** [total, completed] lesson counts for a module — SkillTreeService's percent calc. */
    public function moduleCounts(int $userId, int $moduleId): array
    {
        $total = (int) Db::value('SELECT COUNT(*) FROM lessons WHERE module_id = ? AND is_published = 1', [$moduleId]);
        $done  = (int) Db::value(
            "SELECT COUNT(*) FROM user_lesson_progress ulp
             JOIN lessons l ON l.id = ulp.lesson_id
             WHERE ulp.user_id = ? AND l.module_id = ? AND ulp.status = 'completed'",
            [$userId, $moduleId]
        );
        return [$total, $done];
    }

    /**
     * [total, completed] lesson counts across an ENTIRE language (every
     * module, not just one) — the basis for "is this track 100% complete",
     * which TrackAccessService and ProjectEligibilityService both need.
     */
    public function languageCounts(int $userId, int $languageId): array
    {
        $total = (int) Db::value(
            'SELECT COUNT(*) FROM lessons l JOIN modules m ON m.id = l.module_id
             WHERE m.language_id = ? AND l.is_published = 1',
            [$languageId]
        );
        $done = (int) Db::value(
            "SELECT COUNT(*) FROM user_lesson_progress ulp
             JOIN lessons l ON l.id = ulp.lesson_id
             JOIN modules m ON m.id = l.module_id
             WHERE ulp.user_id = ? AND m.language_id = ? AND ulp.status = 'completed'",
            [$userId, $languageId]
        );
        return [$total, $done];
    }
}
