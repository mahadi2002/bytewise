<?php
declare(strict_types=1);

namespace App\Gateways;

final readonly class OtpRequestResult
{
    public function __construct(
        public bool $sent,
    ) {
    }
}
