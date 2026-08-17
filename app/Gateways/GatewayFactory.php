<?php
declare(strict_types=1);

namespace App\Gateways;

/** Single .env-driven switch (SUBSCRIPTION_GATEWAY=mock|carrier) — never a code change. */
final class GatewayFactory
{
    private static ?SubscriptionGateway $subscription = null;
    private static ?CodeExecutionGateway $execution = null;

    public static function subscription(): SubscriptionGateway
    {
        if (self::$subscription instanceof SubscriptionGateway) {
            return self::$subscription;
        }

        self::$subscription = match ((string) config('gateways.subscription', 'mock')) {
            'carrier' => new CarrierGateway(),
            default   => new MockSubscriptionGateway(),
        };

        return self::$subscription;
    }

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
