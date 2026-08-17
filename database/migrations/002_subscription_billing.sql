CREATE TABLE subscriptions (
    id                  BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    user_id             BIGINT UNSIGNED NOT NULL,
    status               ENUM('pending','active','grace','expired','unsubscribed') NOT NULL DEFAULT 'pending',
    gateway_external_ref VARCHAR(191) NULL,
    activated_at        DATETIME NULL,
    grace_started_at    DATETIME NULL,
    expired_at          DATETIME NULL,
    unsubscribed_at     DATETIME NULL,
    unsubscribed_via    ENUM('in_app','sms_stop','admin') NULL,
    created_at          DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at          DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    KEY idx_subscriptions_user (user_id),
    KEY idx_subscriptions_status (status),
    CONSTRAINT fk_subscriptions_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE billing_events (
    id                  BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    subscription_id     BIGINT UNSIGNED NOT NULL,
    event_type          ENUM('charge_success','charge_failed','otp_requested','otp_confirmed','unsubscribed','grace_entered','expired') NOT NULL,
    amount_paisa        INT UNSIGNED NULL,
    gateway_raw_ref      VARCHAR(191) NULL,
    occurred_at          DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    KEY idx_billing_events_subscription (subscription_id),
    CONSTRAINT fk_billing_events_subscription FOREIGN KEY (subscription_id) REFERENCES subscriptions(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE jobs (
    id                  BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    job_name            VARCHAR(100) NOT NULL,
    run_date            DATE NOT NULL,
    status               ENUM('running','done','failed') NOT NULL DEFAULT 'running',
    started_at          DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    finished_at         DATETIME NULL,
    error_message        TEXT NULL,
    UNIQUE KEY uq_jobs_name_date (job_name, run_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
