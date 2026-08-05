# UI/UX SPECIFICATION

## MSIS Secure Intervention Tracking Platform — Enterprise Android Application

---

### Document Control

| Field | Value |
|---|---|
| Document type | UI/UX Design Specification (implementation-ready) |
| Version | 1.0 — Draft |
| Inputs used | Internship report + client functional spec (`cahier_de_charge.txt`), `PROJECT_DISCOVERY.md`, `GAP_ANALYSIS.md`, `SRS.md`, the Stitch-generated mockups in `stitch_plateforme_s_curis_e_msis/` (primary visual inspiration source, per instruction), and the design tokens in `stitch_plateforme_s_curis_e_msis/technical_precision_system/DESIGN.md` |
| Consumers | Stitch AI, Figma AI, Gemini, Claude Code, Cursor, and the Flutter development team |
| Constraint | This document never contradicts `SRS.md`. Every screen, interaction, and business rule referenced here traces back to an SRS section; this document adds *visual and interaction* fidelity, it does not add or remove *functional* scope. |

### Token Reconciliation Note

Three color specifications exist across this project's documents: the Stitch mockups' `DESIGN.md` (primary `#003178`/`#0D47A1` as `primary-container`), the SRS §14.1 restatement of the report (`primary #0D47A1`, `primaryContainer #DCE7F9`), and the palette supplied directly for this document (`primary #0D47A1`, `primaryContainer #1565C0`, `secondary #42A5F5`). Per this project's own established reconciliation discipline (`cahier_de_charge.txt` §0 — the most recent, most explicit, purpose-specific instruction prevails where sources differ in fine detail, provided it doesn't contradict a business rule), **this document adopts the palette supplied for this UI/UX specification as canonical** for all new visual design work, since it is the most recent, most complete, and explicitly purpose-built token set for this deliverable. `DESIGN.md`'s structural guidance (Material 3 tonal-surface logic, JetBrains Mono for technical identifiers, the 4px spacing baseline, 12px standard corner radius) is retained unchanged, as it does not conflict with the new palette — only specific hex values are superseded. This reconciliation is itself an **[Engineering Recommendation]**; it does not alter any functional requirement.

---

## PART A — DESIGN PHILOSOPHY

### A.1 Positioning

This is an **enterprise Android application**, not a consumer social product. Every design decision is evaluated against six qualities: **professionalism, trust, security, reliability, efficiency, speed.** A design choice that reads as playful, decorative, or attention-seeking is wrong for this product by default, even if visually appealing in isolation — MSIS's business (§4 of the SRS) is precisely about replacing an informal, low-trust process with something that *feels* institutional-grade the moment a client opens the app.

### A.2 Reference Language

