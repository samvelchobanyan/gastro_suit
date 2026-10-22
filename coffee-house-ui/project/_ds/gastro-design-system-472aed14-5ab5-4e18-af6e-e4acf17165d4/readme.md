# Gastro Design System

A **white-label design system for restaurant / HoReCa consumer mobile apps.** One neutral base app is re-skinned per customer through a thin, swappable token layer — logo, name, accent color and corner radius change; components never do.

- **Product:** Gastro — a platform that ships a fully-functional ordering app (menus, cart, checkout, order tracking, reservations, loyalty) branded for each restaurant customer.
- **Design philosophy:** modular, bento cards, reusable components, consistent. Blocks can be reordered or resized per customer **without breaking the layout.**
- **Look & feel:** flat, minimal, elegant, clean, high-contrast. Monochrome by default (black / white / grays) with a single applied accent per brand.
- **Target platform:** mobile, 360px design width, 4px baseline grid.

## Sources

The system was built from two client specification documents (extracted to plain text in the project root for reference):

- `uploads/Gastro Mobile App Design Specs.docx` → `Gastro Mobile App Design Specs.txt` — spacing scale, type scale, touch targets, component sizing, radius rules, color-token architecture, states, accessibility.
- `uploads/Gastro Mobile App Mobile App Component List.docx` → `Gastro Mobile App Mobile App Component List.txt` — the full component inventory (≈40 general UI + ≈28 restaurant/ordering domain components).

No Figma file or codebase was provided; the specs are the ground truth. No brand colors are finalized — the accent is an isolated placeholder.

---

## Token architecture

Strict three-tier pipeline (spec-mandated). Never reference a raw hex in a component — always resolve through the semantic layer.

- **Tier 1 — Global / primitive** (`tokens/primitives.css`): raw neutral ramp `--gray-0…1000`, status hues (green/amber/red/blue), alpha overlays.
- **Tier 1 — Brand accent** (`tokens/brand.css`): the **only file a customer overrides.** Placeholder indigo ramp `--accent-50…900` + `--accent-contrast`.
- **Tier 2 — Semantic** (`tokens/semantic.css`): purpose-named aliases (`--color-text-primary`, `--color-bg-surface`, `--color-border-interactive`, status roles, state overlays). Encodes the surface↔text contrast matrix and the 60-30-10 distribution roles.
- **Tier 3 — Component** (`tokens/components.css`): specific overrides (`--button-primary-bg-active`, `--input-border-focus`, `--control-on-bg`, …).
- **Foundations:** `typography.css`, `spacing.css`, `radius.css`, `sizing.css`, `elevation.css`, `motion.css`.
- **Fonts:** `tokens/fonts.css` — Plus Jakarta Sans.

`styles.css` (root) is the single entry point — an `@import` manifest only, in dependency order. Consumers link this one file.

**White-label swap:** override `tokens/brand.css` (accent) and optionally the `--radius-*` aliases → the whole app re-skins with no component edits.

---

## Content fundamentals

Copy is written for a hungry customer who wants to order in seconds. It is **plain, warm and concrete** — never corporate.

- **Voice:** second person and imperative for actions ("Add to cart", "Checkout", "Track order"). The app talks *to* the user, not about itself.
- **Casing:** sentence case for everything except the **Overline** style, which is ALL CAPS with tracking for small category labels ("CHEF'S SPECIALS"). Button labels are sentence case, short, verb-first.
- **Tone:** appetite-forward and specific. Menu descriptions name ingredients and technique ("San Marzano tomato, fior di latte, cold-pressed olive oil") rather than adjectives ("delicious, amazing").
- **Numbers:** prices always 2 decimals with the brand currency symbol; times as ranges ("25–35 min"); tabular figures for alignment.
- **Microcopy:** helpful and solution-oriented, especially errors — pair every error color with an icon and a sentence that says how to fix it ("Please select a payment method").
- **Emoji:** not used. Iconography carries visual meaning instead.
- **Length:** ruthless. Titles ≤ 3 words where possible; descriptions clamp to 2 lines.

