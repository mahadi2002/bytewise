<?php
declare(strict_types=1);

/**
 * For each of the 8 tracks, picks one is_daily_eligible=1 problem the
 * current subscriber base hasn't seen as a daily challenge in the last 14
 * days, inserts a daily_challenges row for today. A single global daily
 * problem per track (not per-user random) keeps the leaderboard comparable
 * — BUILD-SPEC §6. Runs inside cron/run-jobs.php's job guard (once/day)
 * and try/catch — no local error handling here.
 */

use App\Core\Db;
use App\Repositories\DailyChallengeRepository;

const RECENT_AVOID_DAYS = 14;

$repo  = new DailyChallengeRepository();
$today = date('Y-m-d');

$languages = Db::all('SELECT id FROM languages WHERE is_published = 1');

foreach ($languages as $lang) {
    $languageId = (int) $lang['id'];

    if ($repo->forLanguageAndDate($languageId, $today) !== null) {
        continue; // already rotated for this track today (defensive; job guard already covers this)
    }

    $recent    = $repo->recentProblemIds($languageId, RECENT_AVOID_DAYS);
    $eligible  = $repo->eligibleProblemIds($languageId, $recent);

    if ($eligible === []) {
        // No fresh problem available (small seed pool) — fall back to
        // ignoring the recent-avoidance window rather than skipping the
        // track's daily challenge entirely.
        $eligible = $repo->eligibleProblemIds($languageId, []);
    }

    if ($eligible === []) {
        continue; // genuinely no daily-eligible problem exists for this track yet
    }

    $problemId = $eligible[array_rand($eligible)];
    $repo->create($languageId, $problemId, $today);
}
