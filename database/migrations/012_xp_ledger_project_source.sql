-- Projects (008_projects.sql) added project-completion XP awards
-- (ProjectReviewService::approve -> XpService::award(..., 'project', ...))
-- but the xp_ledger.source_type ENUM from 006_engagement.sql was never
-- updated to allow 'project' as a value. Every admin approval of a project
-- submission was throwing a "Data truncated for column 'source_type'"
-- PDOException (500) and leaving the submission marked approved/xp_awarded
-- with no matching xp_ledger row. Add 'project' to the allowed set.
ALTER TABLE xp_ledger
    MODIFY COLUMN source_type ENUM('quiz','problem','daily_challenge','streak_bonus','project') NOT NULL;
