<?php
declare(strict_types=1);

namespace App\Repositories;

use App\Core\Db;

/** statement_md/starter_code are the gated columns — same branch-the-SELECT rule as LessonRepository. */
final class ProblemRepository
{
    private const PUBLIC_COLUMNS = 'id, language_id, lesson_id, slug, title_bn, title_en, difficulty, xp_reward, time_limit_ms, memory_limit_kb, is_daily_eligible, is_published, content_verified';
    private const FULL_COLUMNS   = self::PUBLIC_COLUMNS . ', statement_md, starter_code';

    public function find(int $id): ?array
    {
        return Db::first('SELECT ' . self::FULL_COLUMNS . ' FROM problems WHERE id = ? AND is_published = 1', [$id]);
    }

    public function findBySlug(string $slug): ?array
    {
        return Db::first('SELECT ' . self::FULL_COLUMNS . ' FROM problems WHERE slug = ? AND is_published = 1', [$slug]);
    }

    /** Column-branched: a non-subscriber never has statement_md/starter_code fetched at all. */
    public function findForViewer(int $id, bool $isSubscriber): ?array
    {
        if (!$isSubscriber) {
            return Db::first('SELECT ' . self::PUBLIC_COLUMNS . ' FROM problems WHERE id = ? AND is_published = 1', [$id]);
        }
        return $this->find($id);
    }

    public function forLanguage(int $languageId): array
    {
        return Db::all('SELECT ' . self::PUBLIC_COLUMNS . ' FROM problems WHERE language_id = ? AND is_published = 1', [$languageId]);
    }

    /** Admin CRUD (Phase 14) */
    public function all(): array
    {
        return Db::all(
            'SELECT p.id, p.slug, p.title_bn, p.difficulty, p.is_published, l.name_bn AS language_name
             FROM problems p LEFT JOIN languages l ON l.id = p.language_id
             ORDER BY p.id DESC'
        );
    }

    /** Unconditional lookup for the admin edit form — ignores is_published (same convention as LessonRepository::find()). */
    public function findAny(int $id): ?array
    {
        return Db::first('SELECT ' . self::FULL_COLUMNS . ' FROM problems WHERE id = ?', [$id]);
    }

    public function create(array $data): int
    {
        return Db::insert(
            'INSERT INTO problems (language_id, lesson_id, slug, title_bn, title_en, statement_md, starter_code, difficulty, xp_reward, time_limit_ms, memory_limit_kb, content_verified)
             VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 0)',
            [
                empty($data['language_id']) ? null : $data['language_id'], empty($data['lesson_id']) ? null : $data['lesson_id'], $data['slug'], $data['title_bn'], $data['title_en'],
                $data['statement_md'], $data['starter_code'] ?? null, $data['difficulty'] ?? 'easy',
                $data['xp_reward'] ?? 25, $data['time_limit_ms'] ?? 2000, $data['memory_limit_kb'] ?? 65536,
            ]
        );
    }

    /** language_id/lesson_id/slug not editable here — same convention as LessonRepository::update(). */
    public function update(int $id, array $data): void
    {
        Db::exec(
            'UPDATE problems SET title_bn = ?, title_en = ?, statement_md = ?, starter_code = ?, difficulty = ?, xp_reward = ?, time_limit_ms = ?, memory_limit_kb = ?, is_published = ? WHERE id = ?',
            [
                $data['title_bn'], $data['title_en'], $data['statement_md'], $data['starter_code'] ?? null,
                $data['difficulty'] ?? 'easy', $data['xp_reward'] ?? 25, $data['time_limit_ms'] ?? 2000,
                $data['memory_limit_kb'] ?? 65536, $data['is_published'] ?? 1, $id,
            ]
        );
    }

    public function delete(int $id): void
    {
        Db::exec('DELETE FROM problems WHERE id = ?', [$id]);
    }

    public function randomDailyEligible(int $languageId, array $excludeIds): array
    {
        $exclude = $excludeIds === [] ? '' : ('AND id NOT IN (' . Db::placeholders($excludeIds) . ')');
        return Db::all(
            "SELECT " . self::PUBLIC_COLUMNS . " FROM problems
             WHERE language_id = ? AND is_daily_eligible = 1 AND is_published = 1 {$exclude}
             ORDER BY RAND() LIMIT 1",
            array_merge([$languageId], $excludeIds)
        );
    }
}
