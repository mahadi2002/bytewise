CREATE TABLE users (
    id                  BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    mobile_encrypted    VARBINARY(512) NOT NULL,
    mobile_hash         CHAR(64) NOT NULL,
    operator            ENUM('robi','airtel') NOT NULL,
    display_name        VARCHAR(100) NULL,
    status               ENUM('active','suspended','deleted') NOT NULL DEFAULT 'active',
    created_at          DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at          DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    last_seen_at        DATETIME NULL,
    UNIQUE KEY uq_users_mobile_hash (mobile_hash)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE otp_requests (
    id                  BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    mobile_hash         CHAR(64) NOT NULL,
    otp_hash            VARCHAR(255) NOT NULL,
    purpose             ENUM('subscribe','admin_2fa_recovery') NOT NULL DEFAULT 'subscribe',
    attempt_count       TINYINT UNSIGNED NOT NULL DEFAULT 0,
    max_attempts        TINYINT UNSIGNED NOT NULL DEFAULT 5,
    expires_at          DATETIME NOT NULL,
    consumed_at         DATETIME NULL,
    request_ip          VARBINARY(16) NOT NULL,
    created_at          DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    KEY idx_otp_mobile_hash (mobile_hash),
    KEY idx_otp_expires (expires_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE sessions (
    id                  CHAR(64) PRIMARY KEY,
    user_id             BIGINT UNSIGNED NULL,
    admin_user_id       BIGINT UNSIGNED NULL,
    payload             MEDIUMTEXT NOT NULL,
    ip_address          VARBINARY(16) NULL,
    user_agent          VARCHAR(255) NULL,
    last_activity_at    DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_at          DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    KEY idx_sessions_user (user_id),
    KEY idx_sessions_admin (admin_user_id),
    KEY idx_sessions_activity (last_activity_at),
    CONSTRAINT fk_sessions_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE rate_limits (
    id                  BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    bucket_key          VARCHAR(191) NOT NULL,
    action               VARCHAR(64) NOT NULL,
    window_started_at   DATETIME NOT NULL,
    hit_count            INT UNSIGNED NOT NULL DEFAULT 1,
    UNIQUE KEY uq_rate_limits_bucket_action_window (bucket_key, action, window_started_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE admin_users (
    id                  BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    email               VARCHAR(191) NOT NULL,
    password_hash       VARCHAR(255) NOT NULL,
    totp_secret_encrypted VARBINARY(255) NOT NULL,
    role                ENUM('admin','support') NOT NULL DEFAULT 'admin',
    status               ENUM('active','disabled') NOT NULL DEFAULT 'active',
    created_at          DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    last_login_at       DATETIME NULL,
    UNIQUE KEY uq_admin_users_email (email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
