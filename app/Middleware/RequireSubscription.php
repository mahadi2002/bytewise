<?php
declare(strict_types=1);

namespace App\Middleware;

use App\Core\Request;
use App\Core\Response;
use App\Core\Session;
use App\Services\SubscriptionService;

/**
 * Gated-route guard. Status is re-read from the DB on every request (never
 * session-cached) — a subscription lapsing mid-session must lose access on
 * its very next gated request, per BUILD-SPEC §8's edge-case matrix.
 */
final class RequireSubscription implements Middleware
{
    public function handle(Request $request, callable $next): Response
    {
        $userId = Session::userId();
        if ($userId === null) {
            return Response::redirect(url('/'));
        }

        if (!SubscriptionService::hasAccess($userId)) {
            return Response::redirect(url('/account'));
        }

        return $next($request);
    }
}
