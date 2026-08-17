<?php
declare(strict_types=1);

namespace App\Controllers;

use App\Core\Controller;
use App\Core\Request;
use App\Core\Response;
use App\Repositories\DailyChallengeRepository;
use App\Repositories\LanguageRepository;
use App\Services\SkillTreeService;
use App\Services\StreakService;
use App\Services\TrackAccessService;
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
            $access = TrackAccessService::check((int) $lang['id'], $userId);
            $trees[] = [
                'language' => $lang,
                'tree'     => SkillTreeService::build((int) $lang['id'], $userId),
                'unlocked' => $access['unlocked'],
                'reason'   => $access['reason'],
            ];
        }

        // Unlocked (actionable) tracks first, so "what's next" isn't buried
        // after 6 locked cards — matches how freeCodeCamp/Odin surface the
        // current step rather than a flat alphabetical/id list.
        usort($trees, static fn(array $a, array $b): int => (int) $b['unlocked'] <=> (int) $a['unlocked']);

        $today = date('Y-m-d');
        $dcRepo = new DailyChallengeRepository();
        $dailyChallenges = [];
        foreach ($languages as $lang) {
            $dc = $dcRepo->forLanguageAndDate((int) $lang['id'], $today);
            if ($dc !== null) {
                $dailyChallenges[] = ['language' => $lang, 'challenge' => $dc];
            }
        }

        return $this->view('dashboard/index', [
            'title'    => 'ড্যাশবোর্ড',
            'trees'    => $trees,
            'xpTotal'  => XpService::total($userId),
            'streak'   => StreakService::current($userId),
            'daily'    => $dailyChallenges,
        ]);
    }
}
