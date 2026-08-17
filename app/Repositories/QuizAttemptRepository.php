<?php
declare(strict_types=1);

namespace App\Repositories;

use App\Core\Db;

final class QuizAttemptRepository
{
    public function create(int $userId, int $lessonId, int $scoreCorrect, int $scoreTotal, int $xpAwarded): int
    {
        return Db::insert(
            'INSERT INTO quiz_attempts (user_id, lesson_id, score_correct, score_total, xp_awarded) VALUES (?, ?, ?, ?, ?)',
            [$userId, $lessonId, $scoreCorrect, $scoreTotal, $xpAwarded]
        );
    }

    /**
     * The quiz is optional and never gates lesson completion — XP is its
     * only effect, awarded once per lesson. This checks that "once" without
     * relying on user_lesson_progress, which the quiz no longer touches.
     */
    public function hasBeenRewarded(int $userId, int $lessonId): bool
    {
        return (bool) Db::value(
            'SELECT COUNT(*) FROM quiz_attempts WHERE user_id = ? AND lesson_id = ? AND xp_awarded > 0',
            [$userId, $lessonId]
        );
    }
}
