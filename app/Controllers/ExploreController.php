<?php
declare(strict_types=1);

namespace App\Controllers;

use App\Core\Controller;
use App\Core\Request;
use App\Core\Response;
use App\Repositories\LanguageRepository;
use App\Services\SkillTreeService;

/**
 * Free, ungated catalog — /explore (all 8 tracks) and /explore/{track}
 * (one track's module/lesson skill-tree shape, every node locked for a
 * visitor per BUILD-SPEC §3's free-vs-gated matrix).
 */
final class ExploreController extends Controller
{
    public function index(Request $request): Response
    {
        $languages = (new LanguageRepository())->all();

        return $this->view('courses/explore', [
            'title'     => 'ট্র্যাক এক্সপ্লোর করুন',
            'languages' => $languages,
        ]);
    }

    public function show(Request $request, string $track): Response
    {
        $language = (new LanguageRepository())->findBySlug($track);
        if ($language === null) {
            $this->notFound();
        }

        // A logged-in student has a real skill tree at /courses/{track} —
        // sending them here instead would show every node locked regardless
        // of their actual progress, which contradicted /explore's own index
        // page.
        if ($this->isAuthenticated()) {
            return $this->redirect(url('/courses/' . $track));
        }

        // Visitor teaser: SkillTreeService::build(..., null) locks every node.
        $tree = SkillTreeService::build((int) $language['id'], null);

        return $this->view('courses/track', [
            'title'    => $language['name_bn'],
            'language' => $language,
            'tree'     => $tree,
            'gated'    => true,
        ]);
    }
}
