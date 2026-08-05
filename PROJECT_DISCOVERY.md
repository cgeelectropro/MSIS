# MSIS — Project Discovery Document

**Purpose of this document:** a pre-design understanding artifact. No UI, database, API, or code is designed here. This is the foundation future design/implementation prompts will build on.

**MVP framing:** per your note, the current build target is the **MVP scope only**, which the source document itself defines in §30.1 ("MVP (V1) — périmètre de cette spécification"). Throughout this document, anything tagged **[V2]** or **[V3]** is explicitly *out of scope for now* — flagged for awareness, not for building. Where a section could sprawl into V2/V3 territory, it's called out so it doesn't get accidentally pulled into MVP work.

## Source mapping (methodology)

You referred to two inputs: an internship report (Category A) and requirements you expanded manually (Category B). The single working document in this repo, `cahier_de_charge.txt`, is itself a merge of exactly those two sources plus engineering fill-in — and it **self-tags** its own provenance throughout. This document inherits that tagging directly, mapped as follows:

| Tag used below | Source in `cahier_de_charge.txt` | What it means |
|---|---|---|
| **[A] Report** | Text explicitly attributed to "le rapport" / "rapport de stage" (LEBOU YVAN DANIEL, Institut Supérieur AZIMUT) | Business context, actors, UML-derived business rules, base tech choices, initial DB model, baseline security norms. **Never modified or reinterpreted below.** |
| **[B] Commissioner spec** | Text explicitly attributed to "le cahier des charges fonctionnel fourni... par le commanditaire" (§0, §6) — the screen-by-screen functional requirements and UI spec you supplied | Your manually-expanded requirements: per-screen functional requirements (§6), full UI spec (§13). Per the source document itself, **this prevails over the report's UML/terminology when the two disagree** (e.g. ticket status labels, reconciled in §8.1). |
| **[C] Engineering recommendation** | Every passage explicitly marked "Recommandation d'ingénierie —" in the source | Necessary engineering fill-in for anything the report/commissioner spec left unspecified. Never presented as if it were an official requirement. |

Every extracted item below carries its tag. Where the source document doesn't make the tag obvious from surrounding prose, the tag is inferred from context and marked "(inferred)".

---

## 1. Project Summary

**What it is [A][B]:** A platform replacing MSIS's informal fault-reporting workflow with a Flutter mobile app (Client / Technician / Supervisor) backed by a Laravel REST API and MySQL database, with ticket-scoped encrypted messaging, and security aligned to OWASP Top 10.

**Why it exists [A]:** MSIS (Monde Session Info Service), a Yaoundé-based IT maintenance / audiovisual company, currently manages interventions by phone, WhatsApp, and paper/Excel sheets. This exposes the company and its clients to concrete risk: no traceability, slow pickup of requests, and — critically — transmission in the clear of highly sensitive information (admin passwords, network diagrams, server access credentials).

**Business problem solved [A]:** Eliminates informal, insecure, untraceable channels as the *official* route for fault reporting and resolution, replacing them with a single traceable, encrypted, access-controlled system.

**Goals [A] (§1.1):**
1. Centralize creation, assignment, and tracking of technical interventions in one traceable system.
2. Secure all exchanges (access data, messages, attachments) per OWASP Top 10.
3. Give each role (Client, Technician, Supervisor) a fluid mobile experience suited to their responsibilities.
4. Give management a real-time decisional dashboard on workload and performance.

**Formal problem statement, as posed in the report [A] (§2.2, direct quote):**
> « Comment concevoir, sécuriser selon les standards de l'OWASP Top 10 et déployer une plateforme intégrée (API REST et application mobile) garantissant un suivi fluide, réactif et confidentiel des interventions techniques au sein de Monde Session Info Service ? »

---

## 2. Current Business Process (AS-IS)

**Company profile [A] (§2.1):** Monde Session Info Service, HQ in Yaoundé (Fabrique-Ngousso), founded 2019 by M. Belomo Dennis Hervais. Activities: IT maintenance, audiovisual editing, general sound systems. Clients: individuals, SMEs, large institutions. Org structure: Director General → Secretary; Director General → 3 "Maintenancier" poles (including one Maintenancier-Sonorisateur and one Maintenancier-Infographe).

**Process today, step by step [A] (§5.1):**
1. Client contacts MSIS by phone or WhatsApp to report a fault.
2. Request is noted manually (paper form or Excel) by the secretariat or directly by a technician.
3. Assignment to a technician happens informally — no assignment rule, no visibility for management.
4. Technician intervenes on-site or remotely; sensitive access information (passwords, network diagrams) is exchanged **in the clear** by phone or WhatsApp.
5. Intervention closure is not formalized: no reliable trace, no client evaluation is kept.

**Weaknesses / observed consequences [A] (§2.3):** frequent pickup delays, impossibility of maintaining fault history, no visibility for the end client, and critical security vulnerabilities — troubleshooting sheets circulating over unsecured channels (interception-in-transit risk) and technical access data stored in the clear.

**Risk analysis of the current situation [A] (§2.4):**

| Risk | Probability | Impact | OWASP category |
|---|---|---|---|
| Interception of sensitive data in transit (WhatsApp, SMS) | High | Critical | A02:2021 – Cryptographic Failures |
| Client access credentials stored in the clear | High | Critical | A02:2021 – Cryptographic Failures |
| No control over who can view/modify a ticket | Medium | High | A01:2021 – Broken Access Control |
| Loss of traceability (misplaced paper sheets) | High | Medium | N/A — operational risk |
| No formal authentication of parties involved | Medium | High | A07:2021 – Identification and Authentication Failures |

**AS-IS vs TO-BE comparison [A] (§5.2):**

| Dimension | AS-IS | TO-BE |
|---|---|---|
| Fault declaration | Phone call or WhatsApp message | Structured in-app form (title, description, priority, attachment) |
| Assignment | Manual, untracked | Supervisor-assigned, historized, technician notified |
| Status tracking | None, or verbal | Formal statuses visible to all authorized actors |
| Communication | WhatsApp/phone, unencrypted | Ticket-linked encrypted messaging, access restricted to client/technician/admin |
| History | Scattered paper sheets | Centralized, queryable, exportable MySQL database |
| Steering/oversight | No dashboard | Supervisor dashboard with KPIs and filters |

**Identified functional gap [C]:** the report doesn't detail a notification workflow between ticket declaration and actual pickup — the push/in-app notification system (§21) is engineering fill-in for this gap.

---

## 3. Business Objectives

Grouped by business value, as extracted from §1.1, §2.5, §3.2, §3.3:

**Operational efficiency [A]**
- Centralize creation, assignment, and tracking of all interventions in one system.
- Reduce average fault-pickup time by an estimated 35% (figure sourced from the internship report, §1.2).
- Achieve ≥ 80% first-contact resolution rate within 6 months of operation.

**Security & confidentiality [A]**
- Secure every exchange (access data, messages, attachments) per OWASP Top 10.
- Guarantee confidentiality, integrity, and traceability of technical exchanges at all times.
- Target: zero uncorrected critical security vulnerability in production.

**User experience per role [A]**
- Offer each role (Client, Technician, Supervisor) a fluid, responsibility-appropriate mobile experience.
- Target ≥ 70% client adoption of the app over informal channels within 3 months.

**Management visibility & decision-making [A]**
- Give management a consolidated, real-time dashboard on workload and performance (currently: no consolidation at all).

**Strategic / long-term [A]**
- Eliminate paper, Excel, and consumer messaging apps as the official fault-management channel.
- Build a modular technical base allowing future addition of geolocation, real-time notifications, and predictive features.

**KPI targets defined [A] (§3.3):**

