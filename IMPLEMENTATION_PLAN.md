# IMPLEMENTATION PLAN

## MSIS Secure Intervention Tracking Platform

**Status:** Blueprint — no business logic, no screens, no APIs, no code in this document. Everything here derives from `SRS.md` v1.0 (Draft) and `UI_UX_SPECIFICATION.md` v1.0 (Draft); nothing here redesigns, simplifies, or reinterprets either. Where the SRS has an open **[PENDING DECISION]**, this plan proceeds using the SRS's own stated working assumption and flags it — it does not resolve or guess past it.

---

## 1. Architecture Overview

Two independently deployable applications, integrated only through the REST/WebSocket contract defined in `SRS.md` §18.5/§21.1:

- **Flutter mobile client** — feature-first Clean Architecture, three layers per feature (`presentation` → `domain` → `data`), MVVM at the presentation layer (View = Widget, ViewModel = Riverpod `Notifier`), strict inward dependency rule (outer layers depend on inner layers, never the reverse).
- **Laravel API** — layered MVC-plus (`Controller` → `Service` → `Repository` → `Model`), with `Policy` classes as a cross-cutting authorization layer and `Event`/`Listener` pairs decoupling side effects (notifications, audit logging, WebSocket broadcast) from the request/response cycle.

Both sides implement the **same** business rules independently (client-side validation for UX responsiveness, server-side validation as the actual authority) — per SRS §17's standing rule, client-side validation is never trusted as the source of truth.

### 1.1 Dependency Direction (Flutter)

```
presentation  →  domain  ←  data
   (Widgets,        ↑        (Models/DTOs,
    Riverpod          |        RemoteDataSource,
    Notifiers)     (Entities,   LocalDataSource,
                    UseCases,   RepositoryImpl)
                    Repository
                    interfaces)
```

`domain` has zero Flutter/Dio/Hive imports — it is pure Dart. `presentation` depends on `domain` only (never directly on `data`). `data` depends on `domain` (to implement its repository interfaces) and on `core` (network/storage primitives). This is the one rule every code review in this project enforces without exception.

### 1.2 Dependency Direction (Laravel)

```
routes/api.php → Controller → FormRequest (validation)
                            → Policy (authorization)
                            → Service (business logic)
                            → Repository (data access)
                            → Model (Eloquent)
```

A Controller never queries a Model directly; it never contains business logic beyond orchestration. A Service never accesses `$request` or HTTP concerns. A Repository never contains business logic, only query construction.

---

## 2. Feature Breakdown

Mapped 1:1 to `SRS.md` §9's modules, so every feature folder traces to an approved requirement set — no feature exists in the codebase that doesn't exist in the SRS:

| Feature folder | SRS module | SRS chapter |
|---|---|---|
| `authentication` | Authentication & Session Management | §9.1, §17 |
| `profile` | Profile & Settings | §9.2 |
| `interventions` | Create Intervention, Intervention Detail/Status | §9.3, §9.4 |
| `messages` | Messaging (lives inside `interventions` conversation, but is its own data/domain concern) | §9.4, §21 |
| `dashboard` | Supervisor Dashboard | §9.5 |
| `users` | User Management | §9.6 |
| `notifications` | Notifications | §9.8, §20 |
| `reports` | Reporting | §19 |
| `settings` | (folded into `profile` per SRS FR-PROF-04/05/06 — not a separate top-level feature) | §9.2 |

---

## 3. Development Phases

Matches the sequencing already agreed with the Product Owner for this build:

| Phase | Scope | Depends on |
|---|---|---|
| **0 — Foundation** | Flutter + Laravel scaffolding, core infrastructure, design system tokens, no business logic | This plan |
| **1 — Authentication** | Splash, role selection, login, forgot/reset password, session/token lifecycle, role-based routing guard | Phase 0 |
| **2 — User & Role Management** | Account CRUD, activation/deactivation, profile, technician invitation | Phase 1 |
| **3 — Intervention Management** | Ticket CRUD, status lifecycle, assignment, attachments | Phase 1, 2 |
| **4 — Messaging** | Ticket-scoped encrypted conversation, WebSocket, offline outbox | Phase 3 |
| **5 — Notifications** | Push/in-app/email, event triggers | Phase 3, 4 |
| **6 — Reports & Dashboard aggregation** | KPIs, charts, exports | Phase 3 (status-history table) |
| **7 — Testing hardening** | Fill any coverage gap left by per-phase testing, full E2E journeys, security scan | All prior phases |
| **8 — Deployment** | Docker Compose topology, CI/CD, staging → production | All prior phases |

