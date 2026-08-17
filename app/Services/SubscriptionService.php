<?php
declare(strict_types=1);

namespace App\Services;

use App\Repositories\BillingEventRepository;
use App\Repositories\SubscriptionRepository;

/**
 * Every gated request re-reads from the DB — hasAccess() is a query, never
 * a cached session flag, so a lapsed subscription loses access on its very
 * next gated request (BUILD-SPEC §8 edge-case matrix).
 */
final class SubscriptionService
{
    public static function hasAccess(int $userId): bool
    {
        return (new SubscriptionRepository())->findActive($userId) !== null;
    }

    public static function current(int $userId): ?array
    {
        return (new SubscriptionRepository())->latest($userId);
    }

    /** Called right after OtpService::verify() succeeds and the gateway confirms. */
    public static function activate(int $userId, ?string $externalRef, string $status): array
    {
        $repo  = new SubscriptionRepository();
        $id    = $repo->create($userId, $status, $externalRef);
        $event = match ($status) {
            'active' => 'charge_success',
            default  => 'charge_failed',
        };

        (new BillingEventRepository())->log(
            $id,
            $event,
            (int) round(((float) config('gateway.daily_amount', 2.78)) * 100),
            $externalRef
        );

        return (array) $repo->latest($userId);
    }

    /** Reachable from every subscription state, including 'pending' — BUILD-SPEC §8. */
    public static function unsubscribe(int $userId, string $via = 'in_app'): void
    {
        $repo = new SubscriptionRepository();
        $sub  = $repo->latest($userId);
        if ($sub === null || $sub['status'] === 'unsubscribed') {
            return;
        }

        $repo->setUnsubscribed((int) $sub['id'], $via);
        (new BillingEventRepository())->log((int) $sub['id'], 'unsubscribed');

        // Deliberately does NOT call Session::revokeAllForUser() here: unlike
        // an app with zero free tier, Bytewise has substantial free content
        // (Lesson 1 previews, placement test, /account itself) a
        // non-subscribed student must keep browsing. Gated-content access is
        // already revoked on the very next gated request because
        // RequireSubscription re-queries hasAccess() from the DB every time
        // — killing the session here would just force an unrelated full
        // logout across every device the student is signed in on.
    }
}