| KPI | Definition | Target |
|---|---|---|
| Average pickup time | Time from ticket creation to "En cours" | −35% vs. current |
| First-contact resolution rate | % of tickets resolved without reopening/blocking | ≥ 80% after 6 months |
| Client adoption rate | % of clients using the app vs. informal channels | ≥ 70% at 3 months |
| API availability | REST API uptime | ≥ 99.5% monthly |
| Security incidents | Critical vulnerabilities detected in production | 0 uncorrected critical vulnerability |

---

## 4. Stakeholders

Extracted verbatim in role/expectation form from §4:

| Stakeholder | Project role | Main expectations |
|---|---|---|
| M. Belomo Hervais | Product Owner / professional supervisor | Represents MSIS business needs; validates functional deliverables. An operational platform that reduces delays and secures exchanges. |
| Dr Maxwell Manga | Scrum Master / academic supervisor | Guarantor of the Agile/academic methodological framework. Rigor of the Scrum process and documentation quality. |
| MSIS General Management | Sponsor / final decision-maker | Visibility into workload, ROI, professional image. |
| MSIS Clients (individuals, SMEs, institutions) | End users declaring faults | Simplicity of declaration, transparency of tracking, confidentiality of their data. |
| Field technicians (maintenanciers, sonorisateur, infographe) | End users executing interventions | Clear interface for assigned missions, reliable communication with the client. |
| Supervisor / Administrator | Operational steering: assignment, tracking, account management | Global dashboard, reliable access control. |
| Development team (Flutter, Laravel, DevOps, QA) | Design, build, test, deploy | Clear, unambiguous, implementation-ready specifications. |

**Interaction pattern [A]:** Director General ↔ Secretary; Director General ↔ 3 Maintenancier poles — this is the underlying org chart the Supervisor/Technician roles map onto (§2.1).

---

## 5. System Actors

The source models **three** roles at the data/RBAC level (`users.role ENUM('ADMIN','TECHNICIEN','CLIENT')`, §15.2/§16) — "Supervisor" and "Administrator" are **the same role** (`ADMIN`) throughout the spec, used interchangeably in prose. This is called out explicitly here since your original prompt lists them as four separate actors — the source treats them as three.

### Client [A][B]
- **Responsibilities:** report faults via structured form; track own ticket status; confirm closure and rate satisfaction; communicate with assigned technician.
- **Permissions:** create interventions (own); view/act only on own tickets (`id_client = self`); send/receive messages on own tickets; trigger `RESOLUE → CLOTUREE`.
- **Restrictions:** cannot assign technicians; cannot see other clients' tickets; cannot force illegal status transitions (e.g. cannot self-resolve).
- **Typical workflow [A] (§9.1, UC-02, UC-05):** login → create ticket (title, description, priority, optional photo) → receive ticket number → track status in real time → message assigned technician → upon `RESOLUE`, review technical report → confirm closure + optional 1–5 satisfaction rating.

### Technician [A][B]
- **Responsibilities:** consult assigned missions; execute interventions; document work via technical report; communicate with client without leaking sensitive info outside the secure channel.
- **Permissions:** view/act only on assigned tickets (`id_technicien = self`); transition `EN_ATTENTE→EN_COURS` (pickup), `EN_COURS↔BLOQUE` (with mandatory reason), `EN_COURS→RESOLUE` (with mandatory technical report); send/receive messages on assigned tickets.
- **Restrictions:** cannot create tickets; cannot assign/reassign technicians (including self); cannot trigger `RESOLUE→CLOTUREE` (client-only); cannot skip status transitions.
- **Typical workflow [A] (§9.2, UC-04):** login → view assigned missions list (KPI: assigned/in-progress/closed) → open mission detail → pick up (`EN_COURS`) → execute → optionally block/unblock with reason → resolve with mandatory report → notify client & supervisor.

### Supervisor / Administrator [A][B]
*(Single role in the data model — "Supervisor" in UI/business language, `ADMIN` in the schema.)*
- **Responsibilities:** global oversight of all interventions; assign/reassign technicians; manage user accounts (activate/deactivate, create technician accounts); consolidate reporting for management; audit messaging when required.
- **Permissions:** view **all** interventions regardless of ownership; assign or reassign a technician at any time, including on an already-`EN_COURS` ticket; activate/deactivate any account; create technician accounts (with invitation email); read-only audit access to any ticket's conversation (logged); export reports (CSV/PDF).
- **Restrictions:** cannot send messages on a ticket's conversation (audit access is read-only, §8.4); every audit-mode conversation read is logged to `audit_logs`.
- **Typical workflow [A] (§9.3, UC-03, UC-07):** login → dashboard (4 KPI widgets: total/pending/in-progress/closed) → filter/search tickets → open ticket detail → assign or reassign technician → manage user accounts in a separate tab → export activity reports.

---

## 6. Complete Feature Inventory

Organized by module; each item tagged by source.

### Authentication & Account
- Role selection before login (Client/Technicien/Superviseur) [B] (FR-AUTH-01)
- Email + password login with show/hide password toggle [B] (FR-AUTH-02)
- Trust banner "Connecté et sécurisé — Chiffrement SSL 256-bit" [B] (FR-AUTH-03)
- Forgot-password flow via email [B] (FR-AUTH-04)
- Server-side token issuance + secure on-device storage [B] (FR-AUTH-05)
- Server-side role verification (never trust client-selected role) [B] (FR-AUTH-06)
- Progressive rate-limiting after 5 failed attempts [B] (FR-AUTH-07)
- Password complexity policy on creation/reset [B] (FR-AUTH-08)
- Multi-device session support; per-device logout and "logout everywhere" [C] (§18.4)
- Technician/Supervisor account creation is invite-only, by a Supervisor [A][B] (§18.3, FR-USR-05)
- Client self-registration — **explicitly unresolved**, see open question in §14/§15 below [gap]

### Interventions (Tickets)
- Structured creation form: title, description, priority, optional attachment [B] (FR-CRT-01…04)
- Ticket created with status `EN_ATTENTE`, owned by creating client [B] (FR-CRT-05)
- Creation acknowledgment with generated ticket number [B] (FR-CRT-06)
- Supervisor notified on every new ticket [B] (FR-CRT-07)
- Full detail view: title, description, priority, status, client, assigned technician, attachments, history [B] (FR-DET-01)
- Status transitions per the state machine (see §7 Business Rules) [A][B] (FR-DET-02)
- Technician assignment / reassignment by supervisor [A] (§8.2, UC-03)
- Client-side closure confirmation + optional satisfaction rating [A][B] (UC-05)
- Offline-degraded mode: local queueing of ticket creation, replayed on reconnect [B] (FR-TRV-04)

### Messaging
- Ticket-scoped 1:1 conversation (client ↔ assigned technician) [B] (FR-DET-03)
- Text + photo messages [B] (FR-DET-04)
- Full conversation history, always retrievable by authorized parties [B] (FR-DET-05)
- Push notification on new message [B] (FR-DET-06)
- Per-message timestamp + "seen" indicator [B] (FR-DET-07)
- Strict access control: owner client, assigned technician, admin (read-only audit) only [B] (FR-DET-08)
- Real-time delivery via WSS, REST polling fallback every 15s [C] (§20.1)
- "Typing…" ephemeral indicator (not persisted) [C] (§20.4)
- Offline outbox for messages, sent in chronological order on reconnect [C] (§20.4)

### Notifications
- Push (FCM), in-app (feed + unread badge), email (password reset / invitations), silent data-only pushes for badge refresh [C] (§21.1)
- Event-triggered notifications: new ticket, assignment, status change, closure, new message, account (de)activation [C] (§21.2, table)
- Scheduled/reminder notifications: client reminder if `RESOLUE` unconfirmed 5 days; supervisor alert if `EN_ATTENTE` unassigned past SLA (2h for HAUTE, 24h otherwise) [C] (§21.3)