This document's remaining sections define Phase 0 in full and set the contract every later phase must build against.

---

## 4. Flutter Dependencies

| Package | Purpose | Depended on by | Alternative considered |
|---|---|---|---|
| `flutter_riverpod` | State management — providers/notifiers | Every feature's `presentation` layer | `bloc` (rejected: SRS §24.1 mandates Riverpod) |
| `go_router` | Declarative routing, auth/role redirect guards | `app/router` | `auto_route` (rejected: SRS mandates GoRouter) |
| `dio` | HTTP client | Every feature's `data` layer, via `core/network` | `http` (rejected: lacks interceptor ergonomics needed for token injection/refresh) |
| `freezed` + `freezed_annotation` | Immutable data classes, union types (for `Result<T>`) | Every feature's `domain`/`data` models | — |
| `json_serializable` + `json_annotation` | JSON (de)serialization codegen, paired with Freezed | Every feature's `data` DTOs | Manual `fromJson`/`toJson` (rejected: error-prone at this entity count) |
| `flutter_secure_storage` | Encrypted token storage (Keystore/Keychain) | `core/storage`, `authentication` | — (mandated by SRS SEC-28) |
| `drift` | Local offline cache, outbox queue (SQLite-backed) | `core/storage`, every feature's `data` layer for offline support | `hive`/`hive_flutter` were the original Phase-0 pick per SRS §24.1, but `hive_generator`'s `analyzer` version pin is incompatible with current `freezed`/`build_runner` codegen tooling as of this build (a real, verified `pub` dependency-resolution conflict, not a style preference) — `drift` was substituted during actual scaffolding. Both remain SRS-acceptable per §24.1's "Hive or drift" wording; this is a like-for-like swap within the SRS's own stated tolerance, not a deviation from it. |
| `firebase_core` + `firebase_messaging` | Push notification receipt | `notifications` | — (mandated, SRS §20.1) |
| `image_picker` | Camera/gallery attachment selection | `interventions`, `messages` | — |
| `permission_handler` | Runtime permission requests (camera, storage, notifications) | `interventions`, `messages`, `notifications` | — |
| `connectivity_plus` | Network-state detection, drives `OfflineBanner` and outbox flush | `core/network` | — |
| `get_it` | Service-locator DI, registers repositories/services consumed by Riverpod providers | `core/di` | Pure-Riverpod DI (rejected: SRS §24.1 explicitly pairs GetIt with Riverpod) |
| `flutter_lints` | Static analysis baseline | Whole project | `very_good_analysis` (either acceptable per SRS; `flutter_lints` selected as the more conservative default, easy to upgrade to `very_good_analysis` later without a rewrite) |
| `mocktail` | Test doubles | Test suites only | `mockito` (rejected: `mocktail` avoids build_runner-generated mocks, faster test iteration) |
| `web_socket_channel` (via `laravel_echo`-equivalent Dart client, or a direct Pusher-protocol client) | Realtime messaging channel | `messages` `data` layer | Direct raw WebSocket handling (rejected: reinventing channel-auth/reconnect logic Laravel Echo's protocol already standardizes) |
| `intl` + `flutter_localizations` | Localization (French/English, SRS NFR-L10N) | `app/l10n` | — |

---

## 5. Laravel Dependencies

| Package | Purpose |
|---|---|
| `laravel/sanctum` | Bearer-token authentication (SRS §17.4) |
| `laravel/framework` (queues, events, notifications, broadcasting — first-party) | Core framework capability, no third-party substitute needed |
| `pusher/pusher-php-server` or `beyondcode/laravel-websockets` | Realtime broadcasting transport, contingent on SRS D-03's resolution (this plan proceeds with self-hosted `laravel-websockets`, the SRS's stated working assumption) |
| `predis/predis` (or the PHP `redis` extension) | Redis client for cache/queue/rate-limit backend (SRS §17.9, §25.2) |
| `spatie/laravel-permission` **[considered, not adopted]** | A full RBAC package was evaluated and rejected: the SRS's RBAC model (§17.3) is a fixed 3-role enum plus resource-ownership Policies, not a dynamic permission-assignment system — adopting a general-purpose permissions package would add abstraction the requirements don't call for (a SOLID/YAGNI judgment call, not a requirements gap) |
| `barryvdh/laravel-dompdf` | PDF export generation (SRS RPT-15) |
| `league/csv` | CSV export generation (SRS RPT-14) |
| `intervention/image` | Server-side image handling if any server-side resize/validation beyond MIME-check is needed |
| `pestphp/pest` (or PHPUnit directly) | Test framework (SRS §26.1) |
| `laravel/pint` | Code style enforcement, Laravel's first-party PHP-CS-Fixer wrapper (SRS DEP-11's "PHP-CS-Fixer" requirement) |

