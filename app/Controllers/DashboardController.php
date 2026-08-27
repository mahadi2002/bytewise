<?php
declare(strict_types=1);

namespace App\Controllers;

use App\Core\Controller;
use App\Core\Request;
use App\Core\Response;
use App\Repositories\DailyChallengeRepository;
use App\Repositories\LanguageRepository;
use App\Repositories\UserLessonProgressRepository;
use App\Services\SkillTreeService;
use App\Services\StreakService;
use App\Services\XpService;

/**
 * GET /dashboard — BUILD-SPEC §5: skill tree per track, XP, streak, daily
 * challenge card. This was in the locked route table from the start but
 * never actually got built during the phased implementation — the gap
 * surfaced when a real login left a subscriber with nowhere to go.
 */
final class DashboardController extends Controller
{
    public function index(Request $request): Response
    {
        $userId = (int) $this->currentUserId();

        $languages = (new LanguageRepository())->all();
        $trees = [];
        foreach ($languages as $lang) {
            $trees[] = [
                'language' => $lang,
                'tree'     => SkillTreeService::build((int) $lang['id'], $userId),
            ];
        }

        $today = date('Y-m-d');
        $dcRepo = new DailyChallengeRepository();
        $dailyChallenges = [];
        foreach ($languages as $lang) {
            $dc = $dcRepo->forLanguageAndDate((int) $lang['id'], $today);
            if ($dc !== null) {
                $dailyChallenges[] = ['language' => $lang, 'challenge' => $dc];
            }
        }

        $continueLesson = (new UserLessonProgressRepository())->mostRecentIncomplete($userId);

        return $this->view('dashboard/index', [
            'title'          => 'ড্যাশবোর্ড',
            'trees'          => $trees,
            'xpTotal'        => XpService::total($userId),
            'streak'         => StreakService::current($userId),
            'daily'          => $dailyChallenges,
            'continueLesson' => $continueLesson,
        ]);
    }
}
