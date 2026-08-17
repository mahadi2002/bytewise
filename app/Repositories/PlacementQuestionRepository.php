<?php
declare(strict_types=1);

namespace App\Repositories;

use App\Core\Db;

final class PlacementQuestionRepository
{
    /** Never includes is_correct — same leak-prevention rule as quiz questions. */
    public function forLanguage(int $languageId): array
    {
        $questions = Db::all(
            'SELECT id, question_bn, code_snippet, difficulty_weight, sort_order
             FROM placement_questions WHERE language_id = ? ORDER BY sort_order ASC',
            [$languageId]
        );

        foreach ($questions as &$q) {
            $q['options'] = Db::all(
                'SELECT id, option_label, option_text_bn FROM placement_options WHERE question_id = ? ORDER BY option_label ASC',
                [$q['id']]
            );
        }
        unset($q);

        return $questions;
    }

    /** question_id => correct option_id, ordered by difficulty_weight ascending. */
    public function correctOptionsForLanguage(int $languageId): array
    {
        $rows = Db::all(
            'SELECT pq.id AS question_id, po.id AS option_id
             FROM placement_questions pq
             JOIN placement_options po ON po.question_id = pq.id AND po.is_correct = 1
             WHERE pq.language_id = ?
             ORDER BY pq.difficulty_weight ASC',
            [$languageId]
        );

        $map = [];
        foreach ($rows as $row) {
            $map[(int) $row['question_id']] = (int) $row['option_id'];
        }
        return $map;
    }
}
