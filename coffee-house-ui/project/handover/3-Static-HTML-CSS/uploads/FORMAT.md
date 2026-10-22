# Export format for components and screens

One JSON file per component and one per screen. The consumer is a Flutter project that
builds widgets from these files **without reading the JSX**. Everything needed to reproduce
the look must be in the JSON. Behavior, data flow and interaction logic are out of scope —
only appearance.

Files: `components/<Name>.json`, `screens/<Name>.json`.

---

## 1. Skeleton

Comments below are for reading only — real files contain no comments.

```jsonc
{
  "kind": "component",                      // "component" | "screen"
  "name": "BranchCard",                     // stable across exports; screens: "Home"
  "version": "2026-09-10",                  // export date
  "description": "One sentence: what it is and where it is used.",

  // ---- root: exactly one of the two ----
  "size":  { "width": "fill", "height": "hug", "maxWidth": 328 },       // component
  "frame": { "width": 360, "height": 800, "background": "--color-bg-surface" }, // screen

  "surface": null,                          // or { "background", "radius", "border", "padding" }

  "tree": { },                              // the element tree — section 2

  "content": { },                           // screens only: the mock data shown in the render
  "variants": { },                          // every alternate look — section 3
  "uses": ["StatusPill"],                   // components referenced anywhere in the tree
  "notes": ""                               // prose: caveats, things the schema cannot express
}
```

Keys appear in this order in every file. Keys with no value are written as `null` or `{}`,
never omitted — with one exception: `size` and `frame` are conditional on `kind`, and
`content` exists only for screens.

| `kind` | root key | `content` |
|---|---|---|
| `component` | `size` | omitted |
| `screen` | `frame` | present |

---

## 2. Tree

The tree describes the **default look**: every prop at its default value. Alternate looks go
in `variants`.

Every node has `slot` (a stable name), `type`, and may have `size` and `overlay`.

### 2.1 `row` / `column`

Arrange children horizontally / vertically. Draw nothing themselves.

```jsonc
{ "slot": "details", "type": "column",
  "spacing": ["--space-xs", "--space-xs"],   // gaps BETWEEN children: exactly (children − 1) entries
  "padding": { "all": "--space-base" },      // or { "x", "y" } or { "top", "right", "bottom", "left" }
  "align":   "start",                        // cross axis
  "justify": "start",                        // main axis
  "scroll":  "none",                         // "none" | "horizontal" | "vertical"
  "size":    { "width": "fill" },
  "children": [ ] }
```

`row` and `column` always carry the full field set above; a field that does not apply is
`null`, never omitted. This keeps diffs between exports stable.

### 2.2 `text`

```jsonc
{ "slot": "name", "type": "text",
  "content":   "{name}",                     // "{prop}", a literal, or a template: "{remaining} remaining"
  "style":     "--text-body",
  "color":     "--color-text-primary",
  "lines":     1,
  "overflow":  "ellipsis",
  "align":     "start",
  "transform": "none",                       // "none" | "uppercase"
  "size":      { "width": "fill" } }
```

### 2.3 `icon`

```jsonc
{ "slot": "address.icon", "type": "icon",
  "name": "map-pin", "weight": "regular",    // Phosphor name and weight
  "size": "--icon-xs", "color": "--color-text-tertiary" }
```

### 2.4 `image`

```jsonc
{ "slot": "photo", "type": "image",
  "source":   "{image}",                     // "{prop}" or an asset key
  "size":     [72, 72],                      // or "aspectRatio": 1 with width from parent
  "fit":      "cover",
  "radius":   "--radius-md",
  "fallback": { "slot": "photo.fallback", "type": "box", "background": "--color-bg-surface-sunken" } }
```

### 2.5 `component` — another component of the system

```jsonc
{ "slot": "status", "type": "component",
  "component": "StatusPill",
  "shows": { "label": "Open", "tone": "success" } }   // what this instance displays by default
```

### 2.6 `box` — a plain rectangle: surface, ring, tap target

```jsonc
{ "slot": "bell", "type": "box",
  "size": [44, 44],
  "background": "--color-bg-surface",
  "radius": "--radius-full",
  "border": { "width": 1, "color": "--color-border-muted" },
  "padding": null,
  "child": { } }                             // one node or null
```

### 2.7 `overlay` — nodes placed on top of another node