### Reports & Dashboard
- 4 supervisor KPI widgets: Total / En attente / En cours / Clôturées [B] (FR-DASH-01)
- 3 dashboard tabs: Interventions / Utilisateurs / Rapports [B] (FR-DASH-02)
- Quick status filters [B] (FR-DASH-03)
- Empty state "Aucune intervention" [B] (FR-DASH-04)
- Text search on title/client name [B] (FR-DASH-05, Could)
- Sort by date/priority/status [B] (FR-DASH-06, Could)
- Aggregate KPIs: totals by status/priority, avg pickup/resolution time, per-technician load, avg satisfaction [C] (§23.1)
- Charts: weekly created/closed trend, per-technician load bar chart, status pie chart [C] (§23.2)
- CSV export of filtered interventions; printable PDF dashboard export [C] (§23.3)

### Attachments
- Upload from camera or gallery at ticket creation [B] (FR-CRT-04)
- Upload within a message [B] (FR-DET-04)
- Type/size/count constraints, server-side MIME validation, client-side image compression, signed temporary URLs, recommended async antivirus scan [C] (§22, full table)

### User Management (Supervisor)
- Two separate lists: Technicians / Clients [B] (FR-USR-01)
- Name, email, active/inactive status badge display [B] (FR-USR-02)
- Activate/deactivate with confirmation [B] (FR-USR-03)
- Deactivating a technician auto-releases their un-started `EN_ATTENTE` tickets for reassignment (in-progress tickets stay visible for closure) [B] (FR-USR-04)
- Create technician account with invitation email [B] (FR-USR-05)

### Security & Administration
- RBAC via middleware + ownership Policies [A][C] (§19)
- Bcrypt password hashing, mandatory HTTPS/TLS, AES-256 encryption of message content at rest [A][C] (§20.2, §26)
- Full audit logging of sensitive actions [C] (§15.2 `audit_logs`, §26.5)
- Rate limiting per endpoint [C] (§26.1)

---

## 7. Business Rules

Extracted without summarizing or omitting.

**Ticket ownership & visibility [A] (§8.2):**
- A Client sees only THEIR interventions (`id_client = current user`).
- A Technician sees only interventions ASSIGNED to them (`id_technicien = current user`).
- A Supervisor/Administrator sees ALL interventions and can ASSIGN or REASSIGN a technician at any time, including on a ticket already `EN_COURS`.
- A ticket's messaging is accessible only to the owning client, the assigned technician, and the administrator in audit mode (read-only, logged action).

**Status transition rule [A][B] (§8.3, FR-DET-02 detail):**
- Legal forward path: `EN_ATTENTE → EN_COURS → RESOLUE → CLOTUREE`.
- Sole reversible exception: `EN_COURS ↔ BLOQUE`.
- `EN_ATTENTE → EN_COURS`: triggered by technician assignment (supervisor) or pickup (technician).
- `EN_COURS → BLOQUE`: triggered by technician, **mandatory reason** (e.g. missing part).
- `BLOQUE → EN_COURS`: triggered by technician once the blockage is lifted.
- `EN_COURS → RESOLUE`: triggered by technician at end of intervention, **mandatory technical report**.
- `RESOLUE → CLOTUREE`: triggered by the **client**, who confirms resolution and may add a satisfaction note.
- No backward transition is allowed outside `BLOQUE ↔ EN_COURS`; any attempted status skip (e.g. `EN_ATTENTE → RESOLUE`) is rejected by the API with **HTTP 422**.

**Status label reconciliation [A][B] (§8.1) — do not re-derive, already resolved in source:**

