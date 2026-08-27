<?php
declare(strict_types=1);

namespace App\Repositories;

use App\Core\Db;

final class ModuleRepository
{
    public function forLanguage(int $languageId): array
    {
        return Db::all(
            'SELECT * FROM modules WHERE language_id = ? AND is_published = 1 ORDER BY sort_order ASC',
            [$languageId]
        );
    }

    public function find(int $id): ?array
    {
        return Db::first('SELECT * FROM modules WHERE id = ?', [$id]);
    }

    public function findBySlug(int $languageId, string $slug): ?array
    {
        return Db::first('SELECT * FROM modules WHERE language_id = ? AND slug = ?', [$languageId, $slug]);
    }

    /** Admin CRUD (Phase 14) */
    public function create(int $languageId, string $slug, string $titleBn, string $titleEn, int $sortOrder): int
    {
        return Db::insert(
            'INSERT INTO modules (language_id, slug, title_bn, title_en, sort_order) VALUES (?, ?, ?, ?, ?)',
            [$languageId, $slug, $titleBn, $titleEn, $sortOrder]
        );
    }

    /** language_id/slug not editable here — same convention as LessonRepository::update() (fixed at create, moving a module to another track is a separate deliberate operation). */
    public function update(int $id, string $titleBn, string $titleEn, int $sortOrder, bool $isPublished): void
    {
        Db::exec(
            'UPDATE modules SET title_bn = ?, title_en = ?, sort_order = ?, is_published = ? WHERE id = ?',
            [$titleBn, $titleEn, $sortOrder, $isPublished ? 1 : 0, $id]
        );
    }

    public function delete(int $id): void
    {
        Db::exec('DELETE FROM modules WHERE id = ?', [$id]);
    }
}
