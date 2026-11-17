# GastroSuit — Implementation Notes

Status: working notes · 2026-10-29

Implementation details agreed in the architecture sessions, to start development from.
They are not canonical: the implementation agent reviews them with the user before
coding, and whatever turns out to be structural moves into `ARCHITECTURE_SPEC.md`.
Meaning and rules of the entities are in `DOMAIN_SPEC.md`; the backend contract is in
`guestpilot-api.swagger.json` and `guestpilot-mobile.postman_collection.json`; the backend
source is `samvelchobanyan/guestpilot`.

Each item is marked **agreed** or **proposed** (to be discussed during development).

---

## 1. Product mapping (`ItemResponse` → `Product`) — agreed

- `modifiersJson` groups:
  - the group with `kind: "size"` becomes `Product.sizes`; every other group becomes
    `Product.optionGroups`.
  - `ProductSize.price` = item `price` + the option's `price` (the API gives the size as
    a surcharge over the smallest size, and the item's `price` is the smallest size).
  - Exactly one size is the default: the one with `restrictions.defaultQuantity > 0`,
    else the first (the API orders sizes from the cheapest).
- Group `restrictions.minQuantity` → `minSelected` (absent = 0);
  `restrictions.maxQuantity` → `maxSelected` (absent = null, no limit).
- Option: `isDefault` = `restrictions.defaultQuantity > 0`;
  `isAvailable` = id not in the item's `unavailableModifiers`.
- Group getters: `isRequired` (min ≥ 1), `isSingleChoice` (max = 1), `isPaid` (any option
  price > 0).
- `portion` → `Portion(amount, unit)`; `null` stays null.
- Not mapped for now: `internalName` (fallback only), `slug`, `category` (duplicates
  `categoryId`), `galleryImages` and `allergens` (not in the design), `ingredients` and
  `nutritionalInfo` (free-form; shape pending with the backend).

## 2. Content language — agreed

- Text is resolved to one string while mapping:
  - multi-language maps (`name`, `description`, …): current language → default language
    from `GET /config` → `internalName`;
  - group and option names: `optionNames[id][lang]` → the POS `name`.
- One function does it for every DTO: `localized()` in `data/dto/localized_text.dart`.
  Repositories receive a `ContentLanguage` (current + default) from
  `contentLanguageProvider`, which waits for `GET /config`. If `/config` fails, content
  still loads without the default-language step (current → `internalName`); the config is
  not retried until the app restarts. Revisit when `/config` carries something content
  cannot do without (currency, modules).
- The current language is the device's for now (`core/locale/app_language.dart`). With
  the profile's language switch it becomes the user's choice, stored on the device, and
  the one source for the UI, the `Accept-Language` header and content mapping; signed-in
  users also send it to the profile so notifications use it.
- `Accept-Language` does not affect translated maps; it is for text the server writes
  itself.
- A language change reloads the data that carries text (menu, cart, branches, …).
- Requests carry `Accept-Language` (interceptor): server messages, allergens and cart
  option names come back in it.
- Order history keeps the language the order was placed in.

## 3. Adding to the cart — agreed

- `POST /cart/items` with `itemId`, `branchId` (the active branch), `quantity`, and
  `modifiers` as one flat list: the chosen size by its id, plus every chosen option
  with its id and how many of it (`quantity`, 1 when left out).
- The server merges a line with the same product and the same options into one line and
  sums the quantity.
- Checked on the dev server (2026-11-13):
  - every cart request needs a signed-in user; a guest gets 401;
  - `GET /cart` and `DELETE /cart` take `branchId` (required). The cart is one per user
    and tied to one branch: asked for at another branch it answers empty and discards
    nothing;
  - adding with another `branchId` silently replaces the cart with the one new line;
  - `POST /cart/branch` moves the cart to another branch: the lines stay, priced there,
    and one that branch cannot make is marked unavailable (checked 2026-11-16);
    `GET /cart/branch-preview` answers the same without moving anything (not used yet);
  - an option's quantity over its `maxPerDish` is refused with
    `option_quantity_too_many`; the group's maximum counts the quantities together;
  - `PUT /cart/items/{id}/options` puts a new choice in a line (checked 2026-11-16):
    `modifiers` is the whole choice in the shape of an add, `quantity` is optional. The
    line keeps its id and place; a choice another line of the same product holds merges
    the two into that other line; a refusal (the codes of an add) changes nothing; a
    line that is gone answers 404 `cart_item_not_found`;
  - every change (`POST`, `PUT`, `DELETE` of a line) answers with the whole cart;
  - a required group left empty is refused with `options_required`.
