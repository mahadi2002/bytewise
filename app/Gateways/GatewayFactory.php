<?php
declare(strict_types=1);

namespace App\Gateways;

/** Single .env-driven switch (EXECUTION_GATEWAY=mock|remote_judge) — never a code change. */
final class GatewayFactory
{
    private static ?CodeExecutionGateway $execution = null;

    public static function execution(): CodeExecutionGateway
    {
        if (self::$execution instanceof CodeExecutionGateway) {
            return self::$execution;
        }

        self::$execution = match ((string) config('gateways.execution', 'mock')) {
            'remote_judge' => new RemoteJudgeGateway(),
            default        => new MockExecutionGateway(),
        };

        return self::$execution;
    }
}