---

## 6. Complete Flutter Folder Structure

```
lib/
├── main.dart                       # Entry point; bootstraps DI, runs App
├── app/
│   ├── app.dart                    # MaterialApp.router, ThemeData wiring
│   ├── router/
│   │   ├── app_router.dart         # GoRouter instance + route table
│   │   ├── route_guards.dart       # Auth-state / role-based redirect logic
│   │   └── route_paths.dart        # Typed route path constants
│   ├── theme/
│   │   ├── app_colors.dart         # UI_UX_SPECIFICATION.md Part B.1/B.2 tokens
│   │   ├── app_typography.dart     # Part B.3 type scale
│   │   ├── app_spacing.dart        # Part B.4 spacing scale
│   │   ├── app_theme.dart          # Light/dark ThemeData assembly
│   │   └── status_colors.dart      # Status/priority → color mapping (Part B.1)
│   └── l10n/                       # ARB files (fr, en) + generated localization delegate
├── core/
│   ├── config/
│   │   ├── env.dart                 # Environment abstraction (dev/staging/prod)
│   │   └── app_config.dart          # Base URL, timeouts, feature flags
│   ├── constants/
│   │   └── api_endpoints.dart       # Route-path string constants, matching SRS §18.5
│   ├── errors/
│   │   ├── failures.dart            # Sealed Failure hierarchy (Freezed union)
│   │   └── exceptions.dart          # Data-layer exception types
│   ├── network/
│   │   ├── api_client.dart          # Dio instance factory
│   │   ├── interceptors/
│   │   │   ├── auth_interceptor.dart      # Attaches Authorization header
│   │   │   ├── refresh_interceptor.dart   # SRS §17.4 revoke-and-reissue flow
│   │   │   ├── logging_interceptor.dart   # Debug-build-only request/response logging
│   │   │   └── error_interceptor.dart     # Maps Dio errors → domain Failures
│   │   └── connectivity_service.dart      # Wraps connectivity_plus
│   ├── storage/
│   │   ├── secure_token_storage.dart      # flutter_secure_storage wrapper
│   │   ├── local_cache_box_names.dart     # Hive box name constants
│   │   └── offline_outbox.dart            # Generic queued-action persistence
│   ├── security/
│   │   └── (no content in Phase 0 — reserved for any future device-binding work, SRS §17.11 residual-risk item, out of MVP scope)
│   ├── routing/                     # (see app/router — core/routing reserved for any non-GoRouter navigation primitives, currently empty)
│   ├── utils/
│   │   ├── validators.dart          # Shared field-validation functions (SRS BRULE-006/007)
│   │   └── date_formatting.dart     # WAT-display conversion (SRS D-09 resolution)
│   ├── extensions/
│   │   └── build_context_extensions.dart  # Theme/l10n shorthand accessors
│   ├── services/
│   │   └── (feature-agnostic app-wide services land here as they're introduced — empty at Phase 0)
│   └── di/
│       └── injector.dart            # GetIt registration root
├── shared/
│   ├── widgets/
│   │   ├── status_badge.dart        # Component C.1
│   │   ├── priority_chip.dart       # Component C.2
│   │   ├── kpi_card.dart            # Component C.3
│   │   ├── intervention_card.dart   # Component C.4
│   │   ├── user_row.dart            # Component C.5
│   │   ├── message_bubble.dart      # Component C.6
│   │   ├── confirmation_sheet.dart  # Component C.7
│   │   ├── empty_state.dart         # Component C.8
│   │   ├── filter_bar.dart          # Component C.9
│   │   ├── offline_banner.dart      # Component C.10
│   │   └── skeleton_loader.dart     # Part B.17
│   └── models/
│       └── result.dart              # Result<Failure, T> Freezed union, used by every UseCase return type
├── features/
│   ├── authentication/
│   │   ├── presentation/
│   │   │   ├── screens/             # SplashScreen, LoginScreen, ForgotPasswordScreen, ResetPasswordScreen
│   │   │   ├── controllers/         # AuthController (Riverpod Notifier)
│   │   │   └── widgets/             # Screen-local widgets not promoted to shared/
│   │   ├── domain/
│   │   │   ├── entities/            # User, AuthSession
│   │   │   ├── repositories/        # AuthRepository (abstract)
│   │   │   └── usecases/            # LoginUseCase, LogoutUseCase, RefreshTokenUseCase, ...
│   │   └── data/
│   │       ├── models/              # UserDto, LoginResponseDto (Freezed + json_serializable)
│   │       ├── datasources/         # AuthRemoteDataSource
│   │       └── repositories/        # AuthRepositoryImpl
│   ├── profile/            (same 3-layer shape)
│   ├── interventions/      (same 3-layer shape)
│   ├── messages/           (same 3-layer shape)
│   ├── dashboard/          (same 3-layer shape)
│   ├── users/               (same 3-layer shape)
│   ├── notifications/      (same 3-layer shape)
│   └── reports/            (same 3-layer shape)
└── test/                    # Mirrors lib/ structure 1:1, per feature
```

