CREATE TABLE quiz_questions (
    id                  INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    lesson_id           INT UNSIGNED NOT NULL,
    question_bn          TEXT NOT NULL,
    question_en          TEXT NULL,
    code_snippet          TEXT NULL,
    sort_order            TINYINT UNSIGNED NOT NULL DEFAULT 1,
    KEY idx_quiz_questions_lesson (lesson_id),
    CONSTRAINT fk_quiz_questions_lesson FOREIGN KEY (lesson_id) REFERENCES lessons(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE quiz_options (
    id                  INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    question_id          INT UNSIGNED NOT NULL,
    option_label          CHAR(1) NOT NULL,
    option_text_bn        VARCHAR(255) NOT NULL,
    is_correct             TINYINT(1) NOT NULL DEFAULT 0,
    KEY idx_quiz_options_question (question_id),
    CONSTRAINT fk_quiz_options_question FOREIGN KEY (question_id) REFERENCES quiz_questions(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE quiz_attempts (
    id                  BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    user_id              BIGINT UNSIGNED NOT NULL,
    lesson_id            INT UNSIGNED NOT NULL,
    score_correct         TINYINT UNSIGNED NOT NULL,
    score_total            TINYINT UNSIGNED NOT NULL,
    xp_awarded              SMALLINT UNSIGNED NOT NULL DEFAULT 0,
    attempted_at           DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    KEY idx_quiz_attempts_user (user_id),
    KEY idx_quiz_attempts_lesson (lesson_id),
    CONSTRAINT fk_quiz_attempts_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT fk_quiz_attempts_lesson FOREIGN KEY (lesson_id) REFERENCES lessons(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE placement_questions (
    id                  TINYINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    language_id          TINYINT UNSIGNED NOT NULL,
    question_bn            TEXT NOT NULL,
    code_snippet            TEXT NULL,
    difficulty_weight       TINYINT UNSIGNED NOT NULL DEFAULT 1,
    sort_order               TINYINT UNSIGNED NOT NULL DEFAULT 1,
    KEY idx_placement_questions_language (language_id),
    CONSTRAINT fk_placement_questions_language FOREIGN KEY (language_id) REFERENCES languages(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE placement_options (
    id                  INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    question_id           TINYINT UNSIGNED NOT NULL,
    option_label            CHAR(1) NOT NULL,
    option_text_bn           VARCHAR(255) NOT NULL,
    is_correct                TINYINT(1) NOT NULL DEFAULT 0,
    KEY idx_placement_options_question (question_id),
    CONSTRAINT fk_placement_options_question FOREIGN KEY (question_id) REFERENCES placement_questions(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE placement_attempts (
    id                  BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    user_id                BIGINT UNSIGNED NULL,
    session_id              CHAR(64) NULL,
    language_id              TINYINT UNSIGNED NOT NULL,
    recommended_module_id    INT UNSIGNED NULL,
    raw_score                 TINYINT UNSIGNED NOT NULL,
    attempted_at               DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    KEY idx_placement_attempts_user (user_id),
    CONSTRAINT fk_placement_attempts_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL,
    CONSTRAINT fk_placement_attempts_language FOREIGN KEY (language_id) REFERENCES languages(id) ON DELETE CASCADE,
    CONSTRAINT fk_placement_attempts_module FOREIGN KEY (recommended_module_id) REFERENCES modules(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
