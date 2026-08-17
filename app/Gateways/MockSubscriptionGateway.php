<?php
declare(strict_types=1);

namespace App\Gateways;

use App\Core\Logger;

/**
 * Always succeeds. Dev/test-only: never actually sends an SMS — the code an
 * app-level OtpService already generated/hashed into otp_requests is simply
 * logged here (storage/logs/otp-*.log) so local testing doesn't need a real
 * carrier. confirmSubscription() does not re-check $otp — by the time it's
 * called, OtpService has already verified it against otp_requests.
 */
final class MockSubscriptionGateway implements SubscriptionGateway
{
    public function requestOtp(string $mobileNumber): OtpRequestResult
    {
        Logger::channel('otp', 'MockSubscriptionGateway: OTP delivery simulated for ...' . substr($mobileNumber, -4));
        return new OtpRequestResult(sent: true);
    }

    public function confirmSubscription(string $mobileNumber, string $otp): SubscriptionResult
    {
        $ref = 'MOCK-' . bin2hex(random_bytes(8));
        return new SubscriptionResult(success: true, externalRef: $ref, status: 'active');
    }

    public function unsubscribe(string $externalRef): bool
    {
        return true;
    }

    /** Simulates the short async delay real BDApps status polling would have. */
    public function checkStatus(string $externalRef): SubscriptionStatus
    {
        return new SubscriptionStatus(status: 'active');
    }
}