**Dependency rule enforced in code review, restated:** a file under `features/x/presentation` may import from `features/x/domain` and from `shared/` and `app/theme`; it may never import from `features/x/data` or from any other feature's internals directly (cross-feature communication happens through domain-layer contracts or navigation, never a direct import of another feature's private classes).

---

## 7. Complete Laravel Folder Structure

```
app/
├── Http/
│   ├── Controllers/Api/V1/
│   │   └── (empty in Phase 0 — AuthController etc. arrive in their respective phase)
│   ├── Requests/
│   │   └── (empty in Phase 0)
│   ├── Resources/
│   │   └── (empty in Phase 0)
│   └── Middleware/
│       ├── CheckRole.php            # SRS SEC-15
│       ├── ForceJsonResponse.php
│       └── LogAuditTrail.php        # SRS §24
├── Models/
│   └── (empty in Phase 0 — created alongside their migrations per phase)
├── Policies/
│   └── (empty in Phase 0)
├── Services/
│   └── (empty in Phase 0)
├── Repositories/
│   ├── Contracts/                   # Interface per repository, bound in a ServiceProvider
│   └── Eloquent/                    # Concrete Eloquent implementations
├── Events/
│   └── (empty in Phase 0)
├── Listeners/
│   └── (empty in Phase 0)
├── Notifications/
│   └── (empty in Phase 0)
├── Enums/
│   ├── UserRole.php                 # ADMIN, TECHNICIEN, CLIENT
│   ├── InterventionStatus.php       # EN_ATTENTE, EN_COURS, BLOQUE, RESOLUE, CLOTUREE[, ANNULEE pending D-17]
│   ├── InterventionPriority.php     # BASSE, NORMALE, HAUTE
│   └── NotificationChannel.php      # push, in_app, email
├── Traits/
│   └── (populated as cross-cutting model behavior is identified — e.g., a future HasAuditLog trait)
├── Helpers/
│   └── (kept deliberately near-empty — global helper functions are avoided in favor of Services, per the coding standards in §14)
└── Providers/
    ├── AppServiceProvider.php
    ├── RepositoryServiceProvider.php  # Binds every Contracts\* interface to its Eloquent implementation
    └── EventServiceProvider.php       # Event→Listener map, populated per phase

database/
├── migrations/                      # One file per table, created per phase, never retroactively edited once merged
├── seeders/
│   └── DemoDataSeeder.php           # Role accounts + sample interventions for local/staging
└── factories/                       # One factory per Eloquent model, for tests

routes/
├── api.php                          # All routes prefixed /api/v1, sanctum + CheckRole
└── channels.php                     # Private WebSocket channel authorization (intervention.{id})

config/
└── (standard Laravel config, plus a project-specific `msis.php` for app-specific tunables — rate-limit values, token TTL, file-upload limits — centralizing every "magic number" named in the SRS rather than inlining them)
```

