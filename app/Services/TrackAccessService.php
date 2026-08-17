<?php
declare(strict_types=1);

namespace App\Services;

use App\Core\Db;
use App\Repositories\LanguageRepository;
use App\Repositories\UserLessonProgressRepository;

/**
 * Single source of truth for "is language X's content reachable for user
 * Y" — a track-level gate sitting ABOVE SkillTreeService's within-track
 * sequential module unlock. Two rule shapes, both product decisions, not
 * guessed at:
 *
 *  - The 6 real languages chain: C -> C++ -> Java -> Python -> JavaScript
 *    -> SQL. Each requires the previous at 100% complete
 *    (languages.prerequisite_language_id).
 *  - Data Structures / Algorithms require at least one real language
 *    track 100% complete (languages.requires_any_language) — their
 *    problems need a language picked to solve in (BUILD-SPEC §9), so
 *    reaching their lessons/problems before any language exists doesn't
 *    make sense.
 *
 * Consulted by CourseController, LessonController, ProblemController, and
 * SubmissionController — every place a track's content (not just its
 * projects) is reachable. Project gating is a separate, stricter concern
 * (ProjectEligibilityService) built on the same 100%-complete signal.
 */
final class TrackAccessService
{
    /** @return array{unlocked: bool, reason: ?array} reason: ['language' => row, 'percent' => int] or ['any' => true] */
    public static function check(int $languageId, ?int $userId): array
    {
        $language = (new LanguageRepository())->find($languageId);
        if ($language === null) {
            return ['unlocked' => false, 'reason' => null];
        }

        if ($userId === null) {
            // Visitor: content is gated by subscription first anyway (RequireSubscription
            // middleware runs before this is ever consulted for a real request) — treat
            // as locked so nothing downstream assumes access.
            return ['unlocked' => false, 'reason' => null];
        }

        if ((int) $language['requires_any_language'] === 1) {
            return self::checkRequiresAny($userId);
        }

        if ($language['prerequisite_language_id'] !== null) {
            return self::checkPrerequisite($userId, (int) $language['prerequisite_language_id']);
        }

        return ['unlocked' => true, 'reason' => null];
    }

    public static function isUnlocked(int $languageId, ?int $userId): bool
    {
        return self::check($languageId, $userId)['unlocked'];
    }

    /** Bangla, user-facing — same message everywhere a locked track redirects (courses/lessons/problems). */
    public static function lockMessage(?array $reason): string
    {
        if ($reason === null) {
            return 'এই ট্র্যাকটি এখনো লক করা আছে।';
        }
        if (!empty($reason['any'])) {
            return 'এই ট্র্যাক শুরু করতে আগে অন্তত একটি ভাষা ট্র্যাক সম্পূর্ণ করুন — Data Structures/Algorithms-এর প্রবলেম সমাধান করতে একটি ভাষা প্রয়োজন।';
        }
        $lang = $reason['language'];
        return "এই ট্র্যাকটি লক করা আছে — আগে {$lang['name_bn']} সম্পূর্ণ করুন ({$reason['percent']}% সম্পন্ন)।";
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

    private static function checkPrerequisite(int $userId, int $prerequisiteLanguageId): array
    {
        $prereq = (new LanguageRepository())->find($prerequisiteLanguageId);
        [$total, $done] = (new UserLessonProgressRepository())->languageCounts($userId, $prerequisiteLanguageId);
        $percent = $total > 0 ? (int) round(($done / $total) * 100) : 0;

        if ($total > 0 && $done === $total) {
            return ['unlocked' => true, 'reason' => null];
        }

        return ['unlocked' => false, 'reason' => ['language' => $prereq, 'percent' => $percent]];
    }

    private static function checkRequiresAny(int $userId): array
    {
        $progressRepo = new UserLessonProgressRepository();
        foreach ((new LanguageRepository())->all() as $lang) {
            if ((int) $lang['is_meta_track'] === 1) {
                continue;
            }
            [$total, $done] = $progressRepo->languageCounts($userId, (int) $lang['id']);
            if ($total > 0 && $done === $total) {
                return ['unlocked' => true, 'reason' => null];
            }
        }

        return ['unlocked' => false, 'reason' => ['any' => true]];
    }
}
