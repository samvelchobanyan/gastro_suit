# Handoff: Coffee House — Home & Order Screens

## Overview
Two mobile screens for a coffee-ordering app ("Coffee House", built on the Gastro white-label design system): **Home** (greeting, loyalty, wallet, vouchers, buy-again/favourites rails, promos, nearby branches) and **Order** (Products/Branches tabs, featured rail, category menu, combo scroll-spy sections, cart bar, product detail overlay).

## About the Design Files
The files in this bundle (`Home.dc.html`, `Order.dc.html`, `ProductOverlay.dc.html`) are **design references built in a proprietary HTML templating format** — not production code to copy directly. They render only inside the design tool's runtime (`support.js` + a custom `<x-dc>`/`sc-if`/`sc-for` template engine) and will not run as-is in a normal web app.

**Your task:** recreate these designs in **React** (the environment requested for this handoff), reproducing layout, styling, content, and interactions using idiomatic React components and CSS — not by trying to load these HTML files directly.

## Fidelity
**High-fidelity.** Every value below (spacing, radius, type styles, colors) is a real design-system token, not a placeholder — reproduce pixel-accurately.

## Design System Foundation
Read `foundations/` first — it has the complete token set as CSS custom properties (colors, type scale, spacing scale, radius scale, elevation, motion) plus `_ds_manifest.json` (component inventory). Port these into your React app as a `:root` CSS file or a theme object; every component below styles itself exclusively from these tokens (no hardcoded hex/px outside of listed exceptions).

**Component library note:** Both screens compose from a shared component library (Gastro Design System) — 20 distinct components reused across screens (ScreenHeader, TabBar, SectionHeader, ProductVerticalCard, ProductMenuCard, IconButton, MenuTabsVertical, BranchCard, Divider, Dropdown, Badge, BottomNavigation, Stepper, Button, SizeSelector, Greeting, Stories, LoyaltyPointsCard, Wallet, Voucher, BuyAgainCard). Source JSX for each lives in `components/` — read these to get exact prop names, internal markup, and styling; build each as its own React component before assembling the screens.

## Screens / Views

### 1. Home
**Purpose:** landing screen — greeting, loyalty status, quick reorder, browse.
**Layout:** 360px-wide mobile column, `flex-direction: column`, fixed 800px height with internal scroll region (`flex:1; overflow-y:auto`) between a fixed top (none here) and a fixed bottom nav bar.

Order top→bottom, each section separated by `--space-base` (16px) or `--space-lg` (24px) padding — see `screens/Home.json` for the exact spacing key on every block:
1. **Greeting** — name "Aram", greeting text "Let's enjoy some coffee", logo image, notification bell. Height 76px.
2. **Stories** row — horizontal scroll, 6 items, 72px avatar + label, seen/unseen ring state. Gap `--space-sm` (8px).
3. **LoyaltyPointsCard** — 1240 points, "Master" membership, "10%" discount, QR code, background photo at 0.35 opacity (dark gray-900 base so a light-on-dark card reads correctly). 328×116px.
4. **Wallet** — balance "֏5,680" with wallet icon. 328×80px.
5. **SectionHeader "Vouchers"** + 2 Voucher cards, horizontal scroll.
6. **TabBar** (size "small", 2 tabs: "Buy again" / "Favourites") — controls which rail below shows.
7. **BuyAgainCard rail** (shown when tab = buy-again) OR **ProductVerticalCard rail** (shown when tab = favourites) — 3 items each, 128px cards, horizontal scroll.
8. **Promo ad tiles** — 3 plain `<a><img>` tiles (no DS component for this — build as simple linked images), 280px wide, 512:264 aspect ratio, `--radius-md` (16px) corners, `--elevation-card` shadow.
9. **SectionHeader "Nearest branches"** + 3 BranchCard rows separated by Divider.
10. **BottomNavigation** — fixed bottom, 4 items (Home/Order/Gifts/Profile), active = Home. `--space-sm` `--space-base` padding, top border `--color-border-muted`.

