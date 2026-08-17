CREATE TABLE problems (
    id                  INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    language_id          TINYINT UNSIGNED NULL,
    lesson_id             INT UNSIGNED NULL,
    slug                    VARCHAR(64) NOT NULL,
    title_bn                 VARCHAR(191) NOT NULL,
    title_en                 VARCHAR(191) NOT NULL,
    statement_md              MEDIUMTEXT NOT NULL,
    starter_code               MEDIUMTEXT NULL,
    difficulty                  ENUM('easy','medium','hard') NOT NULL DEFAULT 'easy',
    xp_reward                    SMALLINT UNSIGNED NOT NULL DEFAULT 25,
    time_limit_ms                 INT UNSIGNED NOT NULL DEFAULT 2000,
    memory_limit_kb                INT UNSIGNED NOT NULL DEFAULT 65536,
    is_daily_eligible               TINYINT(1) NOT NULL DEFAULT 1,
    is_published                     TINYINT(1) NOT NULL DEFAULT 1,
    content_verified                  TINYINT(1) NOT NULL DEFAULT 0,
    KEY idx_problems_language (language_id),
    UNIQUE KEY uq_problems_slug (slug),
    CONSTRAINT fk_problems_language FOREIGN KEY (language_id) REFERENCES languages(id) ON DELETE CASCADE,
    CONSTRAINT fk_problems_lesson FOREIGN KEY (lesson_id) REFERENCES lessons(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE test_cases (
    id                  INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    problem_id           INT UNSIGNED NOT NULL,
    is_hidden              TINYINT(1) NOT NULL DEFAULT 0,
    stdin                    MEDIUMTEXT NULL,
    expected_stdout           MEDIUMTEXT NOT NULL,
    sort_order                 TINYINT UNSIGNED NOT NULL DEFAULT 1,
    KEY idx_test_cases_problem (problem_id),
    CONSTRAINT fk_test_cases_problem FOREIGN KEY (problem_id) REFERENCES problems(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE submissions (
    id                  BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    user_id               BIGINT UNSIGNED NOT NULL,
    problem_id             INT UNSIGNED NOT NULL,
    language_id            TINYINT UNSIGNED NOT NULL,
    source_code              MEDIUMTEXT NOT NULL,
    gateway_submission_ref    VARCHAR(191) NULL,
    status                     ENUM('queued','running','passed','failed','compile_error','runtime_error','time_limit_exceeded','memory_limit_exceeded','gateway_error') NOT NULL DEFAULT 'queued',
    passed_count                TINYINT UNSIGNED NOT NULL DEFAULT 0,
    total_count                  TINYINT UNSIGNED NOT NULL DEFAULT 0,
    stderr_excerpt                 TEXT NULL,
    xp_awarded                      SMALLINT UNSIGNED NOT NULL DEFAULT 0,
    counted_for_daily_challenge      TINYINT(1) NOT NULL DEFAULT 0,
    submitted_at                      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    completed_at                       DATETIME NULL,
    KEY idx_submissions_user (user_id),
    KEY idx_submissions_problem (problem_id),
    KEY idx_submissions_status (status),
    CONSTRAINT fk_submissions_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT fk_submissions_problem FOREIGN KEY (problem_id) REFERENCES problems(id) ON DELETE CASCADE,
    CONSTRAINT fk_submissions_language FOREIGN KEY (language_id) REFERENCES languages(id) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE submission_test_results (
    id                  BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    submission_id         BIGINT UNSIGNED NOT NULL,
    test_case_id            INT UNSIGNED NOT NULL,
    passed                     TINYINT(1) NOT NULL,
    actual_stdout_excerpt        TEXT NULL,
    KEY idx_submission_test_results_submission (submission_id),
    CONSTRAINT fk_str_submission FOREIGN KEY (submission_id) REFERENCES submissions(id) ON DELETE CASCADE,
    CONSTRAINT fk_str_test_case FOREIGN KEY (test_case_id) REFERENCES test_cases(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE daily_challenges (
    id                  BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    language_id            TINYINT UNSIGNED NOT NULL,
    problem_id               INT UNSIGNED NOT NULL,
    challenge_date              DATE NOT NULL,
    UNIQUE KEY uq_daily_challenges_language_date (language_id, challenge_date),
    CONSTRAINT fk_daily_challenges_language FOREIGN KEY (language_id) REFERENCES languages(id) ON DELETE CASCADE,
    CONSTRAINT fk_daily_challenges_problem FOREIGN KEY (problem_id) REFERENCES problems(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
