# MSIS — Gap Analysis Report (Technical Design Authority Review)

**Role of this document:** pre-SRS validation gate. It does not redesign anything defined in `cahier_de_charge.txt` or `PROJECT_DISCOVERY.md`. It exists to surface every ambiguity, contradiction, and missing decision that would otherwise be discovered mid-implementation — where it's expensive — instead of now, where it's cheap.

**Inputs used, exclusively:** `cahier_de_charge.txt` (internship report + your commissioner-supplied functional spec, merged), and `PROJECT_DISCOVERY.md` (prior synthesis). Nothing outside these two is assumed.

**MVP framing carried forward:** as in the Discovery Document, findings are weighed against the MVP/V1 scope (`cahier_de_charge.txt` §30.1). Where a gap only matters for V2/V3, it is marked so it doesn't inflate MVP urgency.

**Tagging convention used throughout:**
- **[OFFICIAL – A]** — stated in the internship report. Quoted/referenced, never altered.
- **[OFFICIAL – B]** — stated in your commissioner functional spec (screen-by-screen requirements, §6/§13). Never altered.
- **[DECISION REQUIRED]** — missing, and blocking or risk-bearing enough that it must be decided before implementation. Options + trade-offs given, one recommended — never auto-chosen.
- **[RECOMMENDATION]** — not required by either official source; an enterprise-quality improvement, explicitly optional.

---

## 1. Functional Completeness

Cross-checked against the full FR inventory (`cahier_de_charge.txt` §6, `PROJECT_DISCOVERY.md` §8) for gaps a production app cannot ship without, or would be materially weaker without.

| Feature | Status | Tag |
|---|---|---|
| Password reset workflow | Specified (email link, 60-min validity, anti-enumeration) | [OFFICIAL – A/B] present |
| Email verification | Field exists (`email_verified_at`) but **no workflow, trigger, or gating rule** is specified — is an unverified client allowed to create tickets? | [DECISION REQUIRED] — see D-01 |
| Search | Only on Supervisor dashboard, text on title/client name, Could-have (FR-DASH-05) | Gap for Client/Technician lists — [OFFICIAL – B] scope is dashboard-only, not missing per se, but incomplete for a production app |
| Pagination | 20/page stated only for the Supervisor dashboard (§13.3) | Missing for `/interventions` as consumed by Client/Technician, and for `/notifications`, `/users` — **[DECISION REQUIRED]**, see D-21 |
| Filtering | Status filters for Supervisor (FR-DASH-03) and Technician (FR-TECH-02); no priority filter, no date-range filter anywhere | [RECOMMENDATION] to add priority/date filters |
| User settings | Not specified at all beyond "Profil" as a nav target | [DECISION REQUIRED], see D-01 (bundled with profile) |
| Profile management | Same — no field list, no edit flow | [DECISION REQUIRED] |
| Help / Feedback | Not mentioned anywhere in either source | [RECOMMENDATION] |
| Audit logs | Fully specified (`audit_logs` table, §15.2, §26.5) | [OFFICIAL – C-tier recommendation already accepted into spec] present |
| Activity history | Ticket-level history exists via status/timestamps; no cross-ticket "my activity feed" concept | [RECOMMENDATION] |
| Notifications | Fully specified (§21) | Present |
| Ticket templates / quick-create shortcuts | Not mentioned | [RECOMMENDATION], low priority |
| Client equipment/asset registry (recurring device tied to a client) | Not mentioned; every ticket is a bare title+description with no linked "asset" entity | [RECOMMENDATION] — matters for the V3 "predictive maintenance" idea already named in the source (§31), so flagging now avoids a schema migration later |
| In-app support/contact channel for non-ticket issues (e.g., app bug reports) | Not specified | [RECOMMENDATION] |

**Conclusion for §1:** the ticket lifecycle itself is complete. The account/profile/settings layer is the single biggest functional void — every screen assumes a logged-in user but no screen owns "who am I / what are my preferences."

---

## 2. Business Workflow Analysis

Each workflow named in your prompt, checked against what's actually decided in the sources.

| Workflow | Decided? | Detail |
|---|---|---|
| **Ticket creation** | Yes | Full form + validation + notify-supervisor rule (§6.2). No gap. |
| **Assignment** | Yes | Supervisor-only, any ticket state `EN_ATTENTE`/`EN_COURS` (§8.2, UC-03). No gap. |
| **Acceptance** | Partially | "Pickup" by technician is mentioned as an alternate trigger for `EN_ATTENTE→EN_COURS` alongside supervisor assignment (§6.6 detail) — but **it's never specified whether a technician can *decline* an assignment**, or whether assignment is always binding. **[DECISION REQUIRED]**, see D-16. |
| **Transfer** (reassignment) | Yes, mechanically | Supervisor can reassign at any time, both technicians notified (§8.2, UC-03). **Not decided:** does `motif_blocage` / partial `rapport_technique` carry over to the new technician, or reset? **[DECISION REQUIRED]**, see D-12. |
| **Escalation** | **Not decided at all** | No priority-escalation rule exists (e.g., a `NORMALE` ticket sitting unassigned for days does not auto-escalate to `HAUTE`). The only SLA-adjacent behavior is a supervisor *alert* notification (§21.3) — which informs, but does not escalate, the ticket. **[DECISION REQUIRED]**, see D-16. |
| **Closure** | Yes | Client-only, from `RESOLUE`, optional rating (§8.3, UC-05). No gap. |
| **Cancellation** (client withdraws a ticket before pickup) | **Not specified anywhere** | A client who reports a fault that resolves itself, or was reported by mistake, has no path to cancel — the only forward path is through the full technician lifecycle. **[DECISION REQUIRED]**, see D-17. |
| **Reopening** | Explicitly out of automated scope | UC-05 alt flow: dispute handled manually by contacting the supervisor. Confirmed as an intentional V1 gap, not an oversight — **[OFFICIAL – A]**, carried forward, not re-litigated. |
| **Technician availability** | **Not modeled** | `users.actif` is a binary account-enabled flag, not an availability/capacity signal. There's no "on leave," "at capacity," or "off duty" state, so a supervisor assigning a technician has no system signal for whether that technician can actually take more work. **[DECISION REQUIRED]**, see D-19. |
| **Supervisor actions** | Yes | Assign/reassign, activate/deactivate accounts, create technician accounts, view/export reports (§8.4 matrix). No gap. |
| **Customer confirmation** | Yes | Closure confirmation + optional 1–5 rating (UC-05). No gap. |

**Missing decision not explicitly asked for but surfaced by this analysis:** what happens to a ticket if **the assigned technician's account is deactivated while the ticket is `EN_COURS`**? FR-USR-04 only covers auto-release of un-started `EN_ATTENTE` tickets — an `EN_COURS` ticket "remains visible for closure" per that rule, but visible *to whom*, and can the (now-deactivated) technician still act on it via the API, or is it stuck until manually reassigned? **[DECISION REQUIRED]**, see D-16b.

---

## 3. Data Analysis

Reviewing the six-table model (`cahier_de_charge.txt` §15–16) strictly for structural gaps — not redesigning it.

**Missing entities:**
- No `organizations`/`sites` entity — every institutional client is a single flat `users` row, which conflicts with the source's own V3 mention of "institutions clientes disposant de plusieurs sites" (§31). Not an MVP gap (correctly deferred), but worth a forward-compatible note.
- No `equipment`/`asset` entity linking a client to their recurring hardware — see §1 above.
- No `technician_skills`/`specialties` entity, despite the org chart naming distinct specialties (Maintenancier, Maintenancier-Sonorisateur, Maintenancier-Infographe, §2.1) — assignment today is purely supervisor judgment, with no system-modeled skill-matching. **[RECOMMENDATION]**, not a blocker.
- No `password_reset_tokens` / `personal_access_tokens` tables shown in the DDL, despite Sanctum (personal_access_tokens) and the reset flow (needs a token table) structurally requiring them — these are standard Laravel first-party tables auto-migrated by the framework, so this is a documentation omission rather than a design gap, but it should be stated explicitly so no one thinks they need to hand-design them. **[RECOMMENDATION]** to note explicitly in the eventual SRS.