| Retained status | Report's diagram label | Trigger |
|---|---|---|
| `EN_ATTENTE` | `A_FAIRE` | Ticket creation by client |
| `EN_COURS` | `EN_COURS` | Assignment or pickup by technician |
| `BLOQUE` | `BLOQUE` | Technician-flagged blockage (reversible → `EN_COURS`) |
| `RESOLUE` | `RESOLU` | Technician marks troubleshooting complete |
| `CLOTUREE` | "Clôture & Note" (activity diagram's final step) | Client confirmation + rating |

**RBAC action matrix [A] (§8.4):**

| Action | Client | Technician | Superviseur/Admin |
|---|---|---|---|
| Create an intervention | Yes (own) | No | Yes (on behalf of a client) |
| View intervention list | Own only | Assigned only | All |
| Assign a technician | No | No | Yes |
| Change status `EN_ATTENTE→EN_COURS` | No | Yes (own tickets) | Yes |
| Change status `EN_COURS→RESOLUE` | No | Yes (own tickets) | Yes |
| Change status `RESOLUE→CLOTUREE` | Yes (own tickets) | No | Yes |
| Send a message on a ticket | Yes (own tickets) | Yes (own assigned tickets) | No (read-only audit) |
| Manage user accounts | No | No | Yes |
| View global dashboard | No | No | Yes |

**Field validation rules [B], per screen:**
- **Auth:** email must be RFC 5322-valid, required; password required/non-empty at login (no complexity rule at login). Password creation/reset: ≥ 8 chars, 1 uppercase, 1 digit, 1 special character (FR-AUTH-08).
- **Create intervention:** title 5–150 chars; description 10–3000 chars; priority required, one of `{BASSE, NORMALE, HAUTE}`, default `NORMALE` if unset; attachments JPG/PNG/PDF, ≤10MB/file, ≤5 files/ticket.

**Account deactivation cascade rule [B] (FR-USR-04):** deactivating a technician account automatically releases their un-started `EN_ATTENTE` tickets for reassignment; tickets already `EN_COURS` remain visible to allow closure.

**File upload rules [C] (§22):** images JPG/PNG/WEBP, documents PDF only; 10MB max/file; 5 files max at creation, 1 file max per message; server validates real MIME type (not extension); client-side recompression (max 1920px, 80% quality) before upload; storage outside the public web root or S3-compatible bucket, accessed only via signed temporary Laravel routes — never a direct public URL; async antivirus scan recommended before making a file available to its recipient.

**Notification SLA rules [C] (§21.3):** client reminder if a ticket stays `RESOLUE` unconfirmed for 5 days; supervisor alert if a ticket stays `EN_ATTENTE` unassigned for more than 2 business hours (priority `HAUTE`) or 24 hours (other priorities).

**Auto-closure rule [C] (§UC-05 Exceptions):** absence of client confirmation within 7 days after `RESOLUE` triggers silent automatic closure with notification — explicitly flagged as an engineering recommendation, not a report/commissioner rule.

**Dispute rule [A] (UC-05 Flux alternatif):** a client dissatisfied with resolution can contest by contacting the supervisor — **explicitly out of automated V1 scope, handled manually.**

**Rate limiting rules [C] (§26.1):**

| Endpoint | Limit |
|---|---|
| `/auth/login` | 5 attempts / 15 min / IP + account |
| `/auth/forgot-password` | 3 requests / hour / email |
| `/interventions` (create) | 20 creations / hour / user |
| `/interventions/{id}/messages` (send) | 60 messages / min / user |

**Anti-enumeration rule [A][C] (§18.2, §6.1 states):** the forgot-password API response is identical whether or not the account exists; the login error message never indicates which field (email or password) was wrong.

---

## 8. Functional Requirements

All `FR-*` IDs, verbatim scope, grouped as the source groups them (§6). Priority is MoSCoW as stated in source. All are **[B]** (commissioner functional spec) unless noted.

### 8.1 Authentication (all roles)
| ID | Requirement | Priority |
|---|---|---|
| FR-AUTH-01 | Select role (Client/Technicien/Superviseur) before entering credentials | Must |
| FR-AUTH-02 | Email + password fields, password show/hide toggle | Must |
| FR-AUTH-03 | Trust banner "Connecté et sécurisé — Chiffrement SSL 256-bit" | Should |
| FR-AUTH-04 | "Mot de passe oublié ?" link → email reset flow | Must |
| FR-AUTH-05 | On submit, credentials sent to API; on success, token received and stored encrypted on device | Must |
| FR-AUTH-06 | Server-side re-verification of selected role against actual user role; mismatch rejected | Must |
| FR-AUTH-07 | Progressive delay (rate limiting) after 5 consecutive failed attempts | Should |
| FR-AUTH-08 | Password creation/reset complexity: ≥8 chars, 1 uppercase, 1 digit, 1 special char | (validation rule) |

### 8.2 Create Intervention (Client)
| ID | Requirement | Priority |
|---|---|---|
| FR-CRT-01 | Required short-text "Titre de l'intervention" field | Must |
| FR-CRT-02 | Required multiline "Description détaillée" field | Must |
| FR-CRT-03 | Priority selector: Haute / Normale / Basse | Must |
| FR-CRT-04 | Attach photo from gallery or camera | Should |
| FR-CRT-05 | On submit, ticket created with status `EN_ATTENTE`, client as owner | Must |
| FR-CRT-06 | Creation receipt displayed with generated ticket number | Should |
| FR-CRT-07 | Supervisor notified of new ticket immediately on creation | Must |

### 8.3 Supervisor Dashboard
| ID | Requirement | Priority |
|---|---|---|
| FR-DASH-01 | 4 KPI widgets: Total, En attente, En cours, Clôturées | Must |
| FR-DASH-02 | 3 tabs: Interventions, Utilisateurs, Rapports | Must |
| FR-DASH-03 | Quick filters on intervention list: Toutes/En attente/En cours/Clôturées | Must |
| FR-DASH-04 | Empty state "Aucune intervention" with mailbox icon when a filter yields no result | Should |
| FR-DASH-05 | Text search on title or client name | Could |
| FR-DASH-06 | Sort by creation date, priority, or status | Could |

### 8.4 User Management (Supervisor)
| ID | Requirement | Priority |
|---|---|---|
| FR-USR-01 | Two distinct lists: Techniciens / Clients | Must |
| FR-USR-02 | Display Name, Email, Status (Actif/Inactif) with color badge | Must |
| FR-USR-03 | Activate/Deactivate button with confirmation before applying | Must |
| FR-USR-04 | Deactivating a technician auto-releases un-started `EN_ATTENTE` tickets; `EN_COURS` tickets stay visible for closure | Should |
| FR-USR-05 | Supervisor creates a new technician account, with invitation email | Should |

### 8.5 Technician Space
| ID | Requirement | Priority |
|---|---|---|
| FR-TECH-01 | 3 KPI widgets: Assignées, En cours, Clôturées | Must |
| FR-TECH-02 | "Interventions assignées" list with status filters | Must |
| FR-TECH-03 | Bottom nav bar: Missions, Carte, Messages, Profil | Must |
| FR-TECH-04 | Tapping a mission opens full detail + status change | Must |
| FR-TECH-05 | "Carte" tab shows location of assigned interventions | Could |

### 8.6 Intervention Detail & Messaging
| ID | Requirement | Priority |
|---|---|---|
| FR-DET-01 | Full ticket info: title, description, priority, status, client, assigned technician, attachments, history | Must |
| FR-DET-02 | Status change per the authorized sequence (§7 above) | Must |
| FR-DET-03 | Secure 1:1 conversation linked to `id_intervention` | Must |
| FR-DET-04 | Send text messages and photos in the conversation | Must |
| FR-DET-05 | Conversation history retained and viewable anytime by authorized parties | Must |
| FR-DET-06 | Push notification on new message received | Must |
| FR-DET-07 | Per-message timestamp + "seen" indicator | Should |
| FR-DET-08 | Only owning client, assigned technician, and admin (audit read) can access a ticket's conversation | Must |

### 8.7 Cross-cutting Requirements
| ID | Requirement | Priority |
|---|---|---|
| FR-TRV-01 | A client sees/acts only on their own interventions | Must |
| FR-TRV-02 | A technician sees/acts only on interventions assigned to them | Must |
| FR-TRV-03 | A supervisor sees all interventions and can assign/reassign a technician | Must |
| FR-TRV-04 | Degraded offline mode: view last synced data, queue actions (ticket creation, message send), replay on reconnect | Should |
| FR-TRV-05 | Dark mode following system preference | Could |

### 8.8 User Stories (§10)
30 user stories (`US-01`…`US-30`) trace 1:1 to the FR IDs above, grouped into 6 epics: **Authentication & Account** (US-01–06), **Client Declaration & Tracking** (US-07–12), **Technician Processing** (US-13–17), **Supervisor Steering** (US-18–21), **Secure Messaging** (US-22–26), **Notifications & Offline** (US-27–30). Each follows "As a `<role>`, I want `<action>`, so that `<benefit>`" and cites its source FR ID(s) — see `cahier_de_charge.txt` §10 for the full verbatim list; not reproduced here to avoid duplicating FR content already captured above.

---

## 9. Non-Functional Requirements

Source table, §7, tagged **[A]** where the underlying concern (security, MySQL integrity, mobile fluidity) is report-sourced, with metrics as **[C]** engineering fill-in unless stated otherwise:

| Category | Requirement | Target metric | Tag |
|---|---|---|---|
| Performance | API response time for common ops (list read, ticket creation) | P95 < 400ms excluding file upload | [C] |
| Mobile performance | App cold-start time | < 2.5s on mid-range Android | [C] |
| Scalability | Concurrent active users supported in V1 | 500 concurrent active users, no notable degradation | [C] |
| Maintainability | Automated test coverage of critical backend code (auth, RBAC, status transitions) | ≥ 80% | [C] |
| Accessibility | Contrast & touch-target compliance | WCAG 2.1 AA (contrast ≥ 4.5:1, targets ≥ 44×44dp) | [C] |
| Localization | Supported languages at launch | French (default), English | [A] |
| Availability | Production API uptime | ≥ 99.5% monthly, maintenance windows outside business hours | [C] |
| Offline capability | View + queue actions without network | Persisted local queue, auto-sync on reconnect | [B] (FR-TRV-04) |
| Monitoring | App logging & error tracking | Centralized logs, alerting on 5xx and repeated auth failures | [C] |
| Audit logging | Sensitive-action traceability (login, status change, admin access) | ≥ 12 months retention, timestamp + user ID + IP | [C] |
| Backup | Database backup | Automated daily, 30-day retention, quarterly restore test | [C] |
| Disaster recovery | Recovery objectives | RPO ≤ 24h, RTO ≤ 4h | [C] |
| Data integrity | MySQL referential consistency | Active FK constraints (InnoDB), atomic multi-table transactions | [A] |

**Security NFRs** are large enough to warrant their own section — see §12 below.

---

## 10. Database Information

Extracted as-is from §15–16 — **not redesigned.**

**Model normalization [A][C]:** 3rd normal form (3NF), no transitive dependency, each non-key attribute depends only on its table's primary key.

**Entity relationships [A][C] (§15.1):**
- `users (1) —— (0..*) interventions [id_client]` — a client can create many interventions.
- `users (1) —— (0..*) interventions [id_technicien, nullable]` — a technician can be assigned to many interventions.
- `interventions (1) —— (0..*) messages` — each message belongs to exactly one ticket.
- `users (1) —— (0..*) messages [id_expediteur]` — each message has exactly one sender.
- `interventions (1) —— (0..*) pieces_jointes` — attachments linked directly to a ticket (creation-time).
- `messages (1) —— (0..*) pieces_jointes` — attachments linked to a conversation message.
- `users (1) —— (0..*) notifications` — each notification targets one user.

### `users` [A]
| Field | Type | Constraint | Description |
|---|---|---|---|
| id | BIGINT UNSIGNED | PK, AUTO_INCREMENT | Unique user ID |
| nom | VARCHAR(100) | NOT NULL | Full name |
| email | VARCHAR(100) | UNIQUE, NOT NULL | Login email |
| password | VARCHAR(255) | NOT NULL | Bcrypt hash |
| role | ENUM | `ADMIN,TECHNICIEN,CLIENT` NOT NULL, default `CLIENT` | RBAC role |
| telephone | VARCHAR(20) | NULLABLE | Contact phone [C recommendation] |
| actif | BOOLEAN | NOT NULL, DEFAULT TRUE | Account status (FR-USR-03) |
| email_verified_at | TIMESTAMP | NULLABLE | Email verification date |
| created_at / updated_at | TIMESTAMP | NULLABLE | Standard Laravel timestamps |
| Index | `idx_users_role (role)` | | |

### `interventions` [A][B]
| Field | Type | Constraint | Description |
|---|---|---|---|
| id_intervention | BIGINT UNSIGNED | PK, AUTO_INCREMENT | Unique ticket ID |
| titre | VARCHAR(255) | NOT NULL | Subject |
| description | TEXT | NOT NULL | Fault detail |
| statut | ENUM | `EN_ATTENTE,EN_COURS,BLOQUE,RESOLUE,CLOTUREE`, default `EN_ATTENTE` | Processing state |
| priorite | ENUM | `BASSE,NORMALE,HAUTE`, default `NORMALE` | Urgency |
| id_client | BIGINT UNSIGNED | FK → users.id, NOT NULL, ON DELETE CASCADE | Ticket creator |
| id_technicien | BIGINT UNSIGNED | FK → users.id, NULLABLE, ON DELETE SET NULL | Assigned agent |
| motif_blocage | VARCHAR(255) | NULLABLE | Reason given on transition to `BLOQUE` |
| rapport_technique | TEXT | NULLABLE | Report given on transition to `RESOLUE` |
| note_satisfaction | TINYINT | NULLABLE, CHECK (1–5) | Client's closure rating |
| date_cloture | TIMESTAMP | NULLABLE | Timestamp of `CLOTUREE` transition |
| created_at / updated_at | TIMESTAMP | NULLABLE | Standard Laravel timestamps |
| Indexes | `idx_interv_client`, `idx_interv_technicien`, `idx_interv_statut` | | |
| Check constraint | `chk_note` | `note_satisfaction IS NULL OR BETWEEN 1 AND 5` | |

### `messages` [A]
| Field | Type | Constraint | Description |
|---|---|---|---|
| id_message | BIGINT UNSIGNED | PK, AUTO_INCREMENT | Message ID |
| id_intervention | BIGINT UNSIGNED | FK → interventions, NOT NULL, ON DELETE CASCADE | Parent ticket |
| id_expediteur | BIGINT UNSIGNED | FK → users.id, NOT NULL | Author |
| contenu | TEXT | NOT NULL — **encrypted at rest (AES-256, §20)** | Message body |
| lu | BOOLEAN | NOT NULL, DEFAULT FALSE | Read indicator |
| lu_at | TIMESTAMP | NULLABLE | Read timestamp |
| created_at | DATETIME | NOT NULL | Sent date |
| Index | `idx_msg_intervention (id_intervention, created_at)` | | |

### `pieces_jointes` — [C] recommendation
| Field | Type | Constraint | Description |
|---|---|---|---|
| id | BIGINT UNSIGNED | PK, AUTO_INCREMENT | Attachment ID |
| id_intervention | BIGINT UNSIGNED | FK, NULLABLE, ON DELETE CASCADE | Direct ticket attachment (creation) |
| id_message | BIGINT UNSIGNED | FK, NULLABLE, ON DELETE CASCADE | Conversation-message attachment |
| chemin_fichier | VARCHAR(500) | NOT NULL | Storage path (§22) |
| type_mime | VARCHAR(100) | NOT NULL | MIME type |
| taille_octets | INT UNSIGNED | NOT NULL | File size, upload-validated |
| uploaded_by | BIGINT UNSIGNED | FK → users.id, NOT NULL | Uploader |
| created_at | TIMESTAMP | NOT NULL | Upload date |

### `notifications` — [C] recommendation
| Field | Type | Constraint | Description |
|---|---|---|---|
| id | BIGINT UNSIGNED | PK, AUTO_INCREMENT | Notification ID |
| id_user | BIGINT UNSIGNED | FK → users.id, NOT NULL, ON DELETE CASCADE | Recipient |
| type | VARCHAR(50) | NOT NULL | `ticket_cree`, `statut_modifie`, `nouveau_message`, etc. |
| contenu | VARCHAR(255) | NOT NULL | Notification text |
| id_intervention | BIGINT UNSIGNED | FK, NULLABLE | Related ticket, if any |
| lu | BOOLEAN | NOT NULL, DEFAULT FALSE | In-app read flag |
| created_at | TIMESTAMP | NOT NULL | Generated date |
| Index | `idx_notif_user (id_user, lu)` | | |

### `audit_logs` — [C] recommendation (OWASP A09)
| Field | Type | Constraint | Description |
|---|---|---|---|
| id | BIGINT UNSIGNED | PK, AUTO_INCREMENT | Entry ID |
| id_user | BIGINT UNSIGNED | FK → users.id, NULLABLE | Actor (NULL if anonymous/failed auth) |
| action | VARCHAR(100) | NOT NULL | `login`, `login_failed`, `status_change`, `message_audit_read`, etc. |
| entite / entite_id | VARCHAR(50) / BIGINT | NULLABLE | Affected resource (e.g. `intervention`/123) |
| ip_address | VARCHAR(45) | NOT NULL | Source IP |
| created_at | TIMESTAMP | NOT NULL | Event timestamp |
| Indexes | `idx_audit_user`, `idx_audit_action` | | |

**Engine/charset [A]:** `ENGINE=InnoDB DEFAULT CHARSET=utf8mb4` on every table (from the report's original DDL, preserved as-is in §16). Full runnable `CREATE TABLE` statements for all six tables are in `cahier_de_charge.txt` §16.

---

## 11. Workflows

### Authentication (UC-01) [A]
Precondition: active account exists. Main flow: select role → enter email/password → server verifies credentials + role → access token issued and stored securely → redirect to role's dashboard. Alt flow: forgot-password → time-limited reset email. Exceptions: invalid credentials → generic error; disabled account → explicit "contact your administrator" message; too many attempts → temporary lockout (FR-AUTH-07).

### Declare an Intervention (UC-02) [A][B]
Precondition: client authenticated. Main flow: open creation screen → fill title/description/priority/optional attachment → submit → ticket created `EN_ATTENTE` → supervisor notified. Alt flow: no network → local queue, synced on reconnect (FR-TRV-04). Exceptions: invalid fields → inline errors, submission blocked; server failure → retry option. Postcondition: new ticket exists with a unique ID, visible to the client and all supervisors.

### Assign a Technician (UC-03) [A]
Precondition: ticket is `EN_ATTENTE` or `EN_COURS`; at least one active technician exists. Main flow: supervisor opens ticket detail → selects a technician from active accounts → confirms → `id_technicien` updated, status moves to `EN_COURS` if it was `EN_ATTENTE` → technician notified. Alt flow: reassignment on an already-`EN_COURS` ticket — both old and new technician notified. Exception: technician deactivated mid-flow → list refreshed, assignment blocked with explicit message. Postcondition: ticket linked to chosen technician, appears in their assigned-missions list.

### Process an Intervention / Status Change (UC-04) [A]
Precondition: ticket assigned to the connected technician. Main flow: open mission detail → move to `EN_COURS` → perform the fix → add technical report, move to `RESOLUE` → client and supervisor notified. Alt flow: blockage → move to `BLOQUE` with mandatory reason, back to `EN_COURS` once lifted. Exception: illegal status jump attempted → **HTTP 422** with explicit message. Postcondition: ticket `RESOLUE`, technical report attached, client can proceed to closure.

### Close an Intervention (UC-05) [A]
Precondition: ticket `RESOLUE`, owned by connected client. Main flow: client reviews resolution report → confirms closure → optionally adds 1–5 rating + free comment → status becomes `CLOTUREE`, closure timestamped. Alt flow: client can contest by contacting the supervisor if unsatisfied — **out of automated V1 scope, handled manually.** Exception: no confirmation within 7 days → silent automatic closure + notification [C recommendation]. Postcondition: ticket `CLOTUREE`, permanently archived in client history.

### Send a Secure Message on a Ticket (UC-06) [A]
Precondition: user is the ticket's owning client or assigned technician. Main flow: open ticket conversation → write text or attach photo → send → message encrypted and stored, broadcast in real time via secure WebSocket (WSS) to a connected recipient → push notification if recipient offline. Alt flow: offline send → local queue, auto-sent on reconnect. Exception: access by an unrelated user → **HTTP 403**. Postcondition: message visible in conversation history, marked delivered then read.

### View the Global Dashboard (UC-07) [A]
Precondition: supervisor authenticated. Main flow: open Interventions tab → system computes/displays KPIs → supervisor applies filters/search → opens a ticket for detail or the Reports tab to export. Alt flow: consult Utilisateurs/Rapports tabs from the same dashboard. Exception: no ticket matches filter → empty state (FR-DASH-04). Postcondition: supervisor has an up-to-date activity view and can act directly from the dashboard.

### Navigation maps [B] (§12)
Full screen-to-screen transition tables for common screens, Client journey, Technician journey, and Supervisor journey are defined in `cahier_de_charge.txt` §12.1–12.4 — not duplicated here; consult directly when sequencing screen build order.

---

## 12. Security Requirements

**Authentication mechanism, reconciled [A][B][C] (§18):** report specifies JWT; commissioner spec specifies Laravel Sanctum. Since Sanctum issues opaque bearer tokens rather than RFC 7519 JWTs, the source document explicitly resolves this by adopting **Sanctum for V1** [C], while preserving the same functional semantics (bearer token, expiration, revocation) the report calls for. Token lifetime: 12h (recommended). Stored via `flutter_secure_storage` (Android Keystore / iOS Keychain) — **never** `SharedPreferences` in the clear.

**Password reset [A][B] (§18.2):** one-time link, 60-minute validity; identical API response regardless of account existence (anti-enumeration); all existing access tokens for the account are revoked after a successful reset.

**Account activation [A][B] (§18.3):** client self-registration is out-of-report-detail — **flagged as an open question, not resolved** (see §15 below). Technician/Supervisor accounts are created exclusively by an existing supervisor, invitation-email-based.

**Session management [C] (§18.4):** multi-device login supported (multiple tokens per account); standard logout revokes only the current device's token; a "disconnect all devices" option revokes every token for the account.

**RBAC implementation [A][C] (§19):** two-level enforcement — a `CheckRole` middleware validating the route-level allowed role(s), and Laravel Policies validating resource ownership. `InterventionPolicy::view` authorizes if `user.id === intervention.id_client OR user.id === intervention.id_technicien OR user.role === ADMIN`. `InterventionPolicy::updateStatus` checks both ownership AND transition legality. `MessagePolicy::view` mirrors the same rule at the parent-ticket level, with systematic audit logging when the accessor is ADMIN. Any policy violation returns **403** with a generic message (404 is also acceptable for higher-sensitivity resources, to avoid confirming existence to an unauthorized user).

**Messaging security [A][B][C] (§20):**
- Realtime channel: WSS via Laravel WebSockets (self-hosted) or Pusher (SaaS) — MSIS's choice, both Laravel Broadcasting-compatible.
- Fallback channel: REST polling every 15s if WebSocket is unavailable.
- Each conversation is a private Laravel Echo channel `intervention.{id}`, server-authorized identically to `MessagePolicy::view`.
- **In transit:** HTTPS/WSS mandatory (TLS 1.2 minimum); NGINX enforces HTTP→HTTPS redirect, no cleartext traffic accepted.
- **At rest:** `messages.contenu` encrypted application-side via Laravel `Crypt` (AES-256-CBC, dedicated `APP_KEY`) before write — the database itself never holds plaintext message content. Messaging attachments stored on an at-rest-encrypted volume.
- **Important flagged gap [C]:** the mockup's "Zéro connaissance serveur" (zero server knowledge) badge implies full E2EE (device-held keys only, e.g. Signal protocol) — this **exceeds** the AES-256 server-side-at-rest encryption described above and is a materially larger effort (per-device key management, rotation, device-loss handling). **Recommended for V1:** implement the at-rest encryption above (protects against DB exfiltration) and change the displayed copy to "Conversation chiffrée et strictement confidentielle" rather than promising E2EE that isn't implemented yet. True E2EE is proposed as a **[V2]** evolution.
- Access control: only owning client and assigned technician can send/receive; admin read-only audit access is logged (`audit_logs`, action=`message_audit_read`); if a technician is reassigned, conversation history remains visible to the new technician for context continuity.

**OWASP Top 10:2021 full mapping [A for A01–A03; C for A04–A10] (§26):**

| # | Risk | Countermeasure | Source |
|---|---|---|---|
| A01 | Broken Access Control | RBAC middleware on all routes + ownership-checking Policies (§19) | Report |
| A02 | Cryptographic Failures | Bcrypt password hashing, mandatory HTTPS/TLS 1.2+, AES-256 message encryption at rest (§20.2) | Report |
| A03 | Injection | Eloquent ORM + prepared statements exclusively; no raw concatenated SQL; strict Form Request validation | Report |
| A04 | Insecure Design | Threat modeling at design time (status transition rules, RBAC matrix); design review before building each sensitive module | Recommendation |
| A05 | Security Misconfiguration | `APP_DEBUG=false` in production; security headers (CSP, X-Frame-Options, X-Content-Type-Options); debug tools (Telescope, Horizon) disabled from public access | Recommendation |
| A06 | Vulnerable/Outdated Components | Regular dependency audits (`composer audit`, `flutter pub outdated`), planned major-version updates | Recommendation |
| A07 | Identification & Auth Failures | Strong password policy, rate-limited `/auth/login`, token revocation on reset, 12h token expiry | Recommendation, consistent with report's JWT intent |
| A08 | Software/Data Integrity Failures | Locked dependency files (`composer.lock`/`pubspec.lock`) versioned; signed release APK builds | Recommendation |
| A09 | Security Logging & Monitoring Failures | `audit_logs` table, alerting on repeated auth failures and 5xx errors, centralized app logs | Recommendation |
| A10 | SSRF | No outbound call driven by unvalidated user data; strict allowlist for any future webhook/third-party integration | Recommendation |

**CSRF [A][C] (§26.2):** not applicable to bearer-token mobile API traffic; standard Laravel CSRF protection stays active for any future web admin interface using session/cookie auth.

**Input validation [C] (§26.3):** every input server-validated via dedicated Form Requests, independent of client-side validation (Flutter-only validation is never trusted). Free-text fields (description, messages) are escaped on display, never interpreted as executable HTML/Markdown.

**Prior security testing [A] (§26.4):** the report states functional and security tests were run with Postman and OWASP ZAP on the prototype, with no critical vulnerability detected. Recommendation: repeat this campaign on every major API version bump.

**Audit logging scope [C] (§26.5):** successful/failed logins, ticket status changes, assignment/reassignment, account activation/deactivation, admin audit-mode conversation access — all systematically logged.

---

## 13. Technology Stack

**Mandated by source, not to be substituted without a decision [A][B]:** Flutter (mobile, cross-platform), Laravel (backend API), MySQL (database), Docker + NGINX + Ubuntu VPS (deployment), OWASP Top 10 compliance.

**Flutter application [C recommendation, built on the mandated Flutter base] (§24.1):**
- State management: **Riverpod** (providers, notifiers)
- Navigation: **GoRouter**, with auth/role-based redirect guards
- HTTP client: **Dio**, with interceptors for token injection, refresh, centralized error handling
- Immutable models: **Freezed + json_serializable**
- Dependency injection: **GetIt** alongside Riverpod
- Secure storage: **flutter_secure_storage** (token)
- Local cache / offline queue: **Hive** or **SQLite via drift**
- Lint: **flutter_lints** / **very_good_analysis**

**Laravel API [A for base (Laravel, MVC, Eloquent/MySQL), C for the rest] (§25.1, §18.1):**
- Auth: **Laravel Sanctum**
- ORM: **Eloquent**
- Structure: Services, Repositories, Policies, Form Requests, Events/Listeners, Jobs/Queues (Redis or DB-backed)
- Realtime: **Laravel WebSockets** (self-hosted) or **Pusher** (SaaS), via Laravel Broadcasting

**Notifications [C] (§21.1):** **Firebase Cloud Messaging (FCM)** for push; **Laravel Mail (SMTP)** for email.

**File handling [C] (§22):** local filesystem outside webroot or S3-compatible bucket; **ClamAV** recommended for async antivirus scanning.

**Testing tools [C] (§27.1):** **PHPUnit/Pest** (Laravel unit), **flutter_test + mocktail** (Flutter unit), **flutter_test** (widget), **Postman/Newman** or Pest HTTP tests (API integration), **integration_test / Patrol** (mobile E2E), **OWASP ZAP** (security scan), **k6 or JMeter** (performance/load).

**Deployment/Ops [A for VPS/Docker/NGINX baseline, C for the rest] (§28):** Docker Compose, NGINX reverse proxy, **Let's Encrypt/certbot** (TLS), **GitHub Actions** (CI/CD — lint, test, dependency scan, build, staged deploy with manual production approval), **Codemagic or GitHub Actions** (Flutter release builds), **Firebase App Distribution** (internal distribution channel pre-Play-Store), **Sentry** (error tracking), **Loki** or equivalent (log centralization).

---

## 14. Missing Requirements

Not solved here — only identified. Each flagged **[MVP-relevant]** if it plausibly blocks or meaningfully weakens the V1/MVP scope defined in §30.1 of the source, or **[Post-MVP OK]** if it can legitimately wait.

- **Client self-registration flow** — explicitly unresolved in the source itself (§18.3: "à confirmer avec MSIS si l'inscription est libre ou sur invitation"). **[MVP-relevant — blocks Client onboarding entirely.]**
- **User profile/settings screen content** — "Profil" is named as a nav destination (FR-TECH-03, §12.1) but no fields, edit flow, or settings are specified (change password while logged in, notification preferences, language switch UI, etc.). **[MVP-relevant.]**
- **Password change flow for an already-authenticated user** — only the forgot-password (unauthenticated) flow is specified. **[MVP-relevant.]**
- **Detailed error/exception taxonomy** beyond generic HTTP codes (400/401/403/404/422/429/500) — no error-code catalog per business rule violation. **[MVP-relevant for consistent API design.]**
- **Search/pagination for Client and Technician ticket lists** — pagination (20/page) is specified only for the Supervisor dashboard (§13.3); Client's "mes tickets" and Technician's "mes missions" lists have no stated page size or search behavior. **[MVP-relevant.]**
- **Localization/language-switch UX** — French default + English required (NFR, §7) but no in-app language switcher screen or persistence mechanism is specified. **[MVP-relevant if EN is truly launch-required; otherwise Post-MVP.]**
- **Dark mode token set** — only a single `surfaceDark` color is defined (§14.1); no full dark palette, and the feature itself is Could-have (FR-TRV-05). **[Post-MVP OK — feature is explicitly Could.]**
- **Biometric login** — not mentioned anywhere in the source. **[Post-MVP OK.]**
- **Data retention / deletion policy** — no explicit policy for client/technician personal data beyond `audit_logs`' 12-month retention; no mention of Cameroon's data-protection framework compliance. **[MVP-relevant from a legal/compliance standpoint, even if the mechanism is simple.]**
- **Dispute/reopen flow after closure** — explicitly deferred to manual handling in V1 (UC-05 alt flow), no in-app mechanism at all. **[Post-MVP OK — explicitly deferred by the source itself.]**
- **Push notification preferences (opt-out/mute)** — notification triggers are fully specified (§21.2) but no user-facing control over them. **[Post-MVP OK for MVP, but cheap to add early.]**
- **Concurrent-update conflict handling** — no rule for two actors modifying the same ticket simultaneously (e.g. supervisor reassigning while technician is mid-status-change). **[MVP-relevant — directly affects the status-transition API's correctness.]**
- **API deprecation/versioning policy beyond the `/v1` prefix** — no stated approach for introducing `/v2` or sunsetting `/v1`. **[Post-MVP OK.]**
- **Timezone handling** — all timestamps are just `TIMESTAMP`/`DATETIME`; no explicit statement of stored timezone (UTC vs. Africa/Douala/WAT) or display-conversion rule. **[MVP-relevant — affects every timestamp shown to users.]**
- **SMS as a notification channel** — only Push/in-app/Email are defined (§21.1); given the AS-IS process relied partly on phone/SMS-adjacent habits, its absence may matter for adoption among less smartphone-fluent clients. **[Post-MVP OK, worth flagging to Product Owner.]**
- **App store / release management detail** — APK/AAB/IPA build is mentioned (§28.1, §28.3) but no publishing checklist, store listing requirements, or iOS-specific process (Apple Developer account, TestFlight) beyond a passing "IPA (iOS le cas échéant)". **[Post-MVP OK if Android-first is acceptable; MVP-relevant if iOS ships day one.]**
- **Legal screens** — no Terms of Service, Privacy Policy, or consent-capture screen specified anywhere. **[MVP-relevant given the app handles sensitive technical/security data.]**
- **Horizontal scaling plan beyond the 500-concurrent-user ceiling** — deployment topology (§28.1) is a single VPS; no load-balancing or read-replica strategy is discussed for growth past that ceiling. **[Post-MVP OK — ceiling matches stated V1 target.]**
- **"Disconnect all devices" UI** — the capability is specified at the API/session level (§18.4) but no screen/control is described for a user to trigger it. **[MVP-relevant if the underlying capability is being built anyway.]**
- **Multi-site/multi-branch client accounts [V2-adjacent]** — mentioned only as a V3-recommendation-level web-portal idea (§31) for institutional clients with several sites; the MVP data model has no concept of an organization/site above the individual `users` row. **[Post-MVP OK — matches source's own V3 placement.]**

---

## 15. Engineering Questions

Numbered, to become project decisions before implementation starts on the MVP.

1. Is Client account creation self-service (open sign-up) or supervisor/invite-only, like Technician/Supervisor accounts? (Source explicitly flags this as unresolved, §18.3.)
2. What is the production domain name? (`api.msis-tech.example` in §17 is explicitly marked "indicatif, à confirmer par MSIS.")
3. WebSocket hosting: self-hosted Laravel WebSockets, or Pusher (SaaS)? (§20.1 leaves this as an MSIS choice — has cost/ops implications for a VPS-hosted deployment.)
4. File storage: local filesystem or an S3-compatible bucket? (§22 presents both as options.)
5. Is iOS in scope for MVP launch, or Android-first? (Source treats IPA as conditional — "le cas échéant" — throughout.)
6. Is English localization required at MVP launch, or can it follow? (Listed as an NFR target but with no build-out spec.)
7. What is MSIS's actual policy on ticket dispute/reopening after closure — is "contact the supervisor manually" acceptable long-term, or does this need an in-app flow sooner than V2?
8. Who is authorized to see the `telephone` field on `users` (added as an engineering recommendation, §15.2) — is it visible to the counterpart role (e.g., can a technician see a client's phone number)?
9. What is the target timezone for all stored/displayed timestamps — UTC with device-local display, or Africa/Douala (WAT) directly?
10. Does MSIS require Cameroon-specific data protection/compliance handling beyond the OWASP-driven security controls already specified?
11. What happens to a `CLOTUREE` ticket's messaging — does it become fully read-only, or can the client still message the technician post-closure (e.g., follow-up question)? Not addressed by any FR.
12. For the "Assigner" action on an already-`EN_COURS` ticket (reassignment), does the ticket's `motif_blocage`/in-progress state carry over, or reset?
13. Should the auto-closure-after-7-days rule (an engineering recommendation, not a stated requirement) actually be implemented for MVP, or is it something to validate with the Product Owner first since it silently changes ticket state without user action?
14. Is there a maximum number of technician accounts / concurrent supervisors anticipated, relevant to sizing the invitation and RBAC flows?
15. What is the expected support/on-call model in production — who gets paged on the "5xx spike" or "repeated auth failure" alerts described in §26.5/§28.4?

---

## 16. Engineering Recommendations

Compiled from the source's own "Recommandation d'ingénierie" callouts (all **[C]**), organized by concern. These are recommendations, never requirements — flagged **[V2]/[V3]** where the source itself schedules them beyond MVP.

**Architecture**
- Flutter: feature-first Clean Architecture (presentation/domain/data per feature), Riverpod + GoRouter + Dio + Freezed + GetIt, `Result<T>`-style error propagation, no business logic in widgets (§24).
- Laravel: thin controllers, Services/Repositories/Policies/Form Requests, Events/Listeners for decoupled side effects, Jobs/Queues for async email/push/export (§25).

**Data model completeness**
- Add `pieces_jointes`, `notifications`, `audit_logs` tables (beyond the report's original `users`/`interventions`/`messages`) to support attachments, in-app notification history, and OWASP A09 audit logging (§15).

**Security hardening beyond the report's explicit A01–A03 coverage**
- Full OWASP Top 10 coverage for A04–A10 (threat modeling, secure config, dependency auditing, build-signing/integrity, logging/monitoring, SSRF allowlisting) — see §12 table above.
- Reformulate the mockup's "zero server knowledge" messaging claim to match actual V1 encryption-at-rest behavior, rather than implying unimplemented E2EE.

**Notifications system**
- Full push/in-app/email/silent-data notification architecture with event triggers and SLA-based scheduled alerts (§21) — fills a gap the report itself left unaddressed between ticket declaration and pickup.

**Testing strategy**
- Full test pyramid with coverage targets (unit/widget/integration/E2E/security/performance/UAT) — the report only mentions ad hoc Postman/ZAP testing on the prototype (§27).

**CI/CD & Ops**
- GitHub Actions pipeline (lint → test → dependency scan → staged build → ZAP scan → manual-approved production deploy); Sentry error tracking; centralized log aggregation; scheduled health checks (§28.3–28.4).

**Future roadmap, already staged by the source itself**
- **[V2]** Full end-to-end encryption for messaging (device-held keys, Signal-protocol-class), replacing server-side-only encryption at rest.
- **[V2]** Technician/intervention geolocation with nearest-technician auto-assignment (already named as a report-level future direction, §31).
- **[V2]** Route optimization for technicians with multiple daily missions.
- **[V2]** Client e-signature at closure (already sketched in the report's Sprint 2 planning).
- **[V3]** AI/NLP-assisted ticket categorization and pre-prioritization at creation.
- **[V3]** Predictive technician assignment based on performance/load history.
- **[V3]** Companion web portal for management (advanced reporting, accounting export).
- **[V3, additional]** Predictive maintenance via recurring-fault detection per client/equipment.
- **[V3, additional]** In-app billing/payment for out-of-warranty interventions.
- **[V3, additional]** Web portal for large institutional clients with multiple sites.

---

## 17. Project Completeness Score

Rated against what's needed to move confidently into **MVP** design/implementation (not against the full V1→V3 roadmap).

| Dimension | Score /10 | Why |
|---|---|---|
| Business Requirements | 9 | Business context, problem statement, objectives, KPIs, stakeholders, and personas are all explicit and internally consistent (§1–4, §9). Only gap: no stated budget/timeline beyond the report's rough cost estimate (§28.6). |
| Functional Requirements | 8 | Every FR is ID'd, prioritized (MoSCoW), and traced to a user story (§6, §10). Gaps are narrow but real: self-registration, profile/settings, search/pagination outside the dashboard (§14). |
| Security | 8 | A01–A03 are report-mandated and concrete; A04–A10 are credibly filled in with standard countermeasures; the E2EE-vs-at-rest-encryption gap is unusually well caught and explained rather than glossed over (§12, §20.2). Open item: no data-protection/compliance framework named for Cameroon specifically. |
2 | Database | 8 | Core three tables (`users`, `interventions`, `messages`) are report-sourced with full DDL; three more (`pieces_jointes`, `notifications`, `audit_logs`) are well-justified additions with full DDL, not hand-waved (§15–16). Minor: no `organizations`/multi-site concept, but that's correctly out of MVP scope. |
| Architecture | 7 | Both Flutter and Laravel target architectures are concretely specified down to folder structure and library choices (§24–25) — but these are all engineering recommendations, not report/commissioner mandates, so they still need sign-off before being treated as fixed. |
| UI Requirements | 7 | 7 core screens (+ variants) are fully specified at the composition/state level (§13) and mirrored in working Stitch mockups. Gaps: profile/settings screen, dark mode palette, and any legal/onboarding screens are unspecified. |
| Backend Requirements | 8 | API contract is concrete (routes, auth, error codes, example payloads, §17) and RBAC/status-machine logic is unambiguous. Gap: no explicit conflict-resolution rule for concurrent writes. |
| Deployment | 6 | Baseline steps (Docker Compose, NGINX, migrate --force) are report-sourced and concrete (§28.2); CI/CD, monitoring, and scaling-beyond-500-users are recommendations only, not yet validated against MSIS's actual hosting budget/capability. |
| Testing | 5 | A full test pyramid with coverage targets is proposed (§27), but it's entirely a recommendation layered onto a report that only describes ad hoc prototype testing — no existing test assets or CI history to build from. |
| **Overall MVP Readiness** | **~76%** | The domain, business rules, RBAC, status machine, and data model are unusually rigorous and ready to design against directly. The main pre-implementation blockers are the 15 open questions in §15 (especially client registration, storage/hosting choices, and timezone/locale decisions) — none of them are large, but each should get an explicit answer before screens or schemas are finalized, to avoid rework. |
