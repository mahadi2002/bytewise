-- =============================================================================
-- 009_project_languages_and_prerequisites.sql
--
-- Two related additions, both driven by the same product decision: projects
-- can require more than one language ("hybrid"), and a language track's
-- content can require another track to be finished first.
--
-- 1. project_languages: many-to-many replacement for the single
--    projects.language_id FK, which could not represent a project needing
--    e.g. Python AND SQL at all — not a UI gap, a data-model ceiling.
-- 2. languages.prerequisite_language_id / requires_any_language: the
--    C -> C++ -> Java -> Python -> JavaScript -> SQL chain is now an
--    enforced prerequisite (each requires the previous at 100% complete),
--    and Data Structures / Algorithms require at least one real language
--    track complete (their problems need a language picked to solve in,
--    per BUILD-SPEC §9 — you cannot pick a language you don't have yet).
-- =============================================================================

CREATE TABLE project_languages (
    project_id  INT UNSIGNED NOT NULL,
    language_id TINYINT UNSIGNED NOT NULL,
    is_primary  TINYINT(1) NOT NULL DEFAULT 0, -- card icon/badge order only, never a gating rule
    PRIMARY KEY (project_id, language_id),
    CONSTRAINT fk_project_languages_project FOREIGN KEY (project_id) REFERENCES projects(id) ON DELETE CASCADE,
    CONSTRAINT fk_project_languages_language FOREIGN KEY (language_id) REFERENCES languages(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO project_languages (project_id, language_id, is_primary)
SELECT id, language_id, 1 FROM projects WHERE language_id IS NOT NULL;

ALTER TABLE projects DROP FOREIGN KEY fk_projects_language;
ALTER TABLE projects DROP COLUMN language_id;

ALTER TABLE languages
    ADD COLUMN prerequisite_language_id TINYINT UNSIGNED NULL AFTER launch_order,
    ADD COLUMN requires_any_language TINYINT(1) NOT NULL DEFAULT 0 AFTER prerequisite_language_id,
    ADD CONSTRAINT fk_languages_prerequisite FOREIGN KEY (prerequisite_language_id) REFERENCES languages(id) ON DELETE SET NULL;

-- MySQL forbids UPDATE ... SET x = (SELECT ... FROM same_table) directly
-- (error 1093) — wrapping in an extra derived-table SELECT materializes it
-- first and sidesteps the restriction.
UPDATE languages SET prerequisite_language_id = (SELECT id FROM (SELECT id FROM languages WHERE slug = 'c') AS t)          WHERE slug = 'cpp';
UPDATE languages SET prerequisite_language_id = (SELECT id FROM (SELECT id FROM languages WHERE slug = 'cpp') AS t)        WHERE slug = 'java';
UPDATE languages SET prerequisite_language_id = (SELECT id FROM (SELECT id FROM languages WHERE slug = 'java') AS t)       WHERE slug = 'python3';
UPDATE languages SET prerequisite_language_id = (SELECT id FROM (SELECT id FROM languages WHERE slug = 'python3') AS t)    WHERE slug = 'javascript';
UPDATE languages SET prerequisite_language_id = (SELECT id FROM (SELECT id FROM languages WHERE slug = 'javascript') AS t) WHERE slug = 'sql';
UPDATE languages SET requires_any_language = 1 WHERE slug IN ('data-structures', 'algorithms');