```jsonc
"overlay": [
  { "slot": "unreadDot", "type": "box", "size": [9, 9],
    "radius": "--radius-full", "background": "--color-brand-primary",
    "border": { "width": 2, "color": "--color-bg-surface" },
    "position": { "top": 9, "right": 10 } } ]
```

### 2.8 Nesting rule

Nest only where elements **share or divide space** — one grows while another keeps its size,
several elements form a block that moves together. Do not nest to reproduce how something is
painted: a ring around an image is `border` on the image node, not two wrapper boxes; a tap
target around an icon is `size` on the icon's parent box, not an extra level.

### 2.9 Slot naming

`slot` is mandatory on every node. A node with no role of its own is named after its parent:
`address.icon`, `address.text`, `photo.fallback`. Slot names are stable across exports.

---

## 3. Variants

Every look other than the default. Data-driven (seen / unseen, open / closed, active tab)
and interaction-driven (pressed, disabled) go in the same block.

```jsonc
"variants": {
  "seen": {                                        // axis name
    "prop": "seen",                                // what drives it; "interaction" for pressed/disabled
    "cases": {
      "true": {                                    // case value
        "ring":  { "border": { "color": "--color-border-default" } },   // slot → overridden fields
        "label": { "color": "--color-text-tertiary" }
      }
    }
  },
  "pressed": {
    "prop": "interaction",
    "cases": { "true": { "root": { "scale": "--press-scale" } } }
  }
}
```

A case lists only what changes. Axes are independent — a button with variant × size × state
is three axes. A hidden node is written as `{ "visible": false }`; the spacing entry before it
is dropped too.

For screens, `variants` covers what a screen-level control switches: which tab is open, which
rail is shown.

---

## 4. Values

Every value is one of three things: a **token reference**, a **number**, or a **word from a
closed list**. Nothing else. No prose inside layout fields.

### 4.1 Token or number — decided by meaning, not by value

| The value is a … | Write |
|---|---|
| gap, padding, margin | `--space-*` token |
| color | a color token |
| text style | `--text-*` token |
| icon size | `--icon-*` token |
| corner radius | `--radius-*` token |
| an element's own width, height, diameter, tap-target size | a **number** |

A number that happens to equal a token's value is still a number when it is an element's own
dimension: a 72×72 photo is `[72, 72]`, not `--row-height-two-line`.

A gap that is off the spacing scale (e.g. 6) → nearest token, and say so in `notes`.

Every token reference must exist in `_ds_manifest.json`.

**Remapping.** When the source uses a token of the wrong kind (a radius authored as
`--space-base`) or a token that does not exist (`--color-bg-muted`), write the existing token
of the correct kind with the same resolved value, and record the original in `notes`.

### 4.2 Closed lists

```
kind        component | screen
type        row | column | text | icon | image | component | box
width/height   fill | hug | <number>
align       start | center | end | baseline | stretch
justify     start | center | end | between
scroll      none | horizontal | vertical
overflow    ellipsis | clip | wrap
transform   none | uppercase
fit         cover | contain
weight      thin | light | regular | bold | fill | duotone
```

### 4.3 Where prose goes

`description` and `notes`. Nowhere else. If something cannot be expressed in the schema
(generated artwork, a paint effect), describe it in `notes`.

---

## 5. Stability

These files are diffed between exports to find what the design changed. That only works if
the form does not move.

- Same keys, same order, same names in every file and every export.
- Never rename a key. Never add a key that is not in this document.
- A field is either filled in every file where it applies, or not part of the format.
- Slot names do not change between exports unless the element itself changed.

---

## 6. Do not

Each of these appeared in a previous export of `BranchCard`.

| Do not | Instead |
|---|---|
| `"name": "Body Regular / --color-text-primary (ellipsis)"` | separate `style`, `color`, `lines`, `overflow` fields |
| `"display": "flex"`, `"border": "none"`, `"borderRadius": 0` | `type: row`; `surface: null` |
| `"tag": "button\|div"`, `"renders as <button>"` | nothing — web markup is out of scope |
| `layout` in one export, `structure` in the next | one name, forever |
| a new top-level key such as `keeps` | `notes` |
| geometry on one rail, none on the other four | every rail carries `spacing`, item `size`, `scroll` |
| `"background": "--color-bg-muted"` (no such token) | a token that exists in the manifest |
