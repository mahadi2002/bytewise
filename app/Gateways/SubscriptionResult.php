<?php
declare(strict_types=1);

namespace App\Gateways;

final readonly class SubscriptionResult
{
    public function __construct(
        public bool $success,
        public ?string $externalRef,
        public string $status,
    ) {
    }
}
