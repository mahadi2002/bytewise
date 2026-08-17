<?php
declare(strict_types=1);

namespace App\Controllers;

use App\Core\Controller;
use App\Core\RateLimit;
use App\Core\Request;
use App\Core\Response;
use App\Core\Session;
use App\Core\Validator;
use App\Exceptions\HttpException;
use App\Repositories\LanguageRepository;
use App\Repositories\ProblemRepository;
use App\Repositories\SubmissionRepository;
use App\Repositories\SubmissionTestResultRepository;
use App\Services\SubmissionService;
use App\Services\TrackAccessService;

final class SubmissionController extends Controller
{
    /** POST /problems/{id}/submit — [G][P] rate-limited, validates language_id server-side. */
    public function submit(Request $request, string $id): Response
    {
        $userId = (int) $this->currentUserId();

        $hourWait = RateLimit::tooMany('code_submit', 'user:' . $userId);
        $dayWait  = RateLimit::tooMany('code_submit_day', 'user:' . $userId);
        if ($hourWait !== null || $dayWait !== null) {
            throw new HttpException(429, 'অনেকবার সাবমিট করা হয়েছে। একটু পর আবার চেষ্টা করুন।');
        }
        RateLimit::hit('code_submit', 'user:' . $userId);
        RateLimit::hit('code_submit_day', 'user:' . $userId);

        $problem = (new ProblemRepository())->find((int) $id);
        if ($problem === null) {
            $this->notFound();
        }

        // Defense in depth — ProblemController already blocks reaching the
        // form for a locked track, but a direct POST (bookmarked, replayed)
        // must be rejected here too, not just at the GET.
        if (!TrackAccessService::checkProblem($problem, $userId)['unlocked']) {
            throw new HttpException(403, 'এই ট্র্যাকটি এখনো লক করা আছে।');
        }

        $v = Validator::make($request->body(), [
            'language_id'  => 'required|int',
            'source_code'  => 'required|max:65000',
        ]);
        if ($v->fails()) {
            Session::notify('error', $v->firstError() ?? 'ইনপুট সঠিক নয়।');
            return $this->redirect(url('/problems/' . $id));
        }

        $languageId = (int) $v->get('language_id');

        // Never trust submissions.language_id from the client for a
        // language-locked problem — rejected before it ever reaches the
        // gateway (anti-drift checklist item).
        SubmissionService::assertLanguageAllowed($problem, $languageId);

        $language = (new LanguageRepository())->find($languageId);
        if ($language === null || $language['judge_language_code'] === null) {
            throw new HttpException(422, 'অসমর্থিত ভাষা।');
        }

        $submissionId = SubmissionService::submit($userId, $problem, $languageId, (string) $language['judge_language_code'], $v->get('source_code'));

        return $this->redirect(url('/submissions/' . $submissionId));
    }

    /** GET /submissions/{id} — [G] poll endpoint. JSON when the client asks for it, HTML otherwise. */
    public function show(Request $request, string $id): Response
    {
        $userId     = (int) $this->currentUserId();
        $repo       = new SubmissionRepository();
        $submission = $repo->findForUser((int) $id, $userId);

        if ($submission === null) {
            $this->notFound();
        }

        $submission = SubmissionService::refreshStatus($submission);

        $testResults = in_array($submission['status'], ['passed', 'failed'], true)
            ? (new SubmissionTestResultRepository())->forSubmissionPublic((int) $submission['id'])
            : [];

        if ($request->wantsJson()) {
            return $this->json([
                'status'       => $submission['status'],
                'passed_count' => (int) $submission['passed_count'],
                'total_count'  => (int) $submission['total_count'],
                'stderr'       => $submission['stderr_excerpt'],
                'xp_awarded'   => (int) $submission['xp_awarded'],
                'test_results' => array_map(static fn(array $r): array => [
                    'passed'  => (bool) $r['passed'],
                    'is_hidden' => (bool) $r['is_hidden'],
                    'output'  => $r['actual_stdout_excerpt'],
                ], $testResults),
            ]);
        }

        return $this->view('problems/submission', [
            'title'      => 'সাবমিশন ফলাফল',
            'submission' => $submission,
            'testResults'=> $testResults,
        ]);
    }
}
