CREATE TABLE projects (
    id                  INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    language_id           TINYINT UNSIGNED NOT NULL,
    slug                    VARCHAR(64) NOT NULL,
    title_bn                 VARCHAR(191) NOT NULL,
    title_en                 VARCHAR(191) NOT NULL,
    brief_md                  MEDIUMTEXT NOT NULL,
    rubric_md                  MEDIUMTEXT NOT NULL,
    starter_repo_notes           TEXT NULL,
    xp_reward                     SMALLINT UNSIGNED NOT NULL DEFAULT 100,
    is_published                    TINYINT(1) NOT NULL DEFAULT 1,
    content_verified                 TINYINT(1) NOT NULL DEFAULT 0,
    KEY idx_projects_language (language_id),
    UNIQUE KEY uq_projects_slug (slug),
    CONSTRAINT fk_projects_language FOREIGN KEY (language_id) REFERENCES languages(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE project_submissions (
    id                  BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    user_id               BIGINT UNSIGNED NOT NULL,
    project_id             INT UNSIGNED NOT NULL,
    submission_type          ENUM('link','upload') NOT NULL,
    submission_link             VARCHAR(500) NULL,
    submission_file_path         VARCHAR(255) NULL,
    student_notes                  TEXT NULL,
    review_status                   ENUM('pending','approved','changes_requested') NOT NULL DEFAULT 'pending',
    reviewer_admin_id                BIGINT UNSIGNED NULL,
    reviewer_notes                    TEXT NULL,
    xp_awarded                         SMALLINT UNSIGNED NOT NULL DEFAULT 0,
    submitted_at                        DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    reviewed_at                          DATETIME NULL,
    KEY idx_project_submissions_user (user_id),
    KEY idx_project_submissions_project (project_id),
    KEY idx_project_submissions_status (review_status),
    CONSTRAINT fk_project_submissions_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT fk_project_submissions_project FOREIGN KEY (project_id) REFERENCES projects(id) ON DELETE CASCADE,
    CONSTRAINT fk_project_submissions_reviewer FOREIGN KEY (reviewer_admin_id) REFERENCES admin_users(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