Examples — Display: "Order in seconds" · H1: "Your favourites" · Overline: "CHEF'S SPECIALS" · Caption: "Delivered in 25–35 min · Free over $20".

---

## Visual foundations

**Color.** Monochrome-first. ~60% neutral canvas/surfaces, ~30% structural grays (borders, dividers, secondary text), ~10% accent reserved strictly for CTAs, active states and focus rings. High contrast throughout — body text targets AA (4.5:1), large text 3:1, and the neutral pairings clear AAA on white. Status colors carry fixed real-world meaning (success green, warning amber, error red, info blue) and are always reinforced with an icon or text — never color alone.

**Type.** Plus Jakarta Sans, one family across the whole system. Eight tiers on a strict 4px baseline — every line-height is a multiple of 4 for vertical rhythm (Display 32/40 · H1 24/32 · H2 20/28 · H3 16/24 · Body-L 16/24 · Body 14/20 · Caption 12/16 · Overline 10/12). Weights 400/500/600/700. Display and large headings carry slight negative tracking; overline carries positive tracking + uppercase.

**Spacing & layout.** 4px grid. Spacing scale xs 4 → xxl 48. 360px screen, 16px side margins, 8px gutter, max 4 columns (76 / 160 / 244 / 328px presets). Auto-layout gaps: 8px between headline and description, 16px between independent blocks. Nested padding must be ≤ its container's padding. Bento composition — blocks reflow without breaking.

**Backgrounds.** Flat solids only — no gradients, no textures, no patterns, no hand illustration. Canvas is `--gray-50`; surfaces are white. Imagery (dish/restaurant photos) is the color and warmth in the UI; the chrome stays neutral so photography pops.

**Elevation.** Restrained and neutral (black-based, so it survives re-branding). Four levels: card (subtle), raised (FAB / cart bar), overlay (dialog / dropdown / toast), sheet (upward cast). Flat by default — elevation only separates true layers.

**Corners.** Radii scale with element size: micro 4/8 (badges, checkboxes), small 8/12 (tags, small buttons, thumbnails), medium 12/16 (inputs, dialogs, cards), macro 24/32 (bottom sheets, modals), full 9999 (pills, tabs, avatars). Cards use 16px, inputs 12px.

**Cards.** White surface, 1px `--color-border-muted`, 16px radius, subtle `--elevation-card` shadow, 16px internal padding. No colored left-border accents.

**Borders.** 1px default; focus/active raises to **2px** and shifts to the accent. Three neutral weights (muted / default / strong) + interactive accent.

**Motion.** Subtle and functional, never decorative. Press feedback resolves under 100ms; toggles ~150ms; standard transitions ~200ms; sheets/dialogs ~300ms. Four easing curves — standard (default), decelerate (entering), accelerate (exiting), emphasized (gentle overshoot for confirmation). Selection controls/cards may shrink to 0.97 on press.

**Interaction states (spec State Matrix).** No hover on mobile. Pressed = +10–12% black/white overlay. Focused = 2px outline distinct from default. Disabled = 30–38% opacity. Loading = freeze size, hide label, centered spinner. Error = error color on border/text/icon + assistive text below.

**Transparency & blur.** Used sparingly — scrim behind modals (`--alpha-black-40`); pressed overlays as translucent tints. No frosted-glass chrome by default.

---

## Iconography

