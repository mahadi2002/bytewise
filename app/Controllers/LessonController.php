<?php
declare(strict_types=1);

namespace App\Controllers;

use App\Core\Controller;
use App\Core\Request;
use App\Core\Response;
use App\Core\Session;
use App\Repositories\DiscussionPostRepository;
use App\Repositories\LanguageRepository;
use App\Repositories\LessonRepository;
use App\Repositories\ModuleRepository;
use App\Repositories\QuizAttemptRepository;
use App\Repositories\QuizQuestionRepository;
use App\Repositories\UserLessonProgressRepository;
use App\Services\TrackAccessService;
use App\Services\XpService;

final class LessonController extends Controller
{
    /** GET /lesson/{slug} — [F] if free preview, else a locked teaser card. Never touches gated columns for a non-subscriber. */
    public function showFree(Request $request, string $slug): Response
    {
        $repo   = new LessonRepository();
        $lesson = $repo->findBySlugForViewer($slug, $this->isAuthenticated());

        if ($lesson === null) {
            $this->notFound();
        }

        $isLocked = !array_key_exists('body_md', $lesson);
        $discussionCount = $isLocked ? 0 : (new DiscussionPostRepository())->countForContext('lesson', (int) $lesson['id']);

        return $this->view('lessons/show', [
            'title'           => $lesson['title_bn'],
            'lesson'          => $lesson,
            'locked'          => $isLocked,
            'questions'       => [],
            'completed'       => false,
            'discussionCount' => $discussionCount,
            'extraScripts'    => ['dist/editor.js'],
        ]);
    }

    /** GET /lessons/{id} — [G] full lesson + optional inline quiz, marks progress in_progress on view. */
    public function showGated(Request $request, string $id): Response
    {
        $lessonId = (int) $id;
        $repo     = new LessonRepository();
        $lesson   = $repo->findForViewer($lessonId, $this->isAuthenticated());

        if ($lesson === null || !array_key_exists('body_md', $lesson)) {
            $this->notFound();
        }

        $module = (new ModuleRepository())->find((int) $lesson['module_id']);
        $userId = (int) $this->currentUserId();

        if (!TrackAccessService::isUnlocked($userId)) {
            Session::notify('info', 'This track is not available right now.');
            return $this->redirect(url('/dashboard'));
        }

        $progressRepo = new UserLessonProgressRepository();
        $progress = $progressRepo->find($userId, $lessonId);
        if ($progress === null || $progress['status'] !== 'completed') {
            $progressRepo->markInProgress($userId, $lessonId);
        }

        $discussionCount = (new DiscussionPostRepository())->countForContext('lesson', $lessonId);

        return $this->view('lessons/show', [
            'title'           => $lesson['title_bn'],
            'lesson'          => $lesson,
            'locked'          => false,
            'module'          => $module,
            'questions'       => (new QuizQuestionRepository())->forLesson($lessonId),
            'completed'       => $progress !== null && $progress['status'] === 'completed',
            'discussionCount' => $discussionCount,
            'extraScripts'    => ['dist/editor.js'],
        ]);
    }

    /**
     * Shared by complete() and submitQuiz(): resolve the lesson + its
     * module, 404 on a missing/unpublished lesson, redirect if the track
     * is locked. Returns the resolved pair, or a Response the caller must
     * return immediately (the lock-redirect case).
     *
     * @return array{lesson: array, module: array}|Response
     */
    private function resolveGatedLesson(int $lessonId, int $userId): array|Response
    {
        $lesson = (new LessonRepository())->find($lessonId);
        if ($lesson === null || !$lesson['is_published']) {
            $this->notFound();
        }

        $module = (new ModuleRepository())->find((int) $lesson['module_id']);
        if (!TrackAccessService::isUnlocked($userId)) {
            Session::notify('info', 'This track is not available right now.');
            return $this->redirect(url('/dashboard'));
        }

        return ['lesson' => $lesson, 'module' => $module];
    }

