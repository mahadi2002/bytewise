<?php
declare(strict_types=1);

namespace App\Repositories;

use App\Core\Db;

/**
 * brief_md/rubric_md are gated columns — same branch-the-SELECT rule as
 * LessonRepository/ProblemRepository. Languages are a many-to-many via
 * project_languages (a project can require more than one — "hybrid"),
 * never projects.language_id, which was dropped in migration 009.
 */
final class ProjectRepository
{
    private const PUBLIC_COLUMNS = 'id, slug, title_bn, title_en, xp_reward, is_published, content_verified';
    private const FULL_COLUMNS   = self::PUBLIC_COLUMNS . ', brief_md, rubric_md, starter_repo_notes';

    public function all(): array
    {
        return Db::all('SELECT ' . self::PUBLIC_COLUMNS . ' FROM projects WHERE is_published = 1');
    }

    public function find(int $id): ?array
    {
        return Db::first('SELECT ' . self::FULL_COLUMNS . ' FROM projects WHERE id = ? AND is_published = 1', [$id]);
    }

    public function findForViewer(int $id, bool $isSubscriber): ?array
    {
        if (!$isSubscriber) {
            return Db::first('SELECT ' . self::PUBLIC_COLUMNS . ' FROM projects WHERE id = ? AND is_published = 1', [$id]);
        }
        return $this->find($id);
    }

    /** @return array<int,array> language rows required by this project, primary first. */
    public function languagesForProject(int $projectId): array
    {
        return Db::all(
            'SELECT l.* FROM project_languages pl JOIN languages l ON l.id = pl.language_id
             WHERE pl.project_id = ? ORDER BY pl.is_primary DESC, l.launch_order ASC',
            [$projectId]
        );
    }

    /** @param array<int,array> $projectIds -> ignored; batches languages for every project in one query. */
    public function languagesForProjects(array $projectIds): array
    {
        if ($projectIds === []) {
            return [];
        }
        $rows = Db::all(
            'SELECT pl.project_id, l.* FROM project_languages pl JOIN languages l ON l.id = pl.language_id
             WHERE pl.project_id IN (' . Db::placeholders($projectIds) . ')
             ORDER BY pl.is_primary DESC, l.launch_order ASC',
            $projectIds
        );

        $byProject = [];
        foreach ($rows as $row) {
            $byProject[(int) $row['project_id']][] = $row;
        }
        return $byProject;
    }

    /**
     * Admin CRUD (Phase 14). $data['language_ids'] is an array of language
     * ids (a form submits this as language_ids[]); the first is treated as
     * primary for card display, never as a gating distinction.
     */
    public function create(array $data): int
    {
        $languageIds = array_values(array_filter(array_map('intval', (array) ($data['language_ids'] ?? []))));

        return Db::transaction(function () use ($data, $languageIds): int {
            $id = Db::insert(
                'INSERT INTO projects (slug, title_bn, title_en, brief_md, rubric_md, starter_repo_notes, xp_reward, content_verified)
                 VALUES (?, ?, ?, ?, ?, ?, ?, 0)',
                [
                    $data['slug'], $data['title_bn'], $data['title_en'],
                    $data['brief_md'], $data['rubric_md'], $data['starter_repo_notes'] ?? null, $data['xp_reward'] ?? 100,
                ]
            );

            foreach ($languageIds as $i => $languageId) {
                Db::exec(
                    'INSERT INTO project_languages (project_id, language_id, is_primary) VALUES (?, ?, ?)',
                    [$id, $languageId, $i === 0 ? 1 : 0]
                );
            }

            return $id;
        });
    }

    /** Unconditional lookup for the admin edit form — ignores is_published (same convention as LessonRepository::find()). */
    public function findAny(int $id): ?array
    {
        return Db::first('SELECT ' . self::FULL_COLUMNS . ' FROM projects WHERE id = ?', [$id]);
    }

    /** slug not editable here — same convention as LessonRepository::update(). Re-syncs project_languages wholesale, same shape as create(). */
    public function update(int $id, array $data): void
    {
        $languageIds = array_values(array_filter(array_map('intval', (array) ($data['language_ids'] ?? []))));

        Db::transaction(function () use ($id, $data, $languageIds): void {
            Db::exec(
                'UPDATE projects SET title_bn = ?, title_en = ?, brief_md = ?, rubric_md = ?, starter_repo_notes = ?, xp_reward = ?, is_published = ? WHERE id = ?',
                [
                    $data['title_bn'], $data['title_en'], $data['brief_md'], $data['rubric_md'],
                    $data['starter_repo_notes'] ?? null, $data['xp_reward'] ?? 100, $data['is_published'] ?? 1, $id,
                ]
            );

            Db::exec('DELETE FROM project_languages WHERE project_id = ?', [$id]);
            foreach ($languageIds as $i => $languageId) {
                Db::exec(
                    'INSERT INTO project_languages (project_id, language_id, is_primary) VALUES (?, ?, ?)',
                    [$id, $languageId, $i === 0 ? 1 : 0]
                );
            }
        });
    }

    public function delete(int $id): void
    {
        Db::exec('DELETE FROM projects WHERE id = ?', [$id]);
    }
}