**Missing attributes:**
- `users` has no `deleted_at` — no soft-delete column anywhere in the schema. Deactivation (`actif=false`) is not the same as deletion; there's no mechanism for GDPR/data-protection-style erasure requests. **[DECISION REQUIRED]**, see D-20.
- `interventions` has no `id_createur` distinct from `id_client` — §8.4 states a supervisor can "Créer une intervention... pour un client," meaning a ticket can be created *by* a supervisor *on behalf of* a client. As modeled, there is no field capturing who actually performed the creation action if it differs from the owning client — this matters for `audit_logs` fidelity. **[DECISION REQUIRED]**, see D-16c.
- `interventions` has no explicit `updated_by`/`last_status_changed_by` — status history is implicit (only the *current* `statut` is stored), so **there is no ticket status history table** — only the current state is queryable, not the sequence of transitions with timestamps and actors. This is a real gap given §7's strict transition rules are exactly the kind of thing an auditor/supervisor would want a full history of. **[DECISION REQUIRED]**, see D-20b.
- `messages` has no `edited_at`/`deleted_at` — no message-edit or message-delete capability is specified or schematically possible. Likely fine for MVP (not in FRs) but worth confirming it's intentional, not an oversight.
- `notifications` has no `channel` field (push vs in-app vs email) recorded per row, only `type` — makes it hard to later audit "did the push actually fire" versus "was it just logged in-app."

**Missing relationships:**
- `pieces_jointes` allows both `id_intervention` and `id_message` to be nullable independently — the DDL does not constrain "exactly one of the two must be set." As written, a row with both NULL or both set is not prevented at the database level. **[DECISION REQUIRED]**, see D-20c — needs either an app-level invariant (Laravel validation) or a DB `CHECK` constraint.
- `audit_logs.entite_id` is a loosely-typed `BIGINT` with a separate `entite VARCHAR(50)` naming the table — this is a polymorphic-by-convention pattern with no enforced FK, which is standard for audit tables but should be explicitly documented as intentional (audit rows must survive the deletion of their subject).

**Missing constraints:**
- No `UNIQUE` constraint preventing duplicate active tickets from the same client with identical title+description within a short window (spam/double-submit protection at the DB layer — currently only the client-side "disable submit while pending" pattern guards against this, per §13.2's state spec, which is a UI-only safeguard).
- No DB-level enforcement of the status state machine itself (that's necessarily application-layer, in the `InterventionPolicy`/Service) — worth confirming in the eventual SRS that this is accepted as an app-layer-only guarantee, since a direct DB write (migration script, manual fix, admin SQL) could silently violate it.

**Missing indexes:**
- `messages` has `idx_msg_intervention` but no index on `id_expediteur` alone — likely fine at MVP scale (500 concurrent users), flagged only for awareness if per-user message analytics are ever needed.
- No composite index on `interventions (id_technicien, statut)` despite "technician's assigned tickets filtered by status" being one of the most common queries in the app (FR-TECH-02) — current indexes (`idx_interv_technicien`, `idx_interv_statut` separately) will work but a composite would be more efficient at scale. **[RECOMMENDATION]**, not a blocker at 500-user scale.

**Missing audit information:** covered above (no status-history table) — this is the most significant data-layer gap found.

**Missing timestamps:** `interventions.date_cloture` exists but there's no equivalent captured moment for `EN_COURS` pickup or `BLOQUE` entry — meaning the "average pickup time" and "average resolution time" KPIs promised in §23.1 **cannot actually be computed** from the current schema, since only creation time and closure time are timestamped; the moment of `EN_ATTENTE→EN_COURS` transition (the pickup-time metric's own end-point) isn't stored anywhere. **[DECISION REQUIRED]**, see D-20b — this one is not optional if §23.1's KPIs are to be delivered as specified.

**Missing soft-delete support:** confirmed absent across all six tables — every deletion in the schema is either a hard `CASCADE`/`SET NULL` FK action. Given `audit_logs` retention requirements (12 months) and the sensitivity of the data (technical access credentials discussed in tickets), hard-deleting a `users` row and cascading into their `interventions`/`messages` may itself be a compliance risk (destroying the very audit trail the system exists to provide). **[DECISION REQUIRED]**, see D-20.

---

## 4. Security Analysis

**Authentication:** Bcrypt + Sanctum bearer tokens, 12h recommended lifetime, role re-verified server-side (§18, §26 A02/A07). Solid baseline.

> **Contradiction flagged:** the API contract (§17.1) specifies `POST /auth/refresh` — "Renouvelle le jeton avant expiration." Laravel Sanctum's personal access tokens are **opaque, framework-agnostic, and do not natively expire or refresh** the way a JWT does (no `exp`/`iat` claim, no refresh-token grant). A 12-hour expiry and a refresh endpoint are both *possible* to bolt onto Sanctum (custom `expires_at` column + a scheduled pruning command + an app-defined refresh semantic that actually just issues a new token and revokes the old one), but this is **not what Sanctum does out of the box**, and the source document's own reconciliation note (§18, "Recommandation d'ingénierie") only resolves *which package* to use — it does not resolve *how* expiry/refresh will actually be implemented on top of it. This is a genuine specification gap, not just a missing decision. **[DECISION REQUIRED]**, see D-22.

**Authorization:** Two-layer RBAC (middleware + Policies) is well specified (§19) and the matrix (§8.4) is unambiguous. No gap.

**Messaging security:** AES-256-at-rest + TLS/WSS in transit is specified, and — notably — the source itself already catches and resolves the "zero server knowledge" (E2EE) messaging-copy contradiction (§20.2), correctly deferring true E2EE to V2. This is one of the most mature parts of the spec; no further gap analysis needed here beyond what `PROJECT_DISCOVERY.md` §12 already captured.

**File uploads:** Type/size/MIME/signed-URL rules are specified (§22). Gaps: (a) no stated policy on **what happens to attachments when their parent ticket or message is deleted** beyond the FK `ON DELETE CASCADE` — i.e., are files actually purged from disk/bucket, or does the DB row disappear while the physical file orphans on storage, silently consuming space and retaining sensitive images indefinitely? **[DECISION REQUIRED]**, see D-30. (b) ClamAV scanning is "recommended," not mandated — if adopted, no decision exists on what happens to a file *while* it's being scanned (is it accessible before the scan completes, or gated?). **[DECISION REQUIRED]**, see D-30b.

**API:** Standard error-code conventions defined (§17.7); rate limiting defined per-endpoint (§26.1) but **no decision on the rate-limit storage backend** — Laravel's default rate limiter uses the cache driver, and under a Dockerized multi-container deployment, rate limits must be tracked in a shared store (Redis) rather than per-container in-memory/file cache, or the limits will be silently ineffective across container restarts/scale-out. **[DECISION REQUIRED]**, see D-28.

**Database:** Eloquent-only, parameterized queries — A03 (Injection) is well covered. No gap beyond what's in §12 of the Discovery Document.

**Sessions:** Multi-device tokens, per-device and "all devices" revocation specified (§18.4). Gap: **no device-binding or device-fingerprinting concept** — a stolen bearer token is fully usable from any device until manually revoked; there's no "new device detected" notification/challenge. **[RECOMMENDATION]**, not a stated requirement, but standard for an app handling admin credentials/network diagrams in its messages.

**Encryption:** covered above (messaging) and in §12 of the Discovery Document. No additional gap.

**OWASP coverage:** A01–A10 all mapped (§26, `PROJECT_DISCOVERY.md` §12). No gap in *coverage*, only in *depth of decided detail* for A05 (which specific security headers, exact CSP policy — not specified) and A06 (audit cadence not scheduled — "regular" is not a cadence). **[RECOMMENDATION]** to formalize both in the eventual SRS.

**Brute force:** covered by §26.1 rate limits + FR-AUTH-07 progressive delay. No gap.

**Replay attacks:** **not addressed anywhere.** Bearer tokens are static secrets with no nonce/timestamp-based replay protection beyond TLS transport security itself — this is standard for bearer-token APIs (replay protection is usually not needed when TLS prevents interception and tokens are revocable), but it should be an explicit, stated acceptance rather than a silent omission, especially given the platform's stated threat model (interception was the #1 AS-IS risk, §2.4). **[RECOMMENDATION]** to explicitly document this as an accepted risk in the SRS rather than leave it implicit.

**SQL Injection:** covered (Eloquent-only, A03). No gap.

**XSS:** covered at the "escape free text on display" level (§26.3) for the mobile app; **no equivalent statement exists for any future web-based interface** (Supervisor web portal is only a V3 idea, §31, so this is correctly out of MVP scope — flagged only for forward awareness).

**CSRF:** correctly ruled not-applicable to the bearer-token mobile API (§26.2); explicitly retained for any future session-based web admin panel. No gap.

**Rate limiting:** covered above (D-28 storage backend decision).

**Audit logs:** well specified (§15.2, §26.5). One decided-but-unenforced gap: the *retention* (12 months) has no stated automated purge/archival job — does data older than 12 months get deleted, archived, or kept forever in practice? **[DECISION REQUIRED]**, see D-26b.

**Device binding:** not specified — see Sessions above. **[RECOMMENDATION]**.

**Biometric authentication:** not mentioned anywhere in either source. **[DECISION REQUIRED]** only in the sense that Product should explicitly confirm it's out of MVP scope (it's a common client expectation on a "secure" app) rather than let it be assumed-out by omission — see D-24.