**Dependency rule enforced in code review:** a Controller may only call a Service or a FormRequest/Resource; it may never call a Repository or a Model directly. A Service may call a Repository, another Service, or dispatch an Event; it may never touch `$request`, `response()`, or any HTTP-layer concern. A Repository may only be called by a Service (or another Repository); it never contains authorization or validation logic.

---

## 8. Database Foundation (Entities Only — No Migrations Yet)

Full field-level definitions are in `SRS.md` §18.3; this section states only the implementation-relevant conventions layered on top.

**Entities:** `users`, `interventions`, `messages`, `pieces_jointes`, `notifications`, `audit_logs`, `intervention_status_history` (per SRS §18.3, including the D-20b addition), plus Laravel's own first-party `personal_access_tokens` and `password_reset_tokens` tables (auto-migrated by Sanctum/framework, not hand-designed — SRS §18.3 note).

**Naming conventions:** `snake_case` table and column names (matching the SRS's own French-language domain field names, e.g. `id_intervention`, `motif_blocage` — these are **not** renamed to English for implementation; the SRS's field names are the contract, and renaming them would silently diverge the codebase from its own specification).

**Migration strategy:** one migration file per table, created in the phase that introduces that table (Phase 1 creates `users` + Sanctum's tables; Phase 3 creates `interventions`, `pieces_jointes`, `intervention_status_history`; Phase 4 creates `messages`; Phase 5 creates `notifications`; `audit_logs` is created in Phase 1 alongside `users`, since login/logout auditing starts in Phase 1). Migrations are never edited after merging to the main branch — a schema correction after merge is a new migration, never a rewritten one (standard Laravel/production-safety practice).

**Index strategy:** every foreign key column is indexed; composite indexes are added where SRS §18.3/§18.4 or `GAP_ANALYSIS.md` §3 identifies a genuinely common query shape (e.g., `interventions (id_technicien, statut)` for the Technician's filtered mission list).

**Soft-delete strategy:** **no** table uses Eloquent `SoftDeletes` in Phase 0–3, per the SRS §18.6 resolution of `GAP_ANALYSIS.md` D-20 — `users.actif=false` is the terminal account lifecycle state; no hard-delete/soft-delete UI path exists for any entity in MVP scope. This is a deliberate absence, not an oversight, and must not be silently added by an implementer who assumes "every enterprise app has soft deletes."

**Audit strategy:** `audit_logs` (Phase 1) is the single audit mechanism; no per-table `created_by`/`updated_by` shadow columns are added beyond what SRS §18.3 already specifies, to avoid duplicating what the audit table and `intervention_status_history` already capture.

**UUID strategy:** primary keys are auto-incrementing `BIGINT UNSIGNED`, matching the SRS's DDL exactly (§18.3) — **no UUID primary keys** are introduced. This is a direct carry-over of an Official Requirement (the report's original schema), not a Phase-0 architectural choice up for reconsideration.

**Timestamp strategy:** stored in UTC (SRS §18 references the D-09 resolution); Laravel's default `created_at`/`updated_at` behavior is used unmodified; WAT (Africa/Douala) conversion happens only at the API-Resource/Flutter-presentation boundary, never in the database or in stored business data.

---

## 9. State Management Strategy

Riverpod, `Notifier`/`AsyncNotifier` classes per feature (SRS §24.1). Convention: one `XController extends Notifier<XState>` per screen or cohesive screen-group; `XState` is a Freezed class distinguishing `initial`/`loading`/`data`/`error` explicitly (not a boolean-flag soup) — this is the concrete implementation of the SRS §16.5 loading/error/success state requirements. Providers are declared `@riverpod` (code-generated) for consistency and to avoid hand-written provider boilerplate drift across ~8 features.

---

## 10. Navigation Strategy

GoRouter, single top-level router in `app/router/app_router.dart`. Route table is organized by feature (each feature may expose a `feature_routes.dart` fragment merged into the top-level table, keeping route definitions physically close to the screens they own). A single `redirect` callback implements the SRS §16.4 rule: evaluated on every navigation event (not only at login), redirecting to `LoginScreen` whenever the current auth-state token is missing/expired/revoked, and enforcing that a screen's declared minimum role matches the current session's role. Deep links (SRS FR-NOTIF-02) resolve through the same route table using named routes with typed path parameters (e.g., ticket ID), never a hand-parsed URL string.

---

## 11. API Strategy

One `ApiClient` (Dio) instance, shared across all features via `core/network`. Every feature's `RemoteDataSource` receives the shared `Dio` instance through GetIt, never constructs its own. Base URL and timeouts come from `core/config/env.dart`, switched per build flavor (§13). Every endpoint call site references `core/constants/api_endpoints.dart` string constants — no inline literal route strings — so the full endpoint surface stays auditable against `SRS.md` §18.5 in one file.

---

## 12. Database Implementation Strategy (Backend)

Repository-pattern-wrapped Eloquent: every Model has a corresponding `Contracts\XRepository` interface and an `Eloquent\XRepository` implementation, bound in `RepositoryServiceProvider`. This exists specifically so Services can be unit-tested against a mocked repository without touching a real database (SRS TR-01–TR-15's unit-test layer depends on this seam existing). Query complexity beyond simple CRUD (the dashboard KPI aggregation, SRS §19.1) lives in its own dedicated `Repositories\Eloquent\ReportingRepository`, kept separate from `InterventionRepository` so a simple ticket-list query and a heavy aggregation query are never accidentally coupled in the same class.

---

## 13. Authentication Strategy

Implements `SRS.md` §17.4 exactly: Sanctum, 12-hour `expiration` config, daily `sanctum:prune-expired` scheduled command, `/auth/refresh` as revoke-and-reissue (SEC-22). Flutter side: `AuthInterceptor` attaches the bearer token to every request from `SecureTokenStorage`; a `RefreshInterceptor` intercepts a 401 response, attempts a single `/auth/refresh` call, and on success retries the original request exactly once — on a second failure, it clears the stored session and triggers the GoRouter redirect to `LoginScreen` (§10). Role-based navigation guards read the role from the decoded session state held in `AuthController`, never re-parsed ad hoc per screen.

---

## 14. Messaging Implementation Strategy

Deferred in detail to Phase 4, but the seam is prepared in Phase 0: `core/network` exposes a `RealtimeChannelClient` abstraction (interface) so the `messages` feature's `data` layer can depend on an abstraction, not directly on whichever WebSocket package is chosen pending SRS D-03's resolution. This keeps the self-hosted-vs-Pusher decision from leaking into feature code.

---

## 15. Offline Synchronization Strategy

`core/storage/offline_outbox.dart` defines a generic `QueuedAction` Hive model (action type, payload, client-generated idempotency key, timestamp) that both `interventions` (ticket creation, SRS FR-TRV-04) and `messages` (message send, SRS §21) feature `data` layers write to when `connectivity_service.dart` reports offline. A single `OutboxSyncService` (registered in `core/di`) drains the queue in chronological order on reconnection, submitting each action's idempotency key so the server-side dedup behavior (SRS §14.4 step 8) has something to key against. This is built once, in Phase 0/1's infrastructure, and reused by every feature that needs offline write support — not reimplemented per feature.

---

## 16. Notification Implementation

Deferred in detail to Phase 5; Phase 0 prepares `firebase_core` initialization in `main.dart` and a `notifications` feature skeleton (empty `data`/`domain`/`presentation` folders) so the FCM device-token registration flow has a home once Phase 5 begins. No notification-handling logic is written in Phase 0.

---

## 17. Error Handling Strategy

**Flutter:** `core/errors/failures.dart` defines a Freezed sealed `Failure` type (`NetworkFailure`, `ValidationFailure`, `AuthFailure`, `ServerFailure`, `UnknownFailure`). Every `UseCase` returns `Future<Result<Failure, T>>` (never throws to the `presentation` layer). `core/network/interceptors/error_interceptor.dart` maps Dio's `DioException` variants and HTTP status codes (SRS §18.5's error-code table) into the corresponding `Failure` subtype at the `data` layer boundary, so `presentation` code only ever pattern-matches over `Failure`, never inspects raw HTTP details.

**Laravel:** a single `app/Exceptions/Handler.php` customization maps validation exceptions to the SRS §18.5 422 payload shape, authorization exceptions to 403, and anything unexpected to a logged 500 with no internal detail in the response body (SRS §18.5's error-code table, SEC-05's misconfiguration-prevention rule).

**SnackBar strategy:** per `UI_UX_SPECIFICATION.md` §16.2/B.15 — Snackbars only for lightweight, non-blocking confirmations; a `Failure` that requires the user to act (retry, correct a field) is never surfaced as a Snackbar, only as an inline or banner error per the UI/UX spec's severity tiers.

---

## 18. Logging Strategy

**Backend:** Laravel's standard log channels, routed to stdout inside the Docker container (picked up by the centralized log aggregation in SRS §25.5), with a dedicated `audit` channel writing exclusively to the `audit_logs` table via a custom log channel/listener — never mixed into the general application log stream. Application logs never contain plaintext passwords, tokens, or decrypted message content (SRS AUDIT-05).

**Mobile:** debug-build-only `LoggingInterceptor` (§6 folder structure) prints request/response metadata; disabled entirely in release builds. Crash/error reporting hooks (Sentry SDK initialization) live in `main.dart`, gated by build flavor.

---

## 19. Testing Strategy

Mirrors `SRS.md` §26 exactly:

- **Flutter:** `test/` mirrors `lib/features/*` 1:1. Unit tests target `domain` UseCases and `presentation` controllers (mocking repositories via `mocktail`). Widget tests target Must-have screens. `integration_test/` holds full-journey E2E tests.
- **Laravel:** Pest feature tests per endpoint (nominal, validation-failure, RBAC-denial cases — SRS TR-01–TR-10 as the seed set); Pest/PHPUnit unit tests per Service and Policy, run against mocked Repository contracts.
- Both suites run in CI on every pull request (§20), and neither suite is scaffolded with placeholder/skipped tests "to fill in later" — a feature's tests are written in the same phase as the feature itself, never deferred to Phase 7 (Phase 7 exists for cross-cutting hardening and E2E coverage, not for backfilling unit tests that should already exist).

---

## 20. Deployment Strategy

Matches `SRS.md` §25 exactly: the six-container Docker Compose topology (nginx, app_laravel, queue_worker, mysql, redis, websocket), GitHub Actions CI/CD (lint → test → dependency scan → staged deploy → ZAP scan → manual-approved production promotion), Firebase App Distribution for pre-store mobile builds. Not restated in further detail here — this plan's job is to ensure Phase 0's `config/env.dart` (Flutter) and `.env`/`config/msis.php` (Laravel) structures are already shaped to receive dev/staging/prod values without a later refactor, not to re-specify the deployment pipeline itself.

---

## 21. Configuration Checklist (Phase 0 Deliverables)

- [ ] `analysis_options.yaml` — `flutter_lints` enabled, project-specific rule overrides limited to what SRS NFR-MAINT-03 requires (zero tolerated errors; warnings reviewed, not auto-suppressed).
- [ ] `build.yaml` — `freezed`/`json_serializable`/Riverpod generator configuration.
- [ ] `pubspec.yaml` — dependencies from §4, dev-dependencies for codegen/testing.
- [ ] Three Flutter build flavors/environments (`dev`, `staging`, `prod`) wired through `core/config/env.dart`, each pointing at a distinct API base URL.
- [ ] `app/l10n/` ARB scaffolding for `fr` (default) and `en`, even if `en` content is initially incomplete (per SRS D-06's architecture-now/content-later resolution).
- [ ] `app/theme/app_theme.dart` producing both light and dark `ThemeData` from the `UI_UX_SPECIFICATION.md` Part B token set.
- [ ] Laravel `composer.json` dependencies from §5.
- [ ] Laravel `config/msis.php` centralizing the SRS's named constants (rate limits §17.9, token TTL §17.4, file-upload limits §22.1).
- [ ] `.env.example` for both applications, documenting every required variable without committing real secrets.
- [ ] `docker-compose.yml` skeleton matching the six-container topology (§25.2 of the SRS), runnable locally even before any feature code exists (an empty Laravel `/api/v1/health` route and an empty Flutter splash screen are sufficient to prove the topology wires together).

## 22. Project Initialization Checklist

1. `flutter create` with the org/bundle identifiers MSIS will confirm (tied to SRS D-02's domain decision for consistency).
2. `composer create-project laravel/laravel` at the target Laravel 12 / PHP 8.4 versions.
3. Install dependencies (§4, §5).
4. Apply the folder structures in §6/§7 (empty directories with `.gitkeep` where no file exists yet, so the structure itself is reviewable before any feature lands).
5. Wire `docker-compose.yml` and confirm all six containers start and the Laravel `/health` route responds through NGINX.
6. Confirm CI (§20) runs lint + an empty test suite successfully on the first commit, so every subsequent phase's tests have a working pipeline from day one rather than retrofitting CI after the fact.

---

## 23. Coding Standards

- **Naming:** Dart — `snake_case.dart` files, `UpperCamelCase` classes suffixed by role (`LoginScreen`, `AuthController`, `AuthRepository`, `UserDto`, `UserEntity`), Riverpod providers suffixed `Provider`. PHP — PSR-12, Laravel's standard `StudlyCase` for classes, `camelCase` for methods, `snake_case` for database columns (matching the SRS's own field names exactly, §8).
- **Architecture rules:** the dependency directions in §1.1/§1.2 are enforced in code review; a PR introducing a `presentation → data` import, or a Laravel `Controller → Model` call bypassing its Service, is rejected regardless of urgency.
- **Dependency rules:** no new package is added to `pubspec.yaml`/`composer.json` without being listed (and justified, per §4/§5's format) in an update to this document — dependency creep is a standing review checklist item, not an afterthought.
- **Folder rules:** every feature has exactly the three layers in §6; no feature introduces a fourth top-level folder without a corresponding update to this plan.
- **Documentation standards:** per the project's global convention (not specific to this plan) — no comments explaining *what* code does; a comment is added only where it captures a non-obvious *why* (a workaround, an SRS cross-reference for a non-obvious business rule, a deliberate omission like §8's "no soft deletes").
- **Error handling standards:** per §17 — no feature is merged with an unhandled `Future` rejection reaching the UI as a raw exception, and no Laravel endpoint is merged without its FormRequest and Policy in place (never "add validation later").
- **Security standards:** per `SRS.md` §17 in full — a PR touching authentication, authorization, file upload, or messaging encryption requires explicit reference to which SRS `SEC-##` requirement it implements, in the PR description.
- **Testing standards:** per §19 — a feature PR without accompanying tests at the levels specified in `SRS.md` §26.1 is not merged.
- **Commit message convention:** Conventional Commits (`feat:`, `fix:`, `refactor:`, `test:`, `docs:`), scoped to the feature folder touched (e.g., `feat(authentication): add role-verification guard`).
- **Branch strategy:** `main` is always deployable (protected, CI-gated); feature branches per phase-item (`feature/auth-login-screen`), merged via PR, never direct-pushed.

---

## 24. Testing Foundation (Phase 0 Scaffolding Only)

- `test/` (Flutter) and the Laravel `tests/Feature` + `tests/Unit` directories are created empty but wired into CI in Phase 0, per §22 step 6 — proving the pipeline works before it has anything real to protect.
- A single placeholder test per side (`flutter test` sanity test; a Pest `it('responds to the health check', ...)` test against `/api/v1/health`) is the *only* test content permitted in Phase 0 — anything more belongs to the phase that introduces the feature it tests.
- Golden tests (widget visual-regression) are introduced starting in Phase 1 for the Authentication screens, using the `UI_UX_SPECIFICATION.md` Part F specs as the reference — not scaffolded generically in Phase 0, since a golden test needs a real widget to snapshot.

---

**END OF DOCUMENT — Implementation Plan, Version 1.0. This is the binding blueprint for Phase 0 onward; any deviation discovered necessary during implementation must be reflected back into this document, not silently diverged from.**