<?php
declare(strict_types=1);

/**
 * Global helper functions. Loaded once by bootstrap.php before anything else.
 */

if (!function_exists('e')) {
    /** The mandatory escape helper. Every echo of a variable goes through this. */
    function e(?string $v): string
    {
        return htmlspecialchars($v ?? '', ENT_QUOTES | ENT_SUBSTITUTE | ENT_HTML5, 'UTF-8');
    }
}

if (!function_exists('env')) {
    /** Read a value from the parsed .env. Never call getenv() elsewhere. */
    function env(string $key, mixed $default = null): mixed
    {
        return \App\Core\Env::get($key, $default);
    }
}

if (!function_exists('config')) {
    /** config('app.env') — dot path into config/config.php (single file for this app). */
    function config(string $path, mixed $default = null): mixed
    {
        static $all = null;
        if ($all === null) {
            $all = require APP_ROOT . '/config/config.php';
        }

        $value = $all;
        foreach (explode('.', $path) as $part) {
            if (!is_array($value) || !array_key_exists($part, $value)) {
                return $default;
            }
            $value = $value[$part];
        }
        return $value;
    }
}

if (!function_exists('url')) {
    /** Absolute URL for a path within the app. */
    function url(string $path = '/'): string
    {
        $base = (string) config('app.url', '');
        return $base . '/' . ltrim($path, '/');
    }
}

if (!function_exists('asset')) {
    /** Cache-busted asset URL. */
    function asset(string $path): string
    {
        $path = '/assets/' . ltrim($path, '/');
        $file = APP_ROOT . '/public' . $path;
        $ver  = is_file($file) ? (string) filemtime($file) : '1';
        return $path . '?v=' . $ver;
    }
}

if (!function_exists('bn_num')) {
    /** Latin digits -> Bangla digits. Prices and mobile numbers stay Latin. */
    function bn_num(int|float|string $n): string
    {
        return strtr((string) $n, [
            '0' => '০', '1' => '১', '2' => '২', '3' => '৩', '4' => '৪',
            '5' => '৫', '6' => '৬', '7' => '৭', '8' => '৮', '9' => '৯',
        ]);
    }
}

if (!function_exists('bn_date')) {
    /**
     * Format a DATETIME/DATE column in Bangla digits. Storage is Asia/Dhaka
     * wall-clock time (the migration session sets time_zone='+06:00', see
     * 02-SCHEMA.sql), so no UTC conversion happens here — this reads the
     * stored value as-is, unlike apps that store UTC and convert at render.
     */
    function bn_date(?string $datetime, bool $withTime = false): string
    {
        if (!$datetime) {
            return '—';
        }
        $ts = strtotime($datetime);
        if ($ts === false) {
            return '—';
        }
        $months = [
            1 => 'জানুয়ারি', 'ফেব্রুয়ারি', 'মার্চ', 'এপ্রিল', 'মে', 'জুন',
            'জুলাই', 'আগস্ট', 'সেপ্টেম্বর', 'অক্টোবর', 'নভেম্বর', 'ডিসেম্বর',
        ];
        $out = bn_num(date('d', $ts)) . ' ' . $months[(int) date('n', $ts)] . ' ' . bn_num(date('Y', $ts));
        if ($withTime) {
            $out .= ', ' . bn_num(date('h:i', $ts)) . ' ' . (date('a', $ts) === 'am' ? 'পূর্বাহ্ণ' : 'অপরাহ্ণ');
        }
        return $out;
    }
}

if (!function_exists('old')) {
    /** Re-populate a form field after a validation failure. */
    function old(string $key, string $default = ''): string
    {
        $old = \App\Core\Session::flashGet('_old') ?? [];
        return (string) ($old[$key] ?? $default);
    }
}

if (!function_exists('errors')) {
    function errors(): array
    {
        return \App\Core\Session::flashGet('_errors') ?? [];
    }
}

if (!function_exists('error_for')) {
    function error_for(string $field): ?string
    {
        $all = errors();
        return isset($all[$field]) ? (string) $all[$field][0] : null;
    }
}

if (!function_exists('csrf_field')) {
    function csrf_field(): string
    {
        return '<input type="hidden" name="_token" value="' . e(\App\Core\Csrf::token()) . '">';
    }
}

if (!function_exists('str_excerpt')) {
    /** Multibyte-safe excerpt that does not cut a Bangla word in half. */
    function str_excerpt(?string $text, int $chars = 180): string
    {
        $text = trim(preg_replace('/\s+/u', ' ', strip_tags((string) $text)) ?? '');
        if (mb_strlen($text, 'UTF-8') <= $chars) {
            return $text;
        }
        $cut = mb_substr($text, 0, $chars, 'UTF-8');
        $sp  = mb_strrpos($cut, ' ', 0, 'UTF-8');
        return rtrim($sp !== false ? mb_substr($cut, 0, $sp, 'UTF-8') : $cut, ' ,।-') . '…';
    }
}

if (!function_exists('mask_msisdn')) {
    /** 01712345678 -> 017XXXXX78 — the only form a mobile number takes in admin list views. */
    function mask_msisdn(string $msisdn): string
    {
        if (strlen($msisdn) !== 11) {
            return $msisdn;
        }
        return substr($msisdn, 0, 3) . 'XXXXX' . substr($msisdn, -2);
    }
}

if (!function_exists('price_line')) {
    /**
     * Single source of truth for every price-disclosure string in the app —
     * see BUILD-SPEC §9. $variant: 'short' (header CTA) | 'full' (everywhere else).
     */
    function price_line(string $variant = 'full'): string
    {
        $amount = number_format((float) config('gateway.daily_amount', 2.78), 2);
        return $variant === 'short'
            ? 'মাত্র ৳' . $amount . '/day'
            : 'Daily ৳' . $amount . ' (Incl. VAT, SD & SC) মাত্র';
    }
}

if (!function_exists('dd')) {
    function dd(mixed ...$vars): never
    {
        if (!config('app.debug')) {
            http_response_code(500);
            exit;
        }
        header('Content-Type: text/plain; charset=utf-8');
        foreach ($vars as $v) {
            var_dump($v);
        }
        exit;
    }
}