**Token refresh:** see the Sanctum contradiction above (D-22) — this is the single most concrete technical risk found in this entire analysis, because it affects the API contract's correctness, not just a missing nice-to-have.

---

## 5. Mobile Application Analysis

| Concern | Status |
|---|---|
| Navigation | GoRouter with auth/role guards recommended (§24.1); concrete per-role navigation maps exist (§12.2–12.4). No gap. |
| Offline support | FR-TRV-04 (Should) covers ticket creation + message send queueing; §20.4 covers message-specific offline queue. **Gap:** no stated conflict-resolution behavior if an offline-queued action becomes invalid by the time it syncs (e.g., a queued "assign technician" action where that technician was deactivated in the meantime, or a queued status change that's now illegal because the ticket moved states server-side first). **[DECISION REQUIRED]**, see D-16d. |
| Caching | Hive/drift recommended for local cache (§24.1) — no cache invalidation policy stated (TTL? push-triggered invalidation? manual pull-to-refresh only?). **[RECOMMENDATION]** to define explicitly. |
| Loading states | Shimmer/skeleton loading specified as a cross-cutting component (§13.7). No gap. |
| Error handling | `Result<T>`/Either pattern recommended (§24.4); generic error messaging patterns specified per-screen (§13.1–13.6). No gap in principle; no gap in the FR-level detail either. |
| State restoration | **Not addressed** — no statement on whether the app preserves navigation/form state across a process kill (e.g., a partially filled ticket-creation form surviving an OS-triggered background kill). **[RECOMMENDATION]**. |
| Connectivity | Handled via the offline-mode requirement (FR-TRV-04) and WSS-to-polling fallback (§20.1). No gap beyond D-16d above. |
| Localization | French default + English required as an NFR (§7) — **no in-app switch mechanism, no translation-file strategy (ARB/gettext/etc.), and no statement on whether locale follows device settings or is user-selectable.** **[DECISION REQUIRED]**, see D-06. |
| Accessibility | WCAG 2.1 AA contrast/touch-target targets stated (§7); semantic labels called out for the auth screen specifically (§13.1) but not confirmed as a blanket requirement across all screens. **[RECOMMENDATION]** to make it explicit and universal in the SRS rather than screen-specific. |
| Dark mode | Could-have (FR-TRV-05); only one color token (`surfaceDark`) exists — a full dark palette is not specified. Correctly low priority given its own MoSCoW rating. |
| Tablet support | Maître-détail two-column layout above 600dp is specified (§13.7) for list+detail screens. No gap. |
| Orientation | **Not addressed at all** — no statement on whether the app locks portrait, or supports landscape, on phones vs. tablets. **[RECOMMENDATION]** to state explicitly (likely: portrait-locked on phone, both on tablet, given the tablet master-detail spec already implies landscape use). |
| Deep links | **Not addressed** — e.g., does a push notification for "new message" open directly to that ticket's conversation, or just to the app's home screen? This materially affects the perceived quality of the notification system already specified in §21. **[DECISION REQUIRED]**, see D-25b. |
| Push notifications | FCM specified as the channel (§21.1); event triggers fully specified (§21.2). Gap is the deep-link behavior above, plus **no stated decision on iOS push (APNs) certificate/key ownership and renewal process** if iOS ships. **[DECISION REQUIRED]**, tied to D-05 (iOS scope) and D-25. |

---

## 6. Backend Analysis

| Concern | Status |
|---|---|
| REST design | Resource-oriented routes, consistent verb/status-code usage (§17). No gap. |
| API versioning | `/api/v1` prefix exists; **no policy for what happens at `/v2`** — parallel versioning, header-based versioning, or hard cutover is undecided. Correctly low-priority pre-MVP (there's nothing to version yet), but should be a named future decision, not a silent gap. **[RECOMMENDATION]**. |
| Pagination | Only stated for the dashboard list (20/page, §13.3). Every other list endpoint in §17 (`/interventions`, `/notifications`, `/users`) says "liste paginée" without specifying page size or cursor-vs-offset strategy. **[DECISION REQUIRED]**, see D-21. |
| Validation | Form Requests per endpoint, French error messages (§25.1). No gap. |
| Policies | `InterventionPolicy`, `MessagePolicy`, (implied) `UserPolicy` are named with concrete authorize-logic pseudocode (§19.2). No gap. |
| Services | `InterventionService`, `MessageService`, `NotificationService` named with clear responsibility split (§25.1). No gap. |
| Repositories | `InterventionRepository`, `UserRepository` named for testability (§25.1). No gap — though only two repositories are named while the domain has ~6 entities; worth confirming in the SRS whether `MessageRepository`/`UserPolicy` etc. are implied-but-unnamed or genuinely out of scope. **[RECOMMENDATION]** to make the repository list exhaustive. |
| Queues | Redis or DB-backed queues for async email/push/export (§25.1) — **no decision on which** driver, which has real infra implications (Redis requires an additional container in the Docker Compose topology, §28.1, that isn't listed among the four named containers — NGINX, Laravel, MySQL, WebSocket). **[DECISION REQUIRED]**, see D-27b. |
| Events | `InterventionCreated`, `StatusChanged`, `MessageSent` named (§25.1) — matches the notification triggers in §21.2 well. No gap. |
| Notifications | Fully specified end to end (§21). No gap. |
| Storage | Local filesystem vs S3-compatible — undecided, see D-04. |
| Caching | **Not mentioned anywhere for the API layer** (as distinct from the mobile app's local cache) — e.g., is the dashboard's KPI aggregation (§23.1) computed fresh on every request, or cached with an invalidation strategy? At 500 concurrent users this may not matter yet, but the P95<400ms target (§7) for "lecture de liste" could be at risk for aggregate/report endpoints without one. **[RECOMMENDATION]**. |
| Background jobs | `SendInvitationEmail`, `ExportInterventionsReport` named (§25.2) — consistent with the queues gap above (D-27b). No further gap beyond that dependency. |

---

## 7. Database Analysis

(Extends §3 above with the specific angles requested.)

- **Normalization:** 3NF explicitly claimed and, on inspection, correctly achieved (§15.1). No gap.
- **Indexes:** covered in §3 — one composite-index recommendation, not a blocker.
- **Constraints:** the `pieces_jointes` XOR-nullable gap (D-20c) is the one genuine structural weakness found.
- **Performance:** P95<400ms target stated (§7) but no query-plan/indexing validation step is scheduled anywhere in the testing strategy (§27) — performance testing (k6/JMeter) is scoped to "high-traffic endpoints" generically, not tied to specific expected-slow queries (e.g., the dashboard aggregation). **[RECOMMENDATION]** to name the dashboard/report endpoints explicitly as k6 targets.
- **Scalability:** 500-concurrent-user ceiling is explicit and accepted as the V1 target (§7) — consistent, not a gap.
- **Backups:** daily automated, 30-day retention, quarterly restore test (§28.5) — well specified. Gap: **no stated backup storage location** (same VPS vs. off-site) despite "copie hors site" being mentioned — "off-site" is asserted but the actual destination (which provider, which region) is undecided. **[DECISION REQUIRED]**, see D-26.
- **Transactions:** "atomic multi-table transactions" required generically (§7) but no specific multi-table operation is called out as requiring one — the most obvious candidate is the status-transition + notification-creation + audit-log-write sequence (three tables touched per status change). Worth making explicit in the SRS which operations are transactionally wrapped. **[RECOMMENDATION]**.
- **History tables:** absent — see §3's status-history gap (D-20b), the single most consequential data-layer finding in this report, since it silently breaks the §23.1 KPI promises.
- **Audit tables:** present and well designed (`audit_logs`). No gap beyond the retention/purge policy (D-26b).

---

## 8. Messaging Analysis

| Concern | Status |
|---|---|
| Encryption | AES-256-CBC at rest, TLS/WSS in transit, E2EE correctly deferred to V2 (§20.2). No gap. |
| Conversation model | 1:1 per ticket, `intervention.{id}` channel (§20.1). No gap — but note this means **a client cannot have a general, ticket-independent conversation with MSIS** (e.g., a pre-sales question) — correctly out of scope per the stated model, just worth confirming that's intentional. |
| Attachments | Rules specified (§22); retention/deletion gap already flagged (D-30). |
| Images | JPG/PNG/WEBP, client-side recompression before upload (§22). No gap. |
| Read receipts | `lu`/`lu_at` fields exist, Should-priority (FR-DET-07). No gap. |
| Typing indicators | Specified as an ephemeral WebSocket event, explicitly not persisted (§20.4). **Gap:** what happens to the typing indicator feature when the app falls back to REST polling (§20.1's own fallback mechanism)? Polling cannot carry an ephemeral "is typing" signal the way a live socket can — the feature silently degrades to non-functional under fallback, and this isn't stated anywhere. **[DECISION REQUIRED]**, see D-29 (likely resolution: accept typing-indicator as unavailable during polling fallback, and state that explicitly rather than leave it implicit). |
| Delivery status | "Delivered then read" implied (UC-06 postcondition) but **no explicit "delivered" state field exists in the `messages` schema** — only `lu`/`lu_at` (read). There's no way to distinguish "sent but not yet delivered to recipient's device" from "delivered but not read," despite the UC explicitly describing that three-state progression. **[DECISION REQUIRED]**, see D-20d. |
| Push notifications | Covered in §21, on new message. No gap. |
| Offline messages | Local outbox, chronological replay on reconnect (§20.4). No gap in principle — no gap in dedup behavior either (source explicitly requires "sans duplication," §27.3). |
| Synchronization | Same as above. No gap beyond D-16d (conflict resolution generally). |
| Retention | **Not addressed for message content** — `audit_logs` has a stated 12-month retention; ticket/message content has none stated. Does a `CLOTUREE` ticket's conversation get archived, purged, or kept forever? Given messages may contain admin credentials and network diagrams (the exact sensitive content this platform exists to protect), an explicit retention/purge policy is a meaningful gap, not a cosmetic one. **[DECISION REQUIRED]**, see D-30c. |
| Moderation | Not mentioned — correctly out of scope for an internal B2B-style support tool where all parties are known, authenticated, ticket-scoped actors; flagged only for completeness, not treated as a real gap. |
| Audit | Admin audit-mode read access is logged (§20.3). No gap. |

---

## 9. Deployment Analysis

| Concern | Status |
|---|---|
| Docker | Compose-based, 4 named containers: NGINX, Laravel, MySQL, WebSocket (§28.1). **Missing from the named topology:** a queue worker container/process and (if Redis is chosen for cache/queue/rate-limiting, per D-27b/D-28) a Redis container. As written, the topology diagram under-counts what the rest of the spec actually requires to run. **[DECISION REQUIRED]**, folded into D-27. |
| Production server | Single Ubuntu VPS, NGINX reverse proxy (§28.1). Consistent with the stated 500-user ceiling; no gap for MVP. |
| Backups | Covered in §7 above (D-26 location gap). |
| SSL | Let's Encrypt/certbot, auto-renewal, forced HTTP→HTTPS (§28.1, §20.2). No gap. |
| CI/CD | GitHub Actions pipeline recommended in full (§28.3) — entirely a recommendation layered on a report that describes zero existing CI. **[RECOMMENDATION]**, adoption is a project-management decision more than a technical one. |
| Monitoring | Sentry (errors), Loki-equivalent (logs), 5-minute health-check probe on `/api/v1/health` (§28.4). Gap: `/api/v1/health` is referenced as a target but **never listed among the actual API routes in §17** — it needs to be added to the formal route table when the SRS is written, or it will be built ad hoc and drift from the rest of the documented contract. **[RECOMMENDATION]**, small but concrete. |
| Logging | Centralized stdout collection recommended (§28.4). No gap beyond the queue-worker container omission above. |
| Health checks | Covered above. |
| Scaling | No plan beyond the single-VPS/500-user ceiling (§7, §28.1) — correctly out of MVP scope, consistent with the source's own stated target; not a gap, a boundary. |

---

## 10. Risk Analysis

| Risk | Category | Likelihood | Impact | Mitigation |
|---|---|---|---|---|
| Sanctum's actual behavior doesn't match the `/auth/refresh` contract as written (D-22) | Technical | High (will surface the first time someone implements the endpoint literally) | Medium — reworkable, but wastes a sprint if discovered late | Resolve D-22 explicitly before backend work starts; document the concrete expiry/refresh mechanism in the SRS, not just "Sanctum" as a package name. |
| Status-history is unrecoverable, breaking §23.1 KPIs (D-20b) | Technical / Business | High (KPIs are explicitly promised to the Product Owner) | High — a management-facing deliverable silently can't be built as specified | Add a lightweight status-history table or an event-sourced log before any dashboard/report work starts; cheap now, expensive as a retrofit once historical data exists without it. |
| Client self-registration left undecided (D-01) | Business | High (blocks the entire Client onboarding funnel) | High — no clients can start using the app without resolving this | Get an explicit Product Owner decision before building the auth module; it gates the very first screen. |
| Attachment/message retention undecided while content includes admin credentials (D-30c) | Security / Compliance | Medium | High — indefinite retention of sensitive credentials is itself a security liability, the same one the project exists to eliminate | Decide and document a retention/purge policy before the messaging module ships, not after. |
| Rate-limit/queue backend undecided under multi-container Docker (D-28, D-27b) | Technical / Operational | Medium (only surfaces under real concurrent load or container restarts) | Medium — silently ineffective rate limiting is a security gap that won't show up in functional testing | Decide Redis-backed cache/queue/rate-limit stack now; add the Redis container to the deployment topology in the SRS. |
| Technician availability not modeled (D-19) | Operational | High (every assignment decision is affected daily) | Medium — doesn't block launch, but undermines the "efficient assignment" business objective from day one | Accept for MVP as a known limitation, or add a minimal `disponible` boolean if cheap; either way, document the decision explicitly rather than let it be an implicit gap. |
| No ticket cancellation path (D-17) | Functional / UX | Medium | Low-Medium — workaround exists (client messages technician/supervisor informally, ironically re-introducing an informal channel the project exists to eliminate) | Decide before Client-side screens are finalized — ties directly to the project's own stated mission (§3.1) of eliminating informal channels. |
| No escalation logic beyond a passive alert (D-16) | Operational | Medium | Medium — SLA targets (§21.3) exist but nothing enforces them beyond notifying a human | Accept a notification-only approach for MVP (consistent with V1 scope) but state explicitly that "escalation" means "alert a human," not "auto-reprioritize," so expectations are calibrated. |
| iOS scope undecided (D-05) affects push (D-25), file signing (A08), and app-store timeline | Business / Operational | High (affects estimation immediately) | Medium — reworkable but affects sprint planning materially | Get an explicit go/no-go on iOS-at-launch before estimating the mobile workstream. |
| Localization mechanism undecided (D-06) despite EN being a stated NFR | Functional | Medium | Low-Medium — reworkable post-launch, but ARB/translation-key retrofitting into already-built screens is real rework | Decide the translation-key strategy before the first screen is built, even if EN copy itself ships later. |
| `pieces_jointes` XOR-nullable constraint unenforced (D-20c) | Data integrity | Low (requires an app bug or manual DB edit to manifest) | Low-Medium — orphaned/ambiguous attachment rows, hard to clean up later | Add either a DB `CHECK` constraint or a strict application-level invariant test; cheap now. |
| Soft-delete absent given sensitive audit trail (D-20) | Compliance / Data integrity | Low-Medium (only matters on an actual deletion request) | High if it occurs — could destroy the exact audit evidence the platform is built to preserve | Decide the deletion-vs-anonymization strategy before any account-deletion feature (even an admin "delete user" button) is built, not after. |

---

## 11. Decision Register

Every decision required before implementation, numbered, with problem / options / trade-offs / recommendation / priority. Recommendations are advisory — final choice belongs to the Product Owner / Technical Design Authority sign-off, not to this document.

---

**D-01 — Client account creation model**
*Problem:* §18.3 explicitly leaves open whether Client registration is self-service or invite-only, and there's no specified profile/settings screen either.
*Options:* (a) Open self-registration (email+password, optionally email-verified before first ticket); (b) Invite-only, same as Technician/Supervisor; (c) Hybrid — self-registration allowed but account starts "unverified" with limited capability (e.g., can't attach files) until email is confirmed.
*Advantages/disadvantages:* (a) fastest adoption, matches a public-facing "report a fault" product, but raises spam/abuse risk without verification; (b) matches the trust model already used for Technician/Supervisor and is more secure, but adds friction that could undermine the ≥70%-adoption-in-3-months KPI (§3.3) since every client needs manual onboarding; (c) balances both but adds implementation complexity for a capability-gating rule that isn't specified anywhere else in the system.
*Recommendation:* (a) open self-registration with mandatory email verification gate before ticket creation — matches a client-facing support product norm and doesn't burden MSIS staff with manual onboarding at the volume implied by the adoption KPI.
*Priority:* Must-resolve before Auth module design.

**D-02 — Production domain / hosting provider**
*Problem:* `api.msis-tech.example` is explicitly marked placeholder (§17).
*Options:* MSIS-owned domain vs. a project-specific subdomain; VPS provider selection.
*Recommendation:* Defer to MSIS business decision — not an engineering call. Document as a blocking prerequisite for the `.env`/deployment step (§28.2).
*Priority:* Must-resolve before deployment, not before development.

**D-03 — WebSocket hosting: self-hosted Laravel WebSockets vs. Pusher (SaaS)**
*Problem:* §20.1 explicitly leaves this open.
*Advantages/disadvantages:* Self-hosted — no recurring SaaS cost, full data residency control (relevant given the platform's confidentiality mission), but adds one more container to operate/monitor/scale on the single VPS (§28.1 topology already under-lists containers, see D-27). Pusher — zero ops burden, proven reliability, but recurring cost and a third-party processor touching (encrypted, but still) message metadata.
*Recommendation:* Self-hosted Laravel WebSockets — consistent with the project's own confidentiality-first mission and the single-VPS budget model implied by §28.6's modest cost estimate (no SaaS line item is budgeted there).
*Priority:* Must-resolve before real-time messaging is built.

**D-04 — File storage: local filesystem vs. S3-compatible bucket**
*Problem:* §22 presents both as valid options without choosing.
*Advantages/disadvantages:* Local — simpler, no extra account/cost, but backup/replication is manual and tied to the single VPS's disk (a VPS failure risks attachment loss alongside the stated RPO≤24h/RTO≤4h targets, §7); S3-compatible — built-in redundancy, easier to scale storage independent of the VPS, but adds a third-party dependency and cost line not currently in the §28.6 estimate.
*Recommendation:* S3-compatible bucket (e.g., a regional MinIO or a Cameroon/African-region-friendly S3 provider) — the RPO/RTO targets are hard to meet for binary attachments on local disk without meaningfully more backup engineering than mysqldump-style DB backups already assume.
*Priority:* Must-resolve before attachment upload implementation.

**D-05 — iOS scope at MVP**
*Problem:* Source treats iOS as conditional ("IPA le cas échéant") throughout; never firmly committed.
*Options:* Android-first, iOS later; both platforms from day one.
*Advantages/disadvantages:* Android-first — faster MVP delivery, matches the likely device mix of MSIS's Cameroon client base, defers Apple Developer account/TestFlight/App Store review overhead; both-from-day-one — broader reach immediately, but real added cost (Apple Developer Program fee, code-signing, APNs setup for D-25) with no stated business justification for needing it at launch.
*Recommendation:* Android-first for MVP, iOS as a fast-follow — no stated requirement forces iOS-day-one, and it measurably shrinks MVP scope.
*Priority:* Must-resolve before mobile estimation/sprint planning.

**D-06 — Localization delivery for MVP**
*Problem:* French+English is a stated NFR (§7) with zero implementation mechanism specified.
*Options:* Ship French-only for MVP with the translation-key architecture in place (ARB files, `flutter_localizations`) but English strings deferred; ship both languages complete at MVP.
*Advantages/disadvantages:* French-only-content — faster MVP, but technically risks the NFR target if "supported at launch" is read literally; both-complete — meets the NFR literally but adds translation workload with no stated priority tier (the NFR table doesn't MoSCoW-rate this the way FRs are rated).
*Recommendation:* Build the localization architecture now (cheap, avoids retrofitting) but treat full English content parity as a fast-follow unless the Product Owner confirms it's launch-blocking.
*Priority:* Architecture must-resolve before first screen is built; content completion is negotiable.

**D-07 — Dispute/reopen mechanism for MVP**
*Problem:* Explicitly deferred to manual handling (UC-05 alt flow) — confirming this stays as-is or needs an MVP escape hatch.
*Recommendation:* Accept the source's own explicit deferral — this is an **[OFFICIAL – A]** decision already made, not actually open. Listed here only to confirm no in-app affordance (e.g., "contest this ticket" button) is silently expected by a screen designer misreading the gap as an oversight.
*Priority:* No action needed — confirmed out of scope.

**D-08 — Cross-role visibility of `telephone` field**
*Problem:* `telephone` was added as an engineering recommendation (§15.2) with no stated visibility rule.
*Options:* Visible to the counterpart party on an active ticket only (client sees assigned technician's phone and vice versa); visible to Supervisor only; not exposed via API at all beyond the owning user.
*Recommendation:* Expose to the counterpart party only while a ticket is `EN_COURS`/`BLOQUE` (operationally useful for on-site coordination — matches the field's own likely intent) and always to Supervisor; never expose a client's phone to a technician not currently assigned, or vice versa.
*Priority:* Should-resolve before the ticket-detail API resource (`InterventionResource`) is finalized.

**D-09 — Timestamp timezone strategy**
*Problem:* No stated storage/display timezone.
*Options:* Store UTC, convert to Africa/Douala (WAT, UTC+1) for display; store WAT directly.
*Recommendation:* Store UTC (Laravel/MySQL default, avoids DST-adjacent ambiguity even though WAT has no DST) and convert to WAT only at the Flutter presentation layer — standard practice, keeps the backend timezone-agnostic if MSIS ever operates outside Cameroon.
*Priority:* Should-resolve before the first migration is written (touches every table).

**D-10 — Data protection / compliance framework**
*Problem:* No Cameroon-specific compliance framework named beyond the OWASP-driven technical controls.
*Recommendation:* Confirm with MSIS/legal whether Cameroon's data protection regime (or any sector-specific requirement given the "grandes institutions" client base, §2.1) imposes obligations beyond what's already specified; this is a legal question, not an engineering one, but the answer affects D-20 (soft-delete/erasure) directly.
*Priority:* Should-resolve before D-20 is finalized.

**D-11 — Post-closure messaging state**
*Problem:* No stated rule for whether a `CLOTUREE` ticket's conversation stays open for new messages.
*Options:* Fully read-only after closure; remains open indefinitely; remains open for a grace period (e.g., 7 days) then locks.
*Recommendation:* Read-only after closure, consistent with the ticket itself being described as "définitivement archivé" (UC-05 postcondition) — a closed ticket that can still receive new messages contradicts its own "definitively archived" characterization in the source.
*Priority:* Should-resolve before the messaging Policy (`MessagePolicy::send`) is implemented.

**D-12 — Reassignment carry-over behavior**
*Problem:* No rule for whether `motif_blocage`/`rapport_technique` persist or reset on technician reassignment.
*Recommendation:* Persist both fields as-is (they describe the *ticket's* state, not the technician's) — resetting them would destroy exactly the "continuity of context" the source explicitly requires for conversation history on reassignment (§20.3), so the same principle should extend to these fields for consistency.
*Priority:* Should-resolve before `InterventionService::assignTechnician` is implemented.

**D-13 — Auto-closure-after-7-days rule**
*Problem:* This rule is an engineering recommendation (UC-05 exception), not an official requirement — it silently changes ticket state without explicit user action, which is a meaningful behavior to introduce unilaterally.
*Recommendation:* Validate explicitly with the Product Owner before implementing — silent auto-transitions are exactly the kind of "invented rule" the source's own methodology (Category C discipline) warns against smuggling in as if official.
*Priority:* Must-confirm with Product Owner before the closure workflow is built — do not implement by default.

**D-14 — Expected account-volume scale**
*Problem:* No stated ceiling on technician/supervisor account counts, only the 500-concurrent-user NFR (which is almost certainly Client-dominated).
*Recommendation:* Confirm with MSIS the realistic technician headcount (org chart in §2.1 suggests a small team — 3 poles) — this affects whether the technician-assignment UI needs a searchable/paginated picker or a simple flat list.
*Priority:* Low — nice to know before building the assignment UI, not launch-blocking.

**D-15 — Production support/on-call model**
*Problem:* §26.5/§28.4 specify *what* gets alerted (5xx spikes, repeated auth failures) but not *who* responds.
*Recommendation:* MSIS operational decision — document the on-call owner (likely the same dev team, given company size) in the eventual deployment runbook, not the SRS itself.
*Priority:* Low for MVP — needed before go-live, not before development starts.

**D-16 — Ticket escalation logic**
*Problem:* No auto-escalation exists; only a passive supervisor alert (§21.3).
*Recommendation:* Accept notification-only escalation for MVP — matches the source's own V1 scope discipline — but state explicitly in the SRS that "escalation" = "alert," not "reprioritize," so no one assumes automatic priority changes exist.
*Priority:* Should-clarify in SRS wording; no new engineering work implied if accepted as-is.

**D-16b — Deactivated technician with an `EN_COURS` ticket**
*Problem:* FR-USR-04 only defines behavior for un-started `EN_ATTENTE` tickets.
*Options:* Ticket stays assigned to the deactivated technician (frozen, supervisor must manually reassign); ticket is auto-flagged for mandatory reassignment; deactivated technician retains write access to only their already-`EN_COURS` tickets until closed.
*Recommendation:* Auto-flag for mandatory reassignment (surface it prominently on the Supervisor dashboard) but revoke the deactivated technician's write access immediately (their auth token should already be unusable once `actif=false`, consistent with §18/§19's access model) — leaving a disabled account able to act on live tickets contradicts the very purpose of deactivation.
*Priority:* Should-resolve before `UserPolicy`/deactivation Service logic is implemented.

**D-16c — Supervisor-created ticket attribution**
*Problem:* §8.4 allows a supervisor to create a ticket "for a client," but the schema only has `id_client`, no distinct creator field.
*Recommendation:* Add an `audit_logs` entry capturing the true actor (already structurally possible without a schema change, since `audit_logs.id_user` is separate from the ticket's `id_client`) rather than a new `interventions` column — keeps the core ticket table clean while preserving full attribution in the audit trail.
*Priority:* Should-resolve before the ticket-creation Service/Controller is implemented.

**D-16d — Offline-queued action becomes invalid before sync**
*Problem:* No conflict-resolution rule exists for a locally-queued action that's no longer valid by the time it reaches the server (stale status transition, deactivated assignee, etc.).
*Options:* Server silently rejects with a clear error surfaced to the user on next app open; server attempts best-effort reconciliation (e.g., re-validate and apply what's still valid, discard the rest); block sync entirely until the user manually reviews conflicts.
*Recommendation:* Server rejects with a clear, itemized error list surfaced to the user (consistent with the existing 422 convention, §17.7) — "best-effort reconciliation" risks silently applying a different outcome than the user intended, which is worse than a visible, explainable failure for a security-conscious product.
*Priority:* Should-resolve before the offline-sync module is implemented.

**D-17 — Ticket cancellation by client**
*Problem:* No cancellation path exists between creation and technician pickup.
*Options:* Add a `CLOTUREE`-adjacent terminal state (e.g., `ANNULEE`) reachable only from `EN_ATTENTE`; allow deletion instead of a status; no cancellation at all (client must contact supervisor).
*Recommendation:* Add an `ANNULEE` terminal state reachable only from `EN_ATTENTE`, client-triggered — a genuinely new ticket state is a real schema change, so this should be explicitly accepted or rejected by the Product Owner before the status ENUM is finalized, not patched in later.
*Priority:* Must-resolve before the `interventions.statut` ENUM is finalized in the SRS — changing an ENUM after data exists is a real migration cost.

**D-18 — "Transfer" vs. "reassignment" terminology**
*Problem:* Your prompt names "Transfer" as a distinct workflow from "Assignment"; the source only has one mechanism (reassignment, §8.2).
*Recommendation:* Treat them as the same mechanism — no evidence in either source of a distinct "transfer" concept (e.g., transferring to a different supervisor's queue, or between departments). Flagging only to confirm this reading is correct rather than silently assuming it.
*Priority:* Low — clarify in SRS glossary, no engineering impact expected.

**D-19 — Technician availability/capacity model**
*Problem:* No availability signal beyond binary `actif`.
*Options:* Add a `disponible` boolean the technician toggles; compute an implicit "load" from open ticket count and surface it to the supervisor without a new field; do nothing for MVP.
*Advantages/disadvantages:* Explicit toggle — most accurate, but adds a UI affordance and a state the technician must remember to maintain; computed load — zero new schema, leverages data already captured (`interventions.id_technicien` + `statut`), but doesn't capture true availability (e.g., a technician on leave with zero open tickets still reads as "available"); do nothing — simplest, matches the source's literal scope, but weakens the assignment workflow from day one.
*Recommendation:* Computed load (open-ticket count per technician, already buildable from existing data) surfaced on the assignment UI — meets 80% of the operational need with zero schema change, leaving true availability toggling as a clearly labeled fast-follow.
*Priority:* Should-resolve before the technician-assignment UI is designed, low schema risk either way.

**D-20 — Soft-delete / erasure strategy**
*Problem:* No `deleted_at` anywhere; all deletions are hard, cascading FK actions.
*Options:* Add `deleted_at` (Eloquent `SoftDeletes`) to `users` and `interventions`; keep hard deletes but require an explicit anonymization step before allowing any delete; disallow user deletion entirely (deactivation only, which is already the modeled pattern via `actif`).
*Recommendation:* Disallow hard user deletion entirely for MVP — `actif=false` is already the modeled lifecycle end-state, and it's the only option that doesn't risk cascading away audit-relevant `interventions`/`messages` data. Revisit true erasure only if D-10's compliance review demands a "right to be forgotten"-style flow.
*Priority:* Must-resolve before any "delete account" admin feature is built (even if the answer is "don't build one").

**D-20b — Ticket status-history table**
*Problem:* Only the current `statut` is stored; §23.1's pickup-time/resolution-time KPIs require the *transition timestamps*, which don't exist.
*Recommendation:* Add a lightweight `intervention_status_history` table (`id_intervention`, `ancien_statut`, `nouveau_statut`, `id_user` (actor), `created_at`) populated by the `StatusChanged` event listener already named in §25.1 — this is a small, low-risk addition that makes the already-promised KPIs actually computable, and doubles as richer audit detail than `audit_logs` alone provides for this specific entity.
*Priority:* Must-resolve before the dashboard/reporting module (§23) is built — the KPIs literally cannot be computed without it.

**D-20c — `pieces_jointes` XOR constraint**
*Problem:* Both `id_intervention` and `id_message` are independently nullable with no enforced "exactly one" rule.
*Recommendation:* Enforce via a MySQL `CHECK` constraint (`CHECK ((id_intervention IS NULL) <> (id_message IS NULL))`) rather than relying on application-layer validation alone — cheap, and prevents any future direct-DB-write path (seeders, manual fixes, a future admin tool) from creating ambiguous rows.
*Priority:* Should-resolve before the `pieces_jointes` migration is finalized.

**D-20d — Message delivery-status field**
*Problem:* UC-06 describes a three-state progression (sent → delivered → read) but the schema only models "read" (`lu`/`lu_at`).
*Recommendation:* Add a `livre`/`livre_at` pair alongside the existing `lu`/`lu_at`, populated when the recipient's device acknowledges receipt over the WebSocket channel — small schema addition, closes a real gap between the use-case narrative and the data model that implements it.
*Priority:* Should-resolve before the messaging UI's delivery-indicator (already implied by the mockup's per-bubble timestamp/seen indicator, §13.6) is built.

**D-21 — Pagination strategy across all list endpoints**
*Problem:* Only the dashboard states a page size (20); every other paginated endpoint is silent.
*Options:* Offset-based pagination (simple, Laravel-default, fine at this scale) vs. cursor-based (better for real-time-changing lists like a live ticket queue, more complex to implement).
*Recommendation:* Offset-based (Laravel's default `paginate()`), page size 20 uniformly across `/interventions`, `/notifications`, `/users` — matches the one page-size value already specified, avoids introducing two different pagination mental models, and is entirely sufficient at the stated 500-user scale.
*Priority:* Must-resolve before any list endpoint's `Resource`/Controller is finalized — affects every list screen's contract simultaneously.

**D-22 — Sanctum token expiry/refresh implementation**
*Problem:* §17.1 specifies `/auth/refresh` with JWT-like semantics; Sanctum doesn't natively expire/refresh tokens.
*Options:* (a) Configure Sanctum's `expiration` config value + a scheduled `sanctum:prune-expired` command, and implement `/auth/refresh` as "revoke current token, issue a new one" (not a true refresh-token grant, just a renamed re-login-with-existing-token-as-proof); (b) drop the `/auth/refresh` endpoint entirely and rely on Sanctum's default non-expiring tokens plus the already-specified manual/all-device revocation (§18.4); (c) add `tymon/jwt-auth` after all, restoring true JWT refresh-token semantics as the report originally specified.
*Advantages/disadvantages:* (a) keeps the API contract's shape mostly intact with modest custom code, but is a semantic reinterpretation of "refresh" worth documenting explicitly so no developer assumes standard JWT refresh-token behavior; (b) simplest, fewest moving parts, but is a breaking change to the already-written API contract (§17.1) and removes a UX affordance (silent background renewal) users may expect from a "secure" app; (c) most semantically correct against both the report's original JWT wording and the API contract's refresh endpoint, but reintroduces the exact package the source document deliberately chose *not* to add (§18, "Recommandation d'ingénierie" explicitly weighed and declined this).
*Recommendation:* (a) — implement Sanctum expiration + prune job + a "revoke-and-reissue" `/auth/refresh`, and document this precisely in the SRS as the concrete resolution of the Sanctum/JWT reconciliation the source already started but didn't finish operationally.
*Priority:* Must-resolve before the Auth module is implemented — this is the single highest-confidence technical contradiction found in this review.

**D-23 — Device binding**
*Problem:* No device-fingerprinting/binding exists; a leaked token works from anywhere.
*Recommendation:* Out of MVP scope — no official requirement calls for it, and it adds meaningful complexity (device registration, fingerprint storage, UX for "new device" challenges) disproportionate to the stated V1 goals. Log it as an explicit **[RECOMMENDATION]** for V2 rather than build it now.
*Priority:* Low — confirm out-of-scope, don't implement.

**D-24 — Biometric authentication**
*Problem:* Not mentioned in either source; common user expectation for a "secure" app.
*Recommendation:* Confirm explicitly out-of-MVP-scope with the Product Owner (cheap to add later as a device-local unlock-the-stored-token convenience feature, doesn't change the backend contract at all) rather than let it be silently assumed.
*Priority:* Low — one confirmation needed, no engineering blocker either way.

**D-25 — Deep-link behavior for push notifications**
*Problem:* Not specified whether a push notification opens directly to the relevant ticket/conversation.
*Recommendation:* Deep-link to the specific ticket detail (and conversation tab, for message notifications) — the alternative (opening to a generic home screen) meaningfully undercuts the value of the notification system already fully specified in §21; this is a small GoRouter configuration addition, not a new module.
*Priority:* Should-resolve before the notification-handling code is implemented — cheap to get right the first time, awkward to retrofit once notification payloads are already defined without a target-route field.

**D-25b — iOS push certificate ownership**
*Problem:* If iOS ships (D-05), APNs key/certificate management and renewal ownership is undecided.
*Recommendation:* Tie directly to D-05's outcome — if Android-first is chosen, this is deferred entirely, not decided now.
*Priority:* Deferred, contingent on D-05.

**D-26 — Backup storage location**
*Problem:* "Copie hors site" (off-site copy) is asserted (§28.5) without naming an actual destination.
*Recommendation:* Tie to D-04's storage provider decision — if an S3-compatible bucket is already in use for attachments, the same provider's separate bucket/region is the natural off-site DB-backup destination, avoiding a second vendor relationship.
*Priority:* Should-resolve before the backup automation script is written.

**D-26b — Audit-log retention enforcement**
*Problem:* 12-month retention is stated (§7) with no automated purge/archival job.
*Recommendation:* Add a scheduled job (Laravel scheduler, monthly) that archives (not deletes, given the audit trail's own value) `audit_logs` rows older than 12 months to cold storage rather than the live table, keeping query performance stable on the live table without discarding the data outright.
*Priority:* Should-resolve before go-live, not before development starts — can be added any time before the 12-month mark is first reached in production.

**D-27 — Deployment topology completeness**
*Problem:* The named 4-container topology (§28.1) omits a queue-worker process and a Redis container implied by other decisions in this register (D-27b, D-28).
*Recommendation:* Update the deployment topology in the eventual SRS to explicitly include a Redis container and a queue-worker container/process (can run inside the Laravel container as a supervised process, or as its own container — either is standard) — this isn't a new requirement, just making an already-implied dependency visible before the Docker Compose file is written.
*Priority:* Must-resolve before `docker-compose.yml` is authored.

**D-27b — Queue driver**
*Problem:* §25.1 says "Redis ou base de données" without choosing.
*Recommendation:* Redis — given D-03 (self-hosted WebSockets) and D-28 (rate-limit backend) both already push toward needing Redis in the stack anyway, consolidating the queue driver onto the same Redis instance avoids running two different async infrastructure patterns for no added benefit.
*Priority:* Should-resolve alongside D-27/D-28 as one combined "add Redis" decision.

**D-28 — Rate-limit storage backend**
*Problem:* Default Laravel rate limiting depends on the configured cache driver; undecided, and matters specifically under multi-container Docker.
*Recommendation:* Redis-backed cache driver — same reasoning as D-27b; a file/array cache driver would silently fail to enforce shared rate limits across container restarts or any future horizontal scale-out.
*Priority:* Must-resolve before the `ThrottleRequests` middleware is configured — a silent security gap otherwise.

**D-29 — Typing indicator under polling fallback**
*Problem:* Ephemeral WebSocket-only feature has no defined behavior when the app is in REST-polling fallback mode.
*Recommendation:* Explicitly disable/hide the typing indicator UI element when in polling-fallback mode, rather than attempt to simulate it — a missing feature is a smaller UX cost than a broken/stale one.
*Priority:* Low — a one-line conditional in the messaging UI, but should be a stated decision, not an accidental omission discovered during QA.

**D-30 — Orphaned attachment cleanup**
*Problem:* `ON DELETE CASCADE` removes the DB row but not necessarily the physical file on disk/bucket.
*Recommendation:* Add a model-event listener (Eloquent `deleting` event on `PieceJointe`) that deletes the physical file whenever its DB row is deleted, regardless of what triggered the cascade — otherwise storage cost and, more importantly, sensitive image content silently outlives its own database record.
*Priority:* Must-resolve before the attachment-deletion path (cascading from ticket/message deletion) is implemented — a real data-hygiene and security gap, not a cosmetic one.

**D-30b — File availability during antivirus scan**
*Problem:* If ClamAV scanning (§22, recommended) is adopted, no decision exists on file accessibility during the scan window.
*Recommendation:* Gate the file behind a "pending scan" state — the signed-URL download endpoint already specified (§22) should return a 202/425-style "not yet available" response until the scan completes, rather than serving an unscanned file.
*Priority:* Should-resolve only if/when ClamAV is actually adopted — contingent, not currently blocking.

**D-30c — Message/attachment content retention policy**
*Problem:* No retention/purge policy exists for ticket/message content, despite it containing exactly the sensitive credentials the platform is designed to protect.
*Recommendation:* Confirm with MSIS whether closed-ticket conversations should be purged after some period (e.g., matching or exceeding the 12-month audit-log retention) or retained indefinitely for historical/dispute purposes — this is a genuine policy question, not a technical one, but it must be answered before storage/backup sizing and D-10's compliance review can be finalized.
*Priority:* Should-resolve alongside D-10.

---

## 12. Recommended Improvements

All labeled **Engineering Recommendation** — none alter any official requirement from either source.

- **[Engineering Recommendation]** Add a lightweight `intervention_status_history` table (D-20b) — the single highest-value addition found in this review, since it's the only way the already-promised §23.1 KPIs become computable at all.
- **[Engineering Recommendation]** Consolidate Redis as the single backing store for cache, queue, and rate-limiting (D-27b/D-28) — reduces operational surface area versus running separate mechanisms for each.
- **[Engineering Recommendation]** Add a `message` delivery-status pair (`livre`/`livre_at`) to close the gap between the use-case narrative (UC-06) and the current schema.
- **[Engineering Recommendation]** Add a `CHECK` constraint on `pieces_jointes` to enforce its exactly-one-parent invariant at the database layer, not just in application code.
- **[Engineering Recommendation]** Add an explicit `ANNULEE` (cancelled) terminal ticket state reachable only from `EN_ATTENTE`, closing the client-cancellation gap (D-17) with a minimal schema change if the Product Owner agrees it's in scope.
- **[Engineering Recommendation]** Compute (not schema-add) a per-technician "current open-ticket count" as a lightweight availability proxy for the assignment UI (D-19), deferring a true availability-toggle feature to V2.
- **[Engineering Recommendation]** Explicitly name `/api/v1/health` in the formal route table so it's version-controlled documentation, not an ad hoc endpoint that drifts from the rest of the spec.
- **[Engineering Recommendation]** Formalize the exact CSP/security-header policy (A05) and a concrete dependency-audit cadence (A06) in the SRS, rather than leave both as "should have some."
- **[Engineering Recommendation]** State explicitly, in the SRS's security section, that replay-attack protection is intentionally not implemented beyond TLS + revocable bearer tokens — turns a silent omission into a documented, deliberate risk acceptance.
- **[Engineering Recommendation]** Add a monthly scheduled job to archive (not delete) `audit_logs` rows past the 12-month retention mark, keeping the live table's query performance stable over the product's lifetime.

---

## 13. Implementation Readiness Assessment

Re-scored after this deeper gap analysis — expect this to be somewhat lower than the Discovery Document's §17 scores, since this pass was specifically designed to surface what that pass could only flag at a higher level.

| Dimension | Score /10 | Why |
|---|---|---|
| Business Analysis | 9 | Context, objectives, KPIs, stakeholders, personas remain fully coherent; this review found workflow-level gaps (cancellation, escalation, availability) but no contradiction in the underlying business case itself. |
| Requirements | 7 | FR/NFR coverage is strong, but this review surfaced concrete, previously-invisible gaps (status history breaking the KPI promise, delivery-status modeling, cancellation) that a straight FR-by-FR read would not catch. |
| Architecture | 7 | Recommended architectures for both Flutter and Laravel are internally consistent, but the deployment topology under-counts real dependencies (Redis, queue worker) that the architecture itself implies — an architecture isn't fully "ready" until its own topology reflects its own stack choices. |
| Security | 7 | Strong OWASP coverage overall, but this review found one genuine technical contradiction (Sanctum vs. the stated `/auth/refresh` semantics, D-22) that must be resolved before Auth work starts, plus real, unaddressed gaps in retention/erasure (D-20, D-30c) for a platform whose entire mission is protecting sensitive data. |
| Database | 6 | Core model is sound and 3NF-correct, but the missing status-history table is not a minor gap — it silently breaks a stated deliverable (§23.1 KPIs), and the missing XOR constraint and soft-delete strategy are real integrity gaps, not stylistic preferences. |
| UI | 7 | Screen-level specs are detailed and mockup-backed; account/profile/settings remain the clearest void, and several mobile-specific concerns (deep links, state restoration, orientation) were never addressed in either source. |
| Backend | 7 | Service/Repository/Policy structure is clean and well-named; pagination and queue-driver decisions are the main blockers to calling the backend contract "final." |
| Deployment | 6 | Backup/TLS/migration steps are concrete, but the container topology needs a real update (Redis, queue worker) before `docker-compose.yml` can be written correctly, and backup off-site location is still an open question. |
| Testing | 5 | Unchanged from the Discovery Document's assessment — a strong strategy exists on paper with no existing test assets to validate it against; unaffected by this deeper pass since testing gaps were already the known weak point. |
| **Overall Readiness** | **~68%** | Down from the Discovery Document's ~76% because this pass specifically hunts for exactly the kind of gap that inflates an first-look score — most of what changed is **the database/security dimensions dropping** once status-history, retention, and the Sanctum contradiction were traced to their concrete implications. None of the findings here require re-scoping the project; all are resolvable via the Decision Register (§11) without touching a single official requirement. The project is not under-specified in its *business* logic — it is under-specified in the *operational and data-integrity* details that don't show up until an architect asks "how would I actually build this," which is precisely this document's purpose. |

**Bottom line for SRS go/no-go:** Do not proceed to SRS drafting until the **Must-priority** items in the Decision Register are resolved: D-01 (client registration), D-17 (cancellation, ENUM-affecting), D-20/D-20b/D-20c (soft-delete, status-history, attachment constraint — all schema-affecting), D-21 (pagination), D-22 (Sanctum/refresh contradiction), D-27/D-28 (Redis-dependent topology). Every one of these touches either a database migration or an API contract detail that is expensive to change once the SRS is written and implementation begins — all other findings in this report can be resolved in parallel with, or even during, SRS drafting.
