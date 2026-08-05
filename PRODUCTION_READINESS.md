# MSIS — Production Readiness Report

**Status: Release Candidate 1 (RC1) — MVP feature-complete, infrastructure partially built.** This report is deliberately honest about the difference between "code exists and is tested" and "this is deployed and running in production" — those are not the same claim, and conflating them is exactly what a readiness review exists to prevent.

---

## 1. What's Actually Built

### 1.1 Backend (Laravel 12 / PHP 8.4, `backend/`)

| Module | Status | Tests |
|---|---|---|
| Authentication (Sanctum, 12h expiry/refresh, password reset) | Complete | 16 |
| User & Role Management | Complete | 24 |
| Intervention Management (full status lifecycle, RBAC) | Complete | included above |
| Secure Messaging (encrypted-at-rest, Reverb broadcast, RBAC) | Complete | 13 |
| Notifications & Device Tokens | Complete | 9 |
| Reporting (KPIs, weekly trend, CSV/PDF export) | Complete | 8 |
| **Total** | | **70/70 passing** |

Every module follows Controller → Service → Repository (where warranted) → Policy → FormRequest, matching `IMPLEMENTATION_PLAN.md`. Pint-clean (zero style violations).

### 1.2 Mobile (Flutter, `mobile/`)

Feature-first Clean Architecture across Authentication, Interventions, Messaging (WSS + 15s polling fallback + offline outbox), Users, Notifications (FCM scaffold + local notifications + connectivity monitoring + offline banner), and Reports (KPI cards, bar charts, export-and-save).

- **17/17 tests passing, 0 `flutter analyze` issues** (verified repeatedly across this build).
- Every screen wired into real navigation (no orphaned/unreachable screens) — this was specifically checked after an earlier gap (notification feed existed but wasn't reachable from any screen; DI registrations existed in code but weren't wired for three services) was caught during this build and fixed.

### 1.3 Infrastructure