The visual and interaction language draws from **Material Design 3** as its structural foundation (as mandated implicitly by the Stitch mockups' own Material 3 token structure), inflected toward the density, information-forward layout, and restrained motion of **Linear, Atlassian/Jira Mobile, Slack, Google Workspace, Microsoft Intune, and GitHub Mobile** — enterprise tools whose users are professionals completing a task under time pressure, not browsing for entertainment. Concretely, this means: **high information density over whitespace-for-its-own-sake**, status conveyed through consistent, learnable color+icon+text triads (never color alone), typography that prioritizes legibility of dense technical data (ticket IDs, timestamps) over decorative display type, and motion that confirms an action completed rather than motion that delights.

### A.3 What This Product Is Not

Not a marketing site. Not a lifestyle app. Not a game. No confetti, no bouncy overshoot animations, no illustrated mascots, no gradient-heavy hero sections. Every one of the six reference products listed in A.2 shares this same restraint — that is the deliberate target, not an accident of enterprise software being "boring."

---

## PART B — DESIGN SYSTEM

### B.1 Color Tokens (canonical, per Token Reconciliation Note above)

| Token | Value | Usage |
|---|---|---|
| `primary` | `#0D47A1` | Primary actions, active states, AppBars, brand presence |
| `primaryContainer` | `#1565C0` | Secondary emphasis surfaces — selected chip fills, active nav indicator background |
| `secondary` | `#42A5F5` | Supporting accents, links, secondary icon tinting — never for primary CTAs |
| `success` | `#2E7D32` | Status `RESOLUE`/`CLOTUREE`, "Actif" account badge, priority `BASSE` |
| `warning` | `#F9A825` | Status `EN_ATTENTE`, priority `NORMALE` |
| `danger` | `#C62828` | Status `BLOQUE`, priority `HAUTE`, destructive actions, form errors |
| `surface` | `#FFFFFF` | Card and sheet backgrounds |
| `background` | `#F5F7FA` | Screen background beneath surfaces |
| `onSurface` | `#1A1A1A` | Primary text on light surfaces |
| `onSurfaceVariant` | `#595959` | Secondary text, metadata, timestamps |
| `outline` | `#BDBDBD` | Input borders, dividers, card strokes |

**Status color mapping (governs every status badge/chip in the app — see B.7):**

| Status | Color token | Rationale |
|---|---|---|
| `EN_ATTENTE` | `warning` (`#F9A825`) | Awaiting action — amber signals "needs attention soon," not yet urgent |
| `EN_COURS` | `primary` (`#0D47A1`) | Active work — the brand color, reinforcing this is the system's normal working state |
| `BLOQUE` | `danger`-adjacent, distinct dark orange `#E65100` (from `DESIGN.md`, retained — the canonical `danger` red is reserved for true errors, not operational blockages) | Visually distinct from both `danger` and `warning` so a blocked ticket is never mistaken for an error state or a merely-pending one |
| `RESOLUE` | `success` (`#2E7D32`) | Positive outcome, not yet final |
| `CLOTUREE` | Neutral gray `#616161` | Deliberately desaturated — signals "inactive/archived," distinct from the "positive and current" feeling of `success` |
| `ANNULEE` (pending SRS D-17) | Neutral gray, outline-styled (not filled) | Visually the most "absent" status — a cancelled ticket should read as withdrawn, not as any kind of outcome |

**Priority color mapping:**

| Priority | Color token |
|---|---|
| `HAUTE` | `danger` (`#C62828`) |
| `NORMALE` | `warning` (`#F9A825`) |
| `BASSE` | `success` (`#2E7D32`) |

### B.2 Dark Mode Palette **[Engineering Recommendation — closes the gap flagged in `GAP_ANALYSIS.md` §14, since only one dark token existed anywhere in prior documentation]**

| Token | Light | Dark |
|---|---|---|
| `background` | `#F5F7FA` | `#121212` |
| `surface` | `#FFFFFF` | `#1E1E1E` |
| `surfaceVariant` (cards on cards) | `#F5F7FA` | `#2A2A2A` |
| `onSurface` | `#1A1A1A` | `#EAEAEA` |
| `onSurfaceVariant` | `#595959` | `#A3A3A3` |
| `primary` | `#0D47A1` | `#8AB4F8` (lightened for AA contrast against dark surfaces) |
| `outline` | `#BDBDBD` | `#3D3D3D` |
| Status/priority colors | as B.1 | same hues, lightness increased ~10–15% to maintain ≥4.5:1 contrast against `#1E1E1E` |

Dark mode is a Should-priority, manually toggleable preference (SRS FR-PROF-06), defaulting to system preference. It is a full palette swap via Flutter's `ColorScheme`, never a partial/inconsistent override.

### B.3 Typography

| Style token | Font | Size / Weight | Usage |
|---|---|---|---|
| `displaySmall` | Google Sans (fallback: Inter) | 36sp / Bold | Rare — onboarding-style hero text only, if used |
| `headlineSmall` | Google Sans / Inter | 24sp / SemiBold | Screen titles (large AppBar) |
| `titleLarge` | Inter | 20sp / SemiBold | Section titles, ticket titles |
| `titleMedium` | Inter | 16sp / Medium | Card titles |
| `bodyLarge` | Inter | 16sp / Regular | Primary body text, descriptions |
| `bodyMedium` | Inter | 14sp / Regular | Secondary text, metadata |
| `labelMedium` | Inter | 12sp / Medium | Badges, field labels |
| `technicalMono` | JetBrains Mono | 14sp (list) / 12sp (dense list) / Medium | Ticket IDs, timestamps, serial numbers — retained from `DESIGN.md`; gives technical identifiers a distinct, scannable rhythm from prose text, consistent with the "technical precision" brand personality |

Rule: **any string that is an identifier, a code, or a timestamp renders in `technicalMono`, never in `Inter`.** This is the single most distinctive typographic signal separating this app's enterprise-technical register from a generic consumer app.

### B.4 Spacing & Grid

4px baseline, retained from `DESIGN.md`: `xs=4, sm=8, md=16, lg=24, xl=32, 2xl=48`. Screen margins: 16px mobile, 32px desktop/tablet-wide. Grid: 4-column mobile (<600dp), 8-column tablet (600–1239dp), 12-column desktop (≥1240dp, relevant only if a companion web portal is built in V3).

### B.5 Elevation & Shape

- Elevation via **tonal layering**, not heavy shadow, per Material 3 and `DESIGN.md`: Level 0 (screen background), Level 1 (cards/list items — 1px stroke or minimal shadow), Level 2 (AppBars, nav rails).
- Corner radius: 4px (checkboxes, small tags), 12px (buttons, input fields, cards — the standard), 16px (bottom sheets, dialogs — slightly larger than the `DESIGN.md` baseline of 20px, reconciled downward to the 12–16dp range specified for this document; retained consistently across all modal-style surfaces).
- Full-pill radius reserved exclusively for FABs (B.8).
- High-priority alert cards receive a more pronounced shadow (4px blur, 10% opacity) to visually "break" from the grid, per `DESIGN.md` — the only sanctioned exception to the tonal-layering-over-shadow rule.

### B.6 Iconography

Material Symbols (Rounded), 24dp standard, 20dp in dense lists (message previews, notification rows). Every icon that conveys state (status, priority) is paired with text — icons alone never carry meaning, per NFR-A11Y-03 (colorblindness/screen-reader accessibility).

### B.7 Status Chips & Badges

- Shape: pill.
- Fill: 15% opacity of the status/priority color (B.1).
- Text/icon: full-saturation status/priority color.
- Content: icon + label text always together (e.g., a clock icon + "En attente"), never icon-only or color-only.
- Account status badges (Actif/Inactif, SCR-10) follow the same pattern using `success`/neutral-gray respectively.

### B.8 Buttons

| Variant | Style | Usage |
|---|---|---|
| Primary (Filled) | Solid `primary`, white text, 12px radius, 48dp height | Main CTA per screen (Login, Submit ticket, Confirm) |
| Secondary (Tonal) | `primaryContainer` background, `primary` text | Secondary but still affirmative actions |
| Outlined | 1px `outline` stroke, `primary` text, transparent fill | Tertiary actions ("Save Draft," "Cancel" inside a confirmation sheet) |
| Text | No fill, no stroke, `primary` text | Lowest-emphasis actions (dialog dismiss, "Skip") |
| Destructive | Solid `danger` (or outlined `danger` for lower-emphasis destructive actions) | Deactivate account, cancel ticket, log out of all devices |
| Disabled | 38% opacity of the variant's normal state | Any button gated by unmet validation |
| FAB | Full-pill, solid `primary`, white icon, elevation Level 2 | New intervention (SCR-05), new technician account (SCR-10) — creation actions exclusively, never destructive or navigational |

### B.9 Input Fields

Material 3 "Outlined" style exclusively. 56dp height, 12px radius, floating label using `labelMedium`. Active border color: `primary`. Error state: `danger` border + inline `bodyMedium` error text beneath the field, `danger`-colored. Helper text (character counters) in `onSurfaceVariant`. Every field carries a `semanticsLabel` matching its visible label (NFR-A11Y-03).

### B.10 Search & Filters

Search bars: outlined pill shape (24px radius, an exception to the 12px standard, matching Material 3's search-bar convention), leading search icon, trailing clear icon appearing only once text is entered. Filter chips: pill shape, `outlined` when unselected, `primaryContainer`-filled when selected, arranged in a horizontally scrollable row beneath the search bar (SCR-09).

### B.11 Navigation

- **Bottom navigation bar** (Technician role only, per FR-TECH-03): 4 destinations (Missions, Carte, Messages, Profil), Material 3 `NavigationBar` component, active-destination indicator using `primaryContainer` pill behind the icon.
- **Tab bar** (Supervisor dashboard, FR-DASH-02; User Management, FR-USR-01): Material 3 `TabBar`, underline indicator in `primary`.
- **No navigation drawer** is used anywhere in this application — the three roles' navigation surfaces (bottom nav for Technician, tab bar for Supervisor, simple stack navigation for Client) are each shallow enough that a drawer would add a layer of indirection this product's information architecture does not need. This is a deliberate omission, not an oversight.
- **AppBar**: present on every authenticated screen, carries the screen title (`titleLarge`), a back/menu affordance as appropriate, and the notifications-bell icon with unread-count badge (SCR-14 entry point) on the right.

### B.12 Cards

Used for ticket list items (SCR-05, 07, 09), technician/client rows (SCR-10), notification rows (SCR-14). 12px radius, 1px `outline` stroke, 16px internal padding, white/`surface` fill. Ticket cards carry a **4px vertical priority-color bar on the leading edge** (retained from `DESIGN.md` — a strong, learnable visual signal that requires no additional icon or text to convey urgency at a glance, though the priority label itself is still present in text per B.6's icon-plus-text rule).

### B.13 Lists

High-density layout: 8dp vertical padding between items (not the 16dp card-padding value — list density is deliberately tighter than card padding, per `DESIGN.md`). Ticket IDs and timestamps in `technicalMono`; descriptions/names in `Inter`.

### B.14 Tables

Used only within SCR-11 (Reports)'s data-table view of the export preview, if included. Zebra-striped rows (`background` alternating with `surface`) for scanability at high row counts; `technicalMono` for any ID/date columns.

### B.15 Dialogs, Bottom Sheets, Snackbars

Behavioral rules are defined in SRS §16.1/§16.2; visual treatment: dialogs and bottom sheets at 16px corner radius (top corners only, for sheets), `surface` fill, Level 3 elevation equivalent (8dp-style separation from content behind a scrim). Snackbars: `inverseSurface`-toned background (dark chip against a light theme, and vice versa in dark mode), `bodyMedium` text, single optional text-button action, 12px radius.

### B.16 Charts

Weekly trend (line/area), per-technician load (bar), status distribution (donut) — SRS §19.3. Chart colors draw directly from the status/priority token set (B.1) so a chart segment for `EN_COURS` always renders in the same blue used everywhere else in the app for that status — no separate "chart palette" is introduced. Every chart ships with a textual/tabular equivalent (SRS RPT-13).

### B.17 Progress, Loading, and Skeleton States

- Circular indeterminate spinner: inline within buttons during submission (14–16dp), never full-screen.
- Skeleton/shimmer loaders: used for all list-screen initial loads, matching the shape of the eventual card/list-item content (SRS §16.5). Shimmer animation: a single soft light-band sweep, 1.2s loop, `outline`-toned base.
- Linear progress indicator: reserved for determinate, multi-step operations only (e.g., a multi-file attachment upload's aggregate progress).

### B.18 Empty States

Centered icon (Material Symbols, 64dp, `onSurfaceVariant`-toned) + `titleMedium` primary text + `bodyMedium` contextual subtext. No decorative illustration library is introduced — icon-based empty states keep the enterprise register consistent with B.1–B.3's typographic and iconographic system, rather than importing a mismatched illustration style.

### B.19 Avatar System

Initials-based avatars (first letter of first + last name, per `DESIGN.md`'s user-row pattern), circular, background color deterministically derived from a hash of the user's name (a small, fixed palette of 6 muted tones drawn from desaturated variants of `primary`/`secondary`/`success` — never a status/priority color, to avoid visual confusion with badges). No photo-upload avatar feature exists in MVP scope (not specified in the SRS).

### B.20 Image Handling

Attachment thumbnails: 12px-radius rounded square crop, tap-to-expand into a full-screen gallery viewer with pinch-zoom. Upload-in-progress thumbnails show a semi-transparent overlay with the B.17 circular progress indicator. Broken/failed image loads show a generic "broken image" icon placeholder, never a blank space.

---

## PART C — COMPONENT LIBRARY

Each reusable component: purpose, variants, key properties, and states.

### C.1 `StatusBadge`

- **Purpose:** render a ticket's or account's status as the pill described in B.7.
- **Variants:** `intervention` (5–6 status values, B.1) and `account` (Actif/Inactif).
- **Properties:** `status` (enum), `size` (`compact` for list rows / `standard` for detail headers).
- **States:** static display component, no interactive states beyond standard tap-passthrough if used inside a tappable card.

### C.2 `PriorityChip`

- **Purpose:** render a ticket's priority.
- **Variants:** Haute / Normale / Basse.
- **Properties:** `priority` (enum), `selected` (bool, for use as a filter/form-input chip, distinct from its read-only display use).
- **States:** default, selected (form context), disabled (form context, e.g. while submitting).

### C.3 `KpiCard`

- **Purpose:** the dashboard's summary widgets (SCR-05 has none directly but SCR-07/09/11 all use this).
- **Variants:** icon+number+label (standard); number-only compact variant for narrow layouts.
- **Properties:** `value` (int), `label` (string), `icon`, `onTap` (optional — some KPI cards act as an implicit filter shortcut).
- **States:** loading (skeleton per B.17), populated, tapped (brief scale/opacity feedback, no navigation delay).

### C.4 `InterventionCard`

- **Purpose:** the primary list-item across SCR-05/07/09.
- **Variants:** `client` (shows technician name if assigned), `technician` (shows client name), `supervisor` (shows both + priority bar prominently).
- **Properties:** `title`, `status`, `priority`, `createdAt` (`technicalMono`), `ticketId` (`technicalMono`), `previewSnippet` (optional, description excerpt).
- **States:** default, pressed (ripple), offline-pending (a small sync-pending icon overlay when representing a locally queued, not-yet-synced item).

### C.5 `UserRow`

- **Purpose:** SCR-10's account list item.
- **Variants:** `technician` (includes a workload-count badge, per `GAP_ANALYSIS.md` D-19's computed-load recommendation), `client`.
- **Properties:** `avatar` (C.19-style initials), `name`, `email`, `active` (bool, drives the `account`-variant `StatusBadge`).
- **States:** default, toggling (Switch mid-transition, disabled during the confirmation-sheet flow), disabled-row (visually de-emphasized once `active=false`).

### C.6 `MessageBubble`

- **Purpose:** SCR-08's conversation thread items.
- **Variants:** `outgoing` (right-aligned, `primaryContainer` fill), `incoming` (left-aligned, `surface` fill with `outline` stroke), `attachment` (image thumbnail variant of either).
- **Properties:** `content`, `timestamp` (`technicalMono`, small), `deliveryState` (sent/delivered/read icon per SRS FR-DET-09), `senderAvatar` (incoming only).
- **States:** sending (reduced opacity + inline spinner), sent, failed (retry affordance inline).

### C.7 `ConfirmationSheet`

- **Purpose:** the mandatory destructive-action confirmation pattern (SRS §16.1).
- **Variants:** standard (title + body text + two buttons); impact-detail (adds a supplementary info block, e.g. FR-USR-04's "this technician has N active tickets" warning).
- **Properties:** `title`, `body`, `confirmLabel`, `confirmVariant` (always `Destructive` per B.8 when the underlying action is destructive), `onConfirm`, `onCancel`.
- **States:** default, submitting (confirm button shows inline spinner, sheet becomes non-dismissible mid-submission).

### C.8 `EmptyState`

- **Purpose:** the B.18 pattern, componentized for reuse across every list screen.
- **Properties:** `icon`, `title`, `subtitle` (varies per active filter, per FR-DASH-04).

### C.9 `FilterBar`

- **Purpose:** the horizontally scrollable chip row (B.10) used on SCR-09.
- **Properties:** `filters` (list of chip definitions), `activeFilter(s)` (single-select for status per FR-DASH-03, multi-select if priority filtering is layered in per FR-DASH-07).

### C.10 `OfflineBanner`

- **Purpose:** the persistent non-blocking indicator described in SRS §16.5.
- **Properties:** `visible` (bool, driven by connectivity state).
- **States:** shown/hidden only — no interactive states.

---

## PART D — MOTION SYSTEM

All durations and easing follow **Material Design 3 motion tokens**; no custom easing curve is introduced. No animation exceeds 300ms for a state transition, and no animation blocks user input while playing (per SRS §16.6).

| Interaction | Motion treatment |
|---|---|
| Screen-to-screen navigation | Platform-standard Material shared-axis push/pop; no custom page-route transition |
| Ticket detail entry from a list card | Container-transform-style shared element on the priority bar + title, connecting the list card visually to the detail header, reinforcing spatial continuity |
| FAB → creation screen | FAB morphs into the new screen's AppBar (Material 3 "FAB to fullscreen" transform), reinforcing that the screen *is* the action just triggered |
| Status badge change | 200ms cross-fade between the old and new status color/label — never an instant snap, so a just-occurred change is perceptible without a separate toast being strictly necessary |
| Dialog / bottom sheet appearance | Slide-up + fade-in for sheets (200ms); scale-up + fade-in for dialogs (150ms) |
| Snackbar | Slide-up from bottom edge, 150ms in / 150ms out |
| List item entry (initial load, post-skeleton) | Staggered fade-in, 40ms offset per item, capped at the first 8 visible items to avoid a sluggish feel on long lists |
| Typing indicator | Three-dot pulse, 900ms loop, low-amplitude — present only per SRS FR-DET-10's constraints (never shown under polling fallback, D-29) |
| Pull-to-refresh | Platform-standard Material circular refresh indicator |
| Message send | Optimistic bubble appears instantly at 80% opacity, resolves to 100% opacity + delivery icon once server-confirmed |

### D.1 Haptic Feedback **[Engineering Recommendation]**

Light haptic tick on: destructive-action confirmation, successful status transition, successful message send. No haptic feedback on passive navigation (list scroll, tab switch) — haptics are reserved for moments confirming an action *took effect*, not for general interaction, consistent with this product's restrained motion philosophy (Part A).

### D.2 Performance Considerations

- Shimmer/skeleton and staggered-list animations are disabled automatically when the OS "reduce motion" accessibility setting is active, substituting an instant-appear equivalent.
- Shared-element transitions (FAB morph, card-to-detail transform) are the only animations permitted to be GPU-shader-backed; all others use standard widget-tree animation to keep the app's cold-start and mid-session memory footprint aligned with SRS NFR-PERF-02.

---

## PART E — ACCESSIBILITY

Consolidates and extends SRS §10.5/§16.5's accessibility requirements with concrete design-system application.

- **Screen readers (TalkBack):** every interactive element carries a semantic label; status/priority information is announced as text, never inferred from color alone (B.1, B.7); `MessageBubble` announces sender + content + timestamp as a single unit; charts (B.16) expose their tabular equivalent to the accessibility tree.
- **Contrast:** every token pairing in B.1/B.2 is validated at ≥4.5:1 (WCAG 2.1 AA) for text-on-surface combinations; status-chip text-on-15%-fill combinations are specifically re-validated, since low-opacity fills are the one place in this system where contrast can silently degrade if not checked per pairing.
- **Large fonts:** all typography (B.3) uses `sp` units and respects the OS-level font-scale setting up to at least 130% without truncating or overlapping content — list-row layouts use flexible, not fixed, heights.
- **Touch targets:** minimum 44×44dp per NFR-A11Y-02, raised to 48×48dp on all primary form controls and checkboxes/radios (per `DESIGN.md`'s field-use rationale — technicians may be operating the app while wearing gloves).
- **Color blindness:** the status/priority system's icon+text+color triad (B.6/B.7) ensures no information is conveyed by hue alone; the `EN_COURS`/`BLOQUE` color pair (primary blue vs. dark orange, B.1) was specifically chosen to remain distinguishable under deuteranopia/protanopia simulation, unlike a blue/orange-adjacent pairing closer in luminance.
- **Keyboard/switch navigation:** all interactive elements (including the SCR-02 role selector and B.10 filter chips) are reachable and operable via an external keyboard or switch-access device, with a visible focus indicator (2px `primary`-colored outline) distinct from the pressed/hover state.

## PART F — PER-SCREEN SPECIFICATIONS

Each entry maps to its SRS screen ID (`SCR-##`, `SRS.md` §15) and adds visual/interaction fidelity on top of that behavioral spec. Screens requested in the original brief that have **no corresponding requirement in the SRS or `cahier_de_charge.txt`** are explicitly marked out of scope rather than invented, consistent with this project's standing rule against fabricating unrequested features.

### F.1 Splash (SCR-01)
**Layout:** centered MSIS logotype on `background`, no chrome, no navigation. **Components:** none interactive. **Motion:** logo fades in over 200ms; screen holds for the minimum time needed for the session check (§14.1 of the SRS), capped at 1.5s even if the check resolves faster, to avoid a jarring flash. **States:** N/A (transitional only). **Dark mode:** logo mark swaps to its light-on-dark variant; background follows B.2. **Accessibility:** marked as a non-essential/skippable node in the semantics tree (TalkBack should not linger here).

### F.2 Onboarding **[Not in scope — no corresponding SRS requirement]**
Neither the internship report nor the client functional specification (`cahier_de_charge.txt`) nor `SRS.md` defines an onboarding/first-run tutorial flow; the app's entry path is Splash → Login (F.1 → F.3) directly. Per this project's discipline against inventing unrequested screens, no onboarding flow is specified here. If MSIS later requests one, it should enter as a Should/Could-priority SRS functional requirement first (via the Decision Register process already established in `GAP_ANALYSIS.md`), not be designed ahead of that decision.

### F.3 Authentication / Login (SCR-02)
**Primary actor:** all roles, pre-authentication. **Business goal:** establish a trusted, role-scoped session (BR-002). **Layout hierarchy:** logo mark (top, compact) → trust banner (B.15-style low-emphasis inline banner, lock icon + `bodyMedium` text, `success`-tinted background at 10% opacity) → role `SegmentedButton` (three segments: person / wrench / chart icons for Client/Technicien/Superviseur) → email `TextField` (B.9, envelope leading icon) → password `TextField` (B.9, lock leading icon, eye trailing icon) → "Mot de passe oublié ?" `TextButton` (right-aligned) → primary `FilledButton` "Se connecter" (B.8, full width). **Color usage:** primary button in `primary`; trust banner in `success` at reduced opacity, never `primary` (reserves brand color for the actionable button so it isn't diluted by a passive element). **Validation:** per SRS BRULE-006, submit disabled until role + both fields are non-empty; format validation on blur, not on every keystroke (avoids a jittery error-flicker experience). **Error handling:** inline `bodyMedium` `danger`-colored text beneath the password field for credential errors (per BRULE-015, never field-specific); a `banner`-style (not Snackbar) treatment for account-disabled and rate-limit errors, since these require the user to stop and read, not glance-and-dismiss. **Loading:** submit button internal spinner (B.17), all fields become read-only (not merely disabled-looking — genuinely non-interactive) during the request. **Success:** no visible transition state — the redirect to the role dashboard is immediate on the 200 response. **Dark mode:** trust banner's `success` tint uses the B.2 dark-adjusted `success` token. **Tablet:** form remains centered at a fixed max-width (400dp) rather than stretching edge-to-edge, avoiding an overlong input-field row on wide screens. **Accessibility:** role segmented control exposes each segment's label to TalkBack individually ("Client, non sélectionné," etc.); the whole form is reachable in a single top-to-bottom focus order with no traps.

### F.4 Forgot Password (SCR-03) / Reset Password (SCR-04)
**Layout (SCR-03):** back button → title ("Mot de passe oublié") → explanatory `bodyMedium` text → email field → primary button "Envoyer le lien." **Layout (SCR-04, deep-link entry only):** title → new-password field with a live strength indicator (a 4-segment bar beneath the field, filling left-to-right in `danger`→`warning`→`success` as complexity increases, plus the corresponding text label, never color-only per B.6) → confirm-password field → primary button "Réinitialiser." **Validation/errors:** per SRS §15 SCR-03/SCR-04 exactly; the strength indicator updates on every keystroke (this is the one field in the app where live-as-you-type feedback is appropriate, since it's guiding construction of a new value rather than validating an existing one). **Success:** SCR-03 transitions its own content in-place to a confirmation state (icon + text), not a new route, so the "same response regardless of account existence" rule (BRULE-015) has no visible route-level tell. SCR-04 shows a brief success dialog then routes to SCR-02. **Motion:** the strength bar's fill animates (150ms ease-out) on each change rather than snapping.

### F.5 Client Home / My Interventions (SCR-05)
**Primary actor:** Client. **Layout:** AppBar ("Mes interventions" + notification bell) → optional lightweight status filter row (Active/Closed/Cancelled groupings, not the full Supervisor filter set) → `InterventionCard` (C.4, `client` variant) list, 8dp list spacing (B.13) → FAB (B.8) bottom-right, "+" icon, opens SCR-06. **Empty state (B.18):** icon = outlined document, title "Aucune intervention," subtitle "Créez votre première demande d'intervention." **Loading:** shimmer list matching `InterventionCard`'s shape (B.17). **Offline:** `OfflineBanner` (C.10) appears beneath the AppBar when serving cached data. **Pull-to-refresh:** standard Material indicator. **Tablet/landscape:** at ≥600dp, this screen does not adopt a master-detail split (unlike SCR-09) since a Client's own ticket volume is typically low enough that a split view adds complexity without proportionate value — single-column list retained even on tablet, capped at a centered 600dp-wide column. **Accessibility:** each `InterventionCard` announces title, status, and priority as one focus stop.

### F.6 Create Intervention (SCR-06)
**Primary actor:** Client (Supervisor secondary, per FR-CRT-09). **Layout:** AppBar ("Nouvelle intervention," back arrow) → Title `TextField` with character counter (150 max) → Description `TextField` multiline, 5 visible lines, extensible, character counter (3000 max) → `PriorityChip` (C.2) row, single-select, Haute/Normale/Basse → attachment zone: two icon buttons (camera, gallery) above a horizontally scrollable row of thumbnail previews (B.20), each with a small "×" removal control → (Supervisor path only) a client-selector `DropdownMenu` inserted above the title field → full-width primary button "Créer le ticket," disabled until valid. **Validation:** live character counters color-shift to `danger` only once the field is both non-empty and out of bounds (never `danger` on an empty untouched field — avoids alarming a user who hasn't started typing yet). **Success:** modal dialog (B.15), "Ticket créé — N° `<technicalMono ID>`," primary action "Voir le ticket." **Offline:** orange `banner` (distinct from the `OfflineBanner`'s neutral tone, since this one confirms an action was accepted for later sync, not merely that data may be stale) reading "Vous êtes hors-ligne — le ticket sera envoyé automatiquement," submit remains enabled. **State restoration:** form values persist across an OS-triggered process kill (SRS §16.4). **Accessibility:** attachment removal buttons are labeled "Supprimer la pièce jointe [n]," never a bare icon.

### F.7 Technician Missions / Home (SCR-07)
**Primary actor:** Technician. **Layout:** AppBar ("Mes missions") → 3-widget `KpiCard` (C.3) row (Assignées/En cours/Clôturées) → status `FilterBar` (C.9) → `InterventionCard` (`technician` variant) list → bottom `NavigationBar` (B.11: Missions/Carte/Messages/Profil). **Empty state:** icon = clipboard, "Aucune mission assignée." **Tablet/landscape:** at ≥600dp, adopts a master-detail two-column layout (list left, SCR-08 detail right) per SRS §13.7 — the only Client/Technician-facing screen to do so, since a technician's field workflow benefits materially from seeing detail without losing list context, unlike the Client's comparatively low ticket volume (F.5). **Accessibility:** bottom nav destinations each carry a full-word label beneath the icon at all times (not icon-only, even when space is tight) — an enterprise field tool should never require a user to guess an icon's meaning.

### F.7a Technician Map (SCR-08a)
**Layout:** full-bleed map view beneath the AppBar/nav chrome, markers colored per the status palette (B.1). A persistent, small "Vue liste" `TextButton` overlays the bottom of the map, toggling to a non-map list of the same markers for accessibility parity (Part E). **Empty state:** if no assigned interventions have location data, the map centers on a default MSIS-service-area view with a `bodyMedium` overlay message rather than an empty gray canvas.

### F.8 Intervention Detail & Messaging (SCR-08)
**Primary actor:** Client, Technician, Supervisor, Administrator (audit). **Layout hierarchy:** AppBar (back arrow, ticket `technicalMono` ID as subtitle) → header block (`StatusBadge` + `PriorityChip` + creation date) → collapsible "Détails" section (description, attachments gallery, client/technician names) → role/status-contextual action button (B.8, filled or destructive variant as appropriate — "Prendre en charge," "Signaler un blocage," "Marquer résolu," "Confirmer la clôture," "Réassigner") → "Messagerie" section: security banner (`bodyMedium`, lock icon, `primaryContainer`-tinted, text "Conversation chiffrée et strictement confidentielle" per SRS SEC-27 — **never** a "zero-knowledge" claim) → `MessageBubble` (C.6) thread → composer bar (text field + attachment icon + send icon), hidden/replaced with a "Conversation clôturée" static banner once the ticket is `CLOTUREE` (BRULE-017). **Assignment interaction (Supervisor only):** the "Assigner"/"Réassigner" action opens a bottom sheet (not a separate screen — see the brief's "Assignment screen" request, resolved here as a component per B.15/C.7 pattern) listing active technicians as a searchable, single-select list, each row showing name + current open-ticket count (the `GAP_ANALYSIS.md` D-19 computed-load proxy), with a `ConfirmationSheet`-style confirm step. **Block/Resolve actions:** open a dialog with a required multiline text field (`motif_blocage` / `rapport_technique`), submit disabled until non-empty. **Closure action:** opens a dialog with an optional 1–5 star/segmented rating control + optional comment field. **Typing indicator:** rendered directly above the composer, per D.1's motion spec, absent entirely under polling fallback (SRS D-29). **Empty conversation:** B.18 pattern, icon = chat bubble outline, "Aucune conversation," subtext "Les conversations démarrées depuis les interventions apparaîtront ici." **Unauthorized access:** this screen is never reached by an unauthorized user — the API's 403/404 (SEC-19) is caught by the calling list screen, which shows an error Snackbar and does not navigate. **Tablet:** on the Technician's master-detail layout (F.7), this renders as the detail pane without its own AppBar back arrow (the list remains visible alongside it).

### F.9 Notifications (SCR-14)
**Layout:** AppBar ("Notifications") → reverse-chronological list, unread items marked with a leading `primary`-colored dot + bolded `titleMedium` (vs. regular weight for read items) → tap navigates to the relevant ticket and marks read. **Empty state:** icon = bell-outline, "Aucune notification." **Grouping:** items are date-grouped ("Aujourd'hui," "Hier," "Plus ancien") using sticky section headers in `labelMedium`/`onSurfaceVariant`.

### F.10 Supervisor Dashboard — Interventions Tab (SCR-09)
**Primary actor:** Supervisor. **Layout:** AppBar ("Tableau de bord" + notification bell) → 4-widget `KpiCard` row → `TabBar` (Interventions/Utilisateurs/Rapports, B.11) → search bar (B.10) → `FilterBar` (status, extended with priority + date-range per FR-DASH-07) → `InterventionCard` (`supervisor` variant) list, paginated (SRCH-07/08). **Empty state:** filter-aware subtext per FR-DASH-04 (e.g., "Aucune intervention clôturée" vs. the generic "Aucune intervention," depending on the active filter). **Tablet/desktop-wide (≥1240dp, if a companion web view is ever built):** master-detail layout, list left / SCR-08 detail right, per SRS §13.7. **Accessibility:** the 4 KPI cards are individually tappable shortcuts to the matching filter state, and this is announced ("Total, 42 interventions, activer pour filtrer").

### F.11 Supervisor Dashboard — Utilisateurs Tab (SCR-10)
**Layout:** `TabBar` sub-selector (Techniciens/Clients) → search bar → `UserRow` (C.5) list → FAB "+" (Techniciens sub-tab only) opening an account-creation bottom sheet (name, email, role fixed to Technicien, submit dispatches the invitation). **Deactivation flow:** tapping a row's `Switch` to off triggers `ConfirmationSheet` (C.7) in its impact-detail variant, surfacing the FR-USR-04 warning text when the technician has `EN_COURS` tickets. **States:** the `Switch` shows a brief loading spinner in place of its thumb during the API round-trip, reverting to its prior position if the request fails.

### F.12 Supervisor Dashboard — Rapports Tab (SCR-11)
**Layout:** date-range picker (Material 3 `DateRangePicker`) → KPI summary grid (RPT-01–07) → weekly trend chart → per-technician bar chart → status donut chart (all per B.16) → export row: format selector (CSV/PDF segmented control) + "Exporter" button. **Loading:** charts show a skeleton block (B.17) matching their final aspect ratio, not a spinner, to avoid layout jump on load. **Export success:** Snackbar "Export prêt" with a "Télécharger" action, per SRS RPT-16/17's async-job model — the button does not block waiting for generation.

### F.13 Profile (SCR-12)
**Layout:** AppBar ("Profil") → large avatar (B.19, tappable only in the sense of visual identity — no photo upload in MVP) → name (editable inline or via an edit-mode toggle) → email (read-only, visually de-emphasized in `onSurfaceVariant`) → role badge → phone (editable) → "Changer le mot de passe" list-tile → "Paramètres" list-tile (→ SCR-13) → "Se déconnecter" `TextButton` (danger-tinted text, not filled — a logout is reversible, so it does not warrant a fully destructive button treatment, only the confirmation sheet) → "Déconnecter tous les appareils" (danger-outlined button, `ConfirmationSheet`).

### F.14 Settings (SCR-13)
**Layout:** AppBar ("Paramètres") → "Langue" list-tile with a trailing current-value + chevron, opening a selection sheet (Français/English) → "Thème" list-tile → segmented control (Système/Clair/Sombre) → "Notifications" section header → per-category mute `Switch` rows. Every control commits immediately (no separate Save button), per SRS §15 SCR-13.

### F.15 Help / About **[Not in scope — no corresponding SRS requirement]**
Neither official source specifies Help or About content. Not designed here to avoid inventing unrequested screens; flagged as a candidate for a future SRS addendum if MSIS wants one (a static content screen, low design risk to add later).

### F.16 Audit Logs (screen) **[Not in scope for MVP — no corresponding SRS screen]**
`audit_logs` (SRS §18.3) is a backend data table supporting §24 (Logging & Auditing) and the Administrator's in-conversation audit-read capability (SCR-08); the SRS defines no standalone "audit log browser" UI for any role in MVP. Designing one here would exceed this application's approved functional scope. If a future phase requires a Supervisor-facing audit browser, it should first enter the SRS via the Decision Register process (a new FR, likely V2/V3-tier) before being designed.

### F.17 System Configuration **[Not in scope — no corresponding SRS requirement]**
No system-level configuration screen (feature flags, global settings, etc.) is specified anywhere in `cahier_de_charge.txt`, `PROJECT_DISCOVERY.md`, `GAP_ANALYSIS.md`, or `SRS.md`. Not designed here for the same reason as F.15/F.16.

---

## PART G — SUMMARY OF DEVIATIONS FROM THE ORIGINAL BRIEF

For transparency, since this document's instruction was to spec "everything" from a list that included items outside the approved SRS:

1. **Onboarding, Help, About, a standalone Audit Log browser, and System Configuration** are not specified as screens (F.2, F.15, F.16, F.17), because none has a corresponding requirement in `SRS.md`. Designing them would mean inventing functional scope this project's own methodology explicitly prohibits (see `SRS.md`'s Document Control and provenance-tagging discipline, carried through every document in this chain).
2. **"Assignment screen"** is specified as a bottom-sheet component within SCR-08 (F.8), not a standalone screen, because that is how `SRS.md` §15 (SCR-08) and the underlying use case (UC-03) actually define the interaction — a modal picker invoked from the ticket detail, not a separate navigable screen.
3. **"Dashboard" (generic)** is resolved as three distinct, role-specific screens (F.5 Client, F.7 Technician, F.10 Supervisor) rather than one shared screen, because the SRS explicitly defines three separate screens with non-overlapping content (§7 Actors, §15).

This document is otherwise complete for every in-scope screen and every requested design-system/component/motion/accessibility topic.

---

**END OF DOCUMENT — UI/UX Specification, MSIS Secure Intervention Tracking Platform, Version 1.0 (Draft). Consistent with `SRS.md` v1.0 (Draft) and inherits the same [PENDING DECISION] gates — notably, F.8's cancellation action and F.11's account-status flows should not be pixel-finalized in Figma/Stitch until SRS Decision Register items D-17 and D-20 are resolved, since they affect this document's content directly.**