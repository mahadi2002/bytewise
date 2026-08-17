CREATE TABLE contact_messages (
    id                  BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    user_id               BIGINT UNSIGNED NULL,
    name                    VARCHAR(100) NOT NULL,
    email_or_mobile           VARCHAR(191) NOT NULL,
    message                     TEXT NOT NULL,
    status                       ENUM('new','read','resolved') NOT NULL DEFAULT 'new',
    honeypot_tripped               TINYINT(1) NOT NULL DEFAULT 0,
    created_at                       DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    resolved_at                       DATETIME NULL,
    KEY idx_contact_messages_status (status),
    CONSTRAINT fk_contact_messages_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE audit_log (
    id                  BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    actor_type             ENUM('admin','system') NOT NULL,
    actor_id                 BIGINT UNSIGNED NULL,
    action                     VARCHAR(100) NOT NULL,
    target_type                 VARCHAR(64) NULL,
    target_id                     BIGINT UNSIGNED NULL,
    meta_json                       JSON NULL,
    ip_address                       VARBINARY(16) NULL,
    occurred_at                       DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    KEY idx_audit_log_action (action),
    KEY idx_audit_log_occurred (occurred_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
