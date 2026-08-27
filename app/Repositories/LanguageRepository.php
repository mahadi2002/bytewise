<?php
declare(strict_types=1);

namespace App\Repositories;

use App\Core\Db;

final class LanguageRepository
{
    public function all(): array
    {
        return Db::all('SELECT * FROM languages WHERE is_published = 1 ORDER BY launch_order ASC');
    }

    public function findBySlug(string $slug): ?array
    {
        return Db::first('SELECT * FROM languages WHERE slug = ? AND is_published = 1', [$slug]);
    }

    public function find(int $id): ?array
    {
        return Db::first('SELECT * FROM languages WHERE id = ?', [$id]);
    }

    /** Admin CRUD (Phase 14) — every published/unpublished row, for the admin list view. */
    public function allIncludingUnpublished(): array
    {
        return Db::all('SELECT * FROM languages ORDER BY launch_order ASC');
    }

    /** Unconditional lookup for the admin edit form — ignores is_published. */
    public function findAny(int $id): ?array
    {
        return Db::first('SELECT * FROM languages WHERE id = ?', [$id]);
    }

    /**
     * slug is intentionally not editable here (same convention as
     * LessonRepository::update() leaving slug alone post-create) — it's
     * baked into judge routing/URLs, changing it after launch is a
     * separate, deliberate operation, not a form field.
     */
    public function update(int $id, array $data): void
    {
        Db::exec(
            'UPDATE languages SET name_bn = ?, name_en = ?, launch_order = ?, judge_language_code = ?, is_meta_track = ?, is_published = ? WHERE id = ?',
            [
                $data['name_bn'], $data['name_en'], $data['launch_order'] ?? 1,
                ($data['judge_language_code'] ?? '') !== '' ? $data['judge_language_code'] : null,
                $data['is_meta_track'] ?? 0, $data['is_published'] ?? 1, $id,
            ]
        );
    }

    /** Cascades to modules (and transitively lessons), problems, and project_languages rows via ON DELETE CASCADE — same destructive-by-design convention as LessonRepository::delete(). */
    public function delete(int $id): void
    {
        Db::exec('DELETE FROM languages WHERE id = ?', [$id]);
    }
}
