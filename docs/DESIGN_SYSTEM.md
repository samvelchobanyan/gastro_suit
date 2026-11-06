# GastroSuit — Design System

Status: tokens done · components not started · 2026-11-06

## 0. About this document

How the design handoff's tokens map into code, and the rules for using them. Tokens are
constants: colours, numbers for spacing, radii, heights, text styles. Components are
described here when they are built.

Source of every value: the live handoff tokens in
`coffee-house-ui/project/_ds/gastro-design-system-*/tokens/*.css`. Other copies of the
tokens in the handoff (`export/`, `handover/`, `design_handoff_home_order/`) are older
snapshots and are not used.

Code: `lib/design_system/`. Import `design_system/ds_extensions.dart` to get every token
and `context.brand`.

---

## 1. Layers

| Layer | Code | Depends on the brand |
|---|---|---|
| Palette — raw colours by ramp position | `DSPalette` | No |
| Colour roles — what a colour is for | `DSColors` | No |
| Brand — accent ramp and brand roles | `DSBrand` (`ThemeExtension`) | Yes |
| Typography | `DSTypography` | No |
| Spacing scale, screen layout | `DSSpacing`, `DSLayout` | No |
| Radii | `DSRadius` | No |
| Sizes, icons, strokes | `DSSizes` | No |
| Shadows | `DSElevation` | No |

Rules:
- Use colour roles (`DSColors`, `context.brand.*`). Use `DSPalette` only where no role
  fits.
- Brand values are read only through `context.brand`. Importing a concrete brand
  (`coffeeHouseBrand`) in a widget removes it from the re-skin.
- Everything except the brand is a plain constant.

---

## 2. Naming

Names follow the handoff, so a handoff value maps to code without a lookup table:

| Handoff | Code |
|---|---|
| `--space-md` | `DSSpacing.md` |
| `--color-text-primary` | `DSColors.textPrimary` |
| `--gray-100` | `DSPalette.gray100` |
| `--accent-500` | `context.brand.accent500` |
| `--color-brand-primary` | `context.brand.brandPrimary` |
| `--radius-card` | `DSRadius.card` |
| `--text-body-semibold` | `DSTypography.bodySemibold` |
| `--icon-md` | `DSSizes.iconMd` |
| `--elevation-card` | `DSElevation.card` |

Where a CSS name is not a valid Dart identifier: `--radius-2xl` → `DSRadius.xxl`,
`--button-height-2xs` → `DSSizes.buttonHeight2xs`.

---

## 3. Brand layer

`DSBrand` holds the accent ramp (`accent50` … `accent900`) and `accentContrast` (the
foreground on an accent fill). The brand roles are derived from the ramp:

| Role | Value |
|---|---|
| `brandPrimary`, `borderInteractive`, `focusRing` | accent 500 |
| `brandInteractive` (pressed), `textAccent` | accent 600 |
| `brandSubtle` (tinted surfaces) | accent 50 |
| `textOnBrand` | `accentContrast` |

Brands live in `lib/design_system/theme/brands/`:
- `coffeeHouseBrand` — the first client, values from the handoff;
- `demoBrand` — not a client: a different accent to check the re-skin. Anything that
  stays red under it reads a brand value outside the theme.

`buildAppTheme(brand)` builds the `ThemeData`: the brand as an extension, and Material's
colour scheme filled from the tokens so stock Material widgets match.

Adding a client: a new `DSBrand` constant in `brands/`. Nothing else changes.

---

## 4. Typography

Plus Jakarta Sans, weights 400 / 500 / 600 / 700, bundled in `assets/fonts/`.

| Style | Size / line height | Weight |
|---|---|---|
| `display` | 32 / 40 | 700 |
| `h1` | 24 / 32 | 700 |
| `h2` | 20 / 28 | 700 |
| `h3` | 16 / 24 | 700 |
| `bodyLg`, `bodyLgMedium`, `bodyLgSemibold` | 16 / 24 | 400 / 500 / 600 |
| `body`, `bodyMedium`, `bodySemibold` | 14 / 20 | 400 / 500 / 600 |
| `bodySm`, `bodySmSemibold` | 12 / 16 | 400 / 600 |
| `bodyXs` | 10 / 14 | 400 |
| `caption` | 12 / 16 | 400 |
| `overline` | 10 / 12, tracking 0.08 em, upper case | 600 |

- Styles carry no colour; the colour is a role applied on use
  (`DSTypography.body.copyWith(color: DSColors.textSecondary)`).
- CSS line heights are pixels; Flutter's `height` is a multiplier, so it is set to
  lineHeight / fontSize, with the extra space split evenly above and below as in CSS.
- `overline` is shown in upper case: the text is upper-cased where it is used.

**Open:** the font has no Cyrillic, no Armenian and no dram sign (֏). Russian and Armenian
text and prices fall back to the system font. A font decision is needed before screens
with real content (see §7).

---

## 5. Spacing, layout, radii, sizes, shadows

- `DSSpacing`: `xxs` 2 · `xs` 4 · `sm` 8 · `md` 12 · `base` 16 · `lg` 24 · `xl` 32 ·
  `xxl` 48 — gaps and padding.
- `DSLayout`: screen `margin` 16, `gutter` 8, `gapText` 8 (headline ↔ description),
  `gapBlock` 16 (independent blocks).
- `DSRadius`: scale `xs` 4 · `sm` 8 · `md` 12 · `lg` 16 · `xl` 24 · `xxl` 32 · `full`, and
  by element (`badge`, `tag`, `input`, `card`, `sheet`, `modal`, `pill`, …).
- `DSSizes`: button, input, bar and row heights; icon sizes 16 / 20 / 24 / 32 / 40;
  stroke widths; minimum touch target 48.
- `DSElevation`: `card`, `raised`, `overlay`, `sheet` — lists of `BoxShadow`.

---

## 6. What is not taken from the handoff

- Web layout tokens: screen width 360, column widths 76 / 160 / 244, safe areas. Screen
  size and insets come from `MediaQuery`.
- Motion tokens: the handoff's animations are not the app's; motion is decided later.
- Component tokens (`--button-primary-bg`, `--input-border-focus`, …): added with the
  components that use them.
- `--color-bg-muted`: referenced by the handoff but never defined; it is
  `DSColors.bgSurfaceSunken`.
- `--alpha-white-40`: referenced by the handoff (ProductOverlay) but missing from its
  tokens; added as `DSPalette.alphaWhite40`.

---

## 7. Open

- Font coverage for Russian, Armenian and the dram sign (§4).
