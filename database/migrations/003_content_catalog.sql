CREATE TABLE languages (
    id                  TINYINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    slug                VARCHAR(32) NOT NULL,
    name_bn             VARCHAR(64) NOT NULL,
    name_en             VARCHAR(64) NOT NULL,
    launch_order        TINYINT UNSIGNED NOT NULL,
    judge_language_code  VARCHAR(32) NULL,
    is_meta_track        TINYINT(1) NOT NULL DEFAULT 0,
    is_published        TINYINT(1) NOT NULL DEFAULT 1,
    UNIQUE KEY uq_languages_slug (slug),
    CONSTRAINT chk_languages_judge_code CHECK (is_meta_track = 1 OR judge_language_code IS NOT NULL)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE modules (
    id                  INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    language_id         TINYINT UNSIGNED NOT NULL,
    slug                VARCHAR(64) NOT NULL,
    title_bn            VARCHAR(191) NOT NULL,
    title_en            VARCHAR(191) NOT NULL,
    sort_order          SMALLINT UNSIGNED NOT NULL,
    is_published        TINYINT(1) NOT NULL DEFAULT 1,
    KEY idx_modules_language (language_id),
    UNIQUE KEY uq_modules_language_slug (language_id, slug),
    CONSTRAINT fk_modules_language FOREIGN KEY (language_id) REFERENCES languages(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE lessons (
    id                  INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    module_id           INT UNSIGNED NOT NULL,
    slug                VARCHAR(64) NOT NULL,
    title_bn            VARCHAR(191) NOT NULL,
    title_en            VARCHAR(191) NOT NULL,
    body_md              MEDIUMTEXT NOT NULL,
    code_sample          MEDIUMTEXT NULL,
    code_sample_language VARCHAR(32) NULL,
    xp_reward            SMALLINT UNSIGNED NOT NULL DEFAULT 10,
    is_free_preview      TINYINT(1) NOT NULL DEFAULT 0,
    sort_order           SMALLINT UNSIGNED NOT NULL,
    is_published          TINYINT(1) NOT NULL DEFAULT 1,
    content_verified      TINYINT(1) NOT NULL DEFAULT 0,
    KEY idx_lessons_module (module_id),
    UNIQUE KEY uq_lessons_module_slug (module_id, slug),
    CONSTRAINT fk_lessons_module FOREIGN KEY (module_id) REFERENCES modules(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE cheatsheets (
    id                  TINYINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    language_id         TINYINT UNSIGNED NOT NULL,
    summary_md           MEDIUMTEXT NOT NULL,
    full_md               MEDIUMTEXT NOT NULL,
    updated_at           DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY uq_cheatsheets_language (language_id),
    CONSTRAINT fk_cheatsheets_language FOREIGN KEY (language_id) REFERENCES languages(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
