# GastroSuit — Questions for Design and Product

Status: open list · 2026-11-12

Behaviour the design or the PRD leaves open, to settle with the designer and the product
owner. Questions for the backend are in `IMPLEMENTATION_NOTES.md` (questions for the
backend).

Each entry: what is unclear, and the proposal from the architecture sessions if there is
one.

---

### 1. "+" on a product with choices — decided
Decided with the designers (2026-11-17): on a product with choices (sizes or add-ons,
required or not) the card's "+" opens the product screen, and the user chooses there. On
a product without choices "+" adds one piece. The same holds for the plus of the card's
stepper (§2). Tapping the card itself always opens the product screen.
Replaces the decision of 2026-11-12 ("+" added the default choice without opening the
product).

### 2. The card's stepper with several lines of one product — decided
Decided with the designers (2026-11-17): once the cart holds a product, its card shows a
stepper in place of the "+".
- The number is the product's pieces across all its lines (a small latte ×2 and a large
  one ×1 show 3). It is shown only; it cannot be typed.
- Plus: as the card's "+" (§1) — adds a piece of a product without choices, opens the
  product screen of one with choices.
- Minus: takes one piece from the last of the product's lines in the cart; the line goes
  when that was its only piece. "Last" is the line added or changed last, so after the
  quantity of an older line is changed in the cart, the minus takes from that one.
- A product the branch has stopped shows neither the "+" nor the stepper, even while
  the cart holds it; it is removed in the cart.
- The number changes when the server has answered. A tap made before that is not
  taken.
Replaces the decision of 2026-11-13 (no stepper on the card).

### 3. Unavailable cart lines
A line becomes unavailable (stop-list, an option ran out, another branch). An order is
refused while such lines exist. How they are shown and removed: greyed with the reason
and checkout blocked until removed, or "remove unavailable" in one tap.
Built by default (2026-11-13): the line is dimmed, says "Not available at this branch
now" and can only be removed. The server's reason is a code, not words, so one sentence
is shown for every reason.

### 4. Moving a non-empty cart to another branch — decided
Decided (2026-11-16), now that the backend can move a cart: choosing another branch in
the branch picker takes the cart along, wherever the picker was opened from, and asks
nothing. Its products are priced at the new branch; one that branch cannot make stays
in the cart, marked unavailable (§3). What the cart would look like there is not
checked before the move.
Adding from another branch's page ("+" and the product sheet's "Add") is different: the
backend still replaces the cart with the one new product. There the user is asked
first: on "yes" the product is added and the old cart is gone, on "no" nothing changes.
The question is the handoff's `Dialog` with our own words; no page of the design draws
it.
To revisit: a question before the move ("2 of 5 products are not sold there"), which
the backend can answer in advance, and whether adding at another branch should move
the cart instead of replacing it.

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

Built (2026-11-16): Home's "Order status" block, as drawn, with its four steps. Left
open by the design, to discuss with the designer:
- The API has more statuses than the four steps. An order that awaits payment, whose
  payment failed, or that was cancelled has no block; a cancelled order's block just
  disappears, though the user has paid and is refunded.
- Several orders on their way: one card each, newest first (the design draws one).
- The number is the till's short one (`posNumber`), shown as soon as it exists; before
  that the place is empty.
- ~~The block cannot be tapped~~ — since 2026-11-17 a card opens the order's details
  (§23). The design does not draw the tap.

### 9. Viewing an order with several products — answered by the design
The newer design has "Order details", opened from a row of the history, and a "+3" on
the photo of an order with more products. Built 2026-11-17 (§23).

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

### 15. Wallet money does not expire — revised 2026-11-16
Revised: what the user topped up themselves does not expire; money from elsewhere (a
gift, a credit from the restaurant) may. The API agrees: `expiring` and `expiryDate`
on the wallet. The earlier text:

The PRD (5.5 Wallet) lets gift-card and promo value in the wallet expire. Decided in the
sessions: wallet money never expires; only loyalty points can expire.

