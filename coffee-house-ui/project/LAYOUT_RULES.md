# Layout Fundamentals — Strict Rules

These rules are **binding**. Every screen and component we design MUST follow them exactly. No exceptions.

## Screen width
- **360px** — the single design width for all screens.

## Grid
- **4px baseline grid.** Every dimension, spacing value, and line-height is a multiple of 4px.

## Layout

1. **4 columns maximum.**
2. **Side margins:** 16px from the left and 16px from the right.
3. **Gutter:** 8px between columns.
4. **Allowed column configurations** (content area = 328px wide):
   - **a.** 4 equal columns — each **76px**.
   - **b.** 2 equal columns — each **160px**.
   - **c.** 1 small column (**76px**) + 3 combined columns (**244px**).
   - **d.** 1 full-width column — **328px**.

### Math check
- 360 − 16 (left) − 16 (right) = **328px** content area.
- 4 columns: 4 × 76 + 3 × 8 (gutters) = 304 + 24 = **328px** ✓
- 2 columns: 2 × 160 + 1 × 8 = 320 + 8 = **328px** ✓
- 1 + 3: 76 + 8 + 244 = **328px** ✓
- Full width: **328px** ✓

---

**Any design created in this project must strictly conform to the above.** Column widths, margins, and gutters are fixed — do not improvise other splits.
