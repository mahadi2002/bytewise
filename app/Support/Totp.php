<?php
declare(strict_types=1);

namespace App\Support;

/**
 * RFC 6238 TOTP (HMAC-SHA1, 30s step, 6 digits) — hand-rolled, zero
 * Composer dependencies, compatible with any standard authenticator app
 * (Google Authenticator, Authy, etc.). Secrets are Base32-encoded per the
 * spec's otpauth:// URI convention, stored encrypted (Crypto::encrypt) in
 * admin_users.totp_secret_encrypted — this class never touches storage.
 */
final class Totp
{
    private const DIGITS = 6;
    private const PERIOD = 30;
    private const BASE32_ALPHABET = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ234567';

    public static function generateSecret(int $bytes = 20): string
    {
        return self::base32Encode(random_bytes($bytes));
    }

    /** Accepts codes from the previous, current, and next 30s window to tolerate clock drift. */
    public static function verify(string $secret, string $code, int $window = 1): bool
    {
        if (!preg_match('/^\d{6}$/', $code)) {
            return false;
        }

        $counter = (int) floor(time() / self::PERIOD);

        for ($i = -$window; $i <= $window; $i++) {
            if (hash_equals(self::code($secret, $counter + $i), $code)) {
                return true;
            }
        }

        return false;
    }

    public static function code(string $secret, ?int $counter = null): string
    {
        $counter ??= (int) floor(time() / self::PERIOD);
        $key = self::base32Decode($secret);

        $binCounter = pack('N*', 0) . pack('N*', $counter);
        $hash       = hash_hmac('sha1', $binCounter, $key, true);

        $offset = ord($hash[19]) & 0x0F;
        $truncated = (ord($hash[$offset]) & 0x7F) << 24
            | (ord($hash[$offset + 1]) & 0xFF) << 16
            | (ord($hash[$offset + 2]) & 0xFF) << 8
            | (ord($hash[$offset + 3]) & 0xFF);

        return str_pad((string) ($truncated % (10 ** self::DIGITS)), self::DIGITS, '0', STR_PAD_LEFT);
    }

    /** otpauth://totp/Bytewise:{label}?secret={secret}&issuer=Bytewise&digits=6&period=30 */
    public static function otpauthUri(string $secret, string $label): string
    {
        return sprintf(
            'otpauth://totp/Bytewise:%s?secret=%s&issuer=Bytewise&digits=%d&period=%d',
            rawurlencode($label),
            $secret,
            self::DIGITS,
            self::PERIOD
        );
    }

    private static function base32Encode(string $data): string
    {
        $bits = '';
        foreach (str_split($data) as $byte) {
            $bits .= str_pad(decbin(ord($byte)), 8, '0', STR_PAD_LEFT);
        }

        $output = '';
        foreach (str_split($bits, 5) as $chunk) {
            $chunk = str_pad($chunk, 5, '0', STR_PAD_RIGHT);
            $output .= self::BASE32_ALPHABET[bindec($chunk)];
        }

        return $output;
    }

    private static function base32Decode(string $secret): string
    {
        $secret = strtoupper((string) preg_replace('/[^A-Z2-7]/i', '', $secret));

        $bits = '';
        foreach (str_split($secret) as $char) {
            $pos = strpos(self::BASE32_ALPHABET, $char);
            if ($pos === false) {
                continue;
            }
            $bits .= str_pad(decbin($pos), 5, '0', STR_PAD_LEFT);
        }

        $bytes = '';
        foreach (str_split($bits, 8) as $chunk) {
            if (strlen($chunk) < 8) {
                continue;
            }
            $bytes .= chr((int) bindec($chunk));
        }

        return $bytes;
    }
}
