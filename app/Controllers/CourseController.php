<?php
declare(strict_types=1);

namespace App\Controllers;

use App\Core\Controller;
use App\Core\Request;
use App\Core\Response;
use App\Core\Session;
use App\Repositories\LanguageRepository;
use App\Repositories\LessonRepository;
use App\Repositories\ModuleRepository;
use App\Repositories\UserLessonProgressRepository;
use App\Services\SkillTreeService;
use App\Services\TrackAccessService;

final class CourseController extends Controller
{
    public function show(Request $request, string $track): Response
    {
        $language = (new LanguageRepository())->findBySlug($track);
        if ($language === null) {
            $this->notFound();
        }

        $userId = $this->currentUserId();
        $access = TrackAccessService::check((int) $language['id'], $userId);
        if (!$access['unlocked']) {
            Session::notify('info', TrackAccessService::lockMessage($access['reason']));
            return $this->redirect(url('/dashboard'));
        }

        $tree = SkillTreeService::build((int) $language['id'], $userId);

        return $this->view('courses/track', [
            'title'    => $language['name_bn'],
            'language' => $language,
            'tree'     => $tree,
            'gated'    => false,
        ]);
    }

    /**
     * GET /courses/{track}/{moduleSlug} — the page that was missing
     * entirely: a module's lesson list, each lesson linking to
     * /lessons/{id}. Without this, the skill tree had nowhere to send a
     * click — every node was a bare <span>, and the only way to reach a
     * lesson was to already know its numeric id.
     */
    public function module(Request $request, string $track, string $moduleSlug): Response
    {
        $language = (new LanguageRepository())->findBySlug($track);
        if ($language === null) {
            $this->notFound();
        }

        $userId = $this->currentUserId();
        $access = TrackAccessService::check((int) $language['id'], $userId);
        if (!$access['unlocked']) {
            Session::notify('info', TrackAccessService::lockMessage($access['reason']));
            return $this->redirect(url('/dashboard'));
        }

        $module = (new ModuleRepository())->findBySlug((int) $language['id'], $moduleSlug);
        if ($module === null) {
            $this->notFound();
        }

        // Module-level lock (previous module not yet complete) — same rule
        // SkillTreeService already computes for the tree view; re-derive it
        // here by finding this module's node rather than duplicating the
        // sequential-unlock logic a second time.
        $tree = SkillTreeService::build((int) $language['id'], $userId);
        $node = null;
        foreach ($tree as $candidate) {
            if ((int) $candidate['module']['id'] === (int) $module['id']) {
                $node = $candidate;
                break;
            }
        }
        if ($node === null || $node['state'] === 'locked') {
            Session::notify('info', 'এই মডিউলটি এখনো লক করা আছে — আগের মডিউল সম্পূর্ণ করুন।');
            return $this->redirect(url('/courses/' . $track));
        }

        $lessons = (new LessonRepository())->forModule((int) $module['id']);
        $progressByLesson = (new UserLessonProgressRepository())->forModule((int) $userId, (int) $module['id']);

        return $this->view('courses/module', [
            'title'    => $module['title_bn'],
            'language' => $language,
            'module'   => $module,
            'lessons'  => $lessons,
            'progress' => $progressByLesson,
        ]);
    }
}