### 2. Order
**Purpose:** browse menu, add items to cart, view branch list, open product details.
**Layout:** same 360×800 mobile frame. Structure top→bottom:
1. **ScreenHeader** title "Order" (56px).
2. **TabBar** (size "big", 2 tabs: "Products" / "Branches") — controls whole-screen content below.
3. **Scrollable content region** (`flex:1; overflow-y:auto`), containing (Products tab):
   - **SectionHeader "Featured products"** + horizontal rail of 5 ProductVerticalCards (128px), each with an absolutely-positioned add-to-cart IconButton overlaid bottom-right of the image (`top: calc(128px - 40px - 4px); right:4px`) — icon toggles plus↔x, variant toggles filled↔tonal, per-card independent state.
   - **SectionHeader "Menu"** + **MenuTabsVertical** — 7 categories (Combo deals, Iced Coffee, Iced Drinks, Matcha and Tea, Hot Coffee, Sweets, Other), horizontal scroll of icon+label tabs; selecting one filters the grid below.
   - **If category = "combo"**: a sticky `TabBar` (size "xs") with 4 sub-filter options (Iced Matcha Based / Iced Tea / Hot Matcha Based / Hot Tea) that is a **scroll-spy** — it highlights whichever of 4 titled 2-product sections below is currently scrolled into view, and clicking a tab smooth-scrolls to that section (offset by the sticky bar's height, ~52px). All 4 sections render in one continuous scroll (not tab-switched panels).
   - **Else**: a single section title (category label, `--text-body-semibold`) + an 8-card 2-column grid of ProductMenuCard, each with the same plus/x add-to-cart IconButton overlay bottom-right (`--space-sm` inset). Products are shuffled per category using a seeded shuffle (deterministic per category, not random per render) from a shared 8-item base product list.
   - **Branches tab content** (shown instead of the above when tab = Branches): 6 BranchCard rows separated by Divider, `--space-md` gap.
   - **Cart bar**: sticky to the bottom of the scroll region (not the whole screen — it scrolls with content but sticks once reached), glassmorphic background (`--glass-bg` translucent white + `--glass-border` 1px + `backdrop-filter: blur(var(--glass-blur))`), containing a location Dropdown (flex:1) and a Badge-wrapped cart IconButton on the right. Badge count = number of added items; badge variant + icon-button variant both flip between "empty/tonal" and "default/filled" depending on whether the cart has ≥1 item.
4. **ProductOverlay** (see below) — mounted at the screen root, shown/hidden via `visible` state; NOT part of tab navigation.
5. **BottomNavigation** — fixed bottom, active = Order.

### 3. ProductOverlay (shared, reusable modal)
**Purpose:** product detail view, opened by tapping any product card on Order (or, in future, other screens). Not part of the main nav.
**Layout:**
- A `position: fixed`-equivalent full-screen scrim: `--alpha-black-40` black overlay behind, tap to dismiss.
- The overlay panel itself starts `--space-xl` (32px) from the top of the screen (leaving the screen visible above it) and fills to the bottom, rounded top corners (`--radius-lg` on top-left/top-right only), white background, internal scroll.
- **Image area**: full-width square (`aspect-ratio: 1/1`), `--gray-900` background, `object-fit: contain` (so transparent-background product photos sit correctly on dark). Two icon buttons absolutely positioned over the image, both `xs` size (36px), `tonal` variant: **close (x)** top-left, **heart (favourite)** top-right, both `--space-base` inset.
- **Body** (`--space-base` padding): title row — product name in `--text-h2` (flex:1, wraps via `text-wrap: pretty` so long titles break to a 2nd line instead of overlapping price) + price in `--text-h3` (fixed width, right-aligned, `white-space: nowrap`). Below: description paragraph in `--text-body` / `--color-text-secondary`, fixed copy for all products: "High-quality 100% Arabica with distinct flavor notes revealed through processing". Below: 3 **SizeSelector** controls (Small/Regular/Large), each `flex:1` so they split the row evenly (no wrapper div — flex style applied directly to each), single-select, "Regular" selected by default.
- **Sticky footer bar**: `position: sticky; bottom:0`, white background, top border `--color-border-muted`, `--space-base` padding — a **Stepper** (quantity, default 1) on the left + a full-width primary **Button** (`sm` size, 40px) on the right, label `Add (${price})`, left icon `shopping-cart-simple`.

## Interactions & Behavior
- **Tab switches** (Home rail tab, Order Products/Branches tab): pure state swap, no animation specified — apply the DS's standard ~200ms transition if you add one.
- **Add-to-cart toggle**: tapping a product's overlay icon button flips that single item's added state (icon plus→x, variant filled→tonal); does not open the product overlay (separate click target, `stopPropagation` in the source).
- **Opening the product overlay**: tapping the product card body (not the icon button) opens ProductOverlay with that product's image/name/price.
- **Combo scroll-spy**: implement with `IntersectionObserver` or scroll-position math (source uses manual `getBoundingClientRect` comparison against a threshold of 60px past the sticky bar). Clicking a sub-tab programmatically scrolls its section into view, offset to land just below the sticky bar.
- **Bottom nav navigation**: clicking Home/Order in the nav navigates between the two screens (separate routes in your app); Gifts/Profile are inert placeholders (no screen built yet).
- **Cart badge/icon state**: derived, not directly settable — recomputed from the count of added items every render.
- **Overlay dismiss**: tap the scrim, or tap the x button.

## State Management
Per screen, minimal local state is enough (no global store needed for this fidelity level):
- **Home**: `activeTab` ('buy-again' | 'favourites'), `activeNav` ('home' | 'order' | ...).
- **Order**: `activeTab` ('products'|'branches'), `activeMenuCategory`, `activeComboSubTab`, `addedItemIds: Record<string, boolean>` (per-product-id add state, keyed by a stable id you assign each product), `overlayProduct: {name, image, price} | null`.
- **ProductOverlay**: `quantity: number` (default 1), `selectedSize: 'Small'|'Regular'|'Large'` (default 'Regular').

No data fetching in this prototype — all content is hardcoded sample data (see `screens/*.json` for the literal values).

## Design Tokens
Full token files are in `foundations/*.css` (real values, not excerpts) — port these into your app's theme. Highlights:
- **Spacing scale**: xs 4 · sm 8 · md 12 · base 16 · lg 24 · xl 32 · xxl 48 (all px, 4px grid).
- **Radius scale**: micro 4/8 · small 8/12 · medium 12/16 (cards=16, inputs=12) · macro 24/32 · full 9999.
- **Type scale** (Plus Jakarta Sans, weights 400/500/600/700): Display 32/40 · H1 24/32 · H2 20/28 · H3 16/24 · Body-L 16/24 · Body 14/20 · Caption 12/16 · Overline 10/12 (uppercase, tracked, semibold).
- **Color**: monochrome-first neutral ramp (`--gray-0…1000`) + one accent ramp (`--accent-50…900` + `--accent-contrast`) — **this project's accent is red** (`--accent-500: #ED1D25`), overriding the DS's default indigo placeholder; see `foundations/colors-accent.json` for the exact override ramp. Semantic aliases (`--color-text-primary`, `--color-bg-surface`, `--color-border-muted`, etc.) sit on top — always consume the semantic layer, never the raw ramps, in component code.
- **Glass effect** (used only on the Order cart bar): `--glass-bg` (translucent white), `--glass-border`, `--glass-blur` (12px) — a Foundations-level token addition specific to this project.
- **Elevation**: `--elevation-card` (subtle, used on promo tiles and cards).

## Assets
All images are in `assets/` (product photos, branch photos, promo art, logo, QR code, category icons). Filenames are descriptive (e.g. `ch_fav_iced_fantasy_coffee.png`, `branch_1.png`). Two variants exist for several products — an opaque white-background thumbnail (`ch_fav_*`, used in card grids) and a transparent-background cutout (`iced fantasy coffee-*.png` style names, used inside ProductOverlay so the dark `--gray-900` background shows through). Story avatars use placeholder Unsplash URLs (replace with real assets before ship). Phosphor icon font (`@phosphor-icons/web`) is used throughout via `<i class="ph ph-name">` — self-host for production per the DS guide.

## Files
- `screens/Home.dc.html`, `screens/Order.dc.html`, `screens/ProductOverlay.dc.html` — the original design source (reference only, does not run standalone).
- `screens/Home.json`, `screens/Order.json` — machine-readable screen descriptions (component tree, props, spacing tokens per block) — use these as your literal source of truth for content and structure.
- `components/*.jsx` + `*.d.ts` — Gastro Design System component source (props, internal markup, styling) for every component used across both screens.
- `foundations/*.css` — full design token files.
- `foundations/colors-accent.json` — this project's client-specific accent override (red), takes precedence over the DS's placeholder indigo.
- `assets/` — all images referenced by both screens.
