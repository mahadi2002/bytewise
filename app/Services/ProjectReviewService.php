<?php
declare(strict_types=1);

namespace App\Services;

use App\Repositories\ProjectRepository;
use App\Repositories\ProjectSubmissionRepository;

/** Self-reported + admin-reviewed only — never an auto-grader, see BUILD-SPEC §9. */
final class ProjectReviewService
{
    public static function approve(int $submissionId, int $adminId, ?string $notes): void
    {
        $repo = new ProjectSubmissionRepository();
        $sub  = $repo->find($submissionId);
        if ($sub === null || $sub['review_status'] !== 'pending') {
            return;
        }

        $project = (new ProjectRepository())->find((int) $sub['project_id']);
        $xp      = (int) ($project['xp_reward'] ?? 0);

        $repo->setReview($submissionId, 'approved', $adminId, $notes, $xp);
        XpService::award((int) $sub['user_id'], 'project', (int) $sub['project_id'], $xp);
    }

    public static function requestChanges(int $submissionId, int $adminId, ?string $notes): void
    {
        $repo = new ProjectSubmissionRepository();
        $sub  = $repo->find($submissionId);
        if ($sub === null || $sub['review_status'] !== 'pending') {
            return;
        }

        $repo->setReview($submissionId, 'changes_requested', $adminId, $notes, 0);
    }
}
