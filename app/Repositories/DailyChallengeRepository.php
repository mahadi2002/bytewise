<?php
declare(strict_types=1);

namespace App\Repositories;

use App\Core\Db;

final class DailyChallengeRepository
{
    public function forLanguageAndDate(int $languageId, string $date): ?array
    {
        return Db::first(
            'SELECT dc.*, p.title_bn, p.slug, p.difficulty
             FROM daily_challenges dc JOIN problems p ON p.id = dc.problem_id
             WHERE dc.language_id = ? AND dc.challenge_date = ?',
            [$languageId, $date]
        );
    }

    public function create(int $languageId, int $problemId, string $date): int
    {
        return Db::insert(
            'INSERT INTO daily_challenges (language_id, problem_id, challenge_date) VALUES (?, ?, ?)',
            [$languageId, $problemId, $date]
        );
    }

    /**
     * Eligible problems for a track's daily rotation. A language-locked
     * track matches problems.language_id directly; a meta-track (Data
     * Structures/Algorithms) has NULL there, so membership is inferred
     * through problems.lesson_id -> lessons.module_id -> modules.language_id
     * instead (the only place that link exists in the schema).
     */
    public function eligibleProblemIds(int $languageId, array $recentlyUsedIds): array
    {
        $exclude = $recentlyUsedIds === [] ? '' : ('AND p.id NOT IN (' . Db::placeholders($recentlyUsedIds) . ')');

        $rows = Db::all(
            "SELECT DISTINCT p.id FROM problems p
             LEFT JOIN lessons l ON l.id = p.lesson_id
             LEFT JOIN modules m ON m.id = l.module_id
             WHERE p.is_daily_eligible = 1 AND p.is_published = 1
               AND (p.language_id = ? OR (p.language_id IS NULL AND m.language_id = ?))
               {$exclude}",
            array_merge([$languageId, $languageId], $recentlyUsedIds)
        );

        return array_map(static fn(array $r): int => (int) $r['id'], $rows);
    }

    /** Problem ids already used as this track's daily challenge in the last N days — avoid immediate repeats. */
    public function recentProblemIds(int $languageId, int $days): array
    {
        $rows = Db::all(
            'SELECT problem_id FROM daily_challenges WHERE language_id = ? AND challenge_date >= DATE_SUB(CURDATE(), INTERVAL ? DAY)',
            [$languageId, $days]
        );
        return array_map(static fn(array $r): int => (int) $r['problem_id'], $rows);
    }
}