### 16. "Push notifications" switch on the profile
Until decided (2026-11-17): the switch is on the profile and moves, but turns nothing
on or off and is not remembered.
Whether it is the consent to marketing pushes (the PRD has per-channel marketing
consents; the API has push, SMS and email consents) or turning all notifications on the
device on and off.

### 17. Guest access or sign-in first — decided: guest access
Decided (2026-11-09): the app can be used without signing in. Menu and branches are
public in the API; cart, loyalty, wallet and orders need an account, and sign-in is asked
for when the guest reaches them.
Sign-in is the sheet of §26 (2026-11-19): by phone and a code, opened from the Profile
tab and wherever an action needs an account. There is no separate registration: a number
without an account gets one on its first sign-in.

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
- With sizes, the portion next to the price is the chosen size's own.
- An option one product may carry several of shows a quantity at the end of its row
  once it is chosen. The quantity goes from one up; the checkbox takes the option back.
- "Anything else?" shows the products the merchant suggests with this one and is left
  out when there are none. A card opens that product's sheet over this one; its plus
  adds the product as every card's plus does, and stays a plus (the design turns it
  into a cross that removes the product again).
- Not built, waiting for an answer:
  - "Nutrition facts": the API's nutrition is free-form and empty for every product on
    the dev server; the info button is not shown until its shape is fixed.
- ~~The heart (favourites) comes with that feature~~ — built 2026-11-17 (§24).

