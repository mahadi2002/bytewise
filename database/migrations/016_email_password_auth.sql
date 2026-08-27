-- Replace phone+OTP auth with standard email+password (rebrand: this is a
-- free, login-or-registered-only hobby app, no carrier/SMS dependency at
-- all). Pre-launch — no real user data to preserve, so this is a
-- straightforward destructive column swap, not a backfill migration.

-- The single-column UNIQUE index on mobile_hash cannot outlive its column;
-- drop it explicitly first for clarity even though MySQL would also drop it
-- automatically when the column itself is dropped below.
ALTER TABLE users DROP INDEX uq_users_mobile_hash;

ALTER TABLE users
    DROP COLUMN mobile_encrypted,
    DROP COLUMN mobile_hash,
    DROP COLUMN operator,
    ADD COLUMN email VARCHAR(191) NOT NULL AFTER id,
    ADD COLUMN password_hash VARCHAR(255) NOT NULL AFTER email,
    ADD UNIQUE KEY uq_users_email (email);

DROP TABLE IF EXISTS otp_requests;

-- Password-reset tokens: single-use, short-lived, hashed at rest (never the
-- raw token — same "never store the secret itself" pattern as
-- otp_requests.otp_hash used to follow).
CREATE TABLE password_resets (
    id          BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    user_id     BIGINT UNSIGNED NOT NULL,
    token_hash  CHAR(64) NOT NULL,
    expires_at  DATETIME NOT NULL,
    consumed_at DATETIME NULL,
    created_at  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    KEY idx_password_resets_user (user_id),
    KEY idx_password_resets_token_hash (token_hash),
    CONSTRAINT fk_password_resets_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
