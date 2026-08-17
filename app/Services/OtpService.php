<?php
declare(strict_types=1);

namespace App\Services;

use App\Core\Crypto;
use App\Core\RateLimit;
use App\Exceptions\OtpException;
use App\Gateways\GatewayFactory;
use App\Repositories\OtpRequestRepository;

/**
 * App-owned OTP round-trip (6-digit, hashed at rest, 5-min TTL, attempt cap
 * — rulebook §5 standard). SubscriptionGateway::requestOtp() only triggers
 * delivery (SMS); this class generates, hashes, stores, rate-limits and
 * verifies the code itself, then the caller proceeds to
 * SubscriptionGateway::confirmSubscription() once verify() succeeds.
 *
 * Rate limits are keyed on mobile+IP together (BUILD-SPEC §5: "3/hour +
 * 8/day per number+IP") — a single combined key here, not a separate
 * IP-only check bolted on via middleware, so each action is rate-limited
 * exactly once.
 */
final class OtpService
{
    private const PURPOSE_SUBSCRIBE = 'subscribe';

    public function request(string $mobile, string $ipHash): void
    {
        $key = Crypto::blindIndex($mobile) . ':' . $ipHash;

        $hourWait = RateLimit::tooMany('otp_request', $key);
        if ($hourWait !== null) {
            throw new OtpException('অনেকবার চেষ্টা হয়েছে। ' . RateLimit::humanWait($hourWait) . ' পর আবার চেষ্টা করুন।');
        }
        $dayWait = RateLimit::tooMany('otp_request_day', $key);
        if ($dayWait !== null) {
            throw new OtpException('আজকের জন্য OTP অনুরোধের সীমা শেষ। আগামীকাল আবার চেষ্টা করুন।');
        }
        RateLimit::hit('otp_request', $key);
        RateLimit::hit('otp_request_day', $key);

        $mobileHash = Crypto::blindIndex($mobile);
        $repo = new OtpRequestRepository();
        $repo->invalidatePending($mobileHash, self::PURPOSE_SUBSCRIBE);

        $code = str_pad((string) random_int(0, 999999), 6, '0', STR_PAD_LEFT);
        $ttl  = (int) config('app.otp.ttl', 300) ?: 300;

        $repo->create($mobileHash, password_hash($code, PASSWORD_DEFAULT), self::PURPOSE_SUBSCRIBE, $ttl, (string) ($_SERVER['REMOTE_ADDR'] ?? '127.0.0.1'));

        GatewayFactory::subscription()->requestOtp($mobile);
        \App\Core\Logger::channel('otp', 'Generated OTP for ...' . substr($mobile, -4) . ' (local dev only, never logged in production channel content)');

        // Local dev convenience: echo the code to a file so it doesn't require
        // reading raw hashes. Never happens outside APP_ENV=local.
        if (config('app.env') === 'local') {
            \App\Core\Logger::channel('otp-dev-codes', '...' . substr($mobile, -4) . ' => ' . $code);
        }
    }

    public function resend(string $mobile, string $ipHash): void
    {
        $key = Crypto::blindIndex($mobile) . ':' . $ipHash;
        $wait = RateLimit::tooMany('otp_resend', $key);
        if ($wait !== null) {
            throw new OtpException(RateLimit::humanWait($wait) . ' পর আবার OTP পাঠানো যাবে।');
        }
        RateLimit::hit('otp_resend', $key);
        $this->request($mobile, $ipHash);
    }

    /** @throws OtpException on wrong/expired/exhausted code */
    public function verify(string $mobile, string $code, string $ipHash): void
    {
        // OTP_BYPASS_CODE path — ONLY when APP_ENV=local, checked here (not in
        // the gateway) so swapping SUBSCRIPTION_GATEWAY can never bypass this
        // guard. See tests/otp_bypass_denied_production_test.php for the
        // production check.
        $bypass = (string) config('app.otp_bypass_code', '');
        if (config('app.env') === 'local' && $bypass !== '' && hash_equals($bypass, $code)) {
            (new OtpRequestRepository())->invalidatePending(Crypto::blindIndex($mobile), self::PURPOSE_SUBSCRIBE);
            return;
        }

        $mobileHash = Crypto::blindIndex($mobile);
        $key = $mobileHash . ':' . $ipHash;
        $wait = RateLimit::tooMany('otp_verify', $key);
        if ($wait !== null) {
            throw new OtpException('অনেকবার চেষ্টা হয়েছে। ' . RateLimit::humanWait($wait) . ' পর আবার চেষ্টা করুন।');
        }

        $repo = new OtpRequestRepository();
        $row  = $repo->latestPending($mobileHash, self::PURPOSE_SUBSCRIBE);

        RateLimit::hit('otp_verify', $key);

        if ($row === null) {
            throw new OtpException('কোড পাওয়া যায়নি। নতুন কোড চান।');
        }

        if ((int) $row['attempt_count'] >= (int) $row['max_attempts']) {
            throw new OtpException('অনেকবার ভুল হয়েছে। নতুন কোড চান।');
        }

        if (strtotime((string) $row['expires_at']) < time()) {
            throw new OtpException('কোড মেয়াদোত্তীর্ণ, নতুন কোড চান।');
        }

        if (!password_verify($code, (string) $row['otp_hash'])) {
            $repo->incrementAttempts((int) $row['id']);
            throw new OtpException('কোড মিলছে না। আবার চেষ্টা করুন।');
        }

        $repo->markConsumed((int) $row['id']);
    }
}
