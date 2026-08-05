# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repository actually is

There is **no application code yet** — no `pubspec.yaml`, no `.dart` files, no Laravel backend, no git repo. The repository currently contains only pre-development artifacts for "MSIS" (Monde Session Info Service), a Cameroonian IT-maintenance company:

- `cahier_de_charge.txt` — the full technical SRS (Software Requirements Specification), ~3700 lines, French. **This is the source of truth for any implementation work** and is summarized below.
- `stitch_plateforme_s_curis_e_msis/` — 11 Stitch-exported static HTML/Tailwind UI mockups (one per screen) plus `technical_precision_system/DESIGN.md`, the Material-3-based design token set. See folder-by-folder mapping at the bottom of this file.

Treat any request to "build the app" as: read `cahier_de_charge.txt` for the authoritative requirement, cross-check the relevant `stitch_plateforme_s_curis_e_msis/<screen>/code.html` mockup for the exact UI composition, and scaffold real Flutter/Laravel code that doesn't exist yet — never edit the HTML mockups as if they were the app.

When the SRS and a mockup appear to disagree on terminology, the SRS's own reconciliation rules win (see "Status lifecycle" below) — this has already been resolved once, in `cahier_de_charge.txt` section 8.1, don't re-litigate it.

## Product domain (from the SRS)

MSIS replaces informal ticket handling (phone calls, WhatsApp, paper/Excel — including sensitive access credentials sent in clear text) with a Flutter mobile app backed by a Laravel REST API and MySQL, secured per OWASP Top 10.

**Three roles**, strictly scoped by ownership (never by client-side trust — the server always re-verifies):
- **Client** — creates tickets, sees/acts only on tickets where `id_client = self`, confirms closure.
- **Technicien** — sees/acts only on tickets where `id_technicien = self`, advances status, writes the technical report.
- **Superviseur/Admin** — sees everything, assigns/reassigns technicians, manages accounts, read-only audit access to any conversation.

The full RBAC matrix is in SRS section 8.4; don't re-derive it from screens alone.

### Status lifecycle (ticket/"intervention")

```
EN_ATTENTE → EN_COURS → RESOLUE → CLOTUREE
                ↕
              BLOQUE
```

- `EN_ATTENTE → EN_COURS`: technician assignment or pickup.
- `EN_COURS ↔ BLOQUE`: technician-triggered, requires `motif_blocage` going in.
- `EN_COURS → RESOLUE`: technician-triggered, requires `rapport_technique`.
- `RESOLUE → CLOTUREE`: **client-triggered only** (not the technician), optional `note_satisfaction` (1–5).
- No other transition is legal — any skip (e.g. `EN_ATTENTE → RESOLUE`) must be rejected by the API with **HTTP 422**.
- Note: the underlying stage report used different labels (`A_FAIRE`/`RESOLU`/"Clôture & Note") — `EN_ATTENTE`/`RESOLUE`/`CLOTUREE` are the terms actually used everywhere else (SRS §8.1); don't reintroduce the old labels.

### Data model (MySQL / InnoDB / utf8mb4, 3NF)

Six tables — full DDL is in `cahier_de_charge.txt` §16, verbatim-ready to run:
- `users` — `role ENUM('ADMIN','TECHNICIEN','CLIENT')`, Bcrypt `password`, `actif` boolean (soft-disable, not delete).
- `interventions` — the ticket entity: `statut`, `priorite ENUM('BASSE','NORMALE','HAUTE')`, `id_client`, `id_technicien` (nullable), `motif_blocage`, `rapport_technique`, `note_satisfaction`, `date_cloture`.
- `messages` — belongs to one `interventions` row; `contenu` is **encrypted at rest** (Laravel `Crypt`, AES-256-CBC) — the DB must never hold plaintext message content.
- `pieces_jointes` — attachments, linkable to either a ticket (creation-time) or a message (conversation-time).
- `notifications` — in-app notification feed per user.
- `audit_logs` — sensitive-action trail (login, login_failed, status_change, message_audit_read, …), retained ≥ 12 months, IP-stamped.

### API contract

