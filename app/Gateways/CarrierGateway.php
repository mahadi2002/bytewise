<?php
declare(strict_types=1);

namespace App\Gateways;

use App\Exceptions\GatewayException;

/**
 * Real BDApps/SDP integration — generic name per rulebook §3 vendor-
 * neutrality rule (never a specific vendor's name, even as a placeholder).
 * Fails loud immediately on any call while unconfigured — never silently
 * falls back to mock behavior in production. See TODO.md BLOCKER-1: the
 * real request/response shape is not guessed at here.
 */
final class CarrierGateway implements SubscriptionGateway
{
    public function __construct()
    {
        if ((string) config('gateway.carrier.base_url', '') === '') {
            throw new GatewayException(
                'CarrierGateway is not configured — CARRIER_GATEWAY_BASE_URL is empty. '
                . 'The real BDApps/SDP API contract has not been obtained yet (see TODO.md BLOCKER-1); '
                . 'never guess the request/response shape.'
            );
        }
    }

    public function requestOtp(string $mobileNumber): OtpRequestResult
    {
        throw new GatewayException('CarrierGateway::requestOtp is a stub — real BDApps/SDP API docs required.');
    }

    public function confirmSubscription(string $mobileNumber, string $otp): SubscriptionResult
    {
        throw new GatewayException('CarrierGateway::confirmSubscription is a stub — real BDApps/SDP API docs required.');
    }

    public function unsubscribe(string $externalRef): bool
    {
        throw new GatewayException('CarrierGateway::unsubscribe is a stub — real BDApps/SDP API docs required.');
    }

    public function checkStatus(string $externalRef): SubscriptionStatus
    {
        throw new GatewayException('CarrierGateway::checkStatus is a stub — real BDApps/SDP API docs required.');
    }
}
