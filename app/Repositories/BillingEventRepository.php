<?php
declare(strict_types=1);

namespace App\Repositories;

use App\Core\Db;

final class BillingEventRepository
{
    public function log(int $subscriptionId, string $eventType, ?int $amountPaisa = null, ?string $gatewayRawRef = null): int
    {
        return Db::insert(
            'INSERT INTO billing_events (subscription_id, event_type, amount_paisa, gateway_raw_ref) VALUES (?, ?, ?, ?)',
            [$subscriptionId, $eventType, $amountPaisa, $gatewayRawRef]
        );
    }
}
