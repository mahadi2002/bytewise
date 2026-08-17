<?php
declare(strict_types=1);

return [
    'app' => [
        'name'        => 'Bytewise',
        'env'         => env('APP_ENV', 'production'),
        'debug'       => env('APP_ENV', 'production') === 'local',
        'key'         => base64_decode((string) env('APP_KEY', ''), true) ?: '',
        'hash_pepper' => base64_decode((string) env('HASH_PEPPER', ''), true) ?: '',
        'url'         => rtrim((string) env('APP_URL', ''), '/'),
        'timezone'    => env('APP_TIMEZONE', 'Asia/Dhaka'),
        'trusted_proxies' => env('TRUSTED_PROXIES', ''),

        'session' => [
            'cookie'          => env('SESSION_COOKIE_NAME', 'bytewise_session'),
            'lifetime_minutes' => (int) env('SESSION_LIFETIME_MINUTES', 120),
            'secure'          => (bool) env('SESSION_SECURE_COOKIE', true),
        ],

        'otp_bypass_code' => env('OTP_BYPASS_CODE', ''),

        'mail' => [
            'from_address'          => env('MAIL_FROM_ADDRESS', 'no-reply@bytewise.example'),
            'contact_notify_email'  => env('CONTACT_INBOX_NOTIFY_EMAIL', ''),
        ],
    ],

    'db' => [
        'host'     => env('DB_HOST', '127.0.0.1'),
        'port'     => (int) env('DB_PORT', 3306),
        'database' => env('DB_DATABASE', 'bytewise'),
        'username' => env('DB_USERNAME', 'bytewise_app'),
        'password' => (string) env('DB_PASSWORD', ''),
        'charset'  => 'utf8mb4',
        'collation' => 'utf8mb4_unicode_ci',
    ],

    'migrate_db' => [
        'username' => env('DB_MIGRATE_USERNAME', env('DB_USERNAME', 'bytewise_migrate')),
        'password' => (string) env('DB_MIGRATE_PASSWORD', env('DB_PASSWORD', '')),
    ],

    'gateways' => [
        'subscription' => env('SUBSCRIPTION_GATEWAY', 'mock'),
        'execution'    => env('EXECUTION_GATEWAY', 'mock'),
    ],

    'gateway' => [
        // ৳2.78/day — locked price, see BUILD-SPEC §9 price_line() helper.
        'daily_amount' => 2.78,
        'shortcode'    => '16216',
        'carrier' => [
            'base_url'    => env('CARRIER_GATEWAY_BASE_URL', ''),
            'api_key'     => env('CARRIER_GATEWAY_API_KEY', ''),
            'merchant_id' => env('CARRIER_GATEWAY_MERCHANT_ID', ''),
        ],
    ],

    'execution' => [
        'remote_judge' => [
            'base_url'          => env('REMOTE_JUDGE_BASE_URL', ''),
            'api_key'           => env('REMOTE_JUDGE_API_KEY', ''),
            'timeout_seconds'   => (int) env('REMOTE_JUDGE_TIMEOUT_SECONDS', 10),
        ],
    ],

    'rate_limits' => [
        'otp_request'     => ['per_hour' => (int) env('RATE_LIMIT_OTP_REQUEST_PER_HOUR', 3), 'per_day' => (int) env('RATE_LIMIT_OTP_REQUEST_PER_DAY', 8)],
        'otp_verify'      => ['per_15min' => (int) env('RATE_LIMIT_OTP_VERIFY_PER_15MIN', 5)],
        'otp_resend'      => ['cooldown_seconds' => (int) env('RATE_LIMIT_OTP_RESEND_COOLDOWN_SECONDS', 60)],
        'admin_login'     => ['per_15min' => (int) env('RATE_LIMIT_ADMIN_LOGIN_PER_15MIN', 5)],
        'contact_form'    => ['per_hour' => (int) env('RATE_LIMIT_CONTACT_FORM_PER_HOUR', 3)],
        'code_submit'     => ['per_hour' => (int) env('RATE_LIMIT_CODE_SUBMIT_PER_HOUR', 20), 'per_day' => (int) env('RATE_LIMIT_CODE_SUBMIT_PER_DAY', 100)],
        'discussion_post' => ['per_hour' => (int) env('RATE_LIMIT_DISCUSSION_POST_PER_HOUR', 10)],
    ],
];
