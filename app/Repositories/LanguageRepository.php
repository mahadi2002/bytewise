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
}
