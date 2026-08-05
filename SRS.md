# SOFTWARE REQUIREMENTS SPECIFICATION

## MSIS Secure Intervention Tracking Platform

---

### Document Control

| Field | Value |
|---|---|
| **Project title** | Plateforme sécurisée de communication et de suivi des interventions techniques — Monde Session Info Service (MSIS) |
| **Document type** | Software Requirements Specification (SRS) |
| **Document version** | 1.0 |
| **Status** | Draft — pending Product Owner approval |
| **Scope of this version** | MVP (V1) as defined in §28 (Future Roadmap) |
| **Prepared by** | Engineering documentation function, derived from the internship report of LEBOU YVAN DANIEL (Institut Supérieur AZIMUT) and the client-supplied functional cahier des charges |
| **Primary business source** | `cahier_de_charge.txt` (internship report + client functional specification, merged) |
| **Supporting analysis** | `PROJECT_DISCOVERY.md` (Project Discovery Document), `GAP_ANALYSIS.md` (Gap Analysis Report) |
| **Distribution** | Product Owner (M. Belomo Hervais), Academic Supervisor (Dr Maxwell Manga), Development team (Flutter, Laravel, DevOps, QA) |

### Revision History

| Version | Date | Author | Description |
|---|---|---|---|
| 0.1 | August 2026 | Engineering team | Initial extraction of requirements from the MSIS internship report |
| 1.0 (this document) | August 2026 | Engineering team | Complete SRS: business, functional, non-functional, security, database, API, UI, testing, deployment requirements — synthesized from the report, the client's functional specification, the Project Discovery Document, and the Gap Analysis Report |

### Approval Status

This document is **DRAFT**. It is not authorized for implementation until the following gate is passed:

> All **Must-priority** items in the Decision Register of `GAP_ANALYSIS.md` §11 (D-01, D-17, D-20, D-20b, D-20c, D-21, D-22, D-27, D-28) are resolved by the Product Owner and reflected in this document before development begins. Sections below that depend on an unresolved decision are marked **[PENDING DECISION — see D-xx]** and must not be treated as final.

### Requirement Numbering Conventions

| Prefix | Meaning |
|---|---|
| `BR-###` | Business Requirement |
| `FR-<MODULE>-##` | Functional Requirement (module-scoped, e.g. `FR-AUTH-01`) |
| `NFR-<CATEGORY>-##` | Non-Functional Requirement |
| `BRULE-###` | Business Rule |
| `US-##` | User Story |
| `UC-##` | Use Case |
| `SCR-##` | Screen Specification |
| `SEC-##` | Security Requirement |
| `DR-##` | Data Requirement |
| `TR-##` | Testing Requirement |
| `AC-##` | Acceptance Criterion |

### Requirement Provenance Tagging

Every requirement in this document carries one of three tags, per the project's established documentation discipline (`cahier_de_charge.txt` §0, carried through `PROJECT_DISCOVERY.md` and `GAP_ANALYSIS.md`):

- **[Official Requirement – Report]** — sourced from the internship report; never modified or reinterpreted.
- **[Official Requirement – Client]** — sourced from the client-supplied functional cahier des charges (screen-by-screen requirements); never modified or reinterpreted; prevails over the report's terminology where the two differ.
- **[Engineering Recommendation]** — added because a production-grade enterprise system requires it, and it was not specified by either official source. Always explicitly labeled as such; never presented as an official requirement.

---

## TABLE OF CONTENTS

1. Cover Page *(above)*
2. Table of Contents *(this section)*
3. Executive Summary
4. Business Context
5. Scope
6. Stakeholders
7. Actors
8. Business Requirements
9. Functional Requirements
10. Non-Functional Requirements
11. Business Rules
12. User Stories
13. Use Cases
14. Complete Workflow Specifications
15. Screen Specifications
16. UI Behaviour
17. Security Requirements
18. Data Requirements
19. Reporting Requirements
20. Notification Requirements
21. Messaging Requirements
22. File Management Requirements
23. Search Requirements
24. Logging & Auditing
25. Deployment Requirements
26. Testing Requirements
27. Acceptance Criteria
28. Future Roadmap
29. Appendices