Base path `/api/v1`, JSON everywhere, `Authorization: Bearer <token>` (Laravel Sanctum — the SRS explicitly reconciles the stage report's "JWT" wording to Sanctum for V1, §18). Full endpoint table is in §17; key conventions:
- Standard error codes: 401 (bad/expired token), 403 (RBAC/ownership denial), 422 (validation or illegal status transition), 429 (rate-limited).
- Rate limits: login 5/15min/IP+account, forgot-password 3/hour/email, ticket creation 20/hour/user, messages 60/min/user.
- Password reset always returns the same response whether or not the account exists (anti-enumeration) — the login error message is likewise generic and never says which field was wrong.

## Planned architecture (not yet scaffolded)

### Flutter (mobile client)

Feature-first Clean Architecture, three layers per feature (`presentation` / `domain` / `data`). Stack mandated by the SRS (§24): **Riverpod** (state), **GoRouter** (nav, with auth/role-based redirect guards), **Dio** (HTTP, token-refresh interceptor), **Freezed + json_serializable** (immutable DTOs), **GetIt** (service location alongside Riverpod), **flutter_secure_storage** (token — Keystore/Keychain, never SharedPreferences), **Hive/drift** (offline cache + outbox queue).

```
lib/
├── app/            # MaterialApp, GoRouter config, theme (design tokens from DESIGN.md)
├── core/           # Dio client+interceptors, secure storage, websocket client, DI (GetIt)
├── features/
│   ├── auth/
│   ├── interventions/
│   ├── messaging/
│   ├── dashboard/
│   ├── users_management/
│   └── notifications/
└── shared/         # reusable widgets (KPI cards, status badges), utils
```

Naming: `snake_case` files, `UpperCamelCase` classes suffixed by role (`TicketDetailScreen`, `TicketController`, `TicketRepository`), Riverpod providers suffixed `Provider`, one public widget per file. No business logic in widgets — widgets only observe controller/provider state. Errors propagate as a `Result<T>`/`Either`-style type, never an unhandled exception surfaced to the user. Lint via `flutter_lints`/`very_good_analysis`.

### Laravel (API)

Thin controllers → Form Requests (validation) → Services (business logic) → Repositories (data access) → Policies (authorization). Events/Listeners (`InterventionCreated`, `StatusChanged`, `MessageSent`) decouple notification/broadcast side effects from the request path; Jobs/Queues handle async email, push, and report export.

```
app/
├── Http/Controllers/Api/V1/   Http/Requests/   Http/Resources/   Http/Middleware/
├── Models/          # User, Intervention, Message, PieceJointe, Notification, AuditLog
├── Policies/        # InterventionPolicy, MessagePolicy, UserPolicy
├── Services/        # InterventionService, MessageService, NotificationService
├── Repositories/
├── Events/ Listeners/ Jobs/
routes/api.php        # sanctum + CheckRole middleware on every route
routes/channels.php    # private WS channel `intervention.{id}` authorization
```

Middleware order: `ForceJsonResponse` → `auth:sanctum` → `CheckRole:{role}` → `ThrottleRequests` → `LogAuditTrail`.

Realtime messaging: WSS via Laravel WebSockets or Pusher on a private `intervention.{id}` channel, authorized by the same rule as `MessagePolicy::view`; REST polling every 15s as fallback if the socket is down.

## Security (OWASP Top 10 — full mapping in SRS §26)

- **A01 Broken Access Control** → `CheckRole` middleware + ownership-checking Policies on every resource.
- **A02 Cryptographic Failures** → Bcrypt passwords, mandatory TLS 1.2+/WSS, `messages.contenu` encrypted at rest (AES-256-CBC via Laravel `Crypt`).
- **A03 Injection** → Eloquent ORM only, no raw concatenated SQL, Form Request validation everywhere.
- The mockup's "Zero server knowledge" / full E2EE messaging claim is **explicitly deferred to V2** (§20.2) — V1 only does server-side encryption-at-rest. If implementing the messaging UI, use the SRS's suggested V1 copy ("Conversation chiffrée et strictement confidentielle"), not an E2EE promise the backend doesn't keep yet.
- Uploads: JPG/PNG/WEBP/PDF only, 10MB/file, MIME-sniffed server-side (not just extension-checked), served only via signed temporary Laravel routes — never a public direct URL.

## Design system

`stitch_plateforme_s_curis_e_msis/technical_precision_system/DESIGN.md` is a superset/refinement of the SRS's own §14 design tokens (both are Material 3, primary `#0D47A1`/`#003178`-ish deep blue — reconcile minor hex differences in favor of `DESIGN.md` since it's the more complete spec, unless the SRS explicitly overrides on a status/priority color, which it does in §14.6). Status and priority have fixed color codes in §14.6 — reuse them rather than inventing new ones.

### Screens (folder → SRS section)

| Folder | Screen | SRS spec section |
|---|---|---|
| `connexion_s_curis_e` | Authentication (role picker + login) | §13.1 |
| `nouvelle_intervention` | Create intervention (Client) | §13.2 |
| `tableau_de_bord_superviseur`, `_optimis`, `tableau_de_bord_vide` | Supervisor dashboard (+ optimized/empty-state variants) | §13.3 |
| `gestion_des_utilisateurs` | User management (Supervisor) | §13.4 |
| `mes_missions_tech` | Technician missions | §13.5 |
| `carte_des_missions` | Technician map view | §13.5 (FR-TECH-05, Could-have) |
| `d_tail_messagerie` | Intervention detail + secure messaging | §13.6 |
| `mes_interventions` | Client's own interventions | Client journey, §12.2 |
| `rapports_d_activit` | Activity reports / exports | §23 |

## Testing targets (SRS §27, once code exists)

Backend critical paths (auth, RBAC, status transitions) ≥ 85% coverage; Flutter unit ≥ 75%; Must-have screens 100% widget-tested; every §17 endpoint has an integration test (nominal + validation errors + RBAC denial); OWASP ZAP scan on every staging deploy.

## Deployment (SRS §28, target topology — not yet built)

Docker Compose on an Ubuntu VPS: NGINX (TLS via Let's Encrypt/certbot) → Laravel API container → MySQL container → WebSocket container. Standard deploy sequence once a repo exists: `docker-compose up -d --build` then `docker exec -it app_laravel php artisan migrate --force`. CI (GitHub Actions, recommended but not yet configured) should lint (`PHP-CS-Fixer`, `flutter analyze`) and run the test suite on every PR, then build/deploy to staging → ZAP scan → manual-approval production deploy on merge to `main`.

## Current commands

None — there is no build, lint, or test tooling in this repo yet. The commands above describe the *target* workflow once the Flutter and Laravel projects are scaffolded, not something runnable today.
