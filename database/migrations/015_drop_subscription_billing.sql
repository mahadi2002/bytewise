-- Subscription/billing removal (rebrand + business-model change: this is a
-- free, login-only hobby app now, no paid tier). billing_events has an FK
-- to subscriptions, so it must drop first.
DROP TABLE IF EXISTS billing_events;
DROP TABLE IF EXISTS subscriptions;
