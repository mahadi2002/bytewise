<?php
declare(strict_types=1);

namespace App\Services;

/**
 * Single source of truth for "is a track's content reachable for user Y".
 * Every track is now open to any logged-in user, no prerequisites — product
 * decision (explicitly reversing the earlier hard-gated chain:
 * C -> C++ -> Java -> Python -> JavaScript -> SQL, and the DS/Algorithms
 * "any one language" rule). The `languages.prerequisite_language_id` /
 * `requires_any_language` columns that used to back that chain are gone
 * from the schema entirely (migration 014) — confirmed unread anywhere
 * before dropping them. The auth check stays: an anonymous request still
 * isn't "unlocked", though in practice the `auth` route middleware already
 * blocks it before this is ever consulted on most of the routes below.
 *
 * Consulted by CourseController, LessonController, ProblemController, and
 * SubmissionController (still real gates on their auth-only routes).
 * DashboardController and ExploreController used to consult it too, but
 * both call sites were provably dead — DashboardController's route is
 * already auth-gated, so isUnlocked() there could never return false; see
 * git history for the removed branches. Project gating is a separate,
 * still-active concern (ProjectEligibilityService, hard-gated on
 * 100%-complete languages) — unaffected by this change.
 */
final class TrackAccessService
{
    public static function isUnlocked(?int $userId): bool
    {
        return $userId !== null;
    }
}
