<?php
declare(strict_types=1);

namespace App\Controllers;

use App\Core\Controller;
use App\Core\Request;
use App\Core\Response;
use App\Repositories\DailyChallengeRepository;
use App\Repositories\LanguageRepository;

final class DailyChallengeController extends Controller
{
    public function index(Request $request): Response
    {
        $languages = (new LanguageRepository())->all();
        $repo      = new DailyChallengeRepository();
        $today     = date('Y-m-d');

        $challenges = [];
        foreach ($languages as $lang) {
            $challenges[] = [
                'language'  => $lang,
                'challenge' => $repo->forLanguageAndDate((int) $lang['id'], $today),
            ];
        }

        return $this->view('problems/daily-challenge', [
            'title'      => 'ডেইলি চ্যালেঞ্জ',
            'challenges' => $challenges,
        ]);
    }
}
