<?php
declare(strict_types=1);

namespace App\Repositories;

use App\Core\Db;

final class ProjectSubmissionRepository
{
    public function find(int $id): ?array
    {
        return Db::first('SELECT * FROM project_submissions WHERE id = ?', [$id]);
    }

    public function latestForUserProject(int $userId, int $projectId): ?array
    {
        return Db::first(
            'SELECT * FROM project_submissions WHERE user_id = ? AND project_id = ? ORDER BY id DESC LIMIT 1',
            [$userId, $projectId]
        );
    }

    public function create(int $userId, int $projectId, string $link, ?string $notes): int
    {
        return Db::insert(
            "INSERT INTO project_submissions (user_id, project_id, submission_type, submission_link, student_notes, review_status)
             VALUES (?, ?, 'link', ?, ?, 'pending')",
            [$userId, $projectId, $link, $notes]
        );
    }

    public function pendingQueue(): array
    {
        return Db::all(
            'SELECT ps.*, p.title_bn AS project_title, u.display_name
             FROM project_submissions ps
             JOIN projects p ON p.id = ps.project_id
             JOIN users u ON u.id = ps.user_id
             WHERE ps.review_status = "pending"
             ORDER BY ps.submitted_at ASC'
        );
    }

    public function setReview(int $id, string $status, int $reviewerAdminId, ?string $notes, int $xpAwarded): void
    {
        Db::exec(
            'UPDATE project_submissions
             SET review_status = ?, reviewer_admin_id = ?, reviewer_notes = ?, xp_awarded = ?, reviewed_at = NOW()
             WHERE id = ?',
            [$status, $reviewerAdminId, $notes, $xpAwarded, $id]
        );
    }
}
