# GastroSuit — Questions for Design and Product

Status: open list · 2026-10-30

Behaviour the design or the PRD leaves open, to settle with the designer and the product
owner. Questions for the backend are in `IMPLEMENTATION_NOTES.md` (questions for the
backend).

Each entry: what is unclear, and the proposal from the architecture sessions if there is
one.

---

### 1. Quick "+" on a product that needs a choice
The menu card's "+" adds without opening the product. A product may require a choice
(size, milk).
Proposal: "+" adds the default choice (default size, pre-selected options) when every
required group can be filled by defaults; otherwise "+" opens the product screen.

### 2. "+" turning into "×" after adding
After "+" the card's icon becomes "×" (remove from the cart). The cart may hold several
lines of one product (a small and a large latte), so "×" has no single line to remove.
Proposal: show the quantity of that product in the cart instead of "×"; remove only in
the cart.

### 3. Unavailable cart lines
A line becomes unavailable (stop-list, an option ran out, another branch). An order is
refused while such lines exist. How they are shown and removed: greyed with the reason
and checkout blocked until removed, or "remove unavailable" in one tap.

### 4. Moving a non-empty cart to another branch
When the active branch changes, the cart moves with it; prices and availability are
checked again. Whether the user is asked to confirm ("Your cart moves to Cascade; prices
and availability may change") or it moves silently.

### 5. First branch and no default branch
How the active branch is set the first time and what the flow is when the user has no
default branch (likely a branch selection screen in the first versions).

### 6. Branch map
The PRD has a map with pins and a "select branch" action; the design has no map screen.
It leads to the same branch page as the list.

### 7. Changing the default branch — to confirm
Agreed in the sessions: a new default branch also becomes the active branch when the cart
is empty; with a non-empty cart the active branch stays.
