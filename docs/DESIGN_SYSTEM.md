# GastroSuit — Design System

Status: tokens done · components added as they are reused · 2026-11-12

## 0. About this document

How the design handoff's tokens map into code, and the rules for using them. Tokens are
constants: colours, numbers for spacing, radii, heights, text styles.

Components are not taken from the handoff's component list. A widget enters
`design_system/components/` when it is reused and knows no domain
(`ARCHITECTURE_SPEC.md` §8), and is described here then. See `BUNDLE.md`.

Source of every value: the live handoff tokens in
`coffee-house-ui/project/_ds/gastro-design-system-*/tokens/*.css`. Other copies of the
tokens in the handoff (`export/`, `handover/`, `design_handoff_home_order/`) are older
snapshots and are not used.

Code: `lib/design_system/`. Import `design_system/ds_extensions.dart` to get every token
and `context.colors`.

---

## 1. Layers

| Layer | Code | How it is read |
|---|---|---|
| Palette — raw colours by ramp position, incl. the client's accent ramp | `DSPalette` (`foundations/ds_palette.dart`) | Not in widgets; only to fill role sets |
| Colour roles — what a colour is for | `DSColors` (`ThemeExtension`, `theme/ds_colors.dart`) | `context.colors.textPrimary` |
| Typography | `DSTypography` | Constant |
| Spacing scale, screen layout | `DSSpacing`, `DSLayout` | Constant |
| Radii | `DSRadius` | Constant |
| Sizes, icons, strokes | `DSSizes` | Constant |
| Shadows | `DSElevation` | Constant |
| Motion | `DSMotion` | Constant |

Rules:
- Colours are read only through `context.colors`. A colour taken from `DSPalette` or
  hardcoded drops out of a dark theme or another client's colours.
- A colour the design needs and no role covers: add a role to `DSColors` (and its value to
  every role set), then use it.
- Everything except colours is a plain constant.

---

## 2. Naming

Names follow the handoff, so a handoff value maps to code without a lookup table:

| Handoff | Code |
|---|---|
| `--space-md` | `DSSpacing.md` |
| `--color-text-primary` | `context.colors.textPrimary` |
| `--color-brand-primary` | `context.colors.brandPrimary` |
| `--gray-100`, `--accent-500` | `DSPalette.gray100`, `DSPalette.accent500` (role sets only) |
| `--radius-card` | `DSRadius.card` |
| `--text-body-semibold` | `DSTypography.bodySemibold` |
| `--icon-md` | `DSSizes.iconMd` |
| `--elevation-card` | `DSElevation.card` |

Where a CSS name is not a valid Dart identifier: `--radius-2xl` → `DSRadius.xxl`,
`--button-height-2xs` → `DSSizes.buttonHeight2xs`.

---

## 3. Colour roles and the theme

`DSColors` lists every colour role (backgrounds, brand, text, borders, status, overlays,
the hero scrim). A role set is an instance with values from the palette; there is one,
`lightColors`. Brand roles are ordinary roles in it:

| Role | Value |
|---|---|
| `brandPrimary`, `borderInteractive`, `focusRing` | accent 500 |
| `brandInteractive` (pressed), `textAccent` | accent 600 |
| `brandSubtle` (tinted surfaces) | accent 50 |
| `textOnBrand` | `accentContrast` |

Roles added for handoff components that use raw palette values: `skeletonBase` (gray 100)
and `skeletonHighlight` (gray 200) for `Skeleton`; `handleOnDark` (white at 40%) for a
sheet's handle lying over a photo (`ProductOverlay`). `glassBg` (white at 64%) and
`glassBorder` (white at 24%) are the handoff's `--glass-bg` and `--glass-border`: a
frosted surface floating over content, blurred by `DSSizes.glassBlur`.

`buildAppTheme(colors)` builds the `ThemeData` from one role set: the set itself as an
extension (for our widgets), and Material's colour scheme and text theme (for stock
widgets and `Text` without a style). Both come from the same set, so they cannot drift.

