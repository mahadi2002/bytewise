<?php
declare(strict_types=1);

namespace App\Controllers;

use App\Core\Controller;
use App\Core\Db;
use App\Core\Request;
use App\Core\Response;
use App\Core\Session;
use App\Repositories\DiscussionPostRepository;
use App\Repositories\LanguageRepository;
use App\Repositories\ProblemRepository;
use App\Services\TrackAccessService;

final class ProblemController extends Controller
{
    /**
     * GET /problems/{id} — [G] statement + starter code. For a
     * language-locked problem, the language is fixed and shown as a
     * fact. For a language-agnostic problem (Data Structures/Algorithms,
     * problems.language_id IS NULL — BUILD-SPEC §9), a picker lets the
     * student choose among the 6 executable languages before submitting;
     * there is no per-language starter code to preload since the schema
     * has nowhere to store one for an agnostic problem.
     */
    public function show(Request $request, string $id): Response
    {
        $problem = (new ProblemRepository())->findForViewer((int) $id, $this->isAuthenticated());
        if ($problem === null || !array_key_exists('statement_md', $problem)) {
            $this->notFound();
        }

        if (!TrackAccessService::isUnlocked($this->currentUserId())) {
            Session::notify('info', 'This track is not available right now.');
            return $this->redirect(url('/dashboard'));
        }

        $isAgnostic = $problem['language_id'] === null;
        $language   = $isAgnostic ? null : (new LanguageRepository())->find((int) $problem['language_id']);
        $pickableLanguages = $isAgnostic ? $this->executableLanguages() : [];

        $discussionCount = (new DiscussionPostRepository())->countForContext('problem', (int) $problem['id']);

        return $this->view('problems/show', [
            'title'              => $problem['title_bn'],
            'problem'            => $problem,
            'language'           => $language,
            'isAgnostic'         => $isAgnostic,
            'pickableLanguages'  => $pickableLanguages,
            'discussionCount'    => $discussionCount,
            'extraScripts'       => ['dist/editor.js'],
        ]);
    }

    /** The 6 real executable languages (excludes the is_meta_track=1 rows, which have no judge_language_code). */
    private function executableLanguages(): array
    {
        return Db::all('SELECT * FROM languages WHERE is_meta_track = 0 AND is_published = 1 ORDER BY launch_order ASC');
    }
}
