<?php
declare(strict_types=1);

namespace App\Core;

/**
 * Fixed-window rate limiting on the `rate_limits` table (bucket_key,
 * action, window_started_at, hit_count — see 02-SCHEMA.sql). MySQL-backed,
 * no Redis assumption on shared hosting.
 */
final class RateLimit
{
    /** action => [limit, window seconds] — defaults mirror config('rate_limits'). */
    private static function buckets(): array
    {
        $c = (array) config('rate_limits', []);
        return [
            'login'                  => ['limit' => (int) ($c['login']['per_15min'] ?? 5), 'window' => 900],
            'register'               => ['limit' => (int) ($c['register']['per_15min'] ?? 5), 'window' => 900],
            'password_reset_request' => ['limit' => (int) ($c['password_reset_request']['per_hour'] ?? 3), 'window' => 3600],
            'admin_login'      => ['limit' => (int) ($c['admin_login']['per_15min'] ?? 5), 'window' => 900],
            'contact_form'     => ['limit' => (int) ($c['contact_form']['per_hour'] ?? 3), 'window' => 3600],
            'code_submit'      => ['limit' => (int) ($c['code_submit']['per_hour'] ?? 20), 'window' => 3600],
            'code_submit_day'  => ['limit' => (int) ($c['code_submit']['per_day'] ?? 100), 'window' => 86400],
            'discussion_post'  => ['limit' => (int) ($c['discussion_post']['per_hour'] ?? 10), 'window' => 3600],
        ];
    }

    /** @return int|null seconds until the caller may retry, or null when allowed */
    public static function hit(string $action, string $key): ?int
    {
        $def = self::buckets()[$action] ?? ['limit' => 60, 'window' => 60];
        $windowSeconds = (int) $def['window'];
        $limit         = (int) $def['limit'];

        $now         = time();
        $windowStart = $now - ($now % $windowSeconds);
        $bucketKey   = substr($key, 0, 180);
        $windowDt    = date('Y-m-d H:i:s', $windowStart);

        Db::exec(
            'INSERT INTO rate_limits (bucket_key, action, window_started_at, hit_count) VALUES (?, ?, ?, 1)
             ON DUPLICATE KEY UPDATE hit_count = hit_count + 1',
            [$bucketKey, $action, $windowDt]
        );

        $hits = (int) Db::value(
            'SELECT hit_count FROM rate_limits WHERE bucket_key = ? AND action = ? AND window_started_at = ?',
            [$bucketKey, $action, $windowDt]
        );

        if ($hits > $limit) {
            return ($windowStart + $windowSeconds) - $now;
        }

        return null;
    }

    /** Check without consuming a hit. */
    public static function tooMany(string $action, string $key): ?int
    {
        $def = self::buckets()[$action] ?? ['limit' => 60, 'window' => 60];
        $windowSeconds = (int) $def['window'];
        $limit         = (int) $def['limit'];

        $now         = time();
        $windowStart = $now - ($now % $windowSeconds);
        $bucketKey   = substr($key, 0, 180);

        $hits = (int) Db::value(
            'SELECT hit_count FROM rate_limits WHERE bucket_key = ? AND action = ? AND window_started_at = ?',
            [$bucketKey, $action, date('Y-m-d H:i:s', $windowStart)]
        );

        return $hits >= $limit ? ($windowStart + $windowSeconds) - $now : null;
    }

    public static function humanWait(int $seconds): string
    {
        if ($seconds < 60) {
            return bn_num(max(1, $seconds)) . ' সেকেন্ড';
        }
        if ($seconds < 3600) {
            return bn_num((int) ceil($seconds / 60)) . ' মিনিট';
        }
        return bn_num((int) ceil($seconds / 3600)) . ' ঘণ্টা';
    }
}
