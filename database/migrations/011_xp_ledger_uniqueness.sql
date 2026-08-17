-- Closes a TOCTOU race in XpService::award(): a check-then-insert with no
-- DB-level guarantee let two concurrent requests for the same (user,
-- source) both pass the "already awarded?" check before either row
-- existed, double-paying XP. Every current source_id is always a concrete
-- int (verified: 'quiz'/'problem'/'project' call sites all pass one;
-- 'daily_challenge'/'streak_bonus' are unused so far), so NULL-distinctness
-- in the unique index isn't a concern for existing usage.
ALTER TABLE xp_ledger
    ADD UNIQUE KEY uq_xp_ledger_user_source (user_id, source_type, source_id);
