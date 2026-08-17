<?php
declare(strict_types=1);

namespace App\Repositories;

use App\Core\Db;

final class QuizQuestionRepository
{
    /** Questions + options for a lesson. Never includes is_correct — the view must not leak answers pre-submission. */
    public function forLesson(int $lessonId): array
    {
        $questions = Db::all(
            'SELECT id, question_bn, question_en, code_snippet, sort_order FROM quiz_questions WHERE lesson_id = ? ORDER BY sort_order ASC',
            [$lessonId]
        );

        foreach ($questions as &$q) {
            $q['options'] = Db::all(
                'SELECT id, option_label, option_text_bn FROM quiz_options WHERE question_id = ? ORDER BY option_label ASC',
                [$q['id']]
            );
        }
        unset($q);

        return $questions;
    }

    /** Server-side grading only — the correct option id per question. */
    public function correctOptionsForLesson(int $lessonId): array
    {
        $rows = Db::all(
            'SELECT qq.id AS question_id, qo.id AS option_id
             FROM quiz_questions qq
             JOIN quiz_options qo ON qo.question_id = qq.id AND qo.is_correct = 1
             WHERE qq.lesson_id = ?',
            [$lessonId]
        );

        $map = [];
        foreach ($rows as $row) {
            $map[(int) $row['question_id']] = (int) $row['option_id'];
        }
        return $map;
    }

    /**
     * Full detail (including is_correct + explanation_bn) for building the
     * post-submission result view. Only ever called AFTER server-side
     * grading has already happened — never on the pre-submission GET, which
     * still goes through forLesson() above to avoid leaking answers.
     */
    public function forLessonWithAnswers(int $lessonId): array
    {
        $questions = Db::all(
            'SELECT id, question_bn, question_en, code_snippet, explanation_bn, sort_order FROM quiz_questions WHERE lesson_id = ? ORDER BY sort_order ASC',
            [$lessonId]
        );

        foreach ($questions as &$q) {
            $q['options'] = Db::all(
                'SELECT id, option_label, option_text_bn, is_correct FROM quiz_options WHERE question_id = ? ORDER BY option_label ASC',
                [$q['id']]
            );
        }
        unset($q);

        return $questions;
    }
}
