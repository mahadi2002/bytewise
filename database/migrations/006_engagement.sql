CREATE TABLE user_lesson_progress (
    user_id             BIGINT UNSIGNED NOT NULL,
    lesson_id           INT UNSIGNED NOT NULL,
    status               ENUM('not_started','in_progress','completed') NOT NULL DEFAULT 'not_started',
    completed_at         DATETIME NULL,
    updated_at           DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, lesson_id),
    KEY idx_user_lesson_progress_lesson (lesson_id),
    CONSTRAINT fk_ulp_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT fk_ulp_lesson FOREIGN KEY (lesson_id) REFERENCES lessons(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE xp_ledger (
    id                  BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    user_id               BIGINT UNSIGNED NOT NULL,
    source_type             ENUM('quiz','problem','daily_challenge','streak_bonus') NOT NULL,
    source_id                 BIGINT UNSIGNED NULL,
    xp_amount                   SMALLINT NOT NULL,
    created_at                    DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    KEY idx_xp_ledger_user (user_id),
    CONSTRAINT fk_xp_ledger_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE user_streaks (
    user_id               BIGINT UNSIGNED PRIMARY KEY,
    current_streak_days     SMALLINT UNSIGNED NOT NULL DEFAULT 0,
    longest_streak_days       SMALLINT UNSIGNED NOT NULL DEFAULT 0,
    last_activity_date           DATE NULL,
    CONSTRAINT fk_user_streaks_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE discussion_posts (
    id                  BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    user_id               BIGINT UNSIGNED NOT NULL,
    context_type            ENUM('lesson','problem') NOT NULL,
    context_id                INT UNSIGNED NOT NULL,
    parent_post_id              BIGINT UNSIGNED NULL,
    body_md                       TEXT NOT NULL,
    is_pinned                      TINYINT(1) NOT NULL DEFAULT 0,
    is_hidden_by_admin               TINYINT(1) NOT NULL DEFAULT 0,
    created_at                        DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    KEY idx_discussion_posts_context (context_type, context_id),
    KEY idx_discussion_posts_parent (parent_post_id),
    CONSTRAINT fk_discussion_posts_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT fk_discussion_posts_parent FOREIGN KEY (parent_post_id) REFERENCES discussion_posts(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