### 20. Cart sheet: what the design leaves open
The design's "Basket" is the cart and the checkout in one sheet: the branch, the time,
the products, the tip and the payment method. Built by default until the designer and
the product owner answer:
- The payment method is a saved card: the user's default one until they pick another
  in the list. The list is the saved cards and "New card". Paying with a new card (on
  the bank's page) is not built: its row is shown and takes no taps. The design's
  wallet, loyalty points and voucher are not offered: the API does not treat them as a
  way to pay but as an amount taken off the order, and the design for it is expected
  to change (decided 2026-11-16).
- A card is named "Card •••• 1111": the API gives the masked number and no brand. The
  design's amount at the end of the row is not shown: a card has none.
- A user without saved cards sees "New card" as the payment method and can still
  order: whether the order needs a card is the server's to say.
- The order button places the order. Once it is placed, the success screen takes the
  sheet's place as a screen of its own (the design draws it inside the sheet). A
  refused order leaves the cart as it was, with the reason over the button.
- "Track order" on the success screen closes it and opens the Home tab, as in the
  design, where the order's status is shown (§8).
- An order left unpaid (a declined card) stays on the server as it is; the next order
  is a new one.
- An empty cart (and a guest's): "Your basket is empty" under the order title, with
  "Add products"; no time and no tip.
- While the cart loads a spinner is shown; a failed load shows the generic error with
  "Try again".
- A line shows the price of one piece, as the design does. Its quantity does not go
  under one; the bin removes it.
- The pencil opens the product's sheet on what the line holds (its size, options and
  quantity) with "Save" in place of "Add" and without "Anything else?". The design
  draws the pencil and gives it nothing to do. "Save" puts the new choice and
  quantity in the line, which keeps its place, and closes the sheet; with nothing
  changed it only closes it. A choice another line of the product already holds
  joins that line. A refused save leaves the sheet open with the reason over the
  button. A line the branch cannot make has no pencil.
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

### 21. Loyalty card and wallet: what the API does not give (2026-11-16)
Built: Home's loyalty card and wallet, the sheet with the card's code, the sheet of the
wallet's balance. Drawn in the design and left out, or changed, for want of data:
- **A tier's percent.** The card and the sheet show "Master 10%"; the API gives a tier
  only a name. Shown: the name alone.
- **Progress to the next tier** ("Spend ֏35,000 more to reach Gold 15%") and the "how
  the programme works" sheet with its table of tiers: no next tier, no spend, no list of
  tiers in the API. Both left out, with the sheet's "i" button.
- **The list of gift cards** in the wallet (sender, amount, its own date). The API gives
  the gifts as one sum (`giftCard`) and one amount that expires next (`expiring`,
  `expiryDate`), not saying which part it belongs to. Shown: the sum, and one row
  "Expiring balance" in the list's place. To ask the backend: the gifts as a list.
- **`promo`** in the wallet and **`cashback`** in the loyalty balance: given by the API,
  not drawn. Not shown.
- **An urgent date** is red in the design without saying how close it is. Taken as 7
  days or less.
- **The card's code where the cashier scans it** is drawn light on dark. Built dark on a
  light plate: not every scanner reads a code with its colours swapped. The small code
  on Home's card is light on dark as drawn. To confirm with the designer.
- **Topping up** is built as drawn, with two additions: the limits of the amount under
  its field ("From ֏500 to ֏500,000"), and a message when the payment needs the bank's
  page. The card row is shown, but a top-up cannot be paid with a saved card through
  the API yet (`IMPLEMENTATION_NOTES.md` §19).
- **A guest** sees both blocks empty (decided 2026-11-19): a balance of zero, no
  points, no tier and no code on the card. A tap on either, or on "Top up", opens the
  sign-in sheet; after signing in the user is back on Home, and what they tapped is
  not opened for them. The design does not draw Home for a guest.

### 22. Profile: what is shown and what is not (2026-11-17)
Decided with the product owner for the first step of the Profile tab:
- **A guest** sees a reduced profile: the way to sign in, the language and the links.
  The design does not draw it.
- **The status block** ("Bronze", `UserStatus`) is not shown. It is a paid status
  bought for a number of months, apart from the loyalty tier; the backend turns it on
  per client, and the API has nothing for it yet.
- **"Invite a friend"** is shown with its button; the button does nothing until the
  invite screen is built. It too is to be turned on per client from the backend.
- **"Geolocation"** is not shown: a switch in the app adds nothing to the system's
  permission.
- **"Bank cards"** is shown and leads nowhere until its screen is built. The pencil
  on the user card opens "Edit profile" (§25). "History" (§23) and "Favorite products" (§24) open theirs.
- **"Delete account"** works: it asks in the app's usual two-button dialog, then
  deletes and signs out. The design draws no confirmation; to be replaced when it does.
- **"Terms & conditions", "About developer"** are placed and lead nowhere: whether
  they open a page in the app or a site is not decided.
- **The language** is kept on the phone only and is not sent to the user's profile on
  the server. Each language is named in itself ("Հայերեն", "Русский", "English"); the
  design names them in the app's language. To confirm with the designer.
- **A user without a name** is shown by the phone or the email they sign in with; a
  user without a phone shows the email under the name.

Not in the design system's colour roles, taken from the nearest role; to confirm with
the designer:
- the avatar's fill behind the initials (`accent-100`) is the brand-tinted surface
  (`accent-50`), and the initials are 14 px, not 15;
- the phone on the dark user card (`gray-500`) is the quiet text on dark used on the
  wallet card.

### 23. History and order details (2026-11-17)
Built: "History" with its two tabs, opened from the profile, and "Order details",
opened from a row of the history and from Home's order status. To confirm with the
product owners and the designer:
- **Which orders the history lists.** All of them except the ones that were never
  paid for (awaiting payment, payment failed). A cancelled order is listed.
- **A cancelled order looks like any other in the list**: the design's row has no
  status. Its details say "Cancelled".
- **"Guests" and "Received"** in the details are left out: the API has neither the
  number of guests nor the time the order was handed over. Whether a pickup order
  needs them at all.
- **"Transactions"** lists only what moved through the wallet (top-ups, and payments
  from it): the API lists nothing else. Card payments, voucher purchases and loyalty
  points are added when the backend gives them. A top-up that was not paid for, or
  failed, is not listed.
- **"Repeat order"** is not built: the second step, after the backend is asked how.
- **The photos** are the ones the products have in the branch's menu now; a product
  that left the menu shows the placeholder.
- **"Payment method"** always says "Online payment": the app pays no other way.
  **"Payment status"** is shown only as "Paid"; what a cancelled order should say
  (refunded?) is open.
- **A discount and a tip** get their own rows between the subtotal and the total when
  the order has them; the design draws the subtotal and the total only.
- **States the design does not draw**: loading, a failed load, an empty list ("No
  orders yet", "No transactions yet"), the next page on its way.
- **The order's number** is the till's short one, as on Home; before the till gives
  one the row and the details show none.

### 24. Favourite products (2026-11-17)
Built: the heart on the product sheet's photo, and "Favorite products" opened from the
profile. Decided with the product owner:
- **The favourites are one set for the account**; the screen shows them as the active
  branch sells them, as the menu does. A favourite the active branch does not sell is
  not listed; it is listed again at a branch that sells it. The count on the profile
  counts them all, so it may be more than the list shows.
- **A favourite the branch has stopped is listed as any other, not dimmed.** In the
  menu the branch is named on the screen, so a dimmed product explains itself; in the
  list of favourites a dimmed product would read as something wrong with the list.
  The product sheet it opens says that it cannot be ordered now.
- **A guest who taps the heart is sent to sign in**, and the product becomes a
  favourite on coming back signed in — as with rating a branch.
- **The heart changes at once**, before the server answers; a refused change goes
  back and is said.
- **Home's "Favourites" rail** is not built: it comes with "Buy again".

States the design does not draw: loading, a failed load, no favourites yet, none of
them sold at this branch.

### 25. Edit profile (2026-11-18)
Built as drawn: the photo, first and last name, the birthday as three lists, the
city, the gender, "Save". The phone and the email are not on the screen, and the
server does not let them be changed.
- **The city** is chosen from the cities the organisation's branches stand in (the
  list the branch picker uses). The design's list of cities has no stated source.
- **"Save"** is active once something is changed and the birthday is chosen in full
  or not at all; it goes back to the profile. A refused save is said over the button.
- **The photo is saved the moment it is chosen**, apart from "Save". A tap on it asks
  where to take the picture from: the gallery or the camera.

Open, for the designers:
- **Removing the photo.** The server can; the design draws no way to. Not built.
- **The sheet that asks "gallery or camera"** is not drawn; it is built from the
  list rows of the profile.
- **Taking a value back.** A birthday, a city or a gender once chosen can be changed
  but not cleared: the lists and the radio buttons have no "none".

### 26. Sign-in sheet (2026-11-19)

Built from `LoginSheet`: the phone number, then the code from the SMS. Sign-in by
password is gone from the app in this version.

- **Six cells, not four.** The page draws four; the server's code has six digits
  (decided 2026-11-19). Six cells of 48 with their gaps fill the 360 frame exactly; on
  a narrower screen they shrink together.
- **"Logout" opening the sheet is the prototype's shortcut.** In the app "Log out" signs
  out; the sheet is opened by "Sign in" on the guest's profile and by any action that
  needs an account.
- **A refusal is not drawn.** A refused number or code is said in one line under the
  field, and the code's cells are outlined as wrong until the user types again.
  For designers: how a wrong code, too many attempts and no connection should look.
- **The button while a request is on its way** shows the spinner alone, as every button
  of the app does; the page draws the spinner with the word "Checking".
- **The number is shown as typed** in the code step's text (`+374 77123456`), not
  grouped as on the page (`+374 77 123 456`): the grouping differs by country.
- **"Resend code" has no wait drawn.** It can be tapped again once "Sent" goes back,
  after three seconds; the server is what limits the requests. For designers: whether
  a countdown is wanted.
- **The scrim is not blurred**, unlike on the page: it is the scrim every sheet of the
  app has.

### 27. Floating navigation (2026-11-19)

Built from `NavFloatingIcons` as the four tab pages draw it (glass, light).

- **The loyalty card's item is not a tab.** It opens the card over the tab shown. A
  guest is asked to sign in instead; an instance without a loyalty programme has the
  four tabs only (decided 2026-11-19).
- **A tab is shown at once.** The prototype waits 400 ms before leaving a page so that
  its animation is seen; in the app the plate travels while the tab is already there.
- **The icons not chosen are the text colour** (`textPrimary`), not the page's
  `gray-800`: the theme has no colour of that value, and one shade is not worth one.
- **The glass is the shared one** (`--glass-bg` 80% white, `--glass-blur` 26 since this
  export): the Order tab's cart bar changed with it.
- **No cart counter on the navigation**: the pages draw none.
- The dark variant of the component is not built: no page uses it.