Each client is a separate app; its colours are chosen at build time. The accent ramp in
`DSPalette` is Coffee House's. How another client's colours are supplied is decided when
the second client arrives.

A dark theme, if it comes: a second role set (`darkColors`) passed as `darkTheme`. Widgets
do not change.

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
  (`DSTypography.body.copyWith(color: context.colors.textSecondary)`).
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
  stroke widths; minimum touch target 48. Component sizes the handoff hard-codes inside a
  component, not in its tokens, are added here by name when the component is built:
  `headerLogo` and `headerAction` 44, `notificationDot` 9 (`Greeting`); `storyCircle` 64
  and `storyItemWidth` 72 (`Stories`); `bannerWidth` 280 (Home's promo row);
  `branchImage` 72 (`BranchCard`); `branchHeaderHeight` 260 (`RestaurantHeader`);
  `branchMapHeight` 320 (`MapBottomSheet`);
  `menuCategoryImage` 56 and `menuCategoryItemWidth` 64 (`MenuTabsVertical`);
  `productRailCardWidth` 128 (`ProductVerticalCard`); `badge` 18 (`Badge`).
- `DSElevation`: `card`, `raised`, `overlay`, `sheet` — lists of `BoxShadow`.
- `DSOpacity`: `disabled` 0.35 — a control that cannot be used now.

---

## 6. What is not taken from the handoff

- Web layout tokens: screen width 360, column widths 76 / 160 / 244, safe areas. Screen
  size and insets come from `MediaQuery`.
- Motion tokens as a set: the handoff's animations are not the app's. `DSMotion` holds
  only the durations and curves a component uses (`base`, `standard` so far — the
  sliding indicator of `DSSegmentedTabs`).
- Component tokens (`--button-primary-bg`, `--input-border-focus`, …): added with the
  components that use them.
- `--color-bg-muted`: referenced by the handoff but never defined; it is
  `context.colors.bgSurfaceSunken`.
- `TabBar` size `xs` paints with palette greys: `gray-0` is `bgMain`, `gray-100` is
  `bgSurfaceSunken`; the unselected label's `gray-500` (the value of `textDisabled`) is
  `textTertiary`, since the chip is not disabled.
- `--alpha-white-40`: referenced by the handoff (ProductOverlay) but missing from its
  tokens; added as `DSPalette.alphaWhite40`.
- `ProductOverlay` paints with palette greys: the fill under the photo (`gray-900`) is
  `bgInverse`; the description, the portion and an unchosen option's name (`gray-600`)
  are `textTertiary`.
- Components that paint with palette greys take the role of the same value:
  `ProductMenuCard`'s `gray-900` and `gray-0` are `bgInverse` and `textInverse`;
  `Stepper`'s `gray-50` is `bgCanvas`.
- `IconButton` `tonal` pressed (`accent-100`) has no role: the pressed fill is
  `brandSubtle` under `overlayPressDark`.
- `--alpha-white-80` (the quieter text over `RestaurantHeader`'s photo) is `textInverse`
  at 80%.

---

## 7. Components

| Component | Handoff | What it is |
|---|---|---|
| `DSBottomNavigation` | `BottomNavigation` | Flat bar, hairline on top, 48 high; the active item is the brand colour with a filled icon |
| `DSSkeleton` | `Skeleton` | A loading shape (box or circle) with a sweeping band; blocks compose their own skeletons from it |
| `DSNetworkImage` | — | A cached network picture; a recessed fill while loading, with an image icon on error or without an address |
| `DSStatusPill` | `StatusPill` | A short state label on a tonal capsule (Open / Closed); tones `success`, `error` so far — the handoff's `warning` and `neutral` are added when used |
| `DSSectionHeader` | `SectionHeader` | A section title (`h3`); the handoff's optional action button is used by no page, so it is not built |
| `showDSTallSheet`, `DSSheetHandle` | the frame of `ProductOverlay` and `BasketOverlay` | A sheet over the whole app that starts 32 under the status bar, with 16 top corners. Its content scrolls with the controller it is given; a drag down from the top of the content, or a fling, closes it. The handle is drawn by the content: on the surface, or over a photo |
| `DSTimePicker` | `TimePicker` | A row of pills, 40 high, one picked; as wide as its pills, the screen scrolls it sideways. Keeps no time of its own. The handoff's label and disabled slots are added when used |
| `DSTipSelector` | `TipSelector` | One tile of a row of amounts, at least 80 wide, in the brand colour when chosen |
| `DSAmountField` | `Input`, 40 high | A one-line field for a whole amount: digits only, the currency sign at its end |
| `DSDialog` | `Dialog` | A centred card, up to 320 wide, with a question: a title, a sentence, then cancel (outline) and confirm (primary) side by side; opened with `showDSConfirmDialog`, which answers true or false. The handoff's icon and destructive tone are added when used |
| `DSBottomSheet` | `BottomSheet` | The frame every sheet shares: handle, title with a close button, scrolling content; up to 88% of the screen; opened with `showDSBottomSheet`. The content stays above the keyboard |
| `DSDropdown` | `Dropdown` | A 40-high select box; the list opens under the field. Drawn here, placed and closed by Flutter's `RawMenuAnchor` |
| `DSChipTabs` | `TabBar`, size `xs` | A sideways-scrolling row of chips, one selected. When the selection moves to a chip off the row's edge, the row scrolls just far enough to show it |
| `DSSegmentedTabs` | `TabBar`, size `big` | A full-width switch between views of a screen: equal segments with an icon and a label on a recessed track, and an indicator that slides under the selected one. A separate component from `DSChipTabs`: it looks and behaves differently |
| `DSScreenHeader` | `ScreenHeader` | A screen's title (`h1`); the handoff's back button and trailing action are added when a screen needs them |
| `DSRadio` | `RadioButton` | The radio mark only; the row it sits in takes the tap |
| `DSCheckbox` | `Checkbox` | The checkbox mark only: a 20 square, the brand fill with a tick when checked; the row it sits in takes the tap |
| `DSButton` | `Button` | `primary` and `secondary` (outline), sizes `sm` 40 and `md` 48, an optional icon before the label; other variants and sizes are added when used. Disabled (no `onPressed`) it is dimmed; `loading` shows a spinner in place of the label; neither takes taps |
| `DSIconButton` | `IconButton` | A button with only an icon; `filled` and `tonal`, sizes `xs` 36 and `sm` 40 so far; round, or a square with an input's corners (`rounded`) next to a field |
| `DSStepper` | `Stepper` | A quantity between a minus and a plus; sizes `sm` 32 high and `md` 40. Keeps no number of its own: it shows the value it is given and reports the one asked for |
| `DSRatingStars` | `RatingStars`, display only | Five stars to the half star; zero is five empty stars |
| `DSTextArea` | `Textarea` | A four-line text field on the main background: a hairline border, 2 thick in the interactive colour when focused. Can limit the length; the handoff's label, helper text, error state and counter are added when used |
| `DSRatingInput` | `RatingStars`, not read-only | Five 32 stars to give a rating with: a tap on a star gives that many, whole stars only. Keeps no rating of its own. A separate component from `DSRatingStars`: it takes taps and has no half stars |
| `DSBadge` | `Badge`, variant `empty` | A count on a brand-tinted capsule; the red variant is added when used |

A component that shows a list of choices takes them as a list of its own small class,
declared in the component's file: `DSDropdownOption` (value, label), `DSChipTab` (value,
label), `DSSegment` (value, label, icon). The class says what the component can show for
a choice; the components do not share one.

---

## 8. Open

- Font coverage for Russian, Armenian and the dram sign (§4).
