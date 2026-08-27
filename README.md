# বাইটওয়াইজ (Bytewise)

An interactive, Bangla-first programming education platform for
Bangladeshi beginners — structured tracks (C → C++ → Java → Python →
JavaScript → SQL → Data Structures → Algorithms), inline quizzes, a skill
tree, portfolio projects, and online code execution, gated behind a
৳2.78/day BDApps micro-subscription for Robi & Airtel users. Fifth app in
this workspace's series (after GardenBondhu, IELTS Master BD, PustiSathi,
DinSathi) — same architecture, new domain.

## Stack

- **PHP 8.2+, zero Composer packages.** Hand-rolled front controller,
  Router, Middleware pipeline, Controllers → Services → Repositories, plain
  PHP views.
- **MySQL 8 / MariaDB 10.4+**, `utf8mb4_unicode_ci`, DB-backed sessions,
  storage in Dhaka wall-clock time (no UTC conversion layer).
- **Vanilla JS**, no bundler, no framework — a small deferred poller script
  for the async code-submission result page.
- **Strict CSP**, zero `unsafe-inline` on scripts or styles.
- **Self-hosted fonts**: Hind Siliguri, Inter, JetBrains Mono (all SIL OFL
  1.1) — see `public/assets/fonts/FONT_LICENSE.md`.

This app's locked decisions and exact UI copy are in
[`01-BUILD-SPEC.md`](01-BUILD-SPEC.md), [`02-SCHEMA.sql`](02-SCHEMA.sql),
[`03-ENV-AND-CONFIG.md`](03-ENV-AND-CONFIG.md), and
[`04-AI-BUILD-PLAYBOOK.md`](04-AI-BUILD-PLAYBOOK.md).

## Quick start

```bash
cp .env.example .env
php -r "echo base64_encode(random_bytes(32)), PHP_EOL;"   # run twice → APP_KEY, HASH_PEPPER
php database/migrate.php --seed
php database/scripts/create_admin.php you@example.com "YourPassword123!"
php -S 127.0.0.1:8040 -t public public/router-dev.php
```

Full walkthrough (Windows/XAMPP two-tab setup, seeded credentials, mock
gateway conventions, troubleshooting) is in [STARTING.md](STARTING.md).

## Build status

14 of 15 playbook phases complete and concretely verified (curl-driven
end-to-end tests against the real local DB, not just code review). Phase
10 (real execution sandbox) is blocked on an infrastructure/cost decision
— see [TODO.md](TODO.md) BLOCKER-2.

## Docs

- [STARTING.md](STARTING.md) — local dev setup, seeded credentials, mock-gateway conventions
- [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md)
- [docs/ROUTES.md](docs/ROUTES.md)
- [docs/DATABASE.md](docs/DATABASE.md)
- [docs/FEATURES.md](docs/FEATURES.md) — including known gaps
- [docs/SECURITY.md](docs/SECURITY.md) — checklist with actual verification evidence
- [docs/DEPLOYMENT.md](docs/DEPLOYMENT.md)
- [docs/DEVELOPMENT.md](docs/DEVELOPMENT.md)
- [TODO.md](TODO.md) — pre-launch blockers + phase-by-phase build progress

## License

MIT — see [LICENSE](LICENSE). Self-hosted fonts (Hind Siliguri, Inter,
JetBrains Mono) are SIL OFL 1.1; see
[`public/assets/fonts/FONT_LICENSE.md`](public/assets/fonts/FONT_LICENSE.md).
