-- No recurring-charge cron exists yet (see TODO.md BLOCKER-1: real BDApps/SDP
-- API docs required), but the schema had nowhere to even record when a
-- subscription is next due. Add it now so wiring the real cron later is just
-- app code, not another migration done under time pressure.
ALTER TABLE subscriptions ADD COLUMN last_charged_at TIMESTAMP NULL;
ALTER TABLE subscriptions ADD COLUMN next_charge_at  TIMESTAMP NULL;

-- Not a partial index (MySQL/MariaDB has no CREATE INDEX ... WHERE) — a
-- plain index on next_charge_at covers the same query patterns, just
-- without the storage saving from excluding non-active/grace rows.
CREATE INDEX idx_subscriptions_next_charge ON subscriptions (next_charge_at);
