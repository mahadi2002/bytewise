<?php
declare(strict_types=1);

return [
    'app' => [
        'name'        => env('APP_NAME', 'বাইটওয়াইজ'),
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

        'mail_from' => env('MAIL_FROM', 'no-reply@bytewise.example'),
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
        'execution' => env('EXECUTION_GATEWAY', 'mock'),
    ],

    'execution' => [
        'remote_judge' => [
            'base_url'          => env('REMOTE_JUDGE_BASE_URL', ''),
            'api_key'           => env('REMOTE_JUDGE_API_KEY', ''),
            'timeout_seconds'   => (int) env('REMOTE_JUDGE_TIMEOUT_SECONDS', 10),
        ],
    ],

    'rate_limits' => [
        'login'                  => ['per_15min' => (int) env('RATE_LIMIT_LOGIN_PER_15MIN', 5)],
        'register'               => ['per_15min' => (int) env('RATE_LIMIT_REGISTER_PER_15MIN', 5)],
        'password_reset_request' => ['per_hour' => (int) env('RATE_LIMIT_PASSWORD_RESET_PER_HOUR', 3)],
        'admin_login'     => ['per_15min' => (int) env('RATE_LIMIT_ADMIN_LOGIN_PER_15MIN', 5)],
        'contact_form'    => ['per_hour' => (int) env('RATE_LIMIT_CONTACT_FORM_PER_HOUR', 3)],
        'code_submit'     => ['per_hour' => (int) env('RATE_LIMIT_CODE_SUBMIT_PER_HOUR', 20), 'per_day' => (int) env('RATE_LIMIT_CODE_SUBMIT_PER_DAY', 100)],
        'discussion_post' => ['per_hour' => (int) env('RATE_LIMIT_DISCUSSION_POST_PER_HOUR', 10)],
    ],
];
