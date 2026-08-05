---
name: Technical Precision System
colors:
  surface: '#faf8ff'
  surface-dim: '#d9d9e1'
  surface-bright: '#faf8ff'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#f3f3fb'
  surface-container: '#ededf5'
  surface-container-high: '#e8e7f0'
  surface-container-highest: '#e2e2ea'
  on-surface: '#1a1b21'
  on-surface-variant: '#434652'
  inverse-surface: '#2e3036'
  inverse-on-surface: '#f0f0f8'
  outline: '#737783'
  outline-variant: '#c3c6d4'
  surface-tint: '#2b5bb5'
  primary: '#003178'
  on-primary: '#ffffff'
  primary-container: '#0d47a1'
  on-primary-container: '#a1bbff'
  inverse-primary: '#b0c6ff'
  secondary: '#5e5e5e'
  on-secondary: '#ffffff'
  secondary-container: '#e1dfdf'
  on-secondary-container: '#626262'
  tertiary: '#003f0b'
  on-tertiary: '#ffffff'
  tertiary-container: '#005914'
  on-tertiary-container: '#7ecf79'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#d9e2ff'
  primary-fixed-dim: '#b0c6ff'
  on-primary-fixed: '#001945'
  on-primary-fixed-variant: '#00429c'
  secondary-fixed: '#e4e2e2'
  secondary-fixed-dim: '#c7c6c6'
  on-secondary-fixed: '#1b1c1c'
  on-secondary-fixed-variant: '#464747'
  tertiary-fixed: '#a3f69c'
  tertiary-fixed-dim: '#88d982'
  on-tertiary-fixed: '#002204'
  on-tertiary-fixed-variant: '#005312'
  background: '#faf8ff'
  on-background: '#1a1b21'
  surface-variant: '#e2e2ea'
typography:
  display-lg:
    fontFamily: Hanken Grotesk
    fontSize: 57px
    fontWeight: '700'
    lineHeight: 64px
    letterSpacing: -0.25px
  headline-lg:
    fontFamily: Hanken Grotesk
    fontSize: 32px
    fontWeight: '600'
    lineHeight: 40px
  headline-md:
    fontFamily: Hanken Grotesk
    fontSize: 28px
    fontWeight: '600'
    lineHeight: 36px
  headline-sm:
    fontFamily: Hanken Grotesk
    fontSize: 24px
    fontWeight: '600'
    lineHeight: 32px
  title-lg:
    fontFamily: Inter
    fontSize: 22px
    fontWeight: '500'
    lineHeight: 28px
  title-md:
    fontFamily: Inter
    fontSize: 16px
    fontWeight: '600'
    lineHeight: 24px
    letterSpacing: 0.15px
  body-lg:
    fontFamily: Inter
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
    letterSpacing: 0.5px
  body-md:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '400'
    lineHeight: 20px
    letterSpacing: 0.25px
  label-lg:
    fontFamily: JetBrains Mono
    fontSize: 14px
    fontWeight: '500'
    lineHeight: 20px
  label-md:
    fontFamily: JetBrains Mono
    fontSize: 12px
    fontWeight: '500'
    lineHeight: 16px
  headline-lg-mobile:
    fontFamily: Hanken Grotesk
    fontSize: 28px
    fontWeight: '600'
    lineHeight: 36px
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  base: 4px
  xs: 4px
  sm: 8px
  md: 16px
  lg: 24px
  xl: 32px
  2xl: 48px
  gutter: 16px
  margin-mobile: 16px
  margin-desktop: 32px
---

## Brand & Style

The design system is engineered for technical interventions where reliability, speed of data entry, and clarity are paramount. The brand personality is authoritative and systematic, evoking a sense of industrial-grade security.

The visual style follows a **Corporate / Modern** approach heavily influenced by Material 3 (M3) logic but optimized for high-utility field environments. It prioritizes high-contrast interfaces and a structured information hierarchy to ensure that technicians can navigate complex ticket data under varying lighting conditions. The aesthetic is clean and functional, avoiding unnecessary decoration to focus entirely on task completion and status tracking.

## Colors

