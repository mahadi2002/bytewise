<?php
declare(strict_types=1);

namespace App\Core;

use SessionHandlerInterface;

/**
 * DB-backed session handler (the `sessions` table from 02-SCHEMA.sql).
 * Separate namespaces in one row: user_id for students, admin_user_id for
 * admins — a lapsed subscription or disabled admin loses access on its very
 * next request because status is always re-read from the DB, never cached
 * in the session payload.
 */
final class Session implements SessionHandlerInterface
{
    private static bool $started = false;
    private static ?array $flashRead = null;
    private static ?Request $request = null;

    public static function start(Request $request): void
    {
        if (self::$started || PHP_SAPI === 'cli') {
            return;
        }

        self::$request = $request;

        session_set_save_handler(new self(), true);
        session_name((string) config('app.session.cookie', 'bytewise_session'));
        session_set_cookie_params([
            'lifetime' => 0,
            'path'     => '/',
            'domain'   => '',
            'secure'   => (bool) config('app.session.secure', true),
            'httponly' => true,
            'samesite' => 'Lax',
        ]);

        ini_set('session.use_strict_mode', '1');
        ini_set('session.use_only_cookies', '1');
        ini_set('session.gc_maxlifetime', (string) (((int) config('app.session.lifetime_minutes', 120)) * 60));

        session_start();
        self::$started = true;

        self::$flashRead = $_SESSION['_flash'] ?? [];
        unset($_SESSION['_flash']);
    }

    public static function get(string $key, mixed $default = null): mixed
    {
        return $_SESSION[$key] ?? $default;
    }

    public static function put(string $key, mixed $value): void
    {
        $_SESSION[$key] = $value;
    }

    public static function forget(string $key): void
    {
        unset($_SESSION[$key]);
    }

    public static function userId(): ?int
    {
        $id = $_SESSION['user_id'] ?? null;
        return $id === null ? null : (int) $id;
    }

    public static function adminUserId(): ?int
    {
        $id = $_SESSION['admin_user_id'] ?? null;
        return $id === null ? null : (int) $id;
    }

    public static function regenerate(): void
    {
        if (self::$started) {
            session_regenerate_id(true);
        }
    }

    /** Queue a value for the *next* request only. */
    public static function flash(string $key, mixed $value): void
    {
        $_SESSION['_flash'][$key] = $value;
    }

    public static function flashGet(string $key, mixed $default = null): mixed
    {
        return self::$flashRead[$key] ?? $default;
    }

    /** ['type' => 'success'|'error'|'info', 'text' => '…'] */
    public static function notify(string $type, string $text): void
    {
        self::flash('_notice', ['type' => $type, 'text' => $text]);
    }

    public static function notice(): ?array
    {
        $n = self::flashGet('_notice');
        return is_array($n) ? $n : null;
    }

    public static function destroyAll(): void
    {
        $_SESSION = [];
        if (ini_get('session.use_cookies')) {
            $p = session_get_cookie_params();
            setcookie(session_name(), '', [
                'expires'  => time() - 42000,
                'path'     => $p['path'],
                'domain'   => $p['domain'],
                'secure'   => $p['secure'],
                'httponly' => $p['httponly'],
                'samesite' => 'Lax',
            ]);
        }
        session_destroy();
        self::$started = false;
    }

    // ── SessionHandlerInterface ──────────────────────────────────────────

    public function open(string $path, string $name): bool
    {
        return true;
    }

    public function close(): bool
    {
        return true;
    }

    public function read(string $id): string|false
    {
        $row = Db::first(
            'SELECT payload FROM sessions WHERE id = ? AND last_activity_at > DATE_SUB(NOW(), INTERVAL ? MINUTE)',
            [$id, (int) config('app.session.lifetime_minutes', 120)]
        );
        return $row === null ? '' : (string) $row['payload'];
    }

    public function write(string $id, string $data): bool
    {
        $userId  = isset($_SESSION['user_id']) ? (int) $_SESSION['user_id'] : null;
        $adminId = isset($_SESSION['admin_user_id']) ? (int) $_SESSION['admin_user_id'] : null;

        Db::exec(
            'INSERT INTO sessions (id, user_id, admin_user_id, payload, ip_address, user_agent, last_activity_at, created_at)
             VALUES (?, ?, ?, ?, INET6_ATON(?), ?, NOW(), NOW())
             ON DUPLICATE KEY UPDATE
                user_id = VALUES(user_id),
                admin_user_id = VALUES(admin_user_id),
                payload = VALUES(payload),
                last_activity_at = VALUES(last_activity_at)',
            [
                $id,
                $userId,
                $adminId,
                $data,
                self::$request?->ip() ?? '127.0.0.1',
                self::$request?->userAgent() ?? '',
            ]
        );

        return true;
    }

    public function destroy(string $id): bool
    {
        Db::exec('DELETE FROM sessions WHERE id = ?', [$id]);
        return true;
    }

    public function gc(int $maxLifetime): int|false
    {
        return Db::exec('DELETE FROM sessions WHERE last_activity_at < DATE_SUB(NOW(), INTERVAL ? MINUTE)', [
            (int) config('app.session.lifetime_minutes', 120),
        ]);
    }
}