- `docker-compose.yml`: 6 services (nginx, app_laravel, queue_worker, reverb, mysql, redis) with health checks and `restart: unless-stopped` — validated via `docker compose config` (parses cleanly, no errors).
- `backend/Dockerfile`: multi-stage-ready PHP-FPM image, non-root file ownership on `storage`/`bootstrap/cache`.
- `docker/nginx/default.conf`: PHP-FPM routing, upload limit matching SRS FILE-02, dotfile deny rule.
- `.github/workflows/ci.yml`: lint (Pint, `flutter analyze`) + dependency audit (`composer audit`) + test (Pest, `flutter test`) on every PR/push to `main`. Verified green on GitHub, including catching two real fresh-checkout-only bugs (untracked empty `tests/Unit` dir, missing `APP_KEY`).
- Root `.gitignore` / `.env.example` for the compose-level secrets (`DB_PASSWORD`, `MYSQL_ROOT_PASSWORD`), distinct from `backend/.env`.
- `deploy/vps-setup.sh` + `docker-compose.prod.yml` + `docker/nginx/production.conf.template`: scripted path from a bare Ubuntu VM to a running HTTPS deployment (Let's Encrypt via certbot `--standalone`, Reverb proxied over `/app` so only 80/443 are needed). Not yet run against a real VM.
- `backend/app/Http/Middleware/SecurityHeaders.php`: baseline OWASP A05 headers (CSP, X-Frame-Options, HSTS-when-HTTPS, etc.) on every API response.
- `backend/app/Console/Commands/BackupDatabase.php`: nightly `mysqldump | gzip`, local-disk rotation of 14 (off-site destination still pending D-26).

---

## 2. Security Audit Summary

Full OWASP Top 10 mapping is in `SRS.md` §17.1; status against what's actually implemented (not just specified):

| # | Risk | Implemented? |
|---|---|---|
| A01 Broken Access Control | ✅ `CheckRole` middleware + ownership Policies on every route, tested |
| A02 Cryptographic Failures | ✅ Bcrypt, TLS-ready (nginx forces this once a real cert is added — see §4), AES-256-CBC on `messages.contenu` (tested: SEC-25 test asserts the raw DB column never contains plaintext) |
| A03 Injection | ✅ Eloquent-only, no raw SQL anywhere in the codebase |
| A04 Insecure Design | ✅ Threat model documented in `SRS.md` §17.11 |
| A05 Security Misconfiguration | ⚠️ Partial — `APP_DEBUG` is `true` in the current `.env` (fine for this build/test environment; **must be set to `false` before any real deployment**). No CSP/security-header middleware has been added yet. |
| A06 Vulnerable Components | ✅ `composer audit` wired into CI |
| A07 Auth Failures | ✅ Rate limiting (BRULE-014), tested; Sanctum expiry/refresh resolved per SEC-22 |
| A08 Data Integrity Failures | ⚠️ Partial — `composer.lock`/`pubspec.lock` are version-controllable; release APK signing is **not configured** (no keystore exists — see §4) |
| A09 Logging/Monitoring Failures | ✅ `audit_logs` table + `AuditLogger` service, tested |
| A10 SSRF | ✅ No outbound calls driven by unvalidated user input anywhere in the codebase |

**Residual risks accepted and documented** (per `SRS.md` §17.11, not oversights): no device-binding/replay-protection beyond TLS+revocable tokens; message/attachment retention policy still pending Product Owner decision (D-30c).

---

## 3. Test Coverage Summary

| Layer | Count | What's covered |
|---|---|---|
| Laravel feature tests (Pest) | 70 | Every endpoint's nominal case, validation errors, and RBAC denial — matches SRS §26.1's "100% of catalogued endpoints" target for the modules built |
| Flutter unit/widget tests | 17 | Auth controller state transitions, login screen validation/submission, messaging controller (realtime dedup, offline-failure handling, disposal) |
| **Not yet built:** mobile E2E (`integration_test`/Patrol full-journey tests), golden/visual-regression tests, load testing (k6/JMeter against the P95<400ms target), OWASP ZAP scan | — | These require either a running staging deployment or tooling not exercised in this session — see §4 |

---

## 4. What's NOT Yet Done (Genuine Blockers to Real Deployment)

This is the section that matters most in a readiness review — a report that only lists what's done isn't a readiness review, it's a changelog.

1. ~~No git repository exists yet~~ **Done** — live at github.com/cgeelectropro/MSIS, CI green on every push.
2. ~~No real Firebase project~~ **Done** — real project wired in (`google-services.json`, service-account JSON), verified end-to-end against Google's live OAuth2 endpoint. Only a physical/emulator device is needed to see a push land.
3. **No production domain, TLS certificate, or VPS provisioned yet — but the path there is now scripted.** `deploy/vps-setup.sh` + `docker-compose.prod.yml` + `docker/nginx/production.conf.template` take a fresh Ubuntu VM (written for Oracle Cloud's Always Free tier) to a running HTTPS deployment of the exact existing stack: installs Docker/certbot, issues a real Let's Encrypt cert (`--standalone`), proxies Reverb over the same host on `/app` so only 80/443 need to be open, and runs migrations. Not yet *executed* against a real VM — that's still a manual step (create the VM, point a free DuckDNS/nip.io subdomain at it, run the script) — and renewal past the 90-day cert lifetime isn't automated (documented in the script's own trailing output). SRS decision D-02 (permanent domain) is still open; this is deliberately scoped as a demo/presentation path, not a permanent production answer.
4. **`APP_DEBUG=true`** in the current `.env` — must flip to `false` before any non-local deployment.
5. **No Android release signing configured** — no keystore exists in this repo (correctly — a signing key is a secret, not something to generate speculatively). `flutter build appbundle --release` will fail without one.
6. **No backup automation actually scheduled.** `routes/console.php` has the Sanctum-prune and notification-prune schedules; a `mysqldump`-based backup job (SRS §25.4/DEP-06) is specified but not implemented, since its destination (D-26, off-site storage) is still an open decision.
7. **No staging environment**, so DEP-12's staging → ZAP scan → manual-approval → production pipeline exists only as a described process, not a running one.
8. **Load testing not run.** The P95<400ms target (NFR-PERF-01) is a design target verified only by code review, not measurement — no k6/JMeter run has been executed against this build.
9. **Decision Register items still open** (`GAP_ANALYSIS.md` §11): D-01 (client self-registration model — this build implements open self-registration as the SRS's stated working assumption, pending final Product Owner sign-off), D-02 (domain), D-03 (confirmed: self-hosted Reverb, implemented), D-04 (file storage — this build uses local disk, not S3), D-10 (Cameroon data-protection compliance review), D-26 (backup destination), D-30c (message retention policy).

---

## 5. Release Checklist

Concrete, in order — not aspirational:

- [ ] `git init`, push to a real remote, confirm `.github/workflows/ci.yml` actually runs and passes
- [ ] Resolve D-02 (domain), D-04 (storage backend), D-10/D-26/D-30c (compliance/retention) with the Product Owner
- [ ] Provision a VPS (e.g. Oracle Cloud Always Free) and a free subdomain (DuckDNS/nip.io), then run `deploy/vps-setup.sh DOMAIN=... EMAIL=...` — handles Docker, certbot/TLS, and bringing up the full stack
- [ ] Set `APP_DEBUG=false`, generate a fresh `APP_KEY` for production, move all secrets out of any committed `.env`
- [ ] Create the real Firebase project; add its config to both the Flutter app and `backend/config/services.php`'s `fcm` entry
- [ ] Generate and securely store an Android release keystore; configure `android/key.properties`
- [ ] Implement and schedule the `mysqldump` backup job once D-26's destination is chosen
- [ ] Stand up a staging environment; run the full test suite, then an OWASP ZAP scan, against it
- [ ] Run a k6/JMeter load test against `/interventions`, `/interventions/{id}/messages`, `/reports/dashboard` at the 500-concurrent-user NFR-SCALE-01 target
- [ ] Manual UAT pass against `SRS.md` §27's acceptance criteria with the actual Product Owner

---

## 6. Technical Debt / Known Simplifications

Documented so they're deliberate, not silent:

- Report export (`ReportController::export`) runs synchronously rather than via the queued-Job + signed-URL flow originally sketched in SRS RPT-16 — reasonable at the 500-user scale, revisit if export payloads grow large.
- Reports charts are plain-Flutter proportional bars, not a dedicated charting package — sufficient for the current data shapes (a handful of statuses/technicians), revisit if richer visualizations are wanted.
- Offline message outbox is a flat JSON file (`path_provider`-based), not `drift`/Hive — a deliberate substitution documented in `IMPLEMENTATION_PLAN.md` after a real `pub` dependency conflict between `drift_dev`/`hive_generator` and `riverpod_generator`/`freezed 3.x`; `riverpod_generator` was dropped project-wide in favor of hand-written Riverpod providers as the actual resolution.
- `laravel/reverb` replaces the SRS's originally-referenced `beyondcode/laravel-websockets`, which is abandoned and doesn't support Laravel 12 — Reverb is Laravel's own first-party successor for the same self-hosted WSS role.

---

**Bottom line:** the application layer (backend + mobile, all seven functional modules from the SRS) is complete, tested, and internally consistent — 70 backend + 17 Flutter tests passing, 0 lint/analyzer issues, verified multiple times over the course of this build. What remains is exclusively deployment-time infrastructure and business decisions (domain, hosting, Firebase project, signing keys, compliance sign-off) that require real-world resources and Product Owner input no amount of further coding can substitute for.
