<?php
declare(strict_types=1);

namespace App\Repositories;

use App\Core\Db;

final class SubscriptionRepository
{
    public function latest(int $userId): ?array
    {
        return Db::first('SELECT * FROM subscriptions WHERE user_id = ? ORDER BY id DESC LIMIT 1', [$userId]);
    }

    public function findActive(int $userId): ?array
    {
        return Db::first(
            "SELECT * FROM subscriptions WHERE user_id = ? AND status IN ('active','grace') ORDER BY id DESC LIMIT 1",
            [$userId]
        );
    }

    public function create(int $userId, string $status, ?string $externalRef): int
    {
        $id = Db::insert(
            'INSERT INTO subscriptions (user_id, status, gateway_external_ref, activated_at) VALUES (?, ?, ?, ?)',
            [$userId, $status, $externalRef, $status === 'active' ? Db::now() : null]
        );
        return $id;
    }

    public function setStatus(int $id, string $status): void
    {
        $column = match ($status) {
            'active'       => 'activated_at',
            'grace'        => 'grace_started_at',
            'expired'      => 'expired_at',
            'unsubscribed' => 'unsubscribed_at',
            default        => null,
        };

        if ($column === null) {
            Db::exec('UPDATE subscriptions SET status = ? WHERE id = ?', [$status, $id]);
            return;
        }

        Db::exec("UPDATE subscriptions SET status = ?, {$column} = NOW() WHERE id = ?", [$status, $id]);
    }

    public function setUnsubscribed(int $id, string $via): void
    {
        Db::exec(
            "UPDATE subscriptions SET status = 'unsubscribed', unsubscribed_at = NOW(), unsubscribed_via = ? WHERE id = ?",
            [$via, $id]
        );
    }

    /** Subscriptions whose grace window has elapsed — used by the daily grace-sweep cron job. */
    public function graceExpiredBefore(string $cutoff): array
    {
        return Db::all("SELECT * FROM subscriptions WHERE status = 'grace' AND grace_started_at < ?", [$cutoff]);
    }
}
