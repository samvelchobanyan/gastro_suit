# GastroSuit — Questions for Design and Product

Status: open list · 2026-11-12

Behaviour the design or the PRD leaves open, to settle with the designer and the product
owner. Questions for the backend are in `IMPLEMENTATION_NOTES.md` (questions for the
backend).

Each entry: what is unclear, and the proposal from the architecture sessions if there is
one.

---

### 1. Quick "+" on a product that needs a choice — decided
Decided (2026-11-12): the card's "+" adds the default choice (default size, pre-selected
options) without opening the product. When a required group cannot be filled by defaults
(none is marked, or the marked one has run out), "+" opens the product screen instead.
Tapping the card itself always opens the product screen.

### 2. The card's stepper with several lines of one product — decided
Decided (2026-11-13): the card shows no stepper. The "+" stays a "+" after adding; what
the cart holds is seen in the cart, and quantities are changed in the product sheet
before adding and in the cart. The cart may hold several lines of one product (a small
and a large latte), so a stepper on the card had no single line to count or to take
from.
Left for the designer: a count next to the "+" (the product's total across its lines,
display only) as feedback on the card itself.

### 3. Unavailable cart lines
A line becomes unavailable (stop-list, an option ran out, another branch). An order is
refused while such lines exist. How they are shown and removed: greyed with the reason
and checkout blocked until removed, or "remove unavailable" in one tap.
Built by default (2026-11-13): the line is dimmed, says "Not available at this branch
now" and can only be removed. The server's reason is a code, not words, so one sentence
is shown for every reason.

### 4. Moving a non-empty cart to another branch — decided for now
Decided (2026-11-13): the cart does not move. The backend keeps one cart tied to one
branch and replaces it when a product of another branch is added. So wherever the
active branch would change while the cart is not empty, the user is asked first: on
"yes" the cart is cleared and the branch changes, on "no" nothing changes. This holds
for the branch picker, for adding from another branch's page ("+" and the product
sheet's "Add") and for changing the branch inside the cart. An empty cart changes
branch without a question.
The question is the handoff's `Dialog` with our own words; no page of the design draws
it.
To revisit when the backend can move a cart between branches (prices and availability
checked again): the question then becomes the move.

### 4a. A guest adds to the cart — decided
Decided (2026-11-13): the server keeps a cart only for an account. A guest who taps "+"
or "Add" is sent to sign in, and the product is added when they come back signed in.
A cart kept on the device for a guest is not built.

### 5. First branch and no default branch — decided
Decided (2026-11-09): on every start the active branch is the nearest one; without a
position, the default branch set by the admins for all users. The user's choice is not
kept across restarts. Details in `IMPLEMENTATION_NOTES.md` §7.
Still open: when the app asks for the location permission (at the first start, or after
a screen explaining why).

### 6. Branch map
The PRD has a map with pins and a "select branch" action; the design has no map screen.
It leads to the same branch page as the list.

### 7. Default branch setting in the profile — dropped
There is no per-user default branch any more (see 5). The design's `DefaultBranch`
screen is not needed; to confirm with the designer.

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

### 17. Guest access or sign-in first — decided: guest access
Decided (2026-11-09): the app can be used without signing in. Menu and branches are
public in the API; cart, loyalty, wallet and orders need an account, and sign-in is asked
for when the guest reaches them.
Still open: how the sign-in and registration screens look, and where exactly the guest is
asked to sign in. Until there is a design: a temporary sign-in screen opened from the
Profile tab.

### 18. Feedback sheet: states the design does not draw
The design shows only the empty form (stars, text, "Send"). Built by default until the
designer answers:
- The sheet opens on the rating the user gave earlier, since sending again replaces it;
  while that loads, the form's shapes are shown as a skeleton, and a failed load shows
  the generic error with "Try again".
- "Send" is dimmed until a star is chosen; while sending it shows a spinner and the form
  takes no input.
- A rating that was not accepted leaves the sheet open with what was entered and one
  line of error text above the button.
- An accepted rating closes the sheet with no confirmation.
- The words are limited to the API's 1000 characters with no counter.
- A guest who taps the rate button signs in and then gets the sheet without tapping
  again.

### 19. Product sheet: what the design leaves open
Built by default until the designer and the product owner answer:
- The sheet starts 32 under the status bar. The design has 32 from the top of a frame
  that draws no status bar (the same question as the branch screen's header).
- The fill under the photo is the raw `gray-900`; `bgInverse`, the role of the same
  value, is used.
- A size or an option the branch has run out of is not drawn: it is dimmed and takes no
  taps. A stopped product opens with "Add" dimmed.
- The price under the name is that of the chosen size; "Add" carries the size with the
  chosen options, times the quantity. The design shows one fixed price in both.
- The line under the price is left out when nothing follows it (no description, sizes
  or options).
- A drag down from the top of the content, or a fling down, closes the sheet.
- Not built, waiting for an answer:
  - "Anything else?": the API has no list of products to suggest. Where it comes from
    (featured products, the same category, a list the merchant sets).
  - "Nutrition facts": the API's nutrition is free-form and empty for every product on
    the dev server; the info button is not shown until its shape is fixed.
  - The stepper inside an option row (quantity per option): not supported by the API.
- The heart (favourites) comes with that feature.

### 20. Cart sheet: what the design leaves open
The design's "Basket" is the cart and the checkout in one sheet. Built so far: the
branch, the time, the products and the tip. Built by default until the designer and the
product owner answer:
- The order button shows the total and takes no taps: placing an order, the payment
  method and the success screen are the next stage.
- An empty cart (and a guest's): "Your basket is empty" under the order title, with
  "Add products"; no time and no tip.
- While the cart loads a spinner is shown; a failed load shows the generic error with
  "Try again".
- A line shows the price of one piece, as the design does. Its quantity does not go
  under one; the bin removes it. The design's pencil (edit) is not shown: the API
  changes only a line's quantity.
- A change the server refuses leaves the cart as it was and shows one line of error
  text over the order button.
- The branch is a row with a caret that opens the branch picker; the design shows a
  plain name on a branch's page and a dropdown elsewhere.
- "Add products" closes the sheet, back to the menu it was opened over.
- The tip part is shown only where the branch takes tips. "Other" opens a field for a
  whole amount. The limit (no more than the cart) is checked when the order is placed.
- The time and the tip start over each time the sheet is opened.
- The Order tab's cart bar is labelled "Branch", not the design's "Nearest location":
  the branch is the nearest only until the user picks another.
- Not answered by the API, to settle with the backend: the times an order can be asked
  for. Worked out on the device for now as in the design's row: "ASAP", then the next
  round ten minutes and steps of 10, 15, 15, 30 and 30 minutes, no later than the
  branch closes today.