*(This document is authored and delivered in sequential parts due to its length. Each part appends directly to this file — `SRS.md` — under the chapter headers above. No chapter is duplicated across parts. Progress is tracked in the session's task list.)*

---

## 3. EXECUTIVE SUMMARY

### 3.1 Purpose

This Software Requirements Specification defines, completely and unambiguously, the requirements for the MSIS Secure Intervention Tracking Platform — a Flutter mobile application backed by a Laravel REST API and a MySQL database — for its Minimum Viable Product (MVP / V1) release. It is the single source of truth from which UI design, database schema, backend implementation, mobile implementation, security controls, and test plans are derived. No design or implementation decision should be made outside of, or in contradiction to, this document without a formal change to it.

### 3.2 Business Context

Monde Session Info Service (MSIS), a Yaoundé-based IT maintenance, audiovisual, and sound-systems company, currently manages technical intervention requests through phone calls, WhatsApp messages, and paper or spreadsheet records **[Official Requirement – Report]**. This process is untraceable, slow, and — most critically — transmits highly sensitive technical information (administrator passwords, network diagrams, server access credentials) without any encryption **[Official Requirement – Report]**. This platform is commissioned to replace that process entirely with a secure, traceable, role-based digital system.

### 3.3 Project Overview

The platform consists of three cooperating components:

1. A **Flutter mobile application** serving three user roles — Client, Technician, and Supervisor/Administrator — each with a distinct, purpose-built experience **[Official Requirement – Report/Client]**.
2. A **Laravel REST API**, authenticated via Laravel Sanctum bearer tokens, enforcing role-based access control (RBAC) and exposing the full application data model **[Official Requirement – Report, mechanism reconciled per Gap Analysis D-22]**.
3. A **MySQL database** (InnoDB, utf8mb4, 3NF-normalized), storing users, interventions (tickets), encrypted messages, attachments, notifications, and audit logs **[Official Requirement – Report]**.

The system is secured according to the OWASP Top 10:2021 standard, with the internship report explicitly mandating countermeasures for Broken Access Control (A01), Cryptographic Failures (A02), and Injection (A03); this SRS extends coverage to the remaining seven categories as **[Engineering Recommendation]**, consistent with the project's stated OWASP Top 10 compliance objective **[Official Requirement – Report]**.

### 3.4 Expected Value

| Business outcome | Target | Source |
|---|---|---|
| Reduction in average fault-pickup time | −35% vs. current baseline | [Official Requirement – Report] |
| First-contact resolution rate | ≥ 80% within 6 months of operation | [Official Requirement – Report] |
| Client adoption of the platform over informal channels | ≥ 70% within 3 months | [Official Requirement – Report] |
| Production API availability | ≥ 99.5% monthly | [Official Requirement – Report] |
| Uncorrected critical security vulnerabilities in production | 0 | [Official Requirement – Report] |

### 3.5 MVP Boundary

This SRS specifies the **MVP (V1)** scope only, as defined in `cahier_de_charge.txt` §30.1: role-based authentication and RBAC; full intervention lifecycle (creation → assignment → resolution → closure); encrypted ticket-scoped messaging with attachments; Supervisor dashboard with KPIs and filters; push and in-app notifications; Docker/VPS deployment with automated backup. Features explicitly scheduled for V2 or V3 in the source roadmap (full end-to-end encryption, geolocation/route optimization, AI-assisted triage, predictive assignment, a companion web portal, billing) are described in §28 (Future Roadmap) but are **out of scope for this SRS's implementation mandate**.

---

## 4. BUSINESS CONTEXT

### 4.1 Company Profile **[Official Requirement – Report]**

| Field | Value |
|---|---|
| Legal name | Monde Session Info Service (MSIS) |
| Headquarters | Yaoundé, Fabrique-Ngousso, Cameroon |
| Founded | 2019, by M. Belomo Dennis Hervais (owner) |
| Business activities | IT maintenance, audiovisual editing, general sound systems |
| Client base | Individuals, SMEs, and large institutions |
| Organizational structure | Director General → Secretary; Director General → 3 "Maintenancier" poles, including one Maintenancier-Sonorisateur (sound systems specialist) and one Maintenancier-Infographe (graphics specialist) |

### 4.2 Current Business Process (AS-IS) **[Official Requirement – Report]**

1. A client contacts MSIS by phone call or WhatsApp message to report a technical fault.
2. The request is recorded manually — on a paper form or in a spreadsheet — by the secretariat or directly by a technician.
3. Assignment of the request to a specific technician is informal, with no defined assignment rule and no visibility for company management.
4. The technician intervenes on-site or remotely. Sensitive access information — administrator passwords, network diagrams — is exchanged **without encryption**, over phone calls or WhatsApp.
5. Closure of the intervention is not formalized: no reliable record is kept, and no client evaluation is captured.

### 4.3 Problems With the Current Process **[Official Requirement – Report]**

- **No traceability**: paper records and scattered spreadsheets provide no reliable history of interventions.
- **Slow pickup**: without a structured assignment mechanism, requests can sit unaddressed with no visibility to management.
- **Critical confidentiality failure**: administrator passwords, network topology diagrams, and server access credentials are transmitted over consumer messaging channels (WhatsApp) or spoken over the phone — both susceptible to interception and neither auditable.
- **No formal authentication of parties**: there is no verification that the person receiving sensitive access information is in fact the authorized technician.
- **No management visibility**: company leadership has no consolidated view of workload, technician performance, or client satisfaction.

The risk profile of this AS-IS process, mapped to OWASP Top 10:2021 categories, is documented in full in `PROJECT_DISCOVERY.md` §2 and is not repeated here; it is incorporated by reference and treated as an **[Official Requirement – Report]** input to the security requirements in §17 of this document.

### 4.4 Business Objectives **[Official Requirement – Report]**

1. Centralize creation, assignment, and tracking of all technical interventions in a single, traceable system.
2. Secure all exchanges — access credentials, messages, attachments — in compliance with the OWASP Top 10.
3. Provide each role (Client, Technician, Supervisor) with a mobile experience suited to its specific responsibilities.
4. Provide company management with a real-time decisional dashboard covering workload and performance.

### 4.5 Expected Improvements (AS-IS → TO-BE) **[Official Requirement – Report]**

| Dimension | AS-IS | TO-BE |
|---|---|---|
| Fault declaration | Phone call or WhatsApp message | Structured in-app form (title, description, priority, attachment) |
| Assignment | Manual, untracked | Supervisor-assigned, historized, technician notified |
| Status tracking | None, or verbal | Formal statuses visible to all authorized parties |
| Communication | WhatsApp / phone, unencrypted | Ticket-scoped encrypted messaging, access restricted by role and ownership |
| History | Scattered paper records | Centralized, queryable, exportable MySQL database |
| Management oversight | No dashboard | Supervisor dashboard with KPIs and filters |

---

## 5. SCOPE

### 5.1 In Scope (MVP / V1) **[Official Requirement – Report/Client, structured per §30.1]**

- Role-based authentication (Client, Technician, Supervisor/Administrator) with server-side role verification.
- Full intervention (ticket) lifecycle: creation, assignment/reassignment, status progression (`EN_ATTENTE → EN_COURS → RESOLUE → CLOTUREE`, with the reversible `EN_COURS ↔ BLOQUE` branch), and client-confirmed closure with optional satisfaction rating.
- Ticket-scoped, access-controlled, encrypted-at-rest messaging with text and photo attachments.
- Supervisor dashboard: KPI widgets, filters, search, user management, exportable reports.
- Technician mobile workspace: assigned-missions list, mission detail, status transitions, map view of assigned interventions.
- Push (FCM), in-app, and email notifications across all defined trigger events.
- File upload for ticket creation and messaging, with server-side validation.
- Full audit logging of sensitive actions.
- Docker/NGINX/VPS deployment with TLS, automated daily database backups, and a defined disaster-recovery objective.
- Offline-degraded mode: local viewing of last-synced data and queued actions (ticket creation, message sending), replayed automatically on reconnection.

### 5.2 Out of Scope (MVP / V1)

The following are explicitly excluded from this SRS's implementation mandate. Each is either scheduled for a later phase by the source document itself, or flagged by the Gap Analysis as requiring an explicit Product Owner decision before it can be scoped at all:

- Full end-to-end encryption of messaging (device-held keys) — scheduled **V2** per `cahier_de_charge.txt` §30.2 and `GAP_ANALYSIS.md` §12; MVP implements server-side encryption at rest only (see §17.5).
- Technician/intervention geolocation with automatic nearest-technician assignment — **V2**.
- Route optimization for technicians with multiple daily missions — **V2**.
- Client electronic signature at closure — **V2**.
- AI/NLP-assisted ticket categorization and pre-prioritization — **V3**.
- Predictive technician assignment based on performance history — **V3**.
- Companion web portal for management reporting — **V3**.
- Predictive maintenance analytics, in-app billing/payment, multi-site institutional accounts — **V3** (`cahier_de_charge.txt` §31).
- In-app ticket dispute/reopening after closure — explicitly deferred to manual handling by the source itself (`cahier_de_charge.txt` UC-05 alternative flow); not automated in any phase covered by this SRS.
- Biometric authentication, device binding — not required by either official source; explicitly out of MVP per `GAP_ANALYSIS.md` D-23/D-24 pending Product Owner confirmation.

### 5.3 Assumptions

- **[Engineering Recommendation]** MSIS will designate a single Product Owner decision authority (assumed to be M. Belomo Hervais, per §6) empowered to resolve the open decisions listed in §5.5 without requiring full-committee sign-off, to avoid blocking implementation.
- **[Engineering Recommendation]** The initial technician headcount is small (consistent with the 3-pole organizational structure in §4.1), such that the technician-assignment UI does not require enterprise-scale (1000+) picker optimization at MVP.
- **[Engineering Recommendation]** MSIS has, or will provision, a VPS environment capable of running the full Docker Compose topology defined in §25 (including the Redis dependency introduced by this SRS per Gap Analysis D-27).
- **[Official Requirement – Report]** MySQL, Laravel, and Flutter are fixed technology choices and are not open for substitution.

### 5.4 Constraints

- **[Official Requirement – Report]** Deployment target is a self-managed Ubuntu VPS with Docker and NGINX — not a managed PaaS (e.g., not assumed to be AWS/GCP/Azure-managed services) unless a future decision changes this.
- **[Official Requirement – Report]** The system must achieve OWASP Top 10 compliance; no security control described in §17 may be descoped without an explicit, documented risk acceptance by the Product Owner.
- **[Engineering Recommendation]** The 500-concurrent-user capacity target (§10.3) is treated as a hard non-functional constraint for MVP infrastructure sizing; scaling beyond it is explicitly out of scope (§5.2).

### 5.5 Dependencies

- This SRS's finalization for the areas listed below is **contingent on Product Owner decisions** identified in `GAP_ANALYSIS.md` §11 and referenced throughout this document as **[PENDING DECISION — see D-xx]**:
  - Client account creation model (self-service vs. invite-only) — D-01.
  - Ticket cancellation state (`ANNULEE`) — D-17.
  - Soft-delete/account-erasure policy — D-20.
  - WebSocket hosting (self-hosted vs. Pusher) — D-03.
  - File storage backend (local filesystem vs. S3-compatible) — D-04.
  - iOS inclusion at MVP launch — D-05.
  - Production domain name and hosting provider — D-02.
- **[Engineering Recommendation]** Firebase project provisioning (for FCM) is a prerequisite for the notification module (§20) and should be initiated in parallel with backend development, not after.
- **[Engineering Recommendation]** A decision on the Redis-backed cache/queue/rate-limit stack (Gap Analysis D-27/D-27b/D-28) is a prerequisite for finalizing the Docker Compose deployment topology in §25.

---

## 6. STAKEHOLDERS

**[Official Requirement – Report]**, §4 of the source document, reproduced here as formal SRS content with authority and interaction detail added per standard SRS practice:

| Stakeholder | Project role | Authority | Responsibilities | Interaction pattern |
|---|---|---|---|---|
| M. Belomo Hervais | Product Owner / professional supervisor | Final authority on functional scope and business-rule decisions (§5.5) | Represents MSIS's business needs; validates every functional deliverable before release | Reviews and approves each SRS chapter's business-facing content; is the designated authority for all decisions marked [PENDING DECISION] |
| Dr Maxwell Manga | Scrum Master / academic supervisor | Authority over methodological/academic process compliance | Guarantees the Agile Scrum framework and documentation rigor are followed | Reviews process artifacts (sprint plans, this SRS's structure) rather than functional content |
| MSIS General Management | Sponsor / final decision-maker | Budget and go-live authority | Sponsors the project; consumes the Supervisor dashboard's consolidated reporting | Receives periodic reporting via the platform itself (§19) post-launch |
| MSIS Clients (individuals, SMEs, institutions) | End users declaring faults | None (system authority is role-scoped, §7) | Report faults, track resolution, communicate with assigned technicians, confirm closure | Interacts exclusively through the Client mobile experience (§15) |
| Field technicians | End users executing interventions | None (system authority is role-scoped, §7) | Execute assigned interventions, document work, communicate with clients | Interacts exclusively through the Technician mobile experience (§15) |
| Supervisor / Administrator | Operational steering | Full system authority within RBAC bounds (§7, §17) | Assigns/reassigns technicians, manages accounts, monitors KPIs, audits messaging | Interacts through the Supervisor mobile experience (§15); is the only role with global visibility |
| Development team (Flutter, Laravel, DevOps, QA) | Design, build, test, deploy | Technical implementation authority, bounded by this SRS | Implements every requirement in this document; escalates ambiguity via the Decision Register process, not by inventing behavior | Consumes this SRS as the sole specification input for all deliverables |

---

## 7. ACTORS

The system's data model defines exactly **three** roles (`users.role ENUM('ADMIN','TECHNICIEN','CLIENT')`, `cahier_de_charge.txt` §16) **[Official Requirement – Report]**. "Supervisor" and "Administrator" are the same role throughout the source material and this SRS — referred to as **Supervisor** in business/UI language and `ADMIN` in the data model and API. This SRS does not introduce a fourth, separate Administrator actor; doing so would contradict the official data model.

### 7.1 Client

**[Official Requirement – Report/Client]**

| Aspect | Specification |
|---|---|
| Responsibilities | Report technical faults via a structured form; track ticket status in real time; communicate with the assigned technician; confirm intervention closure and optionally rate satisfaction (1–5); maintain a personal history of past tickets. |
| Permissions | Create interventions (own only); view and act on interventions where `id_client = self`; send/receive messages on own tickets; trigger the `RESOLUE → CLOTUREE` transition. |
| Restrictions | Cannot assign or reassign technicians; cannot view any other client's tickets; cannot perform any status transition other than the final closure confirmation; cannot force an illegal status transition (rejected by the API with HTTP 422, per BRULE-003). |
| Typical workflow | Authenticate → create ticket (title, description, priority, optional attachment) → receive ticket number → track status → message the assigned technician once one exists → upon `RESOLUE`, review the technician's report → confirm closure with optional rating. |

### 7.2 Technician

**[Official Requirement – Report/Client]**

| Aspect | Specification |
|---|---|
| Responsibilities | Consult assigned missions; execute interventions on-site or remotely; communicate with the client without leaking sensitive information outside the secured messaging channel; document work via a mandatory technical report before marking resolution. |
| Permissions | View and act on interventions where `id_technicien = self`; transition `EN_ATTENTE → EN_COURS` (pickup); transition `EN_COURS ↔ BLOQUE` (with mandatory reason on entry); transition `EN_COURS → RESOLUE` (with mandatory technical report); send/receive messages on assigned tickets. |
| Restrictions | Cannot create tickets; cannot assign or reassign technicians, including self-assignment of unassigned tickets; cannot trigger `RESOLUE → CLOTUREE` (client-exclusive action); cannot skip any status transition. |
| Typical workflow | Authenticate → view assigned-missions list with KPI summary (Assignées / En cours / Clôturées) → open a mission's detail → pick up (move to `EN_COURS`) → execute the intervention → optionally flag a blockage with reason, then resume → submit a mandatory technical report and mark `RESOLUE` → the client and supervisor are notified. |

### 7.3 Supervisor / Administrator

**[Official Requirement – Report/Client]**

| Aspect | Specification |
|---|---|
| Responsibilities | Maintain global oversight of all interventions; assign and reassign technicians; manage user accounts (create technician accounts, activate/deactivate any account); consolidate reporting for company management; audit messaging conversations when required. |
| Permissions | View **all** interventions regardless of ownership; assign or reassign a technician on any ticket at any time, including an already-`EN_COURS` ticket; activate/deactivate any user account; create technician accounts (with invitation email); read-only audit access to any ticket's conversation, with every access logged; export activity reports (CSV/PDF). |
| Restrictions | Cannot send messages within a ticket's conversation — audit access is strictly read-only and every read is logged to the audit trail (`audit_logs`, action `message_audit_read`). |
| Typical workflow | Authenticate → view the dashboard (4 KPI widgets: Total / En attente / En cours / Clôturées) → filter/search the intervention list → open a ticket's detail to assign or reassign a technician → switch to the Utilisateurs tab to manage accounts → switch to the Rapports tab to export activity data. |

### 7.4 Actor Interaction Summary

The three actors interact exclusively through the data model's ownership relationships — a Client and a Technician never interact except through a ticket the Supervisor has linked them by (via `id_client` and `id_technicien` on the same `interventions` row), and the Supervisor is the only actor with unrestricted visibility across all actor pairs. This triangular, ticket-mediated interaction model is foundational to every access-control rule in §17 and every screen's data-scoping logic in §15; it is not restated per-screen beyond a pointer back to this section.

---

## 8. BUSINESS REQUIREMENTS

Numbered, top-level business requirements. Each is traced to the objectives in §4.4 and decomposed into Functional Requirements in §9.

| ID | Business Requirement | Traces to | Tag |
|---|---|---|---|
| BR-001 | The system shall provide a single, centralized record of every technical intervention from creation to closure, replacing paper and spreadsheet tracking. | §4.4 Objective 1 | [Official Requirement – Report] |
| BR-002 | The system shall enforce role-based access such that no user can view or modify data outside their role's authorized scope. | §4.4 Objective 2, §4.3 | [Official Requirement – Report] |
| BR-003 | The system shall encrypt all sensitive data — messages, stored credentials — in transit and at rest, eliminating the plaintext transmission that characterizes the current process. | §4.4 Objective 2, §4.3 | [Official Requirement – Report] |
| BR-004 | The system shall provide each of the three roles (Client, Technician, Supervisor) with a distinct, purpose-built mobile experience. | §4.4 Objective 3 | [Official Requirement – Report] |
| BR-005 | The system shall provide company management with a real-time, consolidated view of intervention workload, status distribution, and technician performance. | §4.4 Objective 4 | [Official Requirement – Report] |
| BR-006 | The system shall reduce the average time between fault declaration and pickup by technicians, targeting a 35% reduction versus the current baseline. | §4.4, §3.4 KPI table | [Official Requirement – Report] |
| BR-007 | The system shall achieve a first-contact resolution rate of at least 80% within six months of production operation. | §3.4 KPI table | [Official Requirement – Report] |
| BR-008 | The system shall achieve at least 70% client adoption over informal channels within three months of production operation. | §3.4 KPI table | [Official Requirement – Report] |
| BR-009 | The system shall maintain a complete, timestamped, tamper-evident audit trail of all sensitive actions, for a minimum retention period of 12 months. | §4.3, OWASP A09 | [Engineering Recommendation, formalizing an explicit report gap — see §4.3] |
| BR-010 | The system shall remain functional in a degraded capacity when network connectivity is unavailable, queuing user actions for automatic synchronization upon reconnection. | Cross-cutting requirement, `cahier_de_charge.txt` §6.7 | [Official Requirement – Client] |
| BR-011 | The system shall provide an extensible technical foundation permitting future addition of geolocation, real-time notification enhancements, and predictive analytics without a foundational redesign. | §4.4 strategic goal (§3.2 of `cahier_de_charge.txt`) | [Official Requirement – Report] |
| BR-012 | The system shall be deployable and operable at a total cost of ownership consistent with MSIS's scale as a small/medium enterprise, using self-managed infrastructure (VPS, Docker) rather than a premium managed cloud platform. | §5.4 Constraints | [Official Requirement – Report] |
| BR-013 | The system shall support company growth by accommodating institutional clients with more complex organizational needs in a future phase, without requiring MVP data to be migrated destructively. | `cahier_de_charge.txt` §31 | [Official Requirement – Report, V3-scoped] |

---

## 9. FUNCTIONAL REQUIREMENTS

This chapter specifies every feature, validation rule, workflow, permission, exception, error state, and confirmation behavior for the MVP. Requirements are grouped by module. Each requirement carries its MoSCoW priority (Must/Should/Could/Won't) as established in `cahier_de_charge.txt` §6, and its provenance tag. Requirements not present in the official sources but required to close a gap identified in `GAP_ANALYSIS.md` are numbered as new IDs within the relevant module and explicitly marked **[Engineering Recommendation]**.

### 9.1 Module: Authentication & Session Management

| ID | Requirement | Priority | Tag |
|---|---|---|---|
| FR-AUTH-01 | The user shall select their role (Client, Technicien, Superviseur) before entering credentials. | Must | [Official Requirement – Client] |
| FR-AUTH-02 | The user shall enter email and password, with a show/hide toggle icon on the password field. | Must | [Official Requirement – Client] |
| FR-AUTH-03 | The login screen shall display a trust banner: "Connecté et sécurisé — Chiffrement SSL 256-bit." | Should | [Official Requirement – Client] |
| FR-AUTH-04 | A "Mot de passe oublié ?" link shall initiate the email-based password reset flow. | Must | [Official Requirement – Client] |
| FR-AUTH-05 | On submission, credentials shall be sent to the API; on success, an access token shall be received and stored in encrypted, platform-native secure storage on the device. | Must | [Official Requirement – Client] |
| FR-AUTH-06 | The role selected on the login screen shall be re-verified server-side against the authenticated user's actual role; any mismatch shall be rejected. The client-side role selection shall never be trusted as an authorization signal. | Must | [Official Requirement – Client] |
| FR-AUTH-07 | After 5 consecutive failed login attempts on the same account, a progressive delay (rate limiting) shall be applied before another attempt is permitted. | Should | [Official Requirement – Client] |
| FR-AUTH-08 | Password creation and password reset shall enforce a minimum of 8 characters, including at least one uppercase letter, one digit, and one special character. Login itself imposes no complexity check beyond non-empty submission. | Must (validation rule) | [Official Requirement – Client] |
| FR-AUTH-09 | The user shall be able to log out of the current device only, or log out of all devices simultaneously, revoking every access token associated with the account. | Should | [Engineering Recommendation, formalizing `cahier_de_charge.txt` §18.4] |
| FR-AUTH-10 | An authenticated user shall be able to change their password from within the app (distinct from the unauthenticated forgot-password flow), requiring re-entry of the current password. | Should | [Engineering Recommendation — closes the gap identified in `GAP_ANALYSIS.md` §1] |
| FR-AUTH-11 | Client account registration shall be self-service, gated by mandatory email verification before the account may create its first ticket. **[PENDING DECISION — see D-01; this SRS adopts the Gap Analysis's recommended option and must be reconfirmed by the Product Owner before implementation.]** | Must | [Engineering Recommendation, resolving an explicitly open report question] |
| FR-AUTH-12 | Technician and Supervisor accounts shall be created exclusively by an existing Supervisor, via an invitation email containing a time-limited activation link. | Should | [Official Requirement – Report/Client] |

**Validation rules — Authentication:**
- Email: must be a valid RFC 5322 address; required.
- Password (login): required, non-empty; no complexity check applied at login time.
- Password (creation/reset): per FR-AUTH-08.

**Error, loading, and success states — Authentication:**
- *Loading:* the login button displays a circular progress indicator and disables; all input fields become read-only.
- *Error (invalid credentials):* an inline message reads "Email ou mot de passe incorrect" — it never indicates which field is at fault, to prevent account enumeration.
- *Error (disabled account):* an explicit message reads "Compte désactivé, contactez votre administrateur."
- *Error (rate-limited):* an explicit message states that too many attempts have occurred and specifies (or implies) a retry delay.
- *Success:* automatic redirect to the dashboard corresponding to the authenticated role.

### 9.2 Module: Profile & Settings **[Engineering Recommendation — new module, closes gap identified in `GAP_ANALYSIS.md` §1/§5]**

| ID | Requirement | Priority | Tag |
|---|---|---|---|
| FR-PROF-01 | Every authenticated user shall have access to a Profile screen displaying their name, email, role, and phone number (if provided). | Must | [Engineering Recommendation] |
| FR-PROF-02 | A user shall be able to edit their name and phone number from the Profile screen; email is not user-editable (it is the login identifier). | Should | [Engineering Recommendation] |
| FR-PROF-03 | A user shall be able to change their password from the Profile screen (see FR-AUTH-10). | Should | [Engineering Recommendation] |
| FR-PROF-04 | A user shall be able to toggle in-app notification preferences (mute/unmute categories) from a Settings screen, without affecting the underlying notification triggers defined in §20. | Could | [Engineering Recommendation] |
| FR-PROF-05 | A user shall be able to switch the application's display language between French and English from the Settings screen; the selection persists across sessions. | Should | [Engineering Recommendation, formalizing the NFR in `cahier_de_charge.txt` §7 per Gap Analysis D-06] |
| FR-PROF-06 | A user shall be able to toggle dark mode manually, or leave it following the system preference. | Could | [Official Requirement – Client, FR-TRV-05] |
| FR-PROF-07 | The Profile screen shall provide a "Log out" action and, per FR-AUTH-09, a "Log out of all devices" action. | Must | [Engineering Recommendation] |

### 9.3 Module: Create Intervention (Client)

| ID | Requirement | Priority | Tag |
|---|---|---|---|
| FR-CRT-01 | A required short-text "Titre de l'intervention" field shall be provided. | Must | [Official Requirement – Client] |
| FR-CRT-02 | A required multiline "Description détaillée" field shall be provided. | Must | [Official Requirement – Client] |
| FR-CRT-03 | A priority selector shall be provided with three options: Haute, Normale, Basse. | Must | [Official Requirement – Client] |
| FR-CRT-04 | The client shall be able to attach a photo from the device gallery or camera. | Should | [Official Requirement – Client] |
| FR-CRT-05 | On submission, the ticket shall be created with status `EN_ATTENTE`, owned by the submitting client (`id_client`). | Must | [Official Requirement – Client] |
| FR-CRT-06 | A creation acknowledgment shall be displayed, including the generated ticket number. | Should | [Official Requirement – Client] |
| FR-CRT-07 | Every active Supervisor account shall receive a notification upon ticket creation. | Must | [Official Requirement – Client] |
| FR-CRT-08 | A client shall be able to cancel a ticket that has not yet been picked up (status `EN_ATTENTE`), transitioning it to a terminal `ANNULEE` state. Cancellation shall not be available once a ticket has moved to `EN_COURS` or beyond. **[PENDING DECISION — see D-17; requires Product Owner sign-off before the `interventions.statut` ENUM is finalized, since this adds a new value.]** | Should | [Engineering Recommendation — closes the gap identified in `GAP_ANALYSIS.md` §2] |
| FR-CRT-09 | A Supervisor shall be able to create a ticket on behalf of a client, selecting the owning client from the active client list. The true creating actor (if different from `id_client`) shall be recorded in the audit log. | Should | [Official Requirement – Report, §8.4, with audit detail per `GAP_ANALYSIS.md` D-16c] |

**Validation rules — Create intervention:**
- Title: 5–150 characters, required.
- Description: 10–3000 characters, required.
- Priority: required, one of `{BASSE, NORMALE, HAUTE}`; defaults to `NORMALE` if left unset by the UI (the field itself must not be submittable as empty).
- Attachment: JPG, PNG, or PDF; ≤10MB per file; ≤5 files per ticket.

**Error, offline, and success states — Create intervention:**
- *Validation error:* inline messages appear beneath each invalid field; the submit button remains disabled until the form is valid.
- *Network failure:* a banner reads "Impossible de créer le ticket, vérifiez votre connexion," with a retry option; the draft is preserved locally per the offline mode (§9.9, BR-010).
- *Offline:* an orange banner reads "Vous êtes hors-ligne — le ticket sera envoyé automatiquement"; the submit button remains active and stores the ticket locally for later sync.
- *Success:* a confirmation dialog reads "Ticket créé — N° INT-2026-000123" (illustrative format) with a "Voir le ticket" action leading to the new ticket's detail screen.

### 9.4 Module: Intervention Detail, Status, and Messaging

| ID | Requirement | Priority | Tag |
|---|---|---|---|
| FR-DET-01 | The detail screen shall display all ticket information: title, description, priority, status, owning client, assigned technician, attachments, and history. | Must | [Official Requirement – Client] |
| FR-DET-02 | Status shall change only along the authorized sequence: `EN_ATTENTE → EN_COURS → RESOLUE → CLOTUREE`, with the sole reversible exception `EN_COURS ↔ BLOQUE` (see BRULE-002 for the full transition table). | Must | [Official Requirement – Client] |
| FR-DET-03 | A secure, 1:1 conversation linked to `id_intervention` shall be available to authorized parties. | Must | [Official Requirement – Client] |
| FR-DET-04 | Users shall be able to send text messages and photos within the conversation. | Must | [Official Requirement – Client] |
| FR-DET-05 | The full conversation history shall be retained and retrievable at any time by authorized parties. | Must | [Official Requirement – Client] |
| FR-DET-06 | A push notification shall be sent upon receipt of a new message. | Must | [Official Requirement – Client] |
| FR-DET-07 | Each message shall display a timestamp and a "seen" indicator once read by the recipient. | Should | [Official Requirement – Client] |
| FR-DET-08 | Only the owning client, the assigned technician, and the Administrator (in read-only audit mode) shall be able to access a ticket's conversation. | Must | [Official Requirement – Client] |
| FR-DET-09 | Each message shall additionally track a "delivered" state (delivered to the recipient's device), distinct from "read" (opened by the recipient). | Should | [Engineering Recommendation — closes the gap identified in `GAP_ANALYSIS.md` §8, aligning the schema with the delivered→read progression already described in UC-06] |
| FR-DET-10 | A "typing…" indicator shall be shown when the counterpart is composing a message, delivered as an ephemeral WebSocket event; it shall not appear when the app has fallen back to REST polling (§21.2). | Could | [Official Requirement – Report, §20.4, with fallback behavior per `GAP_ANALYSIS.md` D-29] |
| FR-DET-11 | Once a ticket reaches `CLOTUREE`, its conversation shall become read-only: no new messages may be sent by the client or technician; historical messages remain visible. | Should | [Engineering Recommendation — closes the gap identified in `GAP_ANALYSIS.md` §11, D-11] |

**Status transition detail — FR-DET-02:**
- `EN_ATTENTE → EN_COURS`: triggered by technician assignment (Supervisor) or pickup (Technician).
- `EN_COURS → BLOQUE`: triggered by the Technician, with a **mandatory** reason (`motif_blocage`).
- `BLOQUE → EN_COURS`: triggered by the Technician once the blockage is resolved.
- `EN_COURS → RESOLUE`: triggered by the Technician, with a **mandatory** technical report (`rapport_technique`).
- `RESOLUE → CLOTUREE`: triggered by the Client, with an optional 1–5 satisfaction rating and free-text comment.
- No transition outside this table is permitted; any attempted illegal transition (e.g. `EN_ATTENTE → RESOLUE`) shall be rejected by the API with **HTTP 422** and an explicit error message.

**Error and access-control states — Intervention detail:**
- *Unauthorized access attempt:* a user who is neither the owning client, the assigned technician, nor an Administrator receives **HTTP 403** when attempting to view a ticket or its conversation.
- *Illegal status transition attempt:* **HTTP 422**, with an error payload naming the invalid transition explicitly (never a generic failure message).
- *Empty conversation:* an empty-state illustration with the text "Aucune conversation" and subtext "Les conversations démarrées depuis les interventions apparaîtront ici" is shown before any message exists.

### 9.5 Module: Supervisor Dashboard

| ID | Requirement | Priority | Tag |
|---|---|---|---|
| FR-DASH-01 | Four KPI widgets shall be displayed: Total, En attente, En cours, Clôturées. | Must | [Official Requirement – Client] |
| FR-DASH-02 | Three tabs shall organize the dashboard: Interventions, Utilisateurs, Rapports. | Must | [Official Requirement – Client] |
| FR-DASH-03 | Quick status filters shall be available on the intervention list: Toutes, En attente, En cours, Clôturées. | Must | [Official Requirement – Client] |
| FR-DASH-04 | An empty state reading "Aucune intervention," with a mailbox icon, shall be shown when a filter yields no results. | Should | [Official Requirement – Client] |
| FR-DASH-05 | Text search on ticket title or client name shall be available. | Could | [Official Requirement – Client] |
| FR-DASH-06 | Sorting by creation date, priority, or status shall be available. | Could | [Official Requirement – Client] |
| FR-DASH-07 | A priority filter (Haute/Normale/Basse) and a date-range filter shall be available alongside the status filters. | Could | [Engineering Recommendation — closes the gap identified in `GAP_ANALYSIS.md` §1] |
| FR-DASH-08 | The intervention list shall be paginated at 20 items per page, with pull-to-refresh and infinite scroll. | Must | [Official Requirement – Client, §13.3] |

### 9.6 Module: User Management (Supervisor)

| ID | Requirement | Priority | Tag |
|---|---|---|---|
| FR-USR-01 | Two distinct lists shall be provided: Techniciens and Clients. | Must | [Official Requirement – Client] |
| FR-USR-02 | Each row shall display Name, Email, and Status (Actif/Inactif) with a color-coded badge. | Must | [Official Requirement – Client] |
| FR-USR-03 | An Activate/Deactivate action shall be available per account, requiring confirmation before it takes effect. | Must | [Official Requirement – Client] |
| FR-USR-04 | Deactivating a technician account shall automatically release their un-started `EN_ATTENTE` tickets for reassignment; tickets already `EN_COURS` remain assigned and visible for closure, but the deactivated technician's write access to them is revoked. | Should | [Official Requirement – Client, with the write-access-revocation detail resolved per `GAP_ANALYSIS.md` D-16b] |
| FR-USR-05 | The Supervisor shall be able to create a new technician account, triggering an invitation email. | Should | [Official Requirement – Client] |
| FR-USR-06 | The user management screens shall support text search on name/email, in addition to the two-list Technicien/Client split. | Could | [Engineering Recommendation] |

### 9.7 Module: Technician Space

| ID | Requirement | Priority | Tag |
|---|---|---|---|
| FR-TECH-01 | Three KPI widgets shall be displayed: Assignées, En cours, Clôturées. | Must | [Official Requirement – Client] |
| FR-TECH-02 | An "Interventions assignées" list, filterable by status, shall be provided. | Must | [Official Requirement – Client] |
| FR-TECH-03 | A bottom navigation bar shall provide four destinations: Missions, Carte, Messages, Profil. | Must | [Official Requirement – Client] |
| FR-TECH-04 | Tapping a mission shall open its full detail view with the ability to change status. | Must | [Official Requirement – Client] |
| FR-TECH-05 | The "Carte" tab shall display the location of assigned interventions on a map. | Could | [Official Requirement – Client] |
| FR-TECH-06 | The "Messages" tab shall list all active conversations across the technician's assigned tickets, each opening to that ticket's conversation. | Should | [Engineering Recommendation, formalizing the navigation map in `cahier_de_charge.txt` §12.3] |

### 9.8 Module: Notifications

Full trigger and channel matrix is specified in §20 (Notification Requirements) and is incorporated here by reference to avoid duplication. The functional requirement is:

| ID | Requirement | Priority | Tag |
|---|---|---|---|
| FR-NOTIF-01 | The system shall deliver notifications via push (FCM), in-app feed, and email channels according to the event-trigger matrix in §20.2. | Must | [Official Requirement – Report/Client, formalized as [Engineering Recommendation] fill-in per `cahier_de_charge.txt` §21] |
| FR-NOTIF-02 | Tapping a push notification shall deep-link directly to the relevant ticket detail (and conversation tab, for message notifications), not to a generic home screen. | Should | [Engineering Recommendation — closes the gap identified in `GAP_ANALYSIS.md` §5, D-25] |
| FR-NOTIF-03 | An in-app notification feed with an unread-count badge shall be accessible from every screen's app bar. | Must | [Official Requirement – Report, §21.1] |

### 9.9 Module: Cross-Cutting Requirements

| ID | Requirement | Priority | Tag |
|---|---|---|---|
| FR-TRV-01 | A client shall see and act only on their own interventions. | Must | [Official Requirement – Client] |
| FR-TRV-02 | A technician shall see and act only on interventions assigned to them. | Must | [Official Requirement – Client] |
| FR-TRV-03 | A supervisor shall see all interventions and be able to assign or reassign a technician. | Must | [Official Requirement – Client] |
| FR-TRV-04 | The application shall function in a degraded offline mode: viewing of last-synced data, and queuing of actions (ticket creation, message sending) for automatic replay upon reconnection. | Should | [Official Requirement – Client] |
| FR-TRV-05 | The application shall offer a dark mode following system preference (see FR-PROF-06 for the manual override). | Could | [Official Requirement – Client] |
| FR-TRV-06 | Offline-queued actions that become invalid before synchronization (e.g., a status transition that is no longer legal, or an assignment to a now-deactivated technician) shall be rejected on sync with an explicit, itemized error surfaced to the user — never silently discarded or silently reinterpreted. | Should | [Engineering Recommendation — closes the gap identified in `GAP_ANALYSIS.md` §5, D-16d] |

## 10. NON-FUNCTIONAL REQUIREMENTS

### 10.1 Performance

| ID | Requirement | Target | Tag |
|---|---|---|---|
| NFR-PERF-01 | API response time for common read/write operations (list retrieval, ticket creation) | P95 < 400ms, excluding file upload transfer time | [Engineering Recommendation] |
| NFR-PERF-02 | Mobile application cold-start time | < 2.5s on a mid-range Android device | [Engineering Recommendation] |
| NFR-PERF-03 | Dashboard KPI aggregation query response time | P95 < 800ms at 500 concurrent users (higher tolerance than simple list reads, given aggregation cost) | [Engineering Recommendation, refining the general target per `GAP_ANALYSIS.md` §7] |

### 10.2 Availability & Reliability

| ID | Requirement | Target | Tag |
|---|---|---|---|
| NFR-AVAIL-01 | Production API uptime | ≥ 99.5% monthly, with maintenance windows scheduled outside MSIS business hours | [Engineering Recommendation] |
| NFR-AVAIL-02 | Health-check endpoint (`/api/v1/health`) shall be probed every 5 minutes with alerting on failure | N/A (operational requirement) | [Engineering Recommendation] |
| NFR-REL-01 | Offline-queued actions shall be delivered exactly once on reconnection — no duplicate ticket creation or duplicate message send | 0 duplicate submissions in integration testing | [Official Requirement – Report, §27.3] |

### 10.3 Scalability

| ID | Requirement | Target | Tag |
|---|---|---|---|
| NFR-SCALE-01 | Concurrent active users supported without notable degradation | 500 | [Engineering Recommendation] |
| NFR-SCALE-02 | The system's data model and API contract shall not require a breaking redesign to support horizontal scaling beyond the 500-user ceiling in a future phase | N/A (design constraint) | [Engineering Recommendation] |

### 10.4 Maintainability

| ID | Requirement | Target | Tag |
|---|---|---|---|
| NFR-MAINT-01 | Automated test coverage of critical backend code (authentication, RBAC, status transitions) | ≥ 80% | [Engineering Recommendation] |
| NFR-MAINT-02 | Automated test coverage of Flutter controllers/notifiers and model mappers | ≥ 75% | [Engineering Recommendation] |
| NFR-MAINT-03 | Static analysis (lint) shall run in CI on every pull request with zero tolerated errors | 0 lint errors merged to main | [Engineering Recommendation] |

### 10.5 Accessibility

| ID | Requirement | Target | Tag |
|---|---|---|---|
| NFR-A11Y-01 | Color contrast on all text/background combinations | WCAG 2.1 AA — contrast ratio ≥ 4.5:1 | [Engineering Recommendation] |
| NFR-A11Y-02 | Touch target size on all interactive elements | ≥ 44×44dp (≥ 48×48dp for field-use forms per the design system, §16 UI Behaviour) | [Engineering Recommendation] |
| NFR-A11Y-03 | All form fields shall expose a semantic label readable by screen readers (TalkBack), applied consistently across every screen, not only the authentication screen | N/A (design constraint) | [Engineering Recommendation, broadening the report's single-screen mention per `GAP_ANALYSIS.md` §5] |

### 10.6 Localization

| ID | Requirement | Target | Tag |
|---|---|---|---|
| NFR-L10N-01 | Supported languages | French (default), English | [Official Requirement – Report] |
| NFR-L10N-02 | All user-facing strings shall be externalized to a translation-key architecture (ARB files) from the first screen built, regardless of whether English content is complete at MVP launch | N/A (architecture constraint) | [Engineering Recommendation, per `GAP_ANALYSIS.md` D-06] |

### 10.7 Offline Capability

| ID | Requirement | Target | Tag |
|---|---|---|---|
| NFR-OFF-01 | Viewing of last-synchronized data without network connectivity | Full read access to locally cached tickets/messages | [Official Requirement – Client, FR-TRV-04] |
| NFR-OFF-02 | Queuing of write actions (ticket creation, message send) without network connectivity, with automatic sync on reconnection | Persisted local queue, chronological replay | [Official Requirement – Client, FR-TRV-04] |

### 10.8 Security

Full security requirements are specified in §17. The NFR-level target is:

| ID | Requirement | Target | Tag |
|---|---|---|---|
| NFR-SEC-01 | Uncorrected critical or high-severity security vulnerabilities in production | 0 | [Official Requirement – Report] |
| NFR-SEC-02 | OWASP ZAP automated security scan | Run on every staging deployment | [Engineering Recommendation, formalizing `cahier_de_charge.txt` §27.5] |

### 10.9 Compliance

| ID | Requirement | Target | Tag |
|---|---|---|---|
| NFR-COMP-01 | The system's data-retention and account-deletion behavior shall be reviewed against applicable Cameroon data protection requirements before go-live. **[PENDING DECISION — see D-10; this is a legal review dependency, not a resolved requirement.]** | N/A | [Engineering Recommendation] |

### 10.10 Monitoring & Logging

| ID | Requirement | Target | Tag |
|---|---|---|---|
| NFR-MON-01 | Application error tracking (mobile and backend) | Centralized via Sentry or equivalent, with alerting on crash-rate spikes | [Engineering Recommendation] |
| NFR-MON-02 | Application log centralization | stdout of all containers collected via Loki or equivalent | [Engineering Recommendation] |
| NFR-MON-03 | Alerting on repeated authentication failures and HTTP 5xx spikes | Real-time alert to the on-call channel | [Engineering Recommendation] |

### 10.11 Backup & Recovery

| ID | Requirement | Target | Tag |
|---|---|---|---|
| NFR-BAK-01 | Database backup frequency and retention | Automated daily, 30-day retention | [Engineering Recommendation] |
| NFR-BAK-02 | Backup restore validation | Quarterly documented restore test | [Engineering Recommendation] |
| NFR-BAK-03 | Backup storage location | Off-site, distinct from the production VPS. **[PENDING DECISION — see D-26; specific provider/region not yet chosen.]** | [Engineering Recommendation] |
| NFR-DR-01 | Recovery Point Objective (RPO) | ≤ 24 hours | [Engineering Recommendation] |
| NFR-DR-02 | Recovery Time Objective (RTO) | ≤ 4 hours | [Engineering Recommendation] |

### 10.12 Data Integrity

| ID | Requirement | Target | Tag |
|---|---|---|---|
| NFR-DATA-01 | MySQL referential integrity | Foreign key constraints active (InnoDB), enforced at all times | [Official Requirement – Report] |
| NFR-DATA-02 | Multi-table operations (e.g., status change + notification + audit-log write) shall be wrapped in atomic database transactions | 100% of multi-table write operations | [Engineering Recommendation, per `GAP_ANALYSIS.md` §7] |

---

## 11. BUSINESS RULES

Every business rule governing system behavior, numbered and non-summarized.

**BRULE-001 — Ticket ownership and visibility.** [Official Requirement – Report]
A Client sees and acts only on interventions where `id_client` equals their own user ID. A Technician sees and acts only on interventions where `id_technicien` equals their own user ID. A Supervisor/Administrator sees all interventions without restriction and may assign or reassign a technician on any ticket at any time, including a ticket already `EN_COURS`.

**BRULE-002 — Status transition rule.** [Official Requirement – Client]
A ticket's status may only progress along the sequence `EN_ATTENTE → EN_COURS → RESOLUE → CLOTUREE`. The sole permitted reversible exception is `EN_COURS ↔ BLOQUE`. Any transition not present in this rule — including any attempt to skip a state (e.g., `EN_ATTENTE → RESOLUE` directly) — must be rejected by the API with HTTP 422.

**BRULE-003 — Status transition triggers and preconditions.** [Official Requirement – Report/Client]
- `EN_ATTENTE → EN_COURS`: requires either a Supervisor assignment action or a Technician pickup action.
- `EN_COURS → BLOQUE`: requires a Technician action and a non-empty `motif_blocage`.
- `BLOQUE → EN_COURS`: requires a Technician action, no additional data required.
- `EN_COURS → RESOLUE`: requires a Technician action and a non-empty `rapport_technique`.
- `RESOLUE → CLOTUREE`: requires a Client action; `note_satisfaction` (1–5) and a free-text comment are optional.

**BRULE-004 — Messaging access control.** [Official Requirement – Client]
A ticket's conversation is accessible only to the owning client, the assigned technician, and the Administrator in read-only audit mode. Every audit-mode read by an Administrator must be logged to `audit_logs` with action `message_audit_read`.

**BRULE-005 — RBAC action matrix.** [Official Requirement – Report]

| Action | Client | Technicien | Superviseur/Admin |
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

**BRULE-006 — Field validation: authentication.** [Official Requirement – Client]
Email must conform to RFC 5322 and is required. Login password is required and non-empty with no complexity check. Password creation/reset requires a minimum of 8 characters including at least one uppercase letter, one digit, and one special character.

**BRULE-007 — Field validation: ticket creation.** [Official Requirement – Client]
Title: 5–150 characters. Description: 10–3000 characters. Priority: required, one of `{BASSE, NORMALE, HAUTE}`, defaulting to `NORMALE`. Attachments: JPG/PNG/PDF, ≤10MB per file, ≤5 files per ticket.

**BRULE-008 — Account deactivation cascade.** [Official Requirement – Client]
Deactivating a technician account automatically releases their un-started `EN_ATTENTE` tickets for reassignment. Tickets already `EN_COURS` remain assigned to the deactivated technician for visibility purposes, but per BRULE-013 the deactivated account's write access to the API is revoked entirely, so those tickets require Supervisor reassignment before further progress can be made on them.

**BRULE-009 — File upload rules.** [Official Requirement – Report, engineering-detailed]
Accepted image types: JPG, PNG, WEBP. Accepted document type: PDF. Maximum file size: 10MB. Maximum count: 5 files at ticket creation, 1 file per message. The server must validate the true MIME type of an uploaded file (not merely its extension) and reject any executable or script content. Client-side image recompression (maximum 1920px resolution, 80% quality) is applied before upload.

**BRULE-010 — Notification SLA rules.** [Engineering Recommendation, formalizing `cahier_de_charge.txt` §21.3]
A reminder notification is sent to the client if a ticket remains `RESOLUE` without closure confirmation for 5 days. An alert is sent to Supervisors if a ticket remains `EN_ATTENTE` unassigned for more than 2 business hours (priority `HAUTE`) or 24 hours (other priorities).

**BRULE-011 — Auto-closure rule.** [Engineering Recommendation — requires explicit Product Owner confirmation per D-13 before implementation]
If a client does not confirm closure within 7 days of a ticket reaching `RESOLUE`, the ticket is automatically transitioned to `CLOTUREE` with a system-generated note, and the client is notified. This rule is not an official requirement and must not be implemented without explicit Product Owner sign-off, since it changes ticket state without direct user action.

**BRULE-012 — Dispute handling.** [Official Requirement – Report]
A client dissatisfied with a resolution may contest it by contacting the Supervisor directly. This is explicitly and intentionally outside the automated V1 system — no in-app dispute/reopen mechanism exists in this SRS's scope.

**BRULE-013 — Deactivated account access revocation.** [Engineering Recommendation, resolving `GAP_ANALYSIS.md` D-16b]
The moment a user account's `actif` flag is set to `false`, all of that account's active API bearer tokens must be immediately revoked (not merely left to expire naturally), and any subsequent API request bearing a token issued to that account must be rejected with HTTP 401.

**BRULE-014 — Rate limiting.** [Engineering Recommendation, formalizing `cahier_de_charge.txt` §26.1]

| Endpoint | Limit |
|---|---|
| `POST /auth/login` | 5 attempts / 15 minutes / IP address + account |
| `POST /auth/forgot-password` | 3 requests / hour / email address |
| `POST /interventions` (creation) | 20 creations / hour / user |
| `POST /interventions/{id}/messages` (send) | 60 messages / minute / user |

**BRULE-015 — Anti-enumeration rule.** [Official Requirement – Report/Client]
The `/auth/forgot-password` endpoint returns an identical response regardless of whether the supplied email corresponds to an existing account. The login error message never indicates which of email or password was incorrect.

**BRULE-016 — Reassignment carry-over.** [Engineering Recommendation, resolving `GAP_ANALYSIS.md` D-12]
When a ticket is reassigned from one technician to another, the ticket's `motif_blocage` and `rapport_technique` fields (if populated) are preserved unchanged, and the full conversation history remains visible to the newly assigned technician for context continuity.

**BRULE-017 — Post-closure messaging lock.** [Engineering Recommendation, resolving `GAP_ANALYSIS.md` D-11]
Once a ticket reaches `CLOTUREE`, no new messages may be submitted to its conversation by the client or technician. Historical messages remain fully visible to all previously authorized parties, and to the Administrator in audit mode.

**BRULE-018 — Ticket cancellation.** [Engineering Recommendation — pending Product Owner decision, D-17]
A client may cancel a ticket only while it is in status `EN_ATTENTE`, transitioning it to a terminal `ANNULEE` state. Once a ticket has moved to `EN_COURS` or any later state, cancellation is no longer available through this mechanism.

## 12. USER STORIES

Organized by actor. Each story traces to its source Functional Requirement(s) and carries a one-line acceptance condition; full Given/When/Then acceptance criteria for Must-have stories appear in §27.

### 12.1 Client

| ID | Story | Traces to | Acceptance condition |
|---|---|---|---|
| US-01 | As a Client, I want to select my role before logging in, so that I land directly in the space that concerns me. | FR-AUTH-01 | Role selector is mandatory before the credential fields become active. |
| US-02 | As a Client, I want to show or hide my password while typing, so that I avoid typing errors. | FR-AUTH-02 | Toggling the eye icon switches the field's `obscureText` state without clearing input. |
| US-03 | As a Client, I want to reset a forgotten password by email, so that I regain access without external help. | FR-AUTH-04 | Submitting a valid email always returns the same generic confirmation, per BRULE-015. |
| US-04 | As a Client, I want to be informed that my connection is encrypted, so that I trust the platform. | FR-AUTH-03 | The trust banner renders on the login screen at all times. |
| US-07 | As a Client, I want to describe my fault with a title, description, and priority, so that the technician understands my need quickly. | FR-CRT-01, FR-CRT-02, FR-CRT-03 | Submission is blocked until all three fields pass BRULE-007. |
| US-08 | As a Client, I want to attach a photo of the faulty equipment, so that remote diagnosis is easier. | FR-CRT-04 | Attachment respects BRULE-009's type/size/count limits. |
| US-09 | As a Client, I want to receive a ticket number after my request, so that I can reference it easily. | FR-CRT-06 | The confirmation dialog displays the generated `id_intervention`. |
| US-10 | As a Client, I want to track my intervention's status in real time, so that I know when to expect the technician. | FR-DET-01, FR-DET-02 | The detail screen's status badge reflects the current `statut` value without requiring a manual refresh once a push notification has been received. |
| US-11 | As a Client, I want to confirm closure of my intervention and leave a note, so that I can express my satisfaction level. | FR-DET-02, BRULE-003 | Closure is only actionable from `RESOLUE`; rating is optional. |
| US-12 | As a Client, I want to view the history of all my past tickets, so that I keep a record of my exchanges with MSIS. | FR-TRV-01 | The Client's ticket list includes `CLOTUREE` and `ANNULEE` tickets, not only active ones. |
| US-22 | As a Client, I want to exchange messages with the technician directly on my ticket, so that I can clarify context without resorting to WhatsApp. | FR-DET-03, FR-DET-04 | Message send is only available while BRULE-017 permits it (ticket not yet `CLOTUREE`). |
| US-24 | As a Client, I want my exchanges to be encrypted and invisible to third parties, so that my sensitive information is protected. | FR-DET-08, §17.5 | Message content is never retrievable in plaintext directly from the database. |
| US-25 | As a Client (or Technician), I want to send a photo in the conversation, so that I can illustrate a technical problem. | FR-DET-04 | Attachment respects BRULE-009. |
| US-27 | As a Client, I want to receive a push notification when something important changes on my ticket, so that I stay informed without keeping the app open constantly. | §20.2 event matrix | Every status-change event listed in §20.2 triggers a push per the stated channel. |
| US-28 | As a Client (or Technician), I want to consult my tickets even without network connectivity, so that I can continue working in the field. | FR-TRV-04 | Cached data renders from local storage when offline. |
| US-29 | As a Client (or Technician), I want offline actions to synchronize automatically on reconnection, so that nothing is lost. | FR-TRV-04, FR-TRV-06 | Queued actions replay in chronological order exactly once. |
| US-30 | As a Client (or any user), I want to switch the app to dark mode, so that I reduce eye strain at night. | FR-TRV-05, FR-PROF-06 | Toggle persists across sessions. |
| US-31 | As a Client, I want to cancel a ticket I no longer need before it's picked up, so that I don't waste a technician's time. | FR-CRT-08 | Cancellation option is visible only while `statut = EN_ATTENTE`. |

### 12.2 Technician

| ID | Story | Traces to | Acceptance condition |
|---|---|---|---|
| US-13 | As a Technician, I want to see my assigned interventions with KPI indicators, so that I can organize my day. | FR-TECH-01, FR-TECH-02 | KPI counts match the live count of tickets where `id_technicien = self`, grouped by status. |
| US-14 | As a Technician, I want to consult a mission's full detail before traveling to it, so that I can prepare the necessary equipment. | FR-TECH-04, FR-DET-01 | All ticket fields render, including attachments. |
| US-15 | As a Technician, I want to move an intervention to "En cours" as soon as I begin, so that the client and supervisor are informed. | FR-DET-02 | Transition is only available from `EN_ATTENTE` on a ticket assigned to self. |
| US-16 | As a Technician, I want to report a blockage with a reason, so that the supervisor understands why the intervention is suspended. | FR-DET-02, BRULE-003 | Transition to `BLOQUE` is rejected if `motif_blocage` is empty. |
| US-17 | As a Technician, I want to add a technical report and mark an intervention resolved, so that I document my work. | FR-DET-02, BRULE-003 | Transition to `RESOLUE` is rejected if `rapport_technique` is empty. |

### 12.3 Supervisor / Administrator

| ID | Story | Traces to | Acceptance condition |
|---|---|---|---|
| US-05 | As a Supervisor, I want to create technician accounts and send them an invitation, so that I can onboard them quickly. | FR-USR-05 | Account is created `actif=true`, `TECHNICIEN` role, invitation email dispatched. |
| US-06 | As a Supervisor, I want to activate or deactivate a user account, so that I control access on departure or suspected misuse. | FR-USR-03 | Deactivation triggers BRULE-008 and BRULE-013. |
| US-18 | As a Supervisor, I want to see a dashboard with total, pending, in-progress, and closed ticket counts, so that I can gauge overall workload. | FR-DASH-01 | Counts refresh on pull-to-refresh and reflect real-time data. |
| US-19 | As a Supervisor, I want to filter interventions by status, so that I can focus on urgent matters. | FR-DASH-03 | Filter application is reflected in both the list and the URL/query state (for shareable/bookmarkable filtering, if applicable to the chosen navigation implementation). |
| US-20 | As a Supervisor, I want to assign or reassign a technician to an intervention, so that I can balance workload. | FR-TRV-03 | Reassignment is permitted on tickets in any active status, per BRULE-001. |
| US-21 | As a Supervisor, I want to export an activity report, so that I can present it to company management. | §19 (Reporting Requirements) | Export completes in CSV or PDF format matching the currently applied filters. |
| US-23 | As a Technician, I want to receive a notification as soon as a client writes to me, so that I can respond quickly. | FR-DET-06 | Matches §20.2's "new message" trigger row. |
| US-26 | As an Administrator, I want to audit a conversation in case of a dispute, so that I can verify compliance of the exchanges. | FR-DET-08, BRULE-004 | Every audit read is logged to `audit_logs`. |

---

## 13. USE CASES

Full specification for each of the seven use cases identified from the intervention lifecycle, in the standard Goal / Actor / Preconditions / Main Flow / Alternative Flow / Exception Flow / Postconditions format.

### UC-01 — Authenticate **[Official Requirement – Report]**

| Field | Detail |
|---|---|
| **Goal** | Establish an authenticated session for any role. |
| **Primary actor** | Any user (Client, Technician, Supervisor). |
| **Preconditions** | The user holds an active account. |
| **Main flow** | 1. The user selects their role. 2. The user enters email and password. 3. The system verifies credentials and role server-side (FR-AUTH-06). 4. An access token is issued and stored securely on the device. 5. The user is redirected to the dashboard matching their authenticated role. |
| **Alternative flow** | If the user has forgotten their password, they follow the "Forgot password" flow: a time-limited reset link is emailed (BRULE-015 governs the response). |
| **Exception flow** | Invalid credentials → generic error message (BRULE-015). Disabled account → explicit "Compte désactivé" message. Excessive attempts → temporary lockout (FR-AUTH-07). |
| **Postconditions** | The user holds a valid access token usable for all subsequent authorized API calls. |

### UC-02 — Declare an Intervention **[Official Requirement – Report/Client]**

| Field | Detail |
|---|---|
| **Goal** | Create a new intervention ticket. |
| **Primary actor** | Client. |
| **Preconditions** | The Client is authenticated. |
| **Main flow** | 1. The Client opens the creation screen. 2. Title, description, priority, and an optional attachment are entered. 3. The form is submitted. 4. The system creates the ticket with status `EN_ATTENTE` (FR-CRT-05). 5. All active Supervisors are notified (FR-CRT-07). |
| **Alternative flow** | If no network is available, the ticket is queued locally and synchronized on reconnection (FR-TRV-04). |
| **Exception flow** | Invalid fields → inline errors, submission blocked. Server failure → retry option offered, local draft preserved. |
| **Postconditions** | A new ticket exists with a unique identifier, visible to the Client and to every Supervisor. |

### UC-03 — Assign a Technician to an Intervention **[Official Requirement – Report]**

| Field | Detail |
|---|---|
| **Goal** | Link a technician to a ticket for execution. |
| **Primary actor** | Supervisor. |
| **Preconditions** | The ticket exists with status `EN_ATTENTE` or `EN_COURS`; at least one active technician account exists. |
| **Main flow** | 1. The Supervisor opens the ticket's detail. 2. A technician is selected from the list of active accounts. 3. The Supervisor confirms the assignment. 4. The system updates `id_technicien` and, if the ticket was `EN_ATTENTE`, moves it to `EN_COURS`. 5. The assigned technician is notified. |
| **Alternative flow** | Reassignment: the Supervisor may change the technician on a ticket already `EN_COURS`; both the outgoing and incoming technician are notified, and BRULE-016 governs data carry-over. |
| **Exception flow** | If the selected technician is deactivated between list-load and confirmation, the list is refreshed and the assignment is blocked with an explicit message. |
| **Postconditions** | The ticket is linked to the chosen technician and appears in their assigned-missions list. |

### UC-04 — Process an Intervention (Status Change) **[Official Requirement – Report]**

| Field | Detail |
|---|---|
| **Goal** | Execute and document a technical intervention through to resolution. |
| **Primary actor** | Technician. |
| **Preconditions** | The ticket is assigned to the authenticated technician. |
| **Main flow** | 1. The Technician opens the mission's detail. 2. Status is moved to `EN_COURS`. 3. The intervention is performed. 4. A technical report is added and status is moved to `RESOLUE`. 5. The Client and Supervisor are notified. |
| **Alternative flow** | If a blockage occurs, the Technician moves status to `BLOQUE` with a mandatory reason, then returns to `EN_COURS` once resolved. |
| **Exception flow** | Any attempt at an illegal status transition is rejected with HTTP 422 and an explicit message. |
| **Postconditions** | The ticket carries status `RESOLUE`, a technical report is attached, and the Client may proceed to closure. |

### UC-05 — Close an Intervention **[Official Requirement – Report]**

| Field | Detail |
|---|---|
| **Goal** | Formally confirm resolution and end the ticket's active lifecycle. |
| **Primary actor** | Client. |
| **Preconditions** | The ticket carries status `RESOLUE` and belongs to the authenticated client. |
| **Main flow** | 1. The Client reviews the resolution report. 2. Closure is confirmed. 3. An optional satisfaction rating (1–5) and free-text comment may be added. 4. The system moves status to `CLOTUREE` and timestamps `date_cloture`. |
| **Alternative flow** | A dissatisfied client may contest the resolution by contacting the Supervisor directly — explicitly outside this SRS's automated scope (BRULE-012). |
| **Exception flow** | Absence of confirmation within 7 days triggers the auto-closure rule (BRULE-011), **pending Product Owner confirmation per D-13.** |
| **Postconditions** | The ticket carries status `CLOTUREE` and is permanently archived in the Client's history; per BRULE-017, its conversation becomes read-only. |

### UC-06 — Send a Secure Message on a Ticket **[Official Requirement – Report]**

| Field | Detail |
|---|---|
| **Goal** | Exchange a message within a ticket-scoped, access-controlled conversation. |
| **Primary actor** | Client or Technician. |
| **Preconditions** | The user is the ticket's owning client or its assigned technician; the ticket is not `CLOTUREE` (BRULE-017). |
| **Main flow** | 1. The user opens the ticket's conversation. 2. A text message or photo attachment is composed. 3. The message is sent. 4. The message is encrypted and persisted, then broadcast in real time via a secure WebSocket channel to a connected recipient. 5. If the recipient is offline, a push notification is sent. |
| **Alternative flow** | Offline send: the message is queued locally and sent automatically on reconnection, in order, without duplication. |
| **Exception flow** | Access by a user who is neither the owning client, the assigned technician, nor an auditing Administrator → HTTP 403. |
| **Postconditions** | The message is visible in the conversation history, progressing from delivered (FR-DET-09) to read (FR-DET-07). |

### UC-07 — View the Global Dashboard **[Official Requirement – Report]**

| Field | Detail |
|---|---|
| **Goal** | Provide the Supervisor with a consolidated, actionable view of all intervention activity. |
| **Primary actor** | Supervisor. |
| **Preconditions** | The Supervisor is authenticated. |
| **Main flow** | 1. The Supervisor opens the Interventions tab of the dashboard. 2. KPIs are computed and displayed. 3. Filters or search are applied. 4. A ticket is opened for detail, or the Reports tab is opened for export. |
| **Alternative flow** | The Utilisateurs and Rapports tabs may be consulted from the same dashboard shell. |
| **Exception flow** | No ticket matches the applied filter → the FR-DASH-04 empty state is shown. |
| **Postconditions** | The Supervisor holds an up-to-date activity view and may act directly from the dashboard. |

### UC-08 — Cancel an Intervention **[Engineering Recommendation, pending D-17]**

| Field | Detail |
|---|---|
| **Goal** | Allow a client to withdraw a ticket that has not yet been picked up. |
| **Primary actor** | Client. |
| **Preconditions** | The ticket belongs to the authenticated client and carries status `EN_ATTENTE`. |
| **Main flow** | 1. The Client opens the ticket's detail. 2. A "Cancel" action is selected. 3. Confirmation is required (destructive-action pattern, §16). 4. The system moves status to `ANNULEE`. |
| **Alternative flow** | None. |
| **Exception flow** | Attempted cancellation on a ticket no longer `EN_ATTENTE` → HTTP 422, explicit message that cancellation is no longer available. |
| **Postconditions** | The ticket is terminally `ANNULEE`, retained in history but excluded from active-workload KPIs. |

## 14. COMPLETE WORKFLOW SPECIFICATIONS

Where §13 describes each use case from the actor's point of view, this chapter describes the same processes from the **system's** point of view — every layer touched, in sequence. All endpoint paths referenced below are formally cataloged in §18.5 (Data Access Contract).

### 14.1 Authentication Workflow **[Official Requirement – Report, mechanism per `GAP_ANALYSIS.md` D-22]**

1. Mobile app collects role selection + email + password (client-side form validation per BRULE-006).
2. Mobile app issues `POST /auth/login` with `{email, password}`.
3. Laravel `AuthController` delegates to a Form Request for server-side validation, then to the auth Service.
4. The Service verifies the Bcrypt password hash and the `actif` flag; on failure, returns a generic 401/403 per BRULE-015.
5. On success, a Sanctum personal access token is issued with an application-enforced 12-hour expiration (per D-22's resolution) and an "ability" set matching the user's role.
6. The response payload includes `{token, user}`; the mobile app persists the token via `flutter_secure_storage` and the user object in the Riverpod auth state.
7. `AuthEvent::LoggedIn` is dispatched, writing an `audit_logs` row (`action=login`).
8. GoRouter's auth-state redirect guard routes the user to the dashboard matching their role.
9. Every subsequent API call attaches `Authorization: Bearer <token>` via a Dio interceptor; a 401 response anywhere triggers automatic logout and redirect to the login screen.
10. Token renewal: before the 12-hour window elapses, the mobile app calls `POST /auth/refresh`, which — per D-22 — revokes the current token and issues a new one with a fresh 12-hour window.

### 14.2 Ticket (Intervention) Lifecycle Workflow **[Official Requirement – Report/Client]**

1. **Creation:** Client submits `POST /interventions`; `InterventionService::create` persists the row (`statut=EN_ATTENTE`), dispatches `InterventionCreated`.
2. `InterventionCreated` listener triggers `NotificationService` to notify every active Supervisor (push + in-app, per §20.2).
3. **Assignment:** Supervisor submits `PATCH /interventions/{id}/assigner` with `{id_technicien}`; `InterventionPolicy::assign` verifies caller is `ADMIN`; `InterventionService::assign` updates `id_technicien`, and if `statut=EN_ATTENTE`, advances it to `EN_COURS`; dispatches `StatusChanged` (if the status changed) and a dedicated assignment-notification event.
4. `intervention_status_history` row is written (per `GAP_ANALYSIS.md` D-20b) capturing `ancien_statut`, `nouveau_statut`, actor, and timestamp — this is the sole mechanism by which §19's pickup-time and resolution-time KPIs become computable.
5. **Progression:** Technician submits `PATCH /interventions/{id}/statut` with `{statut, motif_blocage?, rapport_technique?}`; `InterventionPolicy::updateStatus` checks both ownership (BRULE-001) and transition legality (BRULE-002/003) before `InterventionService::updateStatus` commits the change inside a database transaction that also writes the status-history row and dispatches `StatusChanged`.
6. `StatusChanged` listener triggers the appropriate notification per §20.2's event matrix and, where applicable, the SLA-alert scheduler (BRULE-010) is reset/cleared for that ticket.
7. **Closure:** Client submits `PATCH /interventions/{id}/cloturer` with optional `{note_satisfaction, commentaire}`; `InterventionPolicy::close` verifies caller is the owning client and `statut=RESOLUE`; `InterventionService::close` sets `statut=CLOTUREE`, `date_cloture=now()`, writes the final status-history row, and — per BRULE-017 — the `MessagePolicy` begins rejecting new message writes on this ticket from this point forward.
8. **Cancellation (pending D-17):** Client submits an equivalent cancellation action, permitted only from `EN_ATTENTE`, transitioning to `ANNULEE` via the same transactional pattern as step 5–7.

### 14.3 Assignment Workflow (Supervisor-Initiated) **[Official Requirement – Report]**

1. Supervisor's dashboard requests `GET /users?role=TECHNICIEN&actif=true` to populate the assignment picker.
2. Supervisor selects a technician and confirms; mobile app submits `PATCH /interventions/{id}/assigner`.
3. Server re-validates the selected technician is still active at the moment of the write (race-condition guard against the picker having gone stale, per UC-03's exception flow) — if not, the request is rejected with an explicit error rather than silently succeeding against a now-inactive account.
4. On success, both notification recipients (assigned technician; and, on reassignment, the previously assigned technician) are resolved and notified per §20.2.
5. Per BRULE-016, `motif_blocage`/`rapport_technique` are left untouched by this workflow — reassignment never clears ticket-state fields.

### 14.4 Messaging Workflow **[Official Requirement – Report, encryption per §17.5]**

1. Mobile app establishes a Laravel Echo connection to the private channel `intervention.{id}` on opening a ticket's conversation; `routes/channels.php` authorizes the connection using the same rule as `MessagePolicy::view` (BRULE-004).
2. On send, mobile app submits `POST /interventions/{id}/messages` with `{contenu}` or multipart with an attachment.
3. `MessagePolicy::send` verifies the sender is the owning client or assigned technician, and that the ticket is not `CLOTUREE` (BRULE-017).
4. `MessageService::send` encrypts `contenu` via Laravel `Crypt` (AES-256-CBC) before the `INSERT`, persists any attachment via `PieceJointe`, and dispatches `MessageSent`.
5. `MessageSent` listener broadcasts the (decrypted, since broadcast happens server-side before persistence encryption is irrelevant to the live payload) message over the `intervention.{id}` WebSocket channel to any connected recipient, and triggers a push notification if the recipient is not currently connected to that channel.
6. If the WebSocket connection is unavailable, the mobile app falls back to polling `GET /interventions/{id}/messages` every 15 seconds (§21.2); the typing-indicator feature (FR-DET-10) is suppressed entirely in this fallback mode, per `GAP_ANALYSIS.md` D-29.
7. On the recipient opening the conversation, `PATCH /messages/{id}/lu` is called per unread message, setting `lu=true, lu_at=now()`, and the "seen" indicator updates for the sender via the same WebSocket channel.
8. Offline send: the message is written to the local outbox (Hive/drift) with a client-generated idempotency key; on reconnection, queued messages are submitted in chronological order, and the server treats a duplicate idempotency key as a no-op to guarantee "no duplication" (§27.3).

### 14.5 Notification Workflow **[Engineering Recommendation, formalizing `cahier_de_charge.txt` §21]**

1. A domain event fires (`InterventionCreated`, `StatusChanged`, `MessageSent`, account activation/deactivation, or a scheduled SLA/reminder job per BRULE-010/BRULE-011).
2. `NotificationService::notify` resolves the recipient(s) per §20.2's trigger matrix and writes an in-app `notifications` row per recipient.
3. If the recipient has a registered FCM device token, a push notification is dispatched asynchronously via a queued Job (not inline in the request/response cycle, to protect the P95 latency target of NFR-PERF-01).
4. If the event category requires email (password reset, account invitation, account deactivation), a queued `Mail` job is dispatched via SMTP.
5. Mobile app's in-app badge count updates either via the same WebSocket connection (if already open) or on next `GET /notifications` poll.
6. Tapping the push notification deep-links to the relevant ticket (and conversation tab, for message events), per FR-NOTIF-02.

### 14.6 Reporting Workflow **[Engineering Recommendation, formalizing `cahier_de_charge.txt` §23]**

1. Supervisor's dashboard requests `GET /reports/dashboard`; the Service computes aggregate KPIs (totals by status/priority, average pickup/resolution time — now derivable from `intervention_status_history` per §14.2 step 4, per-technician load, average satisfaction).
2. For export, Supervisor requests `GET /reports/export?format=csv|pdf` with the currently applied filters; the request is dispatched as a queued `ExportInterventionsReport` Job (not synchronous, to avoid blocking on potentially large datasets) that generates the file and makes it available via a signed, time-limited download URL.
3. Mobile app polls or is notified (in-app) when the export is ready, then downloads via the signed URL.

### 14.7 Administration Workflow (User Management) **[Official Requirement – Client]**

1. Supervisor requests `GET /users?role=TECHNICIEN` or `?role=CLIENT` to populate the two user-management lists (FR-USR-01).
2. **Account creation:** Supervisor submits `POST /users` with the new technician's details; `UserService::createTechnician` creates the account `actif=true`, generates an invitation token, and queues `SendInvitationEmail`.
3. **Activation/deactivation:** Supervisor submits `PATCH /users/{id}/statut` with `{actif}`; a confirmation dialog is required client-side before this call is issued (§16, destructive-action pattern). On deactivation, `UserService::deactivate` executes, within one transaction: (a) sets `actif=false`; (b) revokes all of the account's Sanctum tokens (BRULE-013); (c) releases un-started `EN_ATTENTE` tickets for reassignment (BRULE-008); (d) leaves `EN_COURS` tickets assigned but access-revoked; (e) writes an `audit_logs` entry.
4. Every write in this workflow is covered by `LogAuditTrail` middleware, ensuring account lifecycle changes are always present in the audit trail (§24).

## 15. SCREEN SPECIFICATIONS

Each screen is specified completely: purpose, actor, navigation, inputs, outputs, validation, business rules, error handling, success handling, and accessibility. Visual composition (colors, spacing, component styling) is governed by the design system in `stitch_plateforme_s_curis_e_msis/technical_precision_system/DESIGN.md` and is elaborated further, at implementation-ready fidelity, in the companion UI/UX Specification document; this chapter defines *behavior and content*, not pixel layout.

### SCR-01 — Splash **[Engineering Recommendation, standard app entry pattern]**

| Field | Specification |
|---|---|
| Purpose | Bridge the cold-start gap while the app determines session validity. |
| Actor | All (pre-authentication). |
| Navigation | Entry point on app launch. Exits to SCR-02 (Login) if no valid token exists, or directly to the role-appropriate dashboard (SCR-05/07/09) if a valid, non-expired token is found in secure storage. |
| Inputs | None. |
| Outputs | MSIS logo/branding only. |
| Validation | N/A. |
| Business rules | Token validity check is local (expiry timestamp) first, then confirmed against `GET /auth/me`; a 401 response forces the no-session path regardless of local expiry state. |
| Error handling | Network failure during the `/auth/me` check falls back to cached user data if available (offline-first), or to SCR-02 if no cached session exists. |
| Success handling | N/A — this screen never persists, it only transitions. |
| Accessibility | Screen is not interactive; no accessibility requirements beyond a reasonable maximum display duration (no indefinite spinner). |

### SCR-02 — Authentication (Login) **[Official Requirement – Client, §13.1]**

| Field | Specification |
|---|---|
| Purpose | Authenticate a user and establish a role-scoped session. |
| Actor | All (pre-authentication). |
| Navigation | Entry from SCR-01 or from logout (any authenticated screen). Exits to SCR-03 (Forgot Password) or to the role-appropriate dashboard on success. |
| Inputs | Role selector (segmented control: Client/Technicien/Superviseur); email field; password field with show/hide toggle. |
| Outputs | Trust banner text; inline error messages. |
| Validation | Per BRULE-006. Submit button disabled until role is selected and both fields are non-empty. |
| Business rules | FR-AUTH-01 through FR-AUTH-08; BRULE-015 (anti-enumeration). |
| Error handling | Per §9.1 error-state specification (generic credential error, disabled-account message, rate-limit message). |
| Success handling | Automatic redirect to the dashboard matching the server-verified role — never the client-selected role if the two ever diverge (they must not, per FR-AUTH-06, but the redirect logic uses the server's answer, not the UI's prior selection). |
| Accessibility | Every field carries a semantic label; role selector is keyboard/switch-navigable; error text is announced by screen readers on appearance (live region). |

### SCR-03 — Forgot Password **[Official Requirement – Client]**

| Field | Specification |
|---|---|
| Purpose | Initiate an email-based password reset. |
| Actor | All (pre-authentication). |
| Navigation | Entry from SCR-02. Exits to a confirmation state (same screen, changed content) or back to SCR-02. |
| Inputs | Email field. |
| Outputs | Confirmation message. |
| Validation | RFC 5322 email format required. |
| Business rules | BRULE-015 — response is identical whether or not the account exists; §26.1 rate limit (3/hour/email). |
| Error handling | Malformed email → inline validation error before submission is even attempted (no server round-trip needed for format errors). Rate-limited → explicit message. |
| Success handling | Confirmation text: an email has been sent if an account exists for that address (phrased to never confirm/deny existence). |
| Accessibility | Same field-labeling standard as SCR-02. |

### SCR-04 — Reset Password **[Official Requirement – Client, reached via emailed link]**

| Field | Specification |
|---|---|
| Purpose | Complete a password reset from a time-limited emailed link. |
| Actor | All (pre-authentication, holding a valid reset token). |
| Navigation | Entry via deep link from the reset email only — not reachable through in-app navigation. Exits to SCR-02 on success. |
| Inputs | New password field; confirm-password field. |
| Outputs | Password-strength validation feedback. |
| Validation | Per FR-AUTH-08 (≥8 chars, 1 uppercase, 1 digit, 1 special character); confirm field must match. |
| Business rules | Reset token validity window is 60 minutes (§18.2 of `cahier_de_charge.txt`); all existing access tokens for the account are revoked upon a successful reset. |
| Error handling | Expired/invalid token → explicit error directing the user to request a new reset link. Password policy violation → inline, field-specific guidance (this is the one screen where specific-field errors are appropriate, since there is no account-enumeration risk once the token itself has already proven account possession). |
| Success handling | Confirmation, then redirect to SCR-02 to log in with the new password. |
| Accessibility | Password strength feedback is exposed as text, not color alone (color-blindness consideration, NFR-A11Y). |

### SCR-05 — Client Home (My Interventions) **[Official Requirement – Client, §12.2]**

| Field | Specification |
|---|---|
| Purpose | Client's primary landing screen: list of their own tickets across all statuses. |
| Actor | Client. |
| Navigation | Entry after login or from any Client screen's back navigation. Exits to SCR-06 (Create Intervention, via FAB) or SCR-08 (Intervention Detail, via list item tap). |
| Inputs | Pull-to-refresh gesture; optional status filter (Active/Closed/Cancelled groupings, per FR-TRV-01 scoping). |
| Outputs | Paginated list of tickets (title, status badge, priority indicator, creation date); empty state if no tickets exist yet. |
| Validation | N/A (read-only list). |
| Business rules | BRULE-001 (own tickets only); FR-TRV-04 offline caching applies. |
| Error handling | Network failure on initial load with no cache → retry affordance. Network failure with existing cache → cached data shown with a subtle "offline" indicator, per NFR-OFF-01. |
| Success handling | N/A (list screen, no submission). |
| Accessibility | List items are individually focusable/announceable, including their status in the announced label (not conveyed by color alone). |

### SCR-06 — Create Intervention **[Official Requirement – Client, §13.2]**

| Field | Specification |
|---|---|
| Purpose | Structured fault-declaration form. |
| Actor | Client (primary); Supervisor (per FR-CRT-09, creating on behalf of a client — this SRS treats it as the same screen with an additional client-selector field visible only to the Supervisor actor). |
| Navigation | Entry from SCR-05's FAB (Client) or from the Supervisor dashboard's ticket-creation entry point. Exits to SCR-08 (new ticket's detail) on success, or back to the origin screen on cancel. |
| Inputs | Title (text); Description (multiline text); Priority (chip selector); Attachment (camera/gallery picker); Client selector (Supervisor path only). |
| Outputs | Character counters on title/description; attachment thumbnails with individual removal controls. |
| Validation | Per BRULE-007. |
| Business rules | FR-CRT-01 through FR-CRT-07; FR-CRT-09 for the Supervisor path. |
| Error handling | Per §9.3 error-state specification (inline validation, network-failure banner with retry, offline banner with local-queue confirmation). |
| Success handling | Confirmation dialog with generated ticket number and a "Voir le ticket" action. |
| Accessibility | Priority chips are individually labeled (not color-only); attachment removal controls carry an explicit "Remove attachment" label per item, not a bare icon. |

### SCR-07 — Technician Missions (Home) **[Official Requirement – Client, §13.5]**

| Field | Specification |
|---|---|
| Purpose | Technician's primary landing screen: assigned interventions with KPI summary. |
| Actor | Technician. |
| Navigation | Entry after login. Bottom navigation bar (FR-TECH-03) provides access to SCR-08a (Carte), SCR-14 (Messages list), SCR-12 (Profil). Exits to SCR-08 (Intervention Detail) via list item tap. |
| Inputs | Status filter; pull-to-refresh. |
| Outputs | Three KPI widgets (Assignées/En cours/Clôturées); filtered mission list. |
| Validation | N/A. |
| Business rules | BRULE-001 (assigned tickets only); FR-TECH-01, FR-TECH-02. |
| Error handling | Same pattern as SCR-05. |
| Success handling | N/A. |
| Accessibility | KPI widgets announce both the number and its label as a single semantic unit ("12 interventions en cours"), not a bare numeral. |

### SCR-08 — Intervention Detail & Messaging **[Official Requirement – Client, §13.6]**

| Field | Specification |
|---|---|
| Purpose | Full ticket detail, status-transition actions, and the ticket's secure conversation. |
| Actor | Client, Technician (per BRULE-001 ownership); Supervisor (full access); Administrator (audit-mode messaging access only, per BRULE-004). |
| Navigation | Entry from SCR-05, SCR-07, SCR-09, or a notification deep link (FR-NOTIF-02). Exits back to the originating list, or to a full-screen conversation view. |
| Inputs | Role- and status-contextual action button (per BRULE-003: pickup, block-with-reason, resolve-with-report, close-with-rating, assign/reassign-for-Supervisor); message composer (text + attachment). |
| Outputs | All ticket fields (FR-DET-01); status badge; attachment gallery; conversation thread with per-message timestamp, delivered/read indicators (FR-DET-09, FR-DET-07), typing indicator when applicable (FR-DET-10). |
| Validation | `motif_blocage` required to submit a block action; `rapport_technique` required to submit a resolve action; message body or attachment required to send (not both empty). |
| Business rules | FR-DET-02 through FR-DET-11 in full; BRULE-002, BRULE-003, BRULE-004, BRULE-016, BRULE-017. |
| Error handling | Illegal transition attempt surfaced as an explicit error (never a silent no-op); unauthorized access returns the user to the previous screen with an explanatory message (HTTP 403 case); empty-conversation state per §9.4. |
| Success handling | Status-change confirmations via Snackbar (§16); message send shows immediate optimistic UI update, reconciled against the server-confirmed state. |
| Accessibility | Status-transition action buttons carry explicit text labels reflecting the specific action available in context (not a generic "Update"); conversation bubbles are announced with sender identity + content + timestamp as one unit. |

### SCR-08a — Technician Map **[Official Requirement – Client, FR-TECH-05, Could-priority]**

| Field | Specification |
|---|---|
| Purpose | Geographic view of the technician's assigned interventions. |
| Actor | Technician. |
| Navigation | Entry from SCR-07's bottom navigation bar. Exits to SCR-08 via marker tap. |
| Inputs | Map pan/zoom gestures. |
| Outputs | Map markers per assigned intervention, color-coded by priority/status per the design system's status palette (`DESIGN.md`). |
| Validation | N/A. |
| Business rules | BRULE-001 (assigned tickets only). |
| Error handling | Location-permission-denied state; no-assigned-interventions empty state. |
| Success handling | N/A. |
| Accessibility | Each marker is independently reachable via a non-map list-view alternative (map-only interaction is not accessible to screen-reader users; a "list view" toggle is required for parity). |

### SCR-09 — Supervisor Dashboard — Interventions Tab **[Official Requirement – Client, §13.3]**

| Field | Specification |
|---|---|
| Purpose | Supervisor's primary operational view: all interventions, KPIs, filters. |
| Actor | Supervisor. |
| Navigation | Entry after login. Tab bar (FR-DASH-02) provides access to SCR-10 (Utilisateurs) and SCR-11 (Rapports). Exits to SCR-08 via list item tap, or SCR-06 via a creation entry point. |
| Inputs | Status filter chips; priority filter; date-range filter; text search (FR-DASH-05); sort control (FR-DASH-06). |
| Outputs | Four KPI widgets (FR-DASH-01); paginated, filtered, searchable ticket list. |
| Validation | N/A. |
| Business rules | BRULE-001 (unrestricted visibility); FR-DASH-01 through FR-DASH-08. |
| Error handling | FR-DASH-04 empty state per active filter combination. |
| Success handling | N/A. |
| Accessibility | Filter chip group is announced as a single selectable group with the active selection stated explicitly. |

### SCR-10 — Supervisor Dashboard — Utilisateurs Tab **[Official Requirement – Client, §13.4]**

| Field | Specification |
|---|---|
| Purpose | User account management. |
| Actor | Supervisor. |
| Navigation | Entry via SCR-09's tab bar. Exits to an account-detail sheet, or to SCR-06-adjacent "create technician" flow. |
| Inputs | Techniciens/Clients sub-tab selector; per-row Activate/Deactivate toggle; search (FR-USR-06); "+" FAB (Techniciens sub-tab only) for account creation. |
| Outputs | Per-row: avatar (initials), name, email, status badge. |
| Validation | Account-creation form: name and email required, email must be unique (server-validated). |
| Business rules | FR-USR-01 through FR-USR-06; BRULE-008, BRULE-013. |
| Error handling | Duplicate-email creation attempt → inline error. Deactivation of an account with `EN_COURS` tickets → confirmation dialog explicitly stating the impact (FR-USR-04's reminder requirement). |
| Success handling | Snackbar confirmation on activation/deactivation/creation. |
| Accessibility | Status badge state (Actif/Inactif) is announced as text, not color alone; the Switch control's current state is announced on focus. |

### SCR-11 — Supervisor Dashboard — Rapports Tab **[Official Requirement – Report, §23; Engineering Recommendation for KPI/chart detail]**

| Field | Specification |
|---|---|
| Purpose | Aggregate reporting and export. |
| Actor | Supervisor. |
| Navigation | Entry via SCR-09's tab bar. |
| Inputs | Date-range selector; export-format selector (CSV/PDF); "Export" action. |
| Outputs | KPI summary (totals by status/priority, average pickup/resolution time, per-technician load, average satisfaction, per §19); weekly trend chart; per-technician load bar chart; status distribution pie chart. |
| Validation | Date range must be a valid, non-inverted interval. |
| Business rules | §19 (Reporting Requirements) in full. |
| Error handling | Export failure (e.g., generation timeout on a large dataset) → explicit retry affordance, since export is an async Job per §14.6. |
| Success handling | Download-ready notification with a signed URL, per §14.6. |
| Accessibility | Every chart is accompanied by an equivalent data table or textual summary, since chart rendering is not reliably screen-reader-accessible. |

### SCR-12 — Profile **[Engineering Recommendation, §9.2]**

| Field | Specification |
|---|---|
| Purpose | View and edit personal account information. |
| Actor | All authenticated roles. |
| Navigation | Entry from the app bar (present on every authenticated screen) or the Technician bottom nav bar. Exits to SCR-13 (Settings), or triggers logout back to SCR-02. |
| Inputs | Name (editable); phone (editable); "Change password" action leading to an in-app password-change form; "Log out" and "Log out of all devices" actions. |
| Outputs | Name, email (read-only), role, phone. |
| Validation | Name non-empty; phone, if provided, must be a plausible phone format. |
| Business rules | FR-PROF-01 through FR-PROF-03, FR-PROF-07; FR-AUTH-09, FR-AUTH-10. |
| Error handling | Password-change with an incorrect current password → inline error, no account lockout counted against this (distinct from login rate limiting). |
| Success handling | Snackbar confirmation on profile update; automatic redirect to SCR-02 on logout. |
| Accessibility | Standard form-field labeling; destructive "Log out of all devices" action follows the confirmation pattern in §16. |

### SCR-13 — Settings **[Engineering Recommendation, §9.2]**

| Field | Specification |
|---|---|
| Purpose | Application-level preferences. |
| Actor | All authenticated roles. |
| Navigation | Entry from SCR-12. |
| Inputs | Language selector (French/English); dark-mode toggle (System/Light/Dark); notification-category mute toggles. |
| Outputs | Current preference state. |
| Validation | N/A. |
| Business rules | FR-PROF-04, FR-PROF-05, FR-PROF-06, FR-TRV-05. |
| Error handling | N/A (local preference, no server round-trip failure mode beyond the notification-mute preference sync, which follows standard save-failure retry). |
| Success handling | Preference applied immediately, no separate "save" step required (each control commits on change). |
| Accessibility | Toggle/selector state changes are announced immediately. |

### SCR-14 — Notifications Feed **[Official Requirement – Report, §21.1]**

| Field | Specification |
|---|---|
| Purpose | In-app history of all notifications. |
| Actor | All authenticated roles. |
| Navigation | Entry via the app bar's notification bell icon (unread-count badge) from any screen. Exits to the relevant ticket detail on tap. |
| Inputs | Pull-to-refresh; tap-to-mark-read (implicit on open). |
| Outputs | Reverse-chronological list, unread items visually distinguished, grouped or flagged by type. |
| Validation | N/A. |
| Business rules | §20 (Notification Requirements) in full; `PATCH /notifications/{id}/lu` on open. |
| Error handling | Empty state: "Aucune notification." |
| Success handling | N/A. |
| Accessibility | Unread state is announced as text ("non lu"), not conveyed by a dot indicator alone. |

## 16. UI BEHAVIOUR

Cross-cutting interaction patterns that apply across every screen in §15. These rules exist so that no two screens implement the same kind of interaction (a confirmation, an error, an empty list) differently. Detailed visual treatment is delivered in the companion UI/UX Specification document; this chapter is the behavioral contract that document must not contradict.

### 16.1 Dialogs & Bottom Sheets **[Official Requirement – Client, §13.7, extended]**

- A **bottom sheet confirmation** is mandatory before any destructive or irreversible action: account deactivation (SCR-10), ticket cancellation (SCR-08, pending D-17), "Log out of all devices" (SCR-12).
- Confirmation sheets state the action's consequence in plain language (e.g., FR-USR-04's reminder that deactivation impacts `EN_COURS` tickets), never a bare "Are you sure?".
- Modal dialogs (not bottom sheets) are reserved for success acknowledgments requiring an explicit next action — e.g., SCR-06's post-creation "Ticket créé — N° ..." dialog with its "Voir le ticket" action.
- Dialogs and sheets are dismissible via an explicit close control and, on Android, the system back gesture; a destructive confirmation's default-focused button is always the non-destructive option (cancel), never the destructive one.

### 16.2 Snackbars **[Official Requirement – Client, §13.7]**

- Used for lightweight, non-blocking confirmations: message sent, status updated, profile saved, account activated/deactivated.
- Auto-dismiss after a fixed duration; never used for errors that require the user to take a corrective action (those use inline or banner treatment instead, per §16.5).
- Never stack more than one Snackbar at a time; a new Snackbar replaces any currently visible one.

### 16.3 Floating Action Buttons (FAB)

- Present on SCR-05 (Client Home → new intervention) and SCR-10's Techniciens sub-tab (→ new technician account).
- Per the design system, full-pill rounding is reserved for FABs specifically, distinguishing them from all other button shapes (12px-radius rectangular buttons elsewhere).
- A FAB never performs a destructive action; it always opens a creation flow.

### 16.4 Navigation & Transitions

- Role-based routing is enforced by a GoRouter redirect guard evaluated on every navigation event, not only at login — a token that becomes invalid mid-session (e.g., remote deactivation, per BRULE-013) must force an immediate redirect to SCR-02 on the next navigation or API call, not merely at the next app launch.
- Screen transitions use platform-idiomatic push/pop animations (Material motion on Android); no custom transition is introduced without a stated reason.
- Deep links (from push notifications, FR-NOTIF-02) resolve directly to the target screen's full navigation stack (i.e., opening a ticket detail via deep link still allows back-navigation to the appropriate list screen, not to a dead end).
- **State restoration [Engineering Recommendation, `GAP_ANALYSIS.md` §5]:** a partially completed form (notably SCR-06, ticket creation) must survive an OS-triggered process kill and restore its entered values when the app is resumed, consistent with standard Android state-restoration APIs.
- **Orientation [Engineering Recommendation, `GAP_ANALYSIS.md` §5]:** phone form factor is portrait-locked; tablet form factor (≥600dp, per the design system's breakpoint) supports both orientations, consistent with the master-detail layout already required at that breakpoint (§13.7 of `cahier_de_charge.txt`).

### 16.5 Loading, Empty, Error, and Success States

- **Loading:** list-based screens use shimmer/skeleton placeholders matching the eventual content's shape, never a full-screen spinner, per `cahier_de_charge.txt` §13.7. Action buttons (e.g., login submit) use an inline circular indicator and self-disable during the request.
- **Empty states:** every list screen defines its own empty-state illustration + primary text + contextual subtext (e.g., SCR-09's filter-aware "Aucune intervention," SCR-08's conversation-specific "Aucune conversation," SCR-14's "Aucune notification"). No list screen may render a blank white space when its data set is empty.
- **Error states:** distinguished by severity — inline field errors (validation, non-blocking to the rest of the form), banner errors (network/server failure, blocking submission, offering retry), and full-screen errors (unauthorized access, resource not found) that redirect or replace the screen's content entirely rather than overlay it.
- **Success states:** Snackbar for lightweight confirmations (§16.2); modal dialog for confirmations requiring a follow-up decision (§16.1); in-place UI update (e.g., a status badge changing color/label immediately) for state-reflecting actions.
- **Offline states:** a persistent, non-blocking banner indicates offline status wherever cached data is being shown in place of live data (NFR-OFF-01); it does not block interaction with the cached content, but every write action taken while offline is visually marked as "pending sync" until confirmed.

### 16.6 Animations & Micro-interactions **[Engineering Recommendation]**

- Status badge color/label transitions animate (cross-fade) rather than snap, to draw attention to a just-occurred state change without being distracting.
- The typing indicator (FR-DET-10) uses a subtle, low-motion pulsing treatment consistent with platform messaging-app conventions, and is entirely absent (not a static/frozen state) when unavailable under polling fallback (D-29).
- All animation durations follow Material Design 3 motion tokens; no animation exceeds 300ms for a state transition or blocks user input while playing.

## 17. SECURITY REQUIREMENTS

### 17.1 OWASP Top 10:2021 Compliance Mapping

| ID | Risk | Countermeasure | Tag |
|---|---|---|---|
| SEC-01 | A01 Broken Access Control | `CheckRole` middleware on every route + ownership-verifying Policies (`InterventionPolicy`, `MessagePolicy`, `UserPolicy`) per §17.3 | [Official Requirement – Report] |
| SEC-02 | A02 Cryptographic Failures | Bcrypt password hashing; mandatory TLS 1.2+/WSS; AES-256-CBC encryption of `messages.contenu` at rest | [Official Requirement – Report] |
| SEC-03 | A03 Injection | Eloquent ORM and parameterized queries exclusively; no raw concatenated SQL; Form Request validation on every endpoint | [Official Requirement – Report] |
| SEC-04 | A04 Insecure Design | Threat modeling performed at design time (this chapter, and the status-transition/RBAC rules in §11); design review required before implementing any module touching authentication, authorization, or messaging | [Engineering Recommendation] |
| SEC-05 | A05 Security Misconfiguration | `APP_DEBUG=false` in production; security headers enforced (CSP, `X-Frame-Options: DENY`, `X-Content-Type-Options: nosniff`); debug/admin tooling (Telescope, Horizon) never exposed on a public route | [Engineering Recommendation] |
| SEC-06 | A06 Vulnerable and Outdated Components | `composer audit` and `flutter pub outdated` run in CI on every pull request; major-version dependency updates reviewed on a defined cadence (monthly, minimum) | [Engineering Recommendation] |
| SEC-07 | A07 Identification and Authentication Failures | Strong password policy (FR-AUTH-08); rate-limited login (BRULE-014); token revocation on password reset; 12-hour token expiry with the refresh mechanism defined in §17.4 | [Engineering Recommendation, consistent with the report's original JWT-based intent] |
| SEC-08 | A08 Software and Data Integrity Failures | `composer.lock` and `pubspec.lock` are version-controlled and never regenerated ad hoc in CI; release Android builds are signed | [Engineering Recommendation] |
| SEC-09 | A09 Security Logging and Monitoring Failures | `audit_logs` table (§18.3); alerting on repeated authentication failures and HTTP 5xx spikes (§10.10); centralized log aggregation | [Engineering Recommendation] |
| SEC-10 | A10 Server-Side Request Forgery | No outbound HTTP call is ever constructed from unvalidated user-supplied input; any future webhook/third-party integration is restricted to an explicit allowlist | [Engineering Recommendation] |

### 17.2 Authentication

- SEC-11: Passwords are hashed with Bcrypt; plaintext passwords are never logged, cached, or transmitted outside the initial TLS-protected login/reset request. **[Official Requirement – Report]**
- SEC-12: The client-selected role at login is re-verified against the server's authoritative role for that account on every login; a mismatch is rejected outright (FR-AUTH-06). **[Official Requirement – Client]**
- SEC-13: After 5 consecutive failed login attempts on one account, a progressive rate-limiting delay is enforced (FR-AUTH-07, BRULE-014). **[Official Requirement – Client]**
- SEC-14: The `/auth/forgot-password` and login-failure responses are indistinguishable regardless of account existence or which credential field was wrong (BRULE-015). **[Official Requirement – Report/Client]**

### 17.3 Authorization (RBAC)

Two-layer enforcement, as specified in `cahier_de_charge.txt` §19 and carried forward unmodified:

- SEC-15: A `CheckRole` middleware validates that the authenticated user's role is permitted for the route being called (route-level authorization). **[Official Requirement – Report]**
- SEC-16: `InterventionPolicy::view(user, intervention)` authorizes if `user.id === intervention.id_client OR user.id === intervention.id_technicien OR user.role === ADMIN`. **[Official Requirement – Report]**
- SEC-17: `InterventionPolicy::updateStatus(user, intervention, newStatus)` verifies both resource ownership and transition legality (BRULE-002/003) before permitting any status write. **[Official Requirement – Report]**
- SEC-18: `MessagePolicy::view(user, message)` mirrors `InterventionPolicy::view` at the parent-ticket level, with every ADMIN-mode read logged to `audit_logs` (`action=message_audit_read`). **[Official Requirement – Report]**
- SEC-19: Any Policy violation returns HTTP 403 with a generic message; for tickets outside a user's ownership scope, HTTP 404 is an acceptable equivalent, avoiding confirmation of the resource's existence to an unauthorized party. **[Official Requirement – Report]**

### 17.4 Token Model — Sanctum, Expiry, and Refresh **[Resolves the contradiction identified in `GAP_ANALYSIS.md` D-22]**

`cahier_de_charge.txt` §18 reconciles the internship report's original "JWT" language with the client-supplied API contract's Laravel Sanctum choice, but leaves the mechanics of the contract's `POST /auth/refresh` endpoint unresolved against Sanctum's default non-expiring, non-refreshing token model. This SRS resolves it as follows, and this resolution is binding:

- SEC-20: Sanctum's `expiration` configuration value is set to 720 minutes (12 hours), matching the report's stated token-lifetime recommendation.
- SEC-21: A scheduled command (`sanctum:prune-expired`, run daily) removes expired tokens from `personal_access_tokens`.
- SEC-22: `POST /auth/refresh` is implemented as an authenticated endpoint that revokes the bearer token used to call it and issues a new token with a fresh 12-hour expiry — this is a "revoke-and-reissue" pattern, not a standard OAuth2 refresh-token grant; mobile clients must treat it accordingly (a single bearer token is presented to prove eligibility for renewal, not a separate refresh secret).
- SEC-23: A request bearing an expired token receives HTTP 401; the mobile app's Dio interceptor treats this identically to any other 401 (forced logout, redirect to SCR-02) unless the request was specifically the `/auth/refresh` call itself, in which case the interceptor instead surfaces re-authentication.

**Tag: [Engineering Recommendation — this entire subsection is the concrete technical resolution of an ambiguity present in both official sources; it does not override either source's stated intent (a Sanctum-based, revocable, expiring bearer token), it makes that intent implementable.]**

### 17.5 Encryption

- SEC-24: All network traffic (HTTPS and WSS) requires TLS 1.2 or higher; the NGINX reverse proxy enforces an HTTP→HTTPS redirect with no cleartext traffic accepted. **[Official Requirement – Report]**
- SEC-25: `messages.contenu` is encrypted with Laravel `Crypt` (AES-256-CBC, dedicated `APP_KEY`) prior to persistence; the database never stores plaintext message content. **[Official Requirement – Report]**
- SEC-26: Messaging attachments are stored on an at-rest-encrypted volume or bucket (tied to the storage backend decision, D-04). **[Official Requirement – Report]**
- SEC-27: The application's user-facing messaging copy states "Conversation chiffrée et strictement confidentielle," not a "zero server knowledge" / end-to-end-encryption claim — the MVP implements server-side encryption at rest, not device-held-key E2EE. True E2EE is a V2 item (§28). **[Engineering Recommendation, correcting a claim present in the design mockups that the MVP's actual encryption model does not yet support]**

### 17.6 Secure Storage (Mobile)

- SEC-28: The access token is stored exclusively via `flutter_secure_storage` (Android Keystore-backed / iOS Keychain-backed); it is never written to `SharedPreferences`, application logs, or crash-reporting payloads. **[Official Requirement – Client]**
- SEC-29: Locally cached offline data (tickets, messages) is stored in the app's sandboxed local database (Hive/drift); no sensitive data is written to external/shared storage. **[Engineering Recommendation]**

### 17.7 Session Management

- SEC-30: A user may hold concurrent sessions (tokens) across multiple devices. **[Official Requirement – Report]**
- SEC-31: Standard logout revokes only the current device's token; "Log out of all devices" (FR-AUTH-09) revokes every token issued to the account. **[Official Requirement – Report]**
- SEC-32: Deactivating a user account (`actif=false`) immediately revokes every active token for that account, independent of any user-initiated logout (BRULE-013). **[Engineering Recommendation, resolving `GAP_ANALYSIS.md` D-16b]**

### 17.8 Password Policy

- SEC-33: Password creation/reset requires ≥8 characters, at least one uppercase letter, one digit, and one special character (FR-AUTH-08, BRULE-006). **[Official Requirement – Client]**
- SEC-34: All existing access tokens for an account are revoked upon a successful password reset. **[Official Requirement – Report]**

### 17.9 Rate Limiting

Per BRULE-014, reproduced here as a formal security control:

| Endpoint | Limit | Storage backend |
|---|---|---|
| `POST /auth/login` | 5 / 15 min / IP + account | Redis-backed cache (per `GAP_ANALYSIS.md` D-28 — a file/array cache driver does not enforce shared limits across the multi-container Docker deployment in §25 and must not be used) |
| `POST /auth/forgot-password` | 3 / hour / email | Redis-backed cache |
| `POST /interventions` | 20 / hour / user | Redis-backed cache |
| `POST /interventions/{id}/messages` | 60 / min / user | Redis-backed cache |

**[Engineering Recommendation for the storage-backend specification; the limits themselves are Official Requirement – Client.]**

### 17.10 Audit Logs

- SEC-35: Every sensitive action is logged to `audit_logs`: successful and failed logins, ticket status changes, technician assignment/reassignment, account activation/deactivation, and every Administrator audit-mode conversation read. **[Official Requirement – Report, structured per `cahier_de_charge.txt` §26.5]**
- SEC-36: `audit_logs` retention is a minimum of 12 months; rows older than that are archived (not deleted) via a monthly scheduled job, per `GAP_ANALYSIS.md` D-26b, keeping the live table's query performance stable. **[Engineering Recommendation]**

### 17.11 Threat Model Summary **[Engineering Recommendation, per SEC-04]**

| Threat | Primary countermeasure | Residual risk accepted |
|---|---|---|
| Credential interception in transit | Mandatory TLS 1.2+ | N/A — mitigated |
| Stored credential/message compromise via DB exfiltration | Bcrypt hashing (passwords), AES-256-CBC (messages) | Attachments' at-rest protection depends on the storage backend decision (D-04) |
| Brute-force login | Rate limiting + progressive delay | N/A — mitigated |
| Account enumeration | Generic error responses (BRULE-015) | N/A — mitigated |
| Unauthorized cross-role/cross-ownership data access | Two-layer RBAC (middleware + Policies) | N/A — mitigated |
| SQL injection | Eloquent ORM exclusively | N/A — mitigated |
| Stolen bearer token used from an unrecognized device | Token revocation (manual, or automatic on deactivation) | **Accepted residual risk**: no device-binding or new-device challenge exists in MVP (`GAP_ANALYSIS.md` D-23); a stolen, unexpired token is usable from any device until explicitly revoked |
| Replay of a captured request | TLS transport security + revocable tokens | **Accepted residual risk**: no nonce/timestamp-based replay protection is implemented beyond what TLS already provides; this is standard for bearer-token APIs and is documented here as a deliberate, not accidental, omission |
| Malicious file upload (executable disguised as an image) | Server-side true-MIME-type validation (not extension-based); optional ClamAV async scan | Scan is recommended, not mandatory, for MVP (§22) |
| Indefinite retention of sensitive credentials exchanged in messages | **[PENDING DECISION — see D-30c]** | Retention/purge policy for message content is not yet decided; flagged as an open risk until resolved |

## 18. DATA REQUIREMENTS

### 18.1 Entity Overview

The data model comprises seven tables — the six defined in `cahier_de_charge.txt` §15–16, plus `intervention_status_history`, added per `GAP_ANALYSIS.md` D-20b as the sole mechanism by which the pickup-time/resolution-time KPIs promised in §19 (Reporting Requirements) become computable. All tables use `ENGINE=InnoDB DEFAULT CHARSET=utf8mb4` **[Official Requirement – Report]**. The model is normalized to 3NF: no non-key attribute depends on anything other than its table's primary key **[Official Requirement – Report]**.

### 18.2 Entity-Relationship Summary

- `users (1) —— (0..*) interventions [id_client]` — a client may create many interventions.
- `users (1) —— (0..*) interventions [id_technicien, nullable]` — a technician may be assigned to many interventions.
- `interventions (1) —— (0..*) messages` — each message belongs to exactly one ticket.
- `users (1) —— (0..*) messages [id_expediteur]` — each message has exactly one sender.
- `interventions (1) —— (0..*) pieces_jointes` — attachments linked directly to a ticket (creation-time).
- `messages (1) —— (0..*) pieces_jointes` — attachments linked to a conversation message.
- `users (1) —— (0..*) notifications` — each notification targets one user.
- `interventions (1) —— (0..*) intervention_status_history` — each status transition is a row, ordered by `created_at`.

**[Official Requirement – Report for the first seven relationships; Engineering Recommendation for the status-history relationship.]**

### 18.3 Complete Entity Definitions

#### `users` **[Official Requirement – Report]**

| Field | Type | Constraint | Description |
|---|---|---|---|
| id | BIGINT UNSIGNED | PK, AUTO_INCREMENT | Unique user identifier |
| nom | VARCHAR(100) | NOT NULL | Full name |
| email | VARCHAR(100) | UNIQUE, NOT NULL | Login identifier |
| password | VARCHAR(255) | NOT NULL | Bcrypt hash |
| role | ENUM | `ADMIN, TECHNICIEN, CLIENT`, NOT NULL, DEFAULT `CLIENT` | RBAC role |
| telephone | VARCHAR(20) | NULLABLE | Contact phone (visibility governed by `GAP_ANALYSIS.md` D-08, resolved in §18.4) |
| actif | BOOLEAN | NOT NULL, DEFAULT TRUE | Account status |
| email_verified_at | TIMESTAMP | NULLABLE | Email verification timestamp, gating FR-AUTH-11 |
| created_at / updated_at | TIMESTAMP | NULLABLE | Standard Laravel timestamps |
| Index | `idx_users_role (role)` | | |

*No `deleted_at` column exists on this table by design decision, per `GAP_ANALYSIS.md` D-20 — see §18.6 (Retention).*

#### `interventions` **[Official Requirement – Report/Client]**

| Field | Type | Constraint | Description |
|---|---|---|---|
| id_intervention | BIGINT UNSIGNED | PK, AUTO_INCREMENT | Unique ticket identifier |
| titre | VARCHAR(255) | NOT NULL | Subject |
| description | TEXT | NOT NULL | Fault detail |
| statut | ENUM | `EN_ATTENTE, EN_COURS, BLOQUE, RESOLUE, CLOTUREE`[, `ANNULEE` — **PENDING DECISION, see D-17**], NOT NULL, DEFAULT `EN_ATTENTE` | Processing state |
| priorite | ENUM | `BASSE, NORMALE, HAUTE`, NOT NULL, DEFAULT `NORMALE` | Urgency |
| id_client | BIGINT UNSIGNED | FK → users.id, NOT NULL, ON DELETE CASCADE | Ticket owner |
| id_technicien | BIGINT UNSIGNED | FK → users.id, NULLABLE, ON DELETE SET NULL | Assigned agent |
| motif_blocage | VARCHAR(255) | NULLABLE | Reason on transition to `BLOQUE` |
| rapport_technique | TEXT | NULLABLE | Report on transition to `RESOLUE` |
| note_satisfaction | TINYINT | NULLABLE, CHECK (1–5) | Client's closure rating |
| date_cloture | TIMESTAMP | NULLABLE | Closure timestamp |
| created_at / updated_at | TIMESTAMP | NULLABLE | Standard Laravel timestamps |
| Indexes | `idx_interv_client`, `idx_interv_technicien`, `idx_interv_statut` | | |
| Check constraint | `chk_note` | `note_satisfaction IS NULL OR BETWEEN 1 AND 5` | |

#### `messages` **[Official Requirement – Report]**

| Field | Type | Constraint | Description |
|---|---|---|---|
| id_message | BIGINT UNSIGNED | PK, AUTO_INCREMENT | Message identifier |
| id_intervention | BIGINT UNSIGNED | FK → interventions, NOT NULL, ON DELETE CASCADE | Parent ticket |
| id_expediteur | BIGINT UNSIGNED | FK → users.id, NOT NULL | Author |
| contenu | TEXT | NOT NULL — encrypted at rest (AES-256, §17.5) | Message body |
| livre | BOOLEAN | NOT NULL, DEFAULT FALSE | Delivered indicator (FR-DET-09) |
| livre_at | TIMESTAMP | NULLABLE | Delivery timestamp |
| lu | BOOLEAN | NOT NULL, DEFAULT FALSE | Read indicator |
| lu_at | TIMESTAMP | NULLABLE | Read timestamp |
| created_at | DATETIME | NOT NULL | Sent date |
| Index | `idx_msg_intervention (id_intervention, created_at)` | | |

*The `livre`/`livre_at` pair is added relative to the original report schema per `GAP_ANALYSIS.md` D-20d, closing the gap between the delivered→read progression described in UC-06 and a schema that previously modeled only "read."* **[Engineering Recommendation for `livre`/`livre_at`; all other fields Official Requirement – Report.]**

#### `pieces_jointes` **[Engineering Recommendation, formalizing a client-supplied requirement (attachments) into the schema]**

| Field | Type | Constraint | Description |
|---|---|---|---|
| id | BIGINT UNSIGNED | PK, AUTO_INCREMENT | Attachment identifier |
| id_intervention | BIGINT UNSIGNED | FK, NULLABLE, ON DELETE CASCADE | Direct ticket attachment (creation) |
| id_message | BIGINT UNSIGNED | FK, NULLABLE, ON DELETE CASCADE | Conversation-message attachment |
| chemin_fichier | VARCHAR(500) | NOT NULL | Storage path (§22) |
| type_mime | VARCHAR(100) | NOT NULL | Server-validated true MIME type |
| taille_octets | INT UNSIGNED | NOT NULL | File size, upload-validated |
| uploaded_by | BIGINT UNSIGNED | FK → users.id, NOT NULL | Uploader |
| created_at | TIMESTAMP | NOT NULL | Upload date |
| **Check constraint (added)** | `chk_pj_xor_parent` | `(id_intervention IS NULL) <> (id_message IS NULL)` | Enforces exactly one parent, per `GAP_ANALYSIS.md` D-20c |

#### `notifications` **[Engineering Recommendation]**

| Field | Type | Constraint | Description |
|---|---|---|---|
| id | BIGINT UNSIGNED | PK, AUTO_INCREMENT | Notification identifier |
| id_user | BIGINT UNSIGNED | FK → users.id, NOT NULL, ON DELETE CASCADE | Recipient |
| type | VARCHAR(50) | NOT NULL | `ticket_cree`, `statut_modifie`, `nouveau_message`, etc. (full catalogue in §20) |
| canal | VARCHAR(20) | NOT NULL | `push`, `in_app`, or `email` — records which channel actually fired for this row |
| contenu | VARCHAR(255) | NOT NULL | Notification text |
| id_intervention | BIGINT UNSIGNED | FK, NULLABLE | Related ticket, if any |
| lu | BOOLEAN | NOT NULL, DEFAULT FALSE | In-app read flag |
| created_at | TIMESTAMP | NOT NULL | Generation date |
| Index | `idx_notif_user (id_user, lu)` | | |

*The `canal` column is added relative to the source schema per `GAP_ANALYSIS.md` §3, allowing per-channel delivery auditing that a `type`-only column cannot provide.* **[Engineering Recommendation]**

#### `audit_logs` **[Engineering Recommendation — OWASP A09]**

| Field | Type | Constraint | Description |
|---|---|---|---|
| id | BIGINT UNSIGNED | PK, AUTO_INCREMENT | Entry identifier |
| id_user | BIGINT UNSIGNED | FK → users.id, NULLABLE | Actor (NULL if anonymous/failed auth) |
| action | VARCHAR(100) | NOT NULL | `login`, `login_failed`, `status_change`, `message_audit_read`, `account_deactivated`, etc. |
| entite / entite_id | VARCHAR(50) / BIGINT | NULLABLE | Affected resource (e.g. `intervention`/123) |
| ip_address | VARCHAR(45) | NOT NULL | Source IP |
| created_at | TIMESTAMP | NOT NULL | Event timestamp |
| Indexes | `idx_audit_user`, `idx_audit_action` | | |

#### `intervention_status_history` **[Engineering Recommendation, `GAP_ANALYSIS.md` D-20b — Must-priority addition]**

| Field | Type | Constraint | Description |
|---|---|---|---|
| id | BIGINT UNSIGNED | PK, AUTO_INCREMENT | History row identifier |
| id_intervention | BIGINT UNSIGNED | FK → interventions, NOT NULL, ON DELETE CASCADE | Parent ticket |
| ancien_statut | ENUM | Same value set as `interventions.statut`, NULLABLE (NULL for the initial creation row) | Prior status |
| nouveau_statut | ENUM | Same value set as `interventions.statut`, NOT NULL | New status |
| id_user | BIGINT UNSIGNED | FK → users.id, NOT NULL | Actor who performed the transition |
| created_at | TIMESTAMP | NOT NULL | Transition timestamp |
| Index | `idx_history_intervention (id_intervention, created_at)` | | |

This table is populated transactionally by every status-write path described in §14.2 and is the authoritative source for the pickup-time and resolution-time KPIs in §19.1 — without it, those KPIs cannot be computed from `interventions` alone, since that table retains only the *current* status.

### 18.4 Business Constraints Applied to Data

- DR-01: `pieces_jointes` must have exactly one non-null parent (`id_intervention` XOR `id_message`) — enforced by `chk_pj_xor_parent`. **[Engineering Recommendation]**
- DR-02: `interventions.note_satisfaction`, if present, must be between 1 and 5 inclusive — enforced by `chk_note`. **[Official Requirement – Report]**
- DR-03: `users.telephone` is exposed via the API to the counterpart party (client ⇄ technician) only while their shared ticket is `EN_COURS` or `BLOQUE`, and always to any Supervisor; it is never exposed to a party with no active shared ticket. **[Engineering Recommendation, resolving `GAP_ANALYSIS.md` D-08]**
- DR-04: Every multi-table write described in §14 (e.g., status change + status-history row + notification row) is wrapped in a single database transaction; a failure at any step rolls back the entire operation. **[Engineering Recommendation]**
- DR-05: No status transition may be written directly to `interventions.statut` without a corresponding `intervention_status_history` row being written in the same transaction — application-layer enforced via the `InterventionService`, since this cannot be a pure database constraint. **[Engineering Recommendation]**

### 18.5 Data Access Contract (API)

Base path: `/api/v1` (production host **[PENDING DECISION — see D-02]**). All responses are JSON. Every endpoint except those explicitly marked "No" under Auth requires `Authorization: Bearer <token>`.

**Authentication**

| Method | Route | Auth | Description |
|---|---|---|---|
| POST | `/auth/login` | No | `{email, password}` → `{token, user}` |
| POST | `/auth/logout` | Yes | Revokes the current token |
| POST | `/auth/refresh` | Yes | Revoke-and-reissue per §17.4 |
| POST | `/auth/forgot-password` | No | `{email}` — response per BRULE-015 |
| POST | `/auth/reset-password` | No | `{token, email, password, password_confirmation}` |
| POST | `/auth/register` | No | Client self-registration, `{nom, email, password, password_confirmation}` — **[PENDING DECISION — see D-01]** |
| GET | `/auth/me` | Yes | Returns the authenticated user's profile |

**Interventions**

| Method | Route | Auth / Role | Description |
|---|---|---|---|
| GET | `/interventions` | All (role-scoped, BRULE-001) | Paginated list (20/page, DR per §23), filterable by status/priority/date range, searchable by title/client name |
| POST | `/interventions` | Client (or Supervisor on behalf of a client, FR-CRT-09) | `{titre, description, priorite, id_client?}` |
| GET | `/interventions/{id}` | Owner / assigned / Supervisor | Full detail |
| PATCH | `/interventions/{id}/statut` | Per BRULE-003/005 | `{statut, motif_blocage?, rapport_technique?}` |
| PATCH | `/interventions/{id}/assigner` | Supervisor | `{id_technicien}` |
| PATCH | `/interventions/{id}/cloturer` | Owning client | `{note_satisfaction?, commentaire?}` |
| PATCH | `/interventions/{id}/annuler` | Owning client, only from `EN_ATTENTE` | **[PENDING DECISION — see D-17]** |
| POST | `/interventions/{id}/pieces-jointes` | Owner / assigned | Multipart upload, per §22 |

**Messaging**

| Method | Route | Auth / Role | Description |
|---|---|---|---|
| GET | `/interventions/{id}/messages` | Owner / assigned / Admin (audit) | Paginated conversation history |
| POST | `/interventions/{id}/messages` | Owner / assigned, ticket not `CLOTUREE` (BRULE-017) | `{contenu}` or multipart with attachment |
| PATCH | `/messages/{id}/lu` | Recipient | Marks read |
| PATCH | `/messages/{id}/livre` | Recipient's client (system-triggered on delivery confirmation) | Marks delivered (FR-DET-09) |

**Users**

| Method | Route | Auth / Role | Description |
|---|---|---|---|
| GET | `/users?role=TECHNICIEN\|CLIENT` | Supervisor | Filtered account list |
| POST | `/users` | Supervisor | Create technician account, dispatches invitation |
| PATCH | `/users/{id}/statut` | Supervisor | `{actif}` — triggers BRULE-008/013 |
| GET | `/profile` | Self | Own profile (FR-PROF-01) |
| PATCH | `/profile` | Self | `{nom?, telephone?}` (FR-PROF-02) |
| PATCH | `/profile/password` | Self | `{current_password, password, password_confirmation}` (FR-AUTH-10) |

**Notifications & Reports**

| Method | Route | Auth / Role | Description |
|---|---|---|---|
| GET | `/notifications` | Self | Paginated, unread-first |
| PATCH | `/notifications/{id}/lu` | Self | Marks read |
| GET | `/reports/dashboard` | Supervisor | Aggregate KPIs (§19.1) |
| GET | `/reports/export?format=csv\|pdf` | Supervisor | Queued export, returns a job reference; completion delivers a signed download URL |

**Operational**

| Method | Route | Auth | Description |
|---|---|---|---|
| GET | `/health` | No | Liveness probe, per §25.5 monitoring requirements |

**Standard error conventions:**

| HTTP code | Meaning | Applies to |
|---|---|---|
| 400 | Bad Request | Malformed request body |
| 401 | Unauthorized | Missing, invalid, or expired token |
| 403 | Forbidden | Authenticated but not authorized for this resource/action |
| 404 | Not Found | Resource does not exist, or exists outside the caller's authorized scope (interchangeable with 403 per SEC-19) |
| 422 | Unprocessable Entity | Validation failure or illegal business-rule/status-transition attempt |
| 429 | Too Many Requests | Rate limit exceeded (§17.9) |
| 500 | Internal Server Error | Logged server-side; no technical detail exposed to the client |

**Pagination convention [Engineering Recommendation, resolving `GAP_ANALYSIS.md` D-21]:** offset-based (Laravel's default `paginate()`), 20 items per page uniformly across every list endpoint above, applied consistently rather than left endpoint-specific.

### 18.6 Retention

| Data category | Retention policy | Tag |
|---|---|---|
| `audit_logs` | Minimum 12 months live, archived (not deleted) thereafter (§17.10) | [Official Requirement – Report, mechanism per Engineering Recommendation] |
| `users` | No hard deletion; `actif=false` is the terminal lifecycle state for MVP, per `GAP_ANALYSIS.md` D-20 | [Engineering Recommendation — **[PENDING DECISION — see D-10, D-20]**, contingent on MSIS's legal/compliance review] |
| `interventions` / `messages` content | No automated purge defined for MVP; retained indefinitely pending the policy decision in D-30c | [PENDING DECISION — see D-30c] |
| `pieces_jointes` physical files | Deleted from storage whenever their owning database row is deleted, via an Eloquent model-event listener, regardless of what triggered the cascade (`GAP_ANALYSIS.md` D-30) | [Engineering Recommendation] |
| Database backups | 30-day retention, daily automated (§25.4) | [Engineering Recommendation] |

## 19. REPORTING REQUIREMENTS

### 19.1 KPIs **[Official Requirement – Report, §23.1]**

| ID | KPI | Definition | Computation source |
|---|---|---|---|
| RPT-01 | Total interventions | Count of all tickets, all-time or period-filtered | `interventions` |
| RPT-02 | Status distribution | Count grouped by `statut` | `interventions` |
| RPT-03 | Priority distribution | Count grouped by `priorite` | `interventions` |
| RPT-04 | Average pickup time | Mean duration from `EN_ATTENTE` to first `EN_COURS` transition | `intervention_status_history` (§18.3) — **not computable from `interventions` alone** |
| RPT-05 | Average resolution time | Mean duration from `EN_COURS` (first entry) to `RESOLUE` | `intervention_status_history` |
| RPT-06 | Per-technician workload | Count of active (`EN_COURS`/`BLOQUE`) tickets per technician | `interventions` |
| RPT-07 | Average satisfaction | Mean of `note_satisfaction` across `CLOTUREE` tickets with a non-null rating | `interventions` |

### 19.2 Dashboards **[Official Requirement – Client, §13.3, §23]**

- RPT-08: The Supervisor dashboard (SCR-09) displays RPT-01 through RPT-03 as real-time KPI widgets, refreshed on pull-to-refresh and on each relevant domain event without requiring a full app restart.
- RPT-09: The Rapports tab (SCR-11) displays the full KPI set (RPT-01–RPT-07) for a Supervisor-selected date range.

### 19.3 Charts **[Official Requirement – Report, §23.2]**

- RPT-10: A weekly trend line/area chart of tickets created versus tickets closed.
- RPT-11: A bar chart of per-technician active workload (RPT-06).
- RPT-12: A pie/donut chart of status distribution (RPT-02).
- RPT-13: Every chart is accompanied by an equivalent textual/tabular summary for accessibility (NFR-A11Y, §16.5's chart-accessibility rule).

### 19.4 Exports **[Official Requirement – Report, §23.3]**

- RPT-14: CSV export of the currently filtered intervention list.
- RPT-15: PDF export of the dashboard, laid out for presentation to company management.
- RPT-16: Exports execute as an asynchronous queued Job (§14.6), never synchronously within the HTTP request/response cycle, to protect NFR-PERF-01.
- RPT-17: Export files are delivered via a signed, time-limited download URL — never a permanent public path (consistent with §22's attachment-security model).

---

## 20. NOTIFICATION REQUIREMENTS

### 20.1 Channels **[Engineering Recommendation, formalizing `cahier_de_charge.txt` §21.1 as the necessary fill-in for a report-identified gap]**

| Channel | Technology | Usage |
|---|---|---|
| Push | Firebase Cloud Messaging (FCM) | Real-time alerts, including when the app is closed |
| In-app | `notifications` table + unread badge (SCR-14) | Persistent, browsable history within the app |
| Email | Laravel Mail (SMTP) | Password reset, account invitation, account deactivation |
| Silent / data-only | FCM data message | Background badge-count refresh without an audible/visible alert |

### 20.2 Event-Trigger Matrix

| Event | Recipient(s) | Channel |
|---|---|---|
| New ticket created | All active Supervisors | Push + in-app |
| Ticket assigned | Assigned technician | Push + in-app |
| Status changed (En cours, Bloqué, Résolue) | Owning client (+ Supervisor if Bloqué) | Push + in-app |
| Ticket closed | Assigned technician, Supervisor | In-app |
| New message received | Recipient, if offline or app backgrounded | Push + in-app |
| Account deactivated/reactivated | Affected user | Email |
| SLA alert: `EN_ATTENTE` unassigned past threshold (BRULE-010) | Supervisors | Push + in-app |
| Reminder: `RESOLUE` unconfirmed 5 days (BRULE-010) | Owning client | Push + in-app |
| Ticket cancelled (pending D-17) | Supervisors (informational) | In-app |

### 20.3 Background Delivery

- NTF-01: Push notifications must be deliverable while the mobile app is fully closed (not merely backgrounded), consistent with standard FCM background-message handling. **[Engineering Recommendation]**
- NTF-02: Notification dispatch is always executed via a queued Job, never inline within the triggering HTTP request, to avoid coupling API response latency to third-party push-delivery latency (§14.5). **[Engineering Recommendation]**
- NTF-03: A push notification's payload includes a deep-link target sufficient for the mobile app to route directly to the relevant ticket/conversation on tap (FR-NOTIF-02). **[Engineering Recommendation]**

---

## 21. MESSAGING REQUIREMENTS

This chapter consolidates the messaging-specific requirements already established in §9.4 (functional), §14.4 (workflow), and §17.5 (encryption); it does not repeat their full detail, only the requirements not already stated elsewhere, plus the architecture summary needed for implementation planning.

### 21.1 Architecture **[Official Requirement – Report, §20.1]**

- Each conversation is a private Laravel Echo channel, `intervention.{id}`, authorized server-side by the same rule as `MessagePolicy::view` (BRULE-004).
- Realtime transport: WSS via self-hosted Laravel WebSockets **[PENDING DECISION — see D-03, this SRS's working assumption per the Gap Analysis's recommendation is self-hosted]**.
- Fallback transport: REST polling of `GET /interventions/{id}/messages` every 15 seconds when the WebSocket connection is unavailable.

### 21.2 Permissions

Governed by BRULE-004 and SEC-16/SEC-18; not restated here.

### 21.3 Encryption

Governed by SEC-25/SEC-26/SEC-27; not restated here.

### 21.4 Attachments

Governed by §22 (File Management Requirements) in full.

### 21.5 Read Receipts & Delivery Status

Governed by FR-DET-07 and FR-DET-09; the `livre`/`lu` field pair is defined in §18.3.

### 21.6 Retention

**[PENDING DECISION — see D-30c]**. No retention/purge policy for message content is finalized in this SRS; message and attachment content is retained indefinitely until a Product Owner decision is made, given the presence of sensitive technical credentials in this data category (§17.11 threat model).

---

## 22. FILE MANAGEMENT REQUIREMENTS

**[Official Requirement – Report, engineering-detailed per `cahier_de_charge.txt` §22]**

### 22.1 Upload

- FILE-01: Accepted image types: JPG, PNG, WEBP. Accepted document type: PDF.
- FILE-02: Maximum file size: 10MB.
- FILE-03: Maximum count: 5 files at ticket creation; 1 file per message.
- FILE-04: Upload is available from both the device camera and photo gallery.

### 22.2 Compression

- FILE-05: Images are recompressed client-side before upload — maximum 1920px on the longest edge, 80% JPEG-equivalent quality — to reduce network consumption, particularly relevant given the offline/low-connectivity field-use context (Technician persona, §7.2).

### 22.3 Validation

- FILE-06: The server validates the true MIME type of every uploaded file (via content inspection, not the file extension or client-declared `Content-Type`), rejecting any executable or script payload regardless of its apparent extension.
- FILE-07: **[Engineering Recommendation]** Asynchronous antivirus scanning (ClamAV or equivalent) is recommended; if adopted, a file is held in a "pending scan" state and its signed download URL returns HTTP 425 (Too Early) or 202 (Accepted, not yet ready) until the scan completes — it is never served unscanned (`GAP_ANALYSIS.md` D-30b).

### 22.4 Storage

- FILE-08: Files are stored outside the public web root, or in an S3-compatible bucket **[PENDING DECISION — see D-04]**.
- FILE-09: File access is exclusively via a signed, time-limited Laravel route — never a permanent, guessable, or directly public URL.
- FILE-10: When a `pieces_jointes` row is deleted (directly, or via cascade from its parent ticket/message), the corresponding physical file is deleted from storage in the same operation, via an Eloquent model-event listener (`GAP_ANALYSIS.md` D-30) — no orphaned file may persist in storage after its database record is gone.

### 22.5 Permissions

- FILE-11: Upload is permitted only by the ticket's owning client or assigned technician (ticket-creation attachments: client only; message attachments: owner/assigned per BRULE-004).
- FILE-12: Download access follows the same authorization rule as the parent ticket/message (BRULE-001/BRULE-004) — the signed URL itself is time-limited but does not bypass ownership checks at issuance time.

---

## 23. SEARCH REQUIREMENTS

### 23.1 Global Search

- SRCH-01: Text search on ticket title or client name is available on the Supervisor dashboard (FR-DASH-05). **[Official Requirement – Client]**
- SRCH-02: Text search on account name/email is available on the User Management screen (FR-USR-06). **[Engineering Recommendation]**
- SRCH-03: No cross-entity global search (e.g., a single search box spanning tickets, users, and messages simultaneously) is in MVP scope; each list screen's search is scoped to that screen's entity only. **[Engineering Recommendation — explicit scope boundary]**

### 23.2 Filtering

- SRCH-04: Status filtering is available on the Supervisor dashboard (FR-DASH-03) and the Technician missions list (FR-TECH-02). **[Official Requirement – Client]**
- SRCH-05: Priority filtering and date-range filtering are available on the Supervisor dashboard (FR-DASH-07). **[Engineering Recommendation]**

### 23.3 Sorting

- SRCH-06: Sorting by creation date, priority, or status is available on the Supervisor dashboard (FR-DASH-06). **[Official Requirement – Client]**

### 23.4 Pagination

- SRCH-07: All list endpoints paginate at 20 items per page, offset-based, per §18.5's pagination convention (`GAP_ANALYSIS.md` D-21). **[Engineering Recommendation]**
- SRCH-08: List screens implement infinite-scroll pagination with pull-to-refresh, consistent with the Supervisor dashboard's stated behavior (§13.3 of `cahier_de_charge.txt`) extended uniformly to every paginated list. **[Engineering Recommendation]**

---

## 24. LOGGING & AUDITING

### 24.1 Audit Event Catalogue **[Official Requirement – Report, §26.5, extended]**

Every row below is written to `audit_logs` (§18.3):

| Action | Trigger |
|---|---|
| `login` | Successful authentication |
| `login_failed` | Failed authentication attempt |
| `password_reset` | Successful password reset completion |
| `status_change` | Any intervention status transition |
| `intervention_assigned` | Technician assignment or reassignment |
| `account_activated` / `account_deactivated` | Supervisor toggling a user's `actif` flag |
| `message_audit_read` | Administrator opening a conversation in audit mode |
| `intervention_cancelled` | Client cancellation (pending D-17) |
| `export_generated` | A CSV/PDF export is produced |

### 24.2 Retention & Compliance

- AUDIT-01: `audit_logs` retention is a minimum of 12 months live; rows older than that are archived, not deleted, via a monthly scheduled job (§17.10). **[Engineering Recommendation]**
- AUDIT-02: Every `audit_logs` row records, at minimum, the actor (`id_user`, nullable for anonymous/failed-auth events), the action, the affected resource, the source IP address, and a timestamp — sufficient to reconstruct "who did what, from where, and when" for any sensitive action. **[Official Requirement – Report]**
- AUDIT-03: Compliance review against applicable Cameroon data-protection requirements is a prerequisite to finalizing this chapter's retention policy for production go-live. **[PENDING DECISION — see D-10]**

### 24.3 Application Logging (Distinct From Audit Logging)

- AUDIT-04: Application-level logs (errors, warnings, request traces) are distinct from the business-facing `audit_logs` table and are centralized via the monitoring stack defined in §25.5 (Loki-equivalent log aggregation, Sentry error tracking). **[Engineering Recommendation]**
- AUDIT-05: Application logs never contain plaintext passwords, raw bearer tokens, or decrypted message content, regardless of log level. **[Engineering Recommendation, security-critical]**

## 25. DEPLOYMENT REQUIREMENTS

### 25.1 Servers **[Official Requirement – Report, §28.1]**

- DEP-01: Production deployment target is a self-managed Ubuntu VPS. **[PENDING DECISION — see D-02 for the specific provider/domain.]**
- DEP-02: The VPS must be sized to sustain NFR-SCALE-01 (500 concurrent active users) across the full container topology defined in §25.2.

### 25.2 Docker Topology

**[Official Requirement – Report for the base topology; Engineering Recommendation for the corrected/completed container list per `GAP_ANALYSIS.md` D-27]**

The originally documented topology (NGINX, Laravel API, MySQL, WebSocket) under-counts the containers actually implied by this SRS's own decisions (Redis for cache/queue/rate-limiting, §17.9/§18.5; a queue worker process for asynchronous notification/export Jobs, §14.5/§19.4). The corrected topology:

| Container | Role |
|---|---|
| `nginx` | TLS-terminating reverse proxy, HTTP→HTTPS redirect enforcement |
| `app_laravel` | Laravel API (PHP-FPM) |
| `queue_worker` | Laravel queue worker process (can run inside `app_laravel`'s image as a supervised secondary process, or as its own container) |
| `mysql` | MySQL 8.x (InnoDB), primary datastore |
| `redis` | Cache, queue backend, rate-limit storage (§17.9, D-27b, D-28) |
| `websocket` | Laravel WebSockets server (contingent on D-03 resolving to self-hosted) |

### 25.3 Reverse Proxy & SSL **[Official Requirement – Report, §28.1]**

- DEP-03: NGINX terminates TLS and reverse-proxies to the Laravel API container.
- DEP-04: TLS certificates are provisioned and auto-renewed via Let's Encrypt/certbot.
- DEP-05: All HTTP traffic is redirected to HTTPS; no cleartext route is served.

### 25.4 Backup & Recovery

Governed by NFR-BAK-01 through NFR-DR-02 (§10.11); not restated here beyond the deployment-specific mechanics:

- DEP-06: `mysqldump` (or an equivalent InnoDB-consistent snapshot mechanism) runs on a daily automated schedule, writing to a location distinct from the production VPS's own disk. **[PENDING DECISION — see D-26 for the specific off-site destination.]**
- DEP-07: A documented restore procedure is exercised quarterly against a non-production environment, with results recorded.

### 25.5 Monitoring, Health Checks & Logging

Governed by NFR-MON-01 through NFR-MON-03 (§10.10); deployment-specific mechanics:

- DEP-08: `GET /api/v1/health` (§18.5) is polled every 5 minutes by an external or in-cluster monitor, alerting on failure.
- DEP-09: All container stdout/stderr is collected into a centralized log store (Loki or equivalent).
- DEP-10: Sentry (or equivalent) captures unhandled exceptions from both the Laravel API and the Flutter mobile app, with alerting on crash-rate or 5xx-rate spikes.

### 25.6 CI/CD **[Engineering Recommendation, formalizing `cahier_de_charge.txt` §28.3]**

- DEP-11: A CI pipeline (GitHub Actions or equivalent) runs on every pull request: static analysis (`PHP-CS-Fixer`, `flutter analyze`), the automated test suite (§26), and a dependency vulnerability scan (`composer audit`, `flutter pub outdated`).
- DEP-12: On merge to the main branch: an automated Docker image build, deployment to a staging environment, an OWASP ZAP automated security scan, and — only on manual approval — promotion to production.
- DEP-13: Flutter release builds (signed APK/AAB, and IPA if D-05 resolves to include iOS) are produced via an automated build pipeline (Codemagic or GitHub Actions) and distributed internally via Firebase App Distribution prior to any public store submission.

### 25.7 Deployment Procedure **[Official Requirement – Report, §28.2, preserved verbatim]**

1. Clone the production Git repository: `git clone https://github.com/msis-tech/api-interventions.git`
2. Configure environment variables (`.env`): database settings and the application secret key.
3. Execute the Docker deployment: `docker-compose up -d --build`
4. Execute database migrations: `docker exec -it app_laravel php artisan migrate --force`

---

## 26. TESTING REQUIREMENTS

### 26.1 Test Pyramid & Coverage Targets **[Official Requirement – Report baseline (ad hoc Postman/ZAP testing); full pyramid is Engineering Recommendation per `cahier_de_charge.txt` §27]**

| Level | Tooling | Scope | Coverage target |
|---|---|---|---|
| Unit (Laravel) | PHPUnit / Pest | Services, status-transition rules, Policies | ≥ 85% of critical business logic |
| Unit (Flutter) | flutter_test, mocktail | Riverpod controllers/notifiers, model mappers | ≥ 75% |
| Widget (Flutter) | flutter_test | Rendering and interaction of Must-have screens (§15) | 100% of Must-have screens |
| API integration | Postman/Newman, or Pest HTTP tests | Every endpoint in §18.5: nominal case, validation errors, RBAC denial | 100% of catalogued endpoints |
| Mobile E2E | integration_test / Patrol | Full lifecycle journeys (declare → assign → resolve → close) across all three roles | Critical journeys per role |
| Security | OWASP ZAP (automated scan), manual RBAC review | Injection, access control, sensitive-data exposure | 0 uncorrected critical/high finding |
| Performance | k6 or JMeter | High-traffic endpoints (`/interventions`, `/interventions/{id}/messages`, `/reports/dashboard`) | P95 within NFR-PERF-01/03 targets at 500 simulated concurrent users |
| Acceptance (UAT) | Manual scenarios with the Product Owner | Every Must-have acceptance criterion in §27 | 100% pass before production go-live |

### 26.2 Representative Test Cases — Authentication & RBAC **[Official Requirement – Report, §27.2]**

- TR-01: Login with valid credentials → 200, token received.
- TR-02: Login with an incorrect password → 401, generic message not indicating which field was wrong.
- TR-03: Login on a deactivated account → 403, explicit message.
- TR-04: A client attempts to view another client's ticket (`id_client` mismatch) → 403/404.
- TR-05: A technician attempts to change the status of a ticket not assigned to them → 403.
- TR-06: A client attempts to force `EN_ATTENTE → RESOLUE` directly → 422 (illegal transition).

### 26.3 Representative Test Cases — Messaging **[Official Requirement – Report, §27.3]**

- TR-07: The owning client and the assigned technician can both read and write the conversation.
- TR-08: A third party unrelated to the ticket can neither read nor write → 403.
- TR-09: The Administrator can read in audit mode; the access generates an `audit_logs` entry.
- TR-10: A message sent while offline is queued and delivered on reconnection, without duplication.

### 26.4 Test Environments **[Official Requirement – Report, §27.4]**

- TR-11: Local — Docker Compose with an isolated test database and seeded demonstration data.
- TR-12: Continuous integration — the full automated suite executes on every pull request (§25.6).
- TR-13: Staging (recette) — a production-mirroring environment used for UAT before every production release.

### 26.5 Security Testing Cadence **[Official Requirement – Report, §27.5]**

- TR-14: An automated OWASP ZAP scan executes on every staging deployment.
- TR-15: A manual review of the RBAC matrix (§11, BRULE-005) is performed whenever a new role or a new sensitive endpoint is added.

---

## 27. ACCEPTANCE CRITERIA

Given/When/Then acceptance criteria for every Must-have functional area, serving as the basis for UAT (§26.4, TR-13).

### 27.1 Authentication

- **AC-01:** Given a user with valid credentials and a correctly matching role selection, when they submit the login form, then they receive a valid access token and are redirected to the dashboard matching their role.
- **AC-02:** Given a user who selects a role that does not match their account's actual role, when they attempt to log in, then the server rejects the mismatch regardless of the client-submitted selection (FR-AUTH-06).
- **AC-03:** Given a password entered incorrectly 5 times in a row, when a 6th attempt is made, then the login is temporarily blocked (FR-AUTH-07).
- **AC-04:** Given an expired access token, when an API request is sent, then it is rejected with HTTP 401 and the mobile app redirects to the login screen.

### 27.2 Ticket Creation

- **AC-05:** Given an authenticated client with a valid form (title 5–150 chars, description 10–3000 chars, priority selected), when the form is submitted, then a ticket is created with status `EN_ATTENTE` and a unique ticket number is returned.
- **AC-06:** Given a form with an empty title, when the client attempts to submit, then the submit button remains disabled and an inline error is shown.

### 27.3 Assignment & Status Change

- **AC-07:** Given a ticket with status `EN_ATTENTE`, when a Supervisor assigns a technician, then the ticket moves to `EN_COURS` and the technician is notified.
- **AC-08:** Given a ticket `EN_COURS` assigned to the connected technician, when that technician attempts to close it directly, then the action is refused — only the client may close a ticket (BRULE-003).
- **AC-09:** Given a ticket `EN_COURS`, when the technician attempts to move it to `BLOQUE` without providing a reason, then the transition is rejected with a validation error.

### 27.4 Messaging

- **AC-10:** Given a conversation linked to a ticket, when the owning client sends a message, then the assigned technician receives it in real time (or on reconnection) and can reply.
- **AC-11:** Given a user with no relationship to a ticket, when they attempt to access its conversation via the API, then the request is rejected with HTTP 403.
- **AC-12:** Given a ticket that has reached `CLOTUREE`, when the client or technician attempts to send a new message, then the send is rejected (BRULE-017).

### 27.5 Security

- **AC-13:** Given an incorrect password entered 5 times consecutively, when a 6th attempt is made, then the connection is temporarily blocked.
- **AC-14:** Given an expired token, when an API request is sent, then it is rejected with HTTP 401 and the application redirects to the login screen.

### 27.6 Dashboard

- **AC-15:** Given at least one ticket in the database, when the Supervisor opens the dashboard, then the four KPI widgets display values consistent with the database state at load time.
- **AC-16:** Given a "Clôturées" filter with no closed tickets, when the Supervisor applies that filter, then the empty state "Aucune intervention" is displayed.

### 27.7 Cancellation **[Engineering Recommendation, pending D-17]**

- **AC-17:** Given a ticket with status `EN_ATTENTE` owned by the connected client, when the client cancels it, then the ticket moves to `ANNULEE` and is excluded from active-workload KPIs.
- **AC-18:** Given a ticket with status `EN_COURS` or later, when the client attempts to cancel it, then the action is rejected with an explicit message that cancellation is no longer available.

## 28. FUTURE ROADMAP

### 28.1 Phase 1 — MVP (V1) **[Official Requirement – Report, §30.1 — this SRS's implementation mandate]**

Role-based authentication and RBAC; account management; full intervention lifecycle (creation → assignment → resolution → closure, including the cancellation extension pending D-17); ticket-scoped encrypted messaging with attachments; Supervisor dashboard with KPIs, filters, and exports; push/in-app/email notifications; Docker/VPS deployment with automated backup. This is the entirety of Chapters 3–27 of this SRS.

### 28.2 Phase 2 (V2) **[Official Requirement – Report, §30.2]**

- Full end-to-end encryption of messaging (device-held keys), replacing the MVP's server-side-only encryption at rest (§17.5, SEC-27).
- Technician/intervention geolocation, with automatic assignment of the nearest available technician.
- Route optimization for technicians handling multiple daily missions.
- Client electronic signature at closure.

### 28.3 Phase 3 (V3) **[Official Requirement – Report, §30.3, §31]**

- AI/NLP-assisted automatic categorization and pre-prioritization of tickets at creation.
- Predictive technician assignment based on historical performance and workload data.
- A companion web portal for company management (advanced reporting, accounting export).
- Predictive maintenance analytics via recurring-fault detection per client/equipment.
- In-app billing/payment for out-of-warranty interventions.
- A web portal for large institutional clients operating multiple sites.

### 28.4 Engineering Recommendations for Future Phases

**[Engineering Recommendation, consolidated from `GAP_ANALYSIS.md` §12]**

- Device binding / new-device challenge for session security, beyond the MVP's revocation-only model (§17.11 residual risk).
- Biometric authentication as a local convenience layer over the existing secure-storage token model.
- A `technician_skills`/specialties entity enabling system-assisted (rather than purely judgment-based) assignment matching.
- A client-facing `equipment`/asset registry, laying the groundwork for the V3 predictive-maintenance capability without requiring a disruptive schema change at that point.
- A formal API versioning policy (header-based or URL-based `/v2`) to be defined before any breaking API change is introduced.

---

## 29. APPENDICES

### 29.1 Glossary **[Official Requirement – Report, §32.1]**

| Term | Definition |
|---|---|
| Ticket / Intervention | A record representing a fault-repair request, from creation to closure |
| RBAC | Role-Based Access Control |
| Policy | A Laravel class encapsulating a resource's authorization rules |
| Clean Architecture | A software architecture style separating presentation, business domain, and data access |
| MoSCoW | A prioritization method: Must have, Should have, Could have, Won't have |
| WSS | WebSocket Secure — an encrypted real-time communication channel |

### 29.2 Acronyms **[Official Requirement – Report, §32.2]**

| Acronym | Meaning |
|---|---|
| API | Application Programming Interface |
| BDD | Base de Données (Database) |
| CRUD | Create, Read, Update, Delete |
| DDL | Data Definition Language |
| FCM | Firebase Cloud Messaging |
| KPI | Key Performance Indicator |
| MCD / MLD | Modèle Conceptuel de Données / Modèle Logique de Données |
| OWASP | Open Web Application Security Project |
| RBAC | Role Based Access Control |
| SRS | Software Requirements Specification |
| UML | Unified Modeling Language |
| VPS | Virtual Private Server |

### 29.3 References **[Official Requirement – Report, §32.3]**

- Internship report: LEBOU YVAN DANIEL, *« Conception et mise en œuvre d'une plateforme sécurisée de communication et de suivi des interventions techniques conforme aux recommandations de l'OWASP : Cas de Monde Session Info Service »*, Institut Supérieur AZIMUT, academic year 2025–2026.
- OWASP Top 10:2021 — https://owasp.org/Top10/
- Official Laravel documentation — https://laravel.com
- Official Flutter documentation — https://flutter.dev
- Joseph Schmuller, *Apprendre UML en 24 heures*, Pearson, 2004 (cited in the internship report).
- Alan Beaulieu, *Learning SQL*, O'Reilly Media, 2009 (cited in the internship report).

### 29.4 Definitions of Provenance Tags

Restated from the Document Control section for reference: **[Official Requirement – Report]** = sourced from the internship report, unmodified. **[Official Requirement – Client]** = sourced from the client-supplied functional cahier des charges, unmodified, and prevailing over report terminology where the two differ. **[Engineering Recommendation]** = added to meet production-grade enterprise standards, not present in either official source, and never to be treated as equivalent in authority to an official requirement without explicit Product Owner approval.

### 29.5 Requirement Traceability Summary **[Official Requirement – Report, §32.4, extended]**

| Module | Screen(s) | Table(s) | Key endpoint(s) |
|---|---|---|---|
| Authentication | SCR-02, SCR-03, SCR-04 | `users` | `/auth/login`, `/auth/forgot-password`, `/auth/register` |
| Profile & Settings | SCR-12, SCR-13 | `users` | `/profile`, `/profile/password` |
| Interventions | SCR-05, SCR-06, SCR-08, SCR-09 | `interventions`, `pieces_jointes`, `intervention_status_history` | `/interventions`, `/interventions/{id}/statut`, `/interventions/{id}/annuler` |
| Messaging | SCR-08 | `messages`, `pieces_jointes` | `/interventions/{id}/messages` |
| Users | SCR-10 | `users` | `/users`, `/users/{id}/statut` |
| Notifications | SCR-14 (all screens' app bar) | `notifications` | `/notifications` |
| Reports | SCR-11 | `interventions`, `intervention_status_history` (aggregated) | `/reports/dashboard`, `/reports/export` |

### 29.6 Open Decisions Register (Summary)

Every **[PENDING DECISION]** marker in this document refers to the full Decision Register in `GAP_ANALYSIS.md` §11 (D-01 through D-30c). This SRS is implementation-ready for every area not marked pending; the pending items must be resolved by the Product Owner and this document updated accordingly before the corresponding module begins implementation. The Must-priority subset, repeated from `GAP_ANALYSIS.md` §13, is: D-01 (client registration), D-17 (cancellation state), D-20/D-20b/D-20c (soft-delete, status-history, attachment constraint), D-21 (pagination — **already resolved in this SRS**, §18.5), D-22 (Sanctum/refresh — **already resolved in this SRS**, §17.4), D-27/D-28 (Redis-dependent topology — **already resolved in this SRS**, §25.2/§17.9). Remaining open items requiring Product Owner sign-off before their respective module begins implementation: D-01, D-02, D-03, D-04, D-05, D-06 (content-completion timing only, architecture already resolved), D-10, D-13, D-17, D-20, D-26, D-30c.

---

**END OF DOCUMENT — Software Requirements Specification, MSIS Secure Intervention Tracking Platform, Version 1.0 (Draft).**

This SRS is now chapter-complete (Chapters 1–29). Per the Document Control section, it remains in **DRAFT** status pending Product Owner resolution of the items listed in §29.6. No implementation work should begin against a module whose governing decision remains open.
