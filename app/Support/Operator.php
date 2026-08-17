<?php
declare(strict_types=1);

namespace App\Support;

/**
 * BTRC operator prefix map — Robi (018) / Airtel (016) only, per BUILD-SPEC
 * §8. Flagged in TODO.md BLOCKER-3 as needing independent verification
 * before launch; prefixes can change.
 */
final class Operator
{
    public static function fromMobile(string $mobile): ?string
    {
        return match (substr($mobile, 0, 3)) {
            '018'   => 'robi',
            '016'   => 'airtel',
            default => null,
        };
    }
}