This design system utilizes a palette rooted in "Deep Blue" to establish institutional trust. The color logic is strictly functional, mapping specific hues to system statuses and priority levels to allow for instant peripheral recognition of urgency.

- **Primary (#0D47A1):** Used for primary actions, active states, and brand presence.
- **Surface & Background:** Utilize off-whites and light grays (Material 3 Surface tones) to reduce eye strain while maintaining high contrast for text.
- **Functional Palettes:** Status and priority colors are applied to semantic tokens. Use these colors for indicators, badges, and progress bars. Ensure that text placed on top of status colors maintains a contrast ratio of at least 4.5:1, often requiring white text for darker statuses (Resolved/Closed) and dark text for lighter ones (Pending).

## Typography

The typography system is designed for maximum legibility. **Hanken Grotesk** provides a sharp, contemporary look for headlines that commands attention. **Inter** is the workhorse for body content, chosen for its exceptional readability in data-heavy lists and forms. **JetBrains Mono** is introduced for labels and technical metadata (such as Serial Numbers, Ticket IDs, and Timestamps) to give the UI a precise, technical feel.

For mobile devices, headline sizes should scale down to prevent excessive wrapping. Use `label-lg` specifically for technical identifiers and `body-lg` for intervention descriptions and technician notes.

## Layout & Spacing

This design system employs a **Fluid Grid** logic with a strict 4px baseline rhythm. This ensures all components align perfectly, creating a sense of order and engineering precision.

- **Desktop (1240px+):** 12-column grid with 24px gutters.
- **Tablet (600px - 1239px):** 8-column grid with 16px gutters.
- **Mobile (Below 600px):** 4-column grid with 16px margins.

Spacing between related form fields should be `md` (16px), while spacing between distinct sections of a technical report should be `xl` (32px). All touch targets must be a minimum of 48x48px to accommodate technicians wearing gloves or working in the field.

## Elevation & Depth

Consistent with Material 3, depth is communicated through **Tonal Layers** rather than heavy shadows. Surfaces are differentiated by their "Container" levels:

- **Level 0 (Background):** The lowest layer, typically the main application background.
- **Level 1 (Surface):** The primary container for cards and list items. Uses a subtle 1px stroke (#E0E0E0) or a very soft, diffused shadow to indicate lift.
- **Level 2 (Navigation):** Top bars and navigation rails that sit above content.

For "High Priority" items or urgent alerts, use a slightly more pronounced shadow (4px blur, 10% opacity) to create a visual "break" from the grid.

## Shapes

The design system uses a standardized **12px (0.75rem)** corner radius for all primary containers and components. This "Rounded" approach softens the technical nature of the app, making it more approachable while maintaining a professional structure.

- **Small Components:** Checkboxes and small tags use a 4px radius.
- **Standard Containers:** Buttons, Input Fields, and Cards use the 12px radius.
- **Full Rounded:** Use pill-shaped buttons only for floating action buttons (FABs) to distinguish them as the primary trigger for new interventions.

## Components

### Buttons
- **Primary:** Solid #0D47A1 with white text. 12px rounded corners.
- **Secondary:** Tonal surface with #0D47A1 text.
- **Outlined:** 1px stroke in Neutral #BDBDBD with #0D47A1 text for secondary actions like "Save Draft."

### Chips & Status Indicators
- Use the status colors defined in Section 2.
- Status chips should have a background opacity of 15% of the status color, with the text/icon in the full-saturation status color for optimal readability.

### Input Fields
- Follow the Material 3 "Outlined" text field style.
- Use 12px corner radius.
- Labels should use `label-md` when floated. Active border color is the Primary Blue.

### Cards
- Used for individual Ticket/Intervention items.
- 12px radius, 1px stroke (#E0E0E0).
- Header should display the Priority color as a vertical 4px bar on the left edge.

### List Items
- High-density layout. Use `jetbrainsMono` for IDs and `inter` for descriptions.
- Vertical padding should be `sm` (8px) to maximize data visibility on a single screen.

### Checkboxes & Radios
- Primary Blue for active states. 
- Ensure a large 48px hit area for easy selection in field conditions.