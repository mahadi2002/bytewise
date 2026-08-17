<?php
declare(strict_types=1);

namespace App\Repositories;

use App\Core\Db;

/**
 * The one place `lessons.body_md`/`code_sample` gating happens at the SQL
 * layer (BUILD-SPEC §3/rulebook §8): findForViewer() branches its column
 * list rather than fetching everything and hiding it in the template — a
 * non-subscriber's SELECT for a non-free-preview lesson never mentions
 * body_md/code_sample/code_sample_language at all.
 */
final class LessonRepository
{
    private const PUBLIC_COLUMNS = 'id, module_id, slug, title_bn, title_en, xp_reward, is_free_preview, sort_order, is_published, content_verified';
    private const FULL_COLUMNS   = self::PUBLIC_COLUMNS . ', body_md, code_sample, code_sample_language';

    public function forModule(int $moduleId): array
    {
        return Db::all(
            'SELECT ' . self::PUBLIC_COLUMNS . ' FROM lessons WHERE module_id = ? AND is_published = 1 ORDER BY sort_order ASC',
            [$moduleId]
        );
    }

    /** Column-branched by viewer eligibility — see class docblock. */
    public function findForViewer(int $lessonId, bool $isSubscriber): ?array
    {
        $row = Db::first(
            'SELECT ' . self::PUBLIC_COLUMNS . ' FROM lessons WHERE id = ? AND is_published = 1',
            [$lessonId]
        );
        if ($row === null) {
            return null;
        }

        if ($isSubscriber || (int) $row['is_free_preview'] === 1) {
            return Db::first(
                'SELECT ' . self::FULL_COLUMNS . ' FROM lessons WHERE id = ? AND is_published = 1',
                [$lessonId]
            );
        }

        return $row;
    }

    public function findBySlugForViewer(string $slug, bool $isSubscriber): ?array
    {
        $row = Db::first(
            'SELECT ' . self::PUBLIC_COLUMNS . ' FROM lessons WHERE slug = ? AND is_published = 1',
            [$slug]
        );
        if ($row === null) {
            return null;
        }

        return $this->findForViewer((int) $row['id'], $isSubscriber);
    }

    public function find(int $id): ?array
    {
        return Db::first('SELECT ' . self::FULL_COLUMNS . ' FROM lessons WHERE id = ?', [$id]);
    }

    /** Next published lesson after $sortOrder in the same module, or null if this was the last one. */
    public function nextInModule(int $moduleId, int $sortOrder): ?array
    {
        return Db::first(
            'SELECT id, slug, title_bn FROM lessons WHERE module_id = ? AND sort_order > ? AND is_published = 1 ORDER BY sort_order ASC LIMIT 1',
            [$moduleId, $sortOrder]
        );
    }

    // ── Admin CRUD (Phase 14) ────────────────────────────────────────────

    public function create(array $data): int
    {
        return Db::insert(
            'INSERT INTO lessons (module_id, slug, title_bn, title_en, body_md, code_sample, code_sample_language, xp_reward, is_free_preview, sort_order, is_published, content_verified)
             VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 0)',
            [
                $data['module_id'], $data['slug'], $data['title_bn'], $data['title_en'],
                $data['body_md'], $data['code_sample'] ?? null, $data['code_sample_language'] ?? null,
                $data['xp_reward'] ?? 10, $data['is_free_preview'] ?? 0, $data['sort_order'] ?? 1,
                $data['is_published'] ?? 1,
            ]
        );
    }

    public function update(int $id, array $data): void
    {
        Db::exec(
            'UPDATE lessons SET title_bn = ?, title_en = ?, body_md = ?, code_sample = ?, code_sample_language = ?, xp_reward = ?, is_free_preview = ?, sort_order = ?, is_published = ? WHERE id = ?',
            [
                $data['title_bn'], $data['title_en'], $data['body_md'], $data['code_sample'] ?? null,
                $data['code_sample_language'] ?? null, $data['xp_reward'] ?? 10, $data['is_free_preview'] ?? 0,
                $data['sort_order'] ?? 1, $data['is_published'] ?? 1, $id,
            ]
        );
    }

    public function delete(int $id): void
    {
        Db::exec('DELETE FROM lessons WHERE id = ?', [$id]);
    }

    public function all(): array
    {
        return Db::all(
            'SELECT l.id, l.slug, l.title_bn, l.module_id, l.is_published, m.title_bn AS module_title, lang.name_bn AS language_name
             FROM lessons l JOIN modules m ON m.id = l.module_id JOIN languages lang ON lang.id = m.language_id
             ORDER BY lang.launch_order, m.sort_order, l.sort_order'
        );
    }
}
