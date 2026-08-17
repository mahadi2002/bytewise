<?php
declare(strict_types=1);

namespace App\Controllers;

use App\Core\Controller;
use App\Core\Request;
use App\Core\Response;
use App\Repositories\LeaderboardRepository;

final class LeaderboardController extends Controller
{
    public function index(Request $request): Response
    {
        $userId = $this->currentUserId();
        $top    = (new LeaderboardRepository())->top(20);

        return $this->view('leaderboard/index', [
            'title'          => 'লিডারবোর্ড',
            'entries'        => $top,
            'currentUserId'  => $userId,
        ]);
    }
}
