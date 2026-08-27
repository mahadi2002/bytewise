-- Drops the prerequisite-gating columns added by migration 009
-- (languages.prerequisite_language_id, languages.requires_any_language).
-- The hard-gated chain they backed (C -> C++ -> Java -> Python ->
-- JavaScript -> SQL, plus "DS/Algorithms needs any one language complete")
-- was deliberately reversed — TrackAccessService::isUnlocked() is now just
-- `return $userId !== null;` and no longer takes a language id at all (see
-- FEATURES.md/DATABASE.md "Learning path & track gating"). An audit
-- confirmed neither column is read anywhere in the codebase, so rather than
-- leave them as permanent inert schema, this migration removes them along
-- with the FK and its supporting index. Unrelated to project_languages
-- (still active — ProjectEligibilityService's hybrid-project gate).
ALTER TABLE languages
    DROP FOREIGN KEY fk_languages_prerequisite,
    DROP INDEX fk_languages_prerequisite,
    DROP COLUMN prerequisite_language_id,
    DROP COLUMN requires_any_language;
