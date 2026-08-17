<?php
declare(strict_types=1);

namespace App\Controllers;

use App\Core\Controller;
use App\Core\Request;
use App\Core\Response;
use App\Core\Session;
use App\Services\SubscriptionService;

/**
 * Reachable in every subscription state (BUILD-SPEC §2/§5) — no `sub`
 * middleware gate on either route, only `auth`. Status is always re-read
 * from the DB (SubscriptionService::current), never session-cached.
 */
final class AccountController extends Controller
{
    public function index(Request $request): Response
    {
        $userId = (int) $this->currentUserId();
        $sub    = SubscriptionService::current($userId);

        return $this->view('account/show', [
            'title'        => 'আমার অ্যাকাউন্ট',
            'subscription' => $sub,
        ]);
    }

    public function unsubscribeForm(Request $request): Response
    {
        $userId = (int) $this->currentUserId();
        $sub    = SubscriptionService::current($userId);

        return $this->view('account/unsubscribe', [
            'title'        => 'Unsubscribe',
            'subscription' => $sub,
        ]);
    }

    public function unsubscribe(Request $request): Response
    {
        $userId = (int) $this->currentUserId();
        SubscriptionService::unsubscribe($userId, 'in_app');

        Session::notify('info', 'আপনার Subscription বন্ধ করা হয়েছে। যেকোনো সময় আবার Subscribe করতে পারবেন।');
        return $this->redirect(url('/account'));
    }
}
