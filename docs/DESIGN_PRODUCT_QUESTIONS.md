# GastroSuit — Questions for Design and Product

Status: open list · 2026-10-30

Behaviour the design or the PRD leaves open, collected during the architecture sessions,
to settle with the designer and the product owner. Questions for the backend are in
`IMPLEMENTATION_NOTES.md` (questions for the backend).

Each entry: what is unclear, why it matters, and the proposal from the sessions if there
is one. Audience: **D** — design, **P** — product.

---

## Menu and product

### 1. Quick "+" on a product that needs a choice — D, P
The menu card's "+" adds without opening the product. A product may require a choice
(size, milk).
Proposal: "+" adds the default choice (default size, pre-selected options) when every
required group can be filled by defaults; otherwise "+" opens the product screen.

### 2. "+" turning into "×" after adding — D
For a product with variants the cart may hold several lines of it (a small and a large
latte), so "×" has no single line to remove.
Proposal: show the quantity of that product in the cart instead of "×"; remove only in
the cart.

### 3. Add-on quantity steppers — D, P
The product screen shows quantity steppers on paid add-ons. The API selects an option at
most once. Either the design drops the steppers or the backend adds quantities.

### 4. "Anything else?" rail on the product screen — D, P
No data source for it in the API: backend recommendations, a list set in the admin, or
products of the same category.

### 5. Portion per size — D
The design shows "300 ml" next to the price. The API has one portion per product, not
per size.

### 6. Gallery, allergens, filters — D, P
In the API or the PRD but not in the design: a product gallery, allergens, menu filters
(by tags). Needed in the first versions or not.

### 7. Nutrition facts — P
The design shows calories, proteins, fats, carbohydrates. The POS data has no fixed
shape for it (also a backend question).

### 8. A product in several categories — P
The API allows one category per product (e.g. an iced latte under both "Iced Coffee" and
"Iced Drinks").

---

## Cart

### 9. Editing a cart line — D
The design has an edit action on a cart line. Proposal: it opens the product screen with
the line's current choice; saving replaces the line.

### 10. Unavailable lines — D
A line becomes unavailable (stop-list, option ran out, another branch). An order is
refused while such lines exist. Options: show them greyed with the reason and block
checkout until removed, or offer "remove unavailable" in one tap.

---

## Branches

### 11. Ordering from a branch page — D, P
The branch page shows that branch's menu with "+". Agreed: browsing does not change the
active branch; adding a product does. Open: the cart button at the bottom of the page
shows the active branch's cart until the first add.

### 12. Moving a non-empty cart to another branch — D, P
The cart moves with the active branch (prices and availability re-checked). Whether the
user confirms it ("Your cart moves to Cascade; prices and availability may change").

### 13. Changing the default branch in the settings — P
Whether it also changes the active branch, in particular when the cart is not empty.

### 14. No default branch — D, P
How the active branch is chosen when the user has no default branch (likely a branch
selection screen in the first versions).

### 15. Branch map — D
The PRD has a map with pins and a "select branch" action; the design has no map screen.
It should lead to the same branch page as the list.

---

## Home and history

### 16. Buy again — D, P
Agreed: a tap moves the active branch to the purchase's branch and adds the same choice.
Open:
- two different choices of one product in one branch: one card or two;
- the product or an option is no longer available;
- the price shown: today's or the one paid;
- confirming the branch change when the cart is not empty.

### 17. History rows — D
The design shows one product per row with a date and a price. The API returns orders
with lines. Is a row an order line or a whole order? Order lines carry no image: take it
from the menu (missing if the product left the menu) or ask the backend.
