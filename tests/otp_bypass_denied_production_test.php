<?php
declare(strict_types=1);

/**
 * Concrete verification for 04-AI-BUILD-PLAYBOOK.md Phase 3 acceptance
 * criterion: OTP_BYPASS_CODE must be rejected when APP_ENV != local, even
 * when the value is present in .env (the exact "left on by mistake in
 * staging" risk the rulebook flags). Run with a production-flavored .env
 * swapped in (see the session's Phase 3 test procedure) — never against the
 * real dev .env.
 *
 * Inserts an OTP row directly via the repository (bypassing
 * SubscriptionGateway::requestOtp, which fails loud under the unconfigured
 * CarrierGateway — a separate, already-verified behavior) so this test
 * isolates exactly the guard under test: OtpService::verify()'s
 * APP_ENV === 'local' check.
 *
 *   php tests/otp_bypass_denied_production_test.php
 */

define('APP_ROOT', dirname(__DIR__));
require APP_ROOT . '/app/bootstrap.php';

use App\Core\Crypto;
use App\Exceptions\OtpException;
use App\Repositories\OtpRequestRepository;
use App\Services\OtpService;

if (config('app.env') !== 'production') {
    fwrite(STDERR, "ABORT: this test must run with APP_ENV=production loaded — got '" . config('app.env') . "'.\n");
    exit(2);
}

$mobile = '01899999998';
$realCode = '000111'; // deliberately NOT equal to OTP_BYPASS_CODE (123456)

(new OtpRequestRepository())->create(
    Crypto::blindIndex($mobile),
    password_hash($realCode, PASSWORD_DEFAULT),
    'subscribe',
    300,
    '127.0.0.1'
);

// Attempt to verify using the bypass code — must NOT be accepted just
// because it matches OTP_BYPASS_CODE; it must fall through to the real
// hash check and fail, since $realCode != bypass code.
try {
    (new OtpService())->verify($mobile, (string) config('app.otp_bypass_code', ''), 'test-ip-hash');
    fwrite(STDERR, "SECURITY FAILURE: OTP_BYPASS_CODE was accepted under APP_ENV=production.\n");
    exit(1);
} catch (OtpException $e) {
    fwrite(STDOUT, "OK: bypass code rejected under APP_ENV=production — " . $e->getMessage() . "\n");
    exit(0);
}
