<?php
declare(strict_types=1);

namespace App\Services;

use App\Core\Db;
use App\Repositories\LanguageRepository;

/**
 * Single source of truth for "is language X's content reachable for user
 * Y". Every track is now open to any subscriber, no prerequisites —
 * product decision (explicitly reversing the earlier hard-gated chain:
 * C -> C++ -> Java -> Python -> JavaScript -> SQL, and the DS/Algorithms
 * "any one language" rule). `languages.prerequisite_language_id` /
 * `requires_any_language` stay in the schema (harmless, and dropping them
 * would mean a migration + FK teardown for no benefit) but are no longer
 * read here. The auth check stays: an anonymous request still isn't
 * "unlocked" by this method, though in practice `RequireSubscription`
 * middleware already blocks it before this is ever consulted.
 *
 * Consulted by CourseController, LessonController, ProblemController, and
 * SubmissionController. Project gating is a separate, still-active concern
 * (ProjectEligibilityService, hard-gated on 100%-complete languages) —
 * unaffected by this change.
 */
final class TrackAccessService
{
    /** @return array{unlocked: bool, reason: ?array} */
    public static function check(int $languageId, ?int $userId): array
    {
        $language = (new LanguageRepository())->find($languageId);
        if ($language === null) {
            return ['unlocked' => false, 'reason' => null];
        }

        if ($userId === null) {
            return ['unlocked' => false, 'reason' => null];
        }

        return ['unlocked' => true, 'reason' => null];
    }

    public static function isUnlocked(int $languageId, ?int $userId): bool
    {
        return self::check($languageId, $userId)['unlocked'];
    }

    /** Only reachable for the language-not-found/not-logged-in cases now — no prerequisite reasons exist anymore. */
    public static function lockMessage(?array $reason): string
    {
        return 'This track is not available right now.';
    }

    /**
     * Resolves the owning language for a problem row: language_id directly
     * for a locked problem, or lesson_id -> module_id -> language_id for a
     * language-agnostic DS/Algorithms problem. Null means "no track to gate
     * against" (shouldn't happen for a real row, but never fabricate one).
     */
    public static function languageIdForProblem(array $problem): ?int
    {
        if ($problem['language_id'] !== null) {
            return (int) $problem['language_id'];
        }

        $languageId = Db::value(
            'SELECT m.language_id FROM problems p
             JOIN lessons l ON l.id = p.lesson_id
             JOIN modules m ON m.id = l.module_id
             WHERE p.id = ?',
            [$problem['id']]
        );
        return $languageId !== null ? (int) $languageId : null;
    }

    /** @return array{unlocked: bool, reason: ?array} — same shape as check(), for a problem row directly. */
    public static function checkProblem(array $problem, ?int $userId): array
    {
        $languageId = self::languageIdForProblem($problem);
        if ($languageId === null) {
            return ['unlocked' => true, 'reason' => null];
        }
        return self::check($languageId, $userId);
    }
}