- In code: `cartProvider` (`domain/state/cart_state.dart`) is the cart at the active
  branch, null for a guest; its methods add, change a quantity, change a line's choice
  (`changeLine`, what the product sheet's "Save" calls), remove a line,
  clear, and move the cart to another branch (`moveTo`, which also makes that branch
  the active one). Adding at another branch makes that branch the active one. The cart sheet (`features/cart/cart_sheet/`)
  shows it and changes it; the time and the tip chosen there are the sheet's own state
  (`CartCheckoutController`) until an order is placed. The times offered are worked out
  by `pickupSlots` next to it; when the server offers them, that controller loads them
  instead and nothing else changes. What must be asked
  first is two calls where the product is added: `ensureSignedIn` (next to the sign-in
  screen) and `confirmReplaceCart` (the cart's `replace_cart_dialog`). The branch
  picker asks nothing: it calls `moveTo`.

## 4. ProductChoice — agreed

- Value class in `domain/entities/` (own file; used by the cart and orders): product id,
  product name, size (optional), chosen options (each with id, group id, name, price).
- Equality by value.
- From cart and order lines (`modifiersJson` of `SelectedModifierResponse`): the
  modifier whose `groupId` starts with `size:` is the size; the rest are options.

## 5. Product screen selection — agreed

- Screen state of the product screen's controller: chosen size and chosen options.
- Starts from the defaults (default size, options with `isDefault`).
- Validates the groups (required filled, maximum not exceeded) to enable "Add".
- Shows a price preview: size price (or base price) + surcharges. The server's price
  is the real one.
- On "Add" it becomes a `ProductChoice` and is sent as in §3.
- Built (2026-11-13) as `ProductSelectionController` next to the product sheet: it holds
  the chosen size, options and quantity, and computes the price and whether the
  selection may be added. The entity carries only what describes itself
  (`defaultSize`, a group's `defaultOptions`). Where the check for the card's quick "+"
  lives is decided with the cart.
- The quantity is part of the selection, 1 to 99.
- The chosen options are kept with how many of each. An option may be taken up to
  its own limit (`maxPerDish`), and a group's minimum and maximum count the pieces of
  its options together; the controller answers how many more of an option fit.
- With sizes the portion shown is the chosen size's own (`portion` on a size option);
  the product's portion is shown only without sizes.
- "Anything else?" is `recommendedProductsProvider` (`domain/state/menu_state.dart`,
  `GET /menu/items/{id}/recommended`), drawn by `RecommendedProductsRail` with the same
  row of cards as the Order tab's featured rail (`ProductCardsRail`).

## 6. Buy again — agreed

- `BuyAgainItem` lives in the Home feature (one consumer): `ProductChoice` + branch
  (id, name) + last purchase date.
- Built from order history: lines grouped by (choice, branch), most recent first. The
  image comes from the menu by product id.
- Tap: the active branch becomes the item's branch, then the choice is added to the cart.
- Open (screen behaviour): unavailable product or option, duplicates in one branch,
  which price to show.

## 7. Default and active branch — agreed (revised 2026-11-09)

- The **default branch** is one branch for all users, set by the admins. It is a
  fallback for when the nearest branch is unknown. There is no per-user default branch:
  the nearest branch takes priority, so a personal setting would rarely be used.
- The **active branch** is the branch the application works with: its menu is shown,
  the cart belongs to it and orders are placed in it. There is always an active branch.
- On start (guest or signed in) the active branch is:
  1. the nearest branch, when the device position is known;
  2. otherwise the default branch.
- The default branch is `defaultBranchId` from `GET /config` (the merchant's choice, else
  their first branch).
- The user's choice is not kept across restarts: every start picks again as above.
- Within a session the user's choice wins: pull-to-refresh recomputes the nearest branch
  but keeps the chosen one (with its fresh data). If the chosen branch leaves the list,
  the rule above applies again. Without a position and a known default, the first branch
  in the list is used. In code: `branchPickProvider` holds the chosen id,
  `activeBranchProvider` computes the active branch.
- Proposed: on start, wait for the position with a short timeout (about 3 s) before
  choosing, so the menu does not switch to another branch in front of the user. No
  permission, a refusal or the timeout → the default branch.
- The active branch changes when the user:
  - picks a branch in the menu screen's branch bar;
  - picks a branch in the cart;
  - uses "Buy again" on a purchase from another branch (the active branch becomes the
    branch of that purchase);
  - adds a product from a branch page.
- Browsing a branch page shows that branch's menu and does not change the active branch.
  Only adding a product from it does.

**On a change of the active branch**

- The active menu is reloaded for the new branch.
- The cart moves to the new branch when the branch is changed in the branch picker
  (decided 2026-11-16, `DESIGN_PRODUCT_QUESTIONS.md` §4): its lines stay, prices and
  availability are the new branch's, and lines unavailable there are marked, not
  removed. Adding a product at another branch still replaces the cart, after the user
  confirms.

**Open questions**

- Whether moving a non-empty cart asks the user to confirm, with what would not be
  sold at the new branch (design question; the backend can answer it in advance).
- A non-empty cart left in another branch when the application starts again.
- A change of organisation (multi-concept): loyalty and wallet are per organisation.
  For now each build serves one organisation, set in the build config (`RESTAURANT_ID`);
  its branches, menu, loyalty and wallet are requested with it.

## 8. Menu state — agreed in principle, details with the implementation agent

- `Menu` value class: branch id, categories (two levels), products; helpers such as
  product by id, products of a category, featured products.
- One provider per branch: `menuProvider(branchId)` — Riverpod family + autoDispose,
  in `domain/state/`. Its notifier only knows "the menu of branch X" and watches nothing
  else, so the same instance serves every screen that asks for that branch.
- Active branch: an app-level state (`activeBranchProvider`). Screens that show the
  active menu (Products tab, Home, favourites) watch `menuProvider(activeBranch)`,
  directly or through a small `activeMenuProvider` wrapper (optional, decide in code).
- The branch page watches `menuProvider(pageBranchId)`. Leaving it disposes that menu
  unless it is the active branch's.
- Adding from a branch page: set the active branch to that branch, move the cart, add.
  The active menu then reuses the menu the branch page already loaded.
- Active branch on start: nearest, else the default branch (§7). `profile.preferredLocationId`
  is not used.

## 9. Riverpod — agreed (2026-11-10; the rules are in `ARCHITECTURE_SPEC.md` §6)

- Current Riverpod (3.x): family arguments arrive through the notifier's constructor.
- Load data with `AsyncNotifier` (`AsyncValue` loading / data / error, async `build`)
  instead of go_sport's `Notifier` + `Future.microtask(load)` + hand-written `isLoading`
  / `error` fields. Reasons: exhaustive states ([[non-exhaustive-loading-guard]]),
  stale loads dropped on argument change or dispose, the error keeps its `AppException`
  type.
- go_sport precedent for a shared parametrised provider: `scheduleControllerProvider`
  (family by date, three consumers).

## 10. Branches: hours, distance, order — agreed (revised 2026-11-10)

- Branches are loaded once (all of them) and refreshed on resume (§11) and by
  pull-to-refresh. Filters (city, district) work on the loaded list.
- Today's hours and "open now" come from the API's `today` (`hours` with `open`, `close`,
  `openNow`; `closed` for a day off; `null` when no hours are entered). They are true at
  the moment of the response; refresh on resume and pull-to-refresh keep them current
  enough. Computing them in the app (`openingHours` + `timezone`, overnight windows) is
  deferred until stale status becomes a real problem.
- The branch card: `hours` → "08:00 – 23:00" and an Open / Closed pill; `closed` → "Closed
  today"; `null` → no hours and no pill (unknown is not closed). `isTemporarilyClosed` →
  a Closed pill whatever the hours.
- Distance is computed in the app (`Geolocator.distanceBetween`) from the branch
  coordinates and the user's position; the list is sorted by it, branches without
  coordinates last. One controller (`BranchesController`, `domain/state/`) fetches the
  branches and the position together. Distance lives in the list state (`NearbyBranch`),
  not in `Branch`. Without a position: the API order (the admin's order), no distance.
- The position: asked for on the first load (Home is first), read once per load; up to 3 s
  for a fix after permission, then the last known one, else none.

## 11. Refresh on resume — agreed, details with the implementation agent

- When the app returns from the background after more than 5 minutes (value to tune),
  shared data is refreshed: branches, the active menu, the cart (later: loyalty,
  wallet).
- Refresh is silent: data already on screen stays, the request runs in the background,
  new data replaces old when it arrives; on failure the old data stays and no error is
  shown. Only a first load shows a loading state or an error.
- Riverpod: re-running an `AsyncNotifier` keeps the previous value (`isRefreshing`);
  screens do not hide data that is already shown.
- After a cold start everything loads as on first start.

## 12. Loyalty card — agreed (QR proposed)

- `LoyaltyCard` is assembled by the repository from two requests made in parallel:
  `GET /loyalty/balance` (points, tier) and `GET /loyalty/counter-qr` (card number).
  Both take `restaurantId` (the organisation).
- Not mapped: `cashback` (always 0 with iiko: cashback accrues as points), `categories`
  (the tier already comes from them), `wallets` (the wallet comes from
  `/wallet/balance`; vouchers are discussed separately).
- The card number does not change; a refresh may re-read only the balance.
- Decided 2026-11-16: the QR is drawn in the app from the card number (`qr_flutter`),
  not shown from the PNG the API sends: sharp at any size and in the theme's colours.

## 13. Order mapping (`OrderResponse` → `Order`) — agreed

- Status: `payment_pending` → awaiting payment; `paid`, `placed` → placed; `accepted` →
  accepted; `preparing` → preparing; `ready` → ready; `completed` → collected;
  `cancelled` → cancelled; `payment_failed` → payment failed; anything else → placed (the
  Swagger says to show an unknown status as in progress; placed is the first step of
  that). Placed and accepted are apart since 2026-11-16: Home's order status draws them
  as two steps. The backend's own table of statuses has no `paid`; it is kept beside
  `placed`. `cancelled` is also what an order becomes when the same cart is checked out
  again.
- Total = `totalToCharge` + `walletSpent` − `walletReturned` (= `itemsTotal` −
  `discount` + `tipAmount`). `walletReturned` is balance released back when the till
  closed the order without taking the balance payment (backend
  `src/shared/utils/wallet-returned.util.ts`).
- Branch from `location` (name in the current language from its translations).
- Lines: `name` is the product name as ordered; `modifiersJson` becomes the choice's
  size (group id starting with `size:`) and add-ons; `itemId` may be null.
- Not mapped: `paymentStatus`, `paymentProvider` (payment flow, not the order), guest
  contact, `itemsTotal` / `walletSpent` / `totalToCharge` separately,
  `updatedAt`. `posNumber` (number called at the till) is `Order.number`, `scheduledAt`
  the pickup time.

- `gatewayOrderId` is not part of `Order` either, but placing an order answers with it
  next to the order while the order awaits payment (`PlacedOrder.paymentReference`):
  paying with a saved card takes it.
- Built so far (§16, §17): the id, the status, the number, the branch name and the time. The lines and
  the amounts are mapped with the screens that show them.

## 14. Voucher mapping (`GET /loyalty/entitlements` → `Voucher`) — agreed

- One voucher per entitlement. The product is `products[0]`: from its `item` (id, name,
  image) — always present in practice; if `item` is null, the name is `posName`, with no
  id and no image.
- `remaining` = `claimable` (how many free items the held count comes to). `count`,
  `costPerUse` and `programName` are not mapped.
- An entitlement with several products: only the first is used for now.
- Takes `restaurantId` (the organisation), like the rest of loyalty.

## 15. Questions for the backend

- Adding a product at another branch replaces the cart; whether it should move the
  cart there and add to it, as `POST /cart/branch` does.
- Return the user's cart without a branch, with the branch it is in (needed to restore
  the active branch on start).
- A fixed shape for `nutritionalInfo` (the design shows calories, proteins, fats,
  carbohydrates) and `ingredients`.
- A product in more than one category (e.g. an iced latte under both "Iced Coffee" and
  "Iced Drinks"); the API allows one.
- An image on order lines (history rows show one; today it can only come from the
  current menu).
- `docs/mobile/FLOWS.md` is referenced by the Swagger and the collection but is not in
  the repository.
- The loyalty tier's percent (the design shows it on the loyalty card; today only the
  tier name comes, taken from the guest's POS category).
- A list of loyalty tiers, if a screen needs it.
- Paid membership (the design has membership levels and buying one for a number of
  months); the API has nothing for it.
- Expiry of loyalty points (the PRD shows expiry dates and "expiring soon"; the API has
  nothing for points).
- Voucher validity date (the API has none).
- ~~Cities and districts as reference lists with ids~~ — done: `GET /branches/cities`,
  `cityId` / `districtId` on a branch and as `/branches` filters.
- ~~The default branch for all users~~ — done: `defaultBranchId` in `GET /config`.

## 16. Placing an order — built for saved cards (2026-11-16)

- `POST /orders` with `branchId`, `fulfillmentType: pickup`, `scheduledAt` (left out for
  as soon as possible) and `tip` (left out for none). No `paymentProvider` is sent: the
  server pays through its default gateway.
- The answer is the order and, for a gateway with a payment page, the page to open.
  Checked on the dev server (2026-11-16):
  - with the default gateway there (`mock-instant`) the order comes back paid
    (`placed`) and the cart is empty;
  - with a gateway that has a page (`mock`) it comes back `payment_pending` with
    `gatewayOrderId`, and the cart stays until it is paid;
  - `POST /payments/cards/{bindingId}/pay` with `{orderId: gatewayOrderId}` pays such
    an order with a saved card and answers `{success, order}`; an order that is not
    awaiting payment is refused with `order_not_awaiting_payment`;
  - `GET /payments/methods` lists the saved cards (`bindingId`, `maskedPan`,
    `expiryDate`, `isDefault`); `GET /config` → `payment` names the gateways.
- In code: `CartCheckoutController.placeOrder` (the cart sheet's controller) places
  the order with the chosen time and tip; when the order comes back awaiting payment,
  it pays it with the chosen card; then the cart is loaded again. The cards are
  `paymentCardsProvider` (`domain/state/payment_cards_state.dart`); the card to pay
  with is `paymentCardProvider` next to it: the one picked in the ways-to-pay sheet
  (`features/payment/payment_method_sheet/`), otherwise the default, otherwise the
  first. The pick is one for the whole app (the cart and the wallet's top-up show the
  same card) and lasts until the app is restarted.
- Not built: the bank's page for a new card (it needs a page shown inside the app that
  sees the return to `/orders/payment-callback`), adding and removing cards, spending
  the balance (`walletToSpend`, `POST /loyalty/calculate-redemption`).
- With `mock-instant` the step that pays with a card never runs on the dev server; it
  is covered by tests only.

## 17. Orders on their way — Home's order status (2026-11-16)

- There is no request for open orders. `OrderRepository.getRecentOrders` reads the first
  page of the history (`GET /orders?limit=5`, newest first); `activeOrdersProvider`
  (`domain/state/active_orders_state.dart`) keeps the ones at one of the four steps:
  placed, accepted, preparing, ready. Empty for a guest, without a request.
- While the list is not empty it is read again every 30 seconds; a read that fails
  keeps the list and the following reads. With nothing on its way there are no reads
  until an order is placed (the checkout reads it again) or Home is pulled to refresh.
- Home's `OrderStatusBlock` reads the provider itself and takes no room without orders,
  while loading and on a failure.
- The dev server moves an order on by itself (placed → preparing in seconds, completed
  in about 12 minutes), so the block can be watched there.
- To ask the backend: a request for the open orders alone, or their statuses in one
  call — the history page carries every order whole, lines included.

## 18. Loyalty card and wallet on Home (2026-11-16)

- `GET /config` → `modules.loyalty` / `modules.wallet` are `ServerConfig.loyaltyEnabled`
  / `walletEnabled`; a module the instance does not name is off. Each block reads its own
  flag through its provider; nothing else checks modules yet.
- `loyaltyCardProvider` and `walletProvider` (`domain/state/`) are none for a guest and
  with the module off, without a request; they wait for `/config` first. Home's blocks
  take no room without a value: while loading, on a failure, for a guest.
- Wallet mapping (`GET /wallet/balance`): `total`, `ownTopUp`, `giftCard` → gifts,
  `expiring` with `expiryDate` → what expires next (no date when nothing expires).
  `promo` is not read. On the dev server `ownTopUp` and `giftCard` equal the POS's
  `deposit` and `certificate` wallets of `/loyalty/balance`.
- The tier is the POS's name for it, a string on `LoyaltyCard`.
- Placing an order reads the loyalty card again.
- Not built: the wallet's history, spending the balance on an order. Topping up: §19.

## 19. Topping up the wallet — built for a gateway without a page (2026-11-16)

- `POST /wallet/top-up` with `amount` only; no `paymentProvider` is sent, the server
  pays through its default gateway. Limits: `/config` → `wallet.minTopUp` / `maxTopUp`
  (`ServerConfig.minTopUp` / `maxTopUp`); the button is off outside them.
- Checked on the dev server (2026-11-16):
  - with the default gateway there (`mock-instant`) the answer is `{topUpNumber,
    success: true}` and the balance has grown at once;
  - with a gateway that has a page (`mock`) the answer is `{topUpNumber,
    paymentFormUrl}`, the balance stays, and `GET /wallet/history` keeps the top-up as
    `pending`;
  - an amount outside the limits is refused with `topup_amount_invalid` and a text;
  - **a saved card cannot pay a top-up**: `POST /payments/cards/{bindingId}/pay` answers
    `order_not_found` for the top-up's number and for the payment's id alike, and the
    top-up request takes no card. With a real gateway the only way is the bank's page.
- In code: `WalletRepository.topUp` answers whether the money is in. Done → the wallet is
  read again and the success screen shown; not done (a page is needed) → a message that
  paying this way is not available yet; a refusal → the server's text.
- The sheet shows the card as the design draws it, and the card can be changed, but it
  is not sent anywhere: the API has nowhere to take it.
- The success screen shares its frame with the order's (`SuccessView`,
  `features/shared_widgets/`).
- A real gateway is the client's to provide; until then this is tried only against the
  mock. To ask the backend: paying a top-up with a saved card; who closes a top-up left
  `pending`.

## 20. The card's stepper — the minus relies on the order of the cart's lines (2026-11-17)

- The rules are in `DESIGN_PRODUCT_QUESTIONS.md` §1–2. In code: `Product.hasChoices`,
  `CartController.removeOne`, `cartQuantitiesProvider`, `quickAddProduct` /
  `quickRemoveProduct`, `ProductCartControl` on both cards.
- A cart line has no time of adding and no position. Checked on the dev server
  (2026-11-17): `GET /cart` lists a new line last, and a line whose quantity was changed
  moves to the end too; adding a product without choices again grows its one line. The
  minus takes from the product's last line in that list.
- This order is not described in the API. To ask the backend: either promise it, or give
  each line the time it was added.
- While a change of the cart waits for the server's answer
  (`CartController.isChanging`), the cards take no taps, as the cart sheet's lines do
  not (`_changing` there): a second tap would be counted from the cart as it was
  before the first came back. The tap is dropped without a sign. Agreed as the simple
  way for now; the other way is a number that changes at once with the changes sent in
  turn.
