<?php
declare(strict_types=1);

namespace App\Controllers;

use App\Core\Controller;
use App\Core\Request;
use App\Core\Response;
use App\Repositories\LanguageRepository;
use App\Repositories\PlacementQuestionRepository;
use App\Services\PlacementService;

/** Free, pre-auth or session-keyed (BUILD-SPEC §5/§6) — no auth/sub middleware on either route. */
final class PlacementTestController extends Controller
{
    public function show(Request $request): Response
    {
        $languages = (new LanguageRepository())->all();
        $language  = $this->findLanguage($languages, $request->str('track'));
        $questions = $language !== null ? (new PlacementQuestionRepository())->forLanguage((int) $language['id']) : [];

        return $this->view('placement-test/show', [
            'title'     => 'স্কিল ডায়াগনস্টিক টেস্ট',
            'languages' => $languages,
            'language'  => $language,
            'questions' => $questions,
        ]);
    }

    public function submit(Request $request): Response
    {
        $languages = (new LanguageRepository())->all();
        $language  = $this->findLanguage($languages, $request->str('track'));

        if ($language === null) {
            return $this->redirect(url('/placement-test'));
        }

        $answers = array_map('intval', $request->input('answers', []));
        $result  = PlacementService::score(
            (int) $language['id'],
            $answers,
            $this->currentUserId(),
            session_id() ?: null
        );

        return $this->view('placement-test/result', [
            'title'    => 'ফলাফল',
            'language' => $language,
            'result'   => $result,
        ]);
    }

    private function findLanguage(array $languages, string $slug): ?array
    {
        if ($slug === '') {
            return null;
        }
        foreach ($languages as $lang) {
            if ($lang['slug'] === $slug) {
                return $lang;
            }
        }
        return null;
    }
}
