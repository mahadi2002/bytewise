<?php
declare(strict_types=1);

namespace App\Controllers;

use App\Core\Controller;
use App\Core\Request;
use App\Core\Response;
use App\Repositories\UserRepository;

/**
 * Plain account page — no subscription state to show any more, just the
 * logged-in user's own details.
 */
final class AccountController extends Controller
{
    public function index(Request $request): Response
    {
        $user = (new UserRepository())->find((int) $this->currentUserId());

        return $this->view('account/show', [
            'title' => 'আমার অ্যাকাউন্ট',
            'user'  => $user,
        ]);
    }
}