**Phosphor** (https://github.com/phosphor-icons/homepage) is the icon system, loaded as the Phosphor web font from CDN (`@phosphor-icons/web`), used via `<i class="ph ph-name">`. Regular weight is the default. Icons inherit `currentColor` and are sized by `font-size`.

- **Bounding boxes** scale in multiples of 4: 16 (inline/status), 20 (list/inputs), **24 (default — nav, header actions)**, 32 (FAB), 40 (grid/onboarding). Keep vectors inside a safe zone (a 24px frame holds a ~20–22px glyph); center vectors optically.
- **Touch targets:** minimum 48×48. A 24px icon sits in a 48px target with 12px padding each side.
- **No emoji.** No hand-rolled SVG icons — always a Phosphor glyph. Common app glyphs: `house`, `magnifying-glass`, `fork-knife`, `shopping-cart-simple`, `heart`, `star`, `storefront`, `motorcycle`, `map-pin`, `clock`, `receipt`, `credit-card`, `bell`, `sliders-horizontal`, `user`, `plus`, `minus`, `caret-down`, `check`, `warning-circle`.

> Note: Phosphor is loaded from CDN, so component/card previews need network access. For offline/production, self-host the Phosphor font. Likewise Plus Jakarta Sans currently loads via Google Fonts `@import` — self-host the `.woff2` files for production so the binaries ship with the system.

---

## Index / manifest

**Root**
- `styles.css` — global entry point (@import manifest). Consumers link this.
- `readme.md` — this guide.
- `SKILL.md` — Agent-Skill entry (portable usage).
- `Gastro Mobile App Design Specs.txt`, `…Component List.txt` — extracted source specs.

**tokens/** — `fonts.css`, `primitives.css`, `brand.css` (swappable accent), `typography.css`, `spacing.css`, `radius.css`, `sizing.css`, `elevation.css`, `motion.css`, `semantic.css`, `components.css`.

**guidelines/** — 20 foundation specimen cards (`@dsCard`), grouped Colors · Type · Spacing · Radius · Sizing · Foundations (elevation/motion/iconography) · Brand.

**components/** — reusable primitives (`.jsx` + `.d.ts` + `.prompt.md` + `@dsCard`), organized by concern. 68 components total:

- `buttons/` — Button
- `icon-button/` — IconButton
- `fab/` — Fab
- `inputs/` — TextInput, TextArea, Dropdown, Accordion
- `search/` — SearchBar, SearchFiltersPanel
- `forms/` — Checkbox, Radio, RadioGroup, Switch, Slider, Stepper, FormGroup
- `navigation/` — TopAppBar, BottomTabBar, Breadcrumb, PageIndicator, NavigationDrawer
- `tabs/` — SegmentedControl, MenuCategoryTabs
- `data-display/` — Divider
- `avatar/` — Avatar
- `badge/` — Badge
- `tag/` — Tag
- `chip/` — Chip
- `rating/` — RatingStars
- `list-items/` — AdvancedListItem, SimpleListItem
- `feedback/` — BottomSheet, Dialog, Toast, ProgressBar, Spinner, Skeleton, EmptyState, ErrorState
- `tooltip/` — Tooltip
- `media/` — MapView (used by LiveOrderTrackingMap; no card of its own)
- `pickers/` — Calendar, DatePicker, TimePicker
- `news/` — NewsListing (vertical, horizontal)
- `section-header/` — SectionHeader
- `menu/` — MenuItemCard, ItemCustomizationSheet, CartLineItem
- `cart/` — CartSummaryBar, OrderTotalBreakdown, PromoCodeInput
- `restaurant/` — RestaurantCard, RestaurantHeader, BranchCard, DeliveryPickupToggle, AddressSelector, DeliveryTimeEstimate
- `filter/` — Filter, FilterBar
- `quick-action-tiles/` — QuickActionTile, QuickActionTiles
- `order/` — OrderStatusTimeline, LiveOrderTrackingMap, OrderHistoryCard, ReorderButton, RatingReviewPrompt
- `checkout/` — TipSelector, PaymentMethodCard, PaymentMethodPicker
- `loyalty/` — LoyaltyRewardsBadge, LoyaltyWidget
- `confirmations/` — ReservationConfirmationCard
- `greeting/` — Greeting

This build-once, neutral inventory covers the full client component brief (`…Component List.txt`) — general UI primitives plus the restaurant/ordering domain set (menu, cart, checkout, tracking, reservations, loyalty). UI-kit screens (full product recreations) are the natural next step and are not yet built.

**Namespace:** components are exposed on `window.GastroDesignSystem_472aed` in `@dsCard` HTML.