    /**
     * POST /lessons/{id}/complete — [G][P] the actual "move forward" action.
     * Teaching here is meant to be gentle, not gated: a lesson is marked
     * done and the learner advances regardless of whether they ever touched
     * the quiz. This is the only place lesson completion is written —
     * submitQuiz() below never marks a lesson complete, only grades it.
     */
    public function complete(Request $request, string $id): Response
    {
        $lessonId = (int) $id;
        $userId   = (int) $this->currentUserId();

        $resolved = $this->resolveGatedLesson($lessonId, $userId);
        if ($resolved instanceof Response) {
            return $resolved;
        }
        ['lesson' => $lesson, 'module' => $module] = $resolved;

        (new UserLessonProgressRepository())->markCompleted($userId, $lessonId);

        $lessonRepo = new LessonRepository();
        $nextLesson = $lessonRepo->nextInModule((int) $module['id'], (int) $lesson['sort_order']);
        if ($nextLesson !== null) {
            return $this->redirect(url('/lessons/' . $nextLesson['id']));
        }

        $language = (new LanguageRepository())->find((int) $module['language_id']);
        Session::notify('success', 'মডিউল সম্পন্ন হয়েছে! 🎉');
        return $this->redirect(url('/courses/' . $language['slug']));
    }

    /**
     * POST /lessons/{id}/quiz — [G][P] grades server-side and awards XP on a
     * fully-correct submission (once per lesson, tracked via quiz_attempts,
     * independent of completion status). Purely optional bonus practice —
     * never marks the lesson completed and never blocks moving on; see
     * complete() above for that.
     */
    public function submitQuiz(Request $request, string $id): Response
    {
        $lessonId = (int) $id;
        $userId   = (int) $this->currentUserId();

        $resolved = $this->resolveGatedLesson($lessonId, $userId);
        if ($resolved instanceof Response) {
            return $resolved;
        }
        ['lesson' => $lesson, 'module' => $module] = $resolved;
        $language = (new LanguageRepository())->find((int) $module['language_id']);

        $qRepo     = new QuizQuestionRepository();
        $correct   = $qRepo->correctOptionsForLesson($lessonId);
        $submitted = $request->input('answers') ?? [];

        $scoreTotal   = count($correct);
        $scoreCorrect = 0;
        foreach ($correct as $questionId => $correctOptionId) {
            $given = (int) ($submitted[$questionId] ?? 0);
            if ($given === $correctOptionId) {
                $scoreCorrect++;
            }
        }
        $passed = $scoreTotal > 0 && $scoreCorrect === $scoreTotal;

        // Per-question breakdown for the result view. Safe to reveal
        // is_correct/explanation here — grading already happened above;
        // this never runs before submission.
        $questions = $qRepo->forLessonWithAnswers($lessonId);
        foreach ($questions as &$q) {
            $chosenId = (int) ($submitted[$q['id']] ?? 0);
            $q['chosen_option_id'] = $chosenId ?: null;
            $q['is_correct'] = $chosenId === ($correct[$q['id']] ?? 0);
        }
        unset($q);

        $attemptRepo = new QuizAttemptRepository();
        $xpAwarded   = 0;
        if ($passed && !$attemptRepo->hasBeenRewarded($userId, $lessonId)) {
            $xpAwarded = XpService::award($userId, 'quiz', $lessonId, (int) $lesson['xp_reward']);
        }
        $attemptRepo->create($userId, $lessonId, $scoreCorrect, $scoreTotal, $xpAwarded);

        return $this->view('lessons/quiz-result', [
            'title'        => $lesson['title_bn'],
            'lesson'       => $lesson,
            'module'       => $module,
            'language'     => $language,
            'questions'    => $questions,
            'passed'       => $passed,
            'scoreTotal'   => $scoreTotal,
            'scoreCorrect' => $scoreCorrect,
            'xpAwarded'    => $xpAwarded,
        ]);
    }
}
