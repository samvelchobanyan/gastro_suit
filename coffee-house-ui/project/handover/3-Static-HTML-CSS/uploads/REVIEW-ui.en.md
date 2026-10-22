# Review of the UI project export

Reviewed: `ui/export/screens` (Home, Order), `ui/export/assets` (32 files),
`ui/export/components` (19 files), `ui/export/tokens`.

**Verdict: the screens are buildable.** Below: what blocks the build, then consistency with
the Design System, then form.

Tags: **[required]** affects what we build · **[recommended]** · **[cosmetic]**.

---

## Screens — `screens/`

**1. [required] The promo tiles have no geometry.**
In `Home.json` the `custom-promo-tiles` section contains only image paths. It is not a
Design System component — the `note` says so. Not stated: tile width, corner radius, shadow.
The aspect ratio can be derived from the files themselves (512×264); the rest cannot. For
anything that is not a component, the screen must describe the look itself — as a node:
`{ "type": "image", "size": [<width>, "auto"], "radius": "--radius-…", "shadow": "--elevation-…" }`.

**2. [recommended] Screen side margins are not stated.**
Neither screen says how far the content sits from the screen edge. We take the
`--layout-margin` token (16px), but that is a guess. State it once at screen level.

**3. [recommended] Bottom bar: pinned flag and chrome.**
In `Order.json` the cart bar has `"sticky": "bottom"`, while `BottomNavigation` has no such
flag on either screen. Its surface — background and top line — is not described either.
Clear from context, but better stated explicitly.

**4. [cosmetic] Prose inside fields.**
`Order.json` has fields that should hold one value but hold a phrase:
- `"icon": "plus/x toggle"` — the field should hold one icon name. State which one is the
  default; describe the other in `variants`.
- `"variant": "filled/tonal toggle"` — the same.
- `"background": "var(--glass-bg) with var(--glass-border), backdrop-filter blur(…)"` —
  three properties in one string. Write as `surface: { background, border }`.

**5. [cosmetic] Spacing keys are named ad hoc.**
`spacingAfterTitle` and `titleSpacingAfter` are the same thing; `sectionSpacingAfter` is the
same `spacingAfter` one level down; `spacingAround` and `innerPadding` are the section's
`padding` and the nested box's `surface.padding`. We propose a fixed set:

| Key | Meaning |
|---|---|
| `spacingAfter` | distance to the next section |
| `titleGap` | distance between a section's title and its content |
| `gap` | distance between items inside a section |
| `padding` | distance from the section edge to its content |

Everything nested inside a section follows the node model of the component format.

---

## Assets — `assets/`

**6. [required] Eight products are present in two versions.**
Each exists as `ch_*.png` (600×600, referenced by the screens) and as `<name>-<hash>.png`
(500×500, referenced by nothing): bumble cherry, chocolate muffin, dubai cheesecake, hot
salted caramel matcha, ice americano, ice creamed cheese, iced fantasy coffee, raf
strawberry. Which version is current? If 500×500 is the newer one, the screens reference the
old files.

**7. [cosmetic] Eleven file names contain spaces.**
We will rename on import, but exporting without spaces is better.

---

## The Design System snapshot inside the UI project

Along with the screens, the UI project exports its own copy of the Design System:
`components/` (19 files) and `tokens/`. This copy **lags behind** the Design System's own
export.

**8. [required] `components/` is a stale snapshot.**
15 components exist both here and in the Design System export, and the content differs.
Here `LoyaltyPointsCard` and `Wallet` have `surface: null`; in the Design System they have
a `surface` with background `--gray-900`. Here the bell dot in `Greeting` has no `position`;
in the Design System it does. Three components (`Button`, `StatusPill`,
`MembershipTierPill`) exist only here.

Two options, either one works:
- refresh the Design System snapshot in the UI project before exporting, so that it matches
  the Design System's own export;
- or do not export `components/` from the UI project at all — we take components from the
  Design System export; it is enough for screens to reference them by name.

**9. [required] `tokens/` — the same snapshot.**
The Design System's foundations define six tokens that are not in this CSS: `--glass-bg`,
`--glass-border`, `--glass-blur`, `--button-height-xxs`, `--button-height-2xs`,
`--text-body-sm-semibold`. Meanwhile `Order.json` already uses the glass tokens. Refresh the
snapshot (or do not export tokens from the UI project — see item 8).

**10. [cosmetic] `_ds_manifest.json` contains only token names**, without values or types.
Nothing is lost — the values are in the CSS — but the manifest cannot serve as a single
machine-readable source.
