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

### 8. Order tracking screen
The success screen after placing an order has a "Track" action, but there is no screen
for an order and its status (the PRD has "order & status").

### 9. Viewing an order with several products
History shows one product per row. There is no way to open an order and see all its
products, the pickup branch and time, and the amounts.

### 10. Branch open but not taking orders
The PRD asks to show the guest a branch's ordering availability (active / ordering off /
temporarily closed). The design shows only open / closed. How a branch that is open but
does not take orders (or not from the app, or outside ordering hours) is shown in the
list, on its page and in the cart.

### 11. Story viewer
The design has only the story circles on the home screen. There is no screen for
watching a story: how slides advance, where the link button is.

### 12. Seen stories in the row
Whether seen stories move to the end of the row or keep their place.

### 13. Banner end time
The API gives each banner an end time (`endsAt`). The server returns only banners on show
when the list loads, but a banner whose time ends while the app is open stays until the
next refresh. Whether the app should hide it once its time has passed (checked when the
screen is shown, not live).

### 14. Points and cashback — one balance or two
The PRD (5.3 Loyalty) shows points and cashback as two separate balances, each enabled
by the operator, and itself marks this as unconfirmed. The design shows points only, and
the backend reports one bonus balance (with iiko, cashback accrues as points). For now
the app follows the API: one points balance. If cashback must be money, the wallet
already has a promo part.

### 15. Wallet money does not expire — to confirm
The PRD (5.5 Wallet) lets gift-card and promo value in the wallet expire. Decided in the
sessions: wallet money never expires; only loyalty points can expire.

### 16. "Push notifications" switch on the profile
Whether it is the consent to marketing pushes (the PRD has per-channel marketing
consents; the API has push, SMS and email consents) or turning all notifications on the
device on and off.
