<?php
declare(strict_types=1);

namespace App\Core;

use Throwable;

/**
 * Daily rotating file logger.
 *
 * NEVER log: a password, a password-reset token, a session id, a
 * submission's raw source code, or APP_KEY/HASH_PEPPER — a log file is the
 * easiest place for a secret to leak.
 */
final class Logger
{
    public static function info(string $message, array $context = []): void
    {
        self::write('info', $message, $context);
    }

    public static function warning(string $message, array $context = []): void
    {
        self::write('warning', $message, $context);
    }

    public static function error(string $message, array $context = []): void
    {
        self::write('error', $message, $context);
    }

    public static function exception(Throwable $e, array $context = []): void
    {
        self::write('error', get_class($e) . ': ' . $e->getMessage(), $context + [
            'file'  => $e->getFile() . ':' . $e->getLine(),
            'trace' => explode("\n", $e->getTraceAsString()),
        ]);
    }

    /** MockExecutionGateway writes dev-only detail here. */
    public static function channel(string $channel, string $message): void
    {
        self::append($channel, date('c') . ' ' . $message . PHP_EOL);
    }

    private static function write(string $level, string $message, array $context): void
    {
        $line = sprintf(
            '[%s] %s: %s %s%s',
            date('c'),
            strtoupper($level),
            $message,
            $context === [] ? '' : (string) json_encode(self::scrub($context), JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES),
            PHP_EOL
        );

        self::append('app', $line);
    }

    private static function scrub(array $context): array
    {
        $blocked = ['password', 'password_confirmation',
            'app_key', 'hash_pepper', 'secret', 'token', 'source_code', 'totp_secret'];

        foreach ($context as $key => $value) {
            if (in_array(strtolower((string) $key), $blocked, true)) {
                $context[$key] = '[redacted]';
            } elseif (is_array($value)) {
                $context[$key] = self::scrub($value);
            }
        }
        return $context;
    }

    private static function append(string $channel, string $line): void
    {
        $dir = APP_ROOT . '/storage/logs';
        if (!is_dir($dir)) {
            @mkdir($dir, 0750, true);
        }
        @file_put_contents($dir . '/' . $channel . '-' . date('Y-m-d') . '.log', $line, FILE_APPEND | LOCK_EX);
    }
}
