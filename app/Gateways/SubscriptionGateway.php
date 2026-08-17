<?php
declare(strict_types=1);

namespace App\Gateways;

/** Per 03-ENV-AND-CONFIG.md §4 — locked contract, do not change signatures. */
interface SubscriptionGateway
{
    public function requestOtp(string $mobileNumber): OtpRequestResult;

    public function confirmSubscription(string $mobileNumber, string $otp): SubscriptionResult;

    public function unsubscribe(string $externalRef): bool;

    public function checkStatus(string $externalRef): SubscriptionStatus;
}
