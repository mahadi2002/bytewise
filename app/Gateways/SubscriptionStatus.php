<?php
declare(strict_types=1);

namespace App\Gateways;

final readonly class SubscriptionStatus
{
    public function __construct(
        public string $status,
    ) {
    }
}
