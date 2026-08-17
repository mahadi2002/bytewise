<?php
declare(strict_types=1);

namespace App\Services;

use App\Repositories\ModuleRepository;
use App\Repositories\PlacementAttemptRepository;
use App\Repositories\PlacementQuestionRepository;

/**
 * Scores a placement attempt and recommends a starting module. Free by
 * design, works pre-auth or session-keyed (BUILD-SPEC §6) — placement_
 * attempts.user_id is nullable precisely so an anonymous visitor's attempt
 * still gets recorded (keyed by PHP session id instead).
 */
final class PlacementService
{
    /**
     * @param array<int,int> $answers question_id => submitted option_id
     * @return array{raw_score:int, total:int, recommended_module: ?array}
     */
    public static function score(int $languageId, array $answers, ?int $userId, ?string $sessionId): array
    {
        $qRepo   = new PlacementQuestionRepository();
        $correct = $qRepo->correctOptionsForLanguage($languageId); // already sorted by difficulty_weight

        $rawScore = 0;
        foreach ($correct as $questionId => $correctOptionId) {
            if ((int) ($answers[$questionId] ?? 0) === $correctOptionId) {
                $rawScore++;
            } else {
                break; // first miss in increasing-difficulty order stops counting
            }
        }

        $modules = (new ModuleRepository())->forLanguage($languageId);
        $index   = min($rawScore, max(0, count($modules) - 1));
        $recommendedModule = $modules[$index] ?? null;

        (new PlacementAttemptRepository())->create(
            $userId,
            $sessionId,
            $languageId,
            $recommendedModule !== null ? (int) $recommendedModule['id'] : null,
            $rawScore
        );

        return [
            'raw_score'           => $rawScore,
            'total'                => count($correct),
            'recommended_module'  => $recommendedModule,
        ];
    }
}
