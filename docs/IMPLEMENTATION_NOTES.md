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
- A language change reloads the data that carries text (menu, cart, branches, …).
- Requests carry `Accept-Language` (interceptor): server messages, allergens and cart
  option names come back in it.
- Order history keeps the language the order was placed in.

## 3. Adding to the cart — agreed

- `POST /cart/items` with `itemId`, `branchId` (the active branch), `quantity`, and
  `modifiers` as one flat list of ids: the chosen size plus every chosen option.
- The server merges a line with the same product and the same options into one line and
  sums the quantity.

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

## 6. Buy again — agreed

- `BuyAgainItem` lives in the Home feature (one consumer): `ProductChoice` + branch
  (id, name) + last purchase date.
- Built from order history: lines grouped by (choice, branch), most recent first. The
  image comes from the menu by product id.
- Tap: the active branch becomes the item's branch, then the choice is added to the cart.
- Open (screen behaviour): unavailable product or option, duplicates in one branch,
  which price to show.

## 7. Default and active branch — agreed


- The **default branch** is a user setting stored on the server (part of the profile).
  It changes only in the settings.
- The **active branch** is the branch the application works with: its menu is shown,
  the cart belongs to it and orders are placed in it. There is always an active branch.
- On start the active branch is the default branch. How it is chosen when there is no
  default branch is decided later.
- The active branch changes when the user:
  - picks a branch in the menu screen's branch bar;
  - picks a branch in the cart;
  - uses "Buy again" on a purchase from another branch (the active branch becomes the
    branch of that purchase);
  - adds a product from a branch page.
- Browsing a branch page shows that branch's menu and does not change the active branch.
  Only adding a product from it does.
- Changing the active branch does not change the default branch.
- Changing the default branch in the settings also makes it the active branch when the
  cart is empty; with a non-empty cart the active branch stays (to confirm with design).

**On a change of the active branch**

- The active menu is reloaded for the new branch.
- The cart moves to the new branch: its lines stay, prices and availability are checked
  again, and lines unavailable there are marked, not removed.

**Open questions**

- Whether moving a non-empty cart asks the user to confirm (design question).
- What happens to the cart until the backend can move it between branches (today it is
  cleared).
- A non-empty cart left in another branch when the application starts again.
- A change of organisation (multi-concept): loyalty and wallet are per organisation.

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
- Default branch: `profile.preferredLocationId`. Active branch starts from it.

## 9. Riverpod — proposed

- Current Riverpod (3.x): family arguments arrive through the notifier's constructor.
- Load data with `AsyncNotifier` (`AsyncValue` loading / data / error, async `build`)
  instead of go_sport's `Notifier` + `Future.microtask(load)` + hand-written `isLoading`
  / `error` fields. Reasons: exhaustive states ([[non-exhaustive-loading-guard]]),
  stale loads dropped on argument change or dispose, the error keeps its `AppException`
  type.
- go_sport precedent for a shared parametrised provider: `scheduleControllerProvider`
  (family by date, three consumers).

## 10. Branches: hours, distance, order — agreed (sorting open)

- Branches are loaded once (all of them) and refreshed on resume (§11) and by
  pull-to-refresh. Filters (city, district) work on the loaded list.
- "Open now" and today's working hours are computed in the app from `openingHours` and
  the branch `timezone`; the API's `today` / `openNow` are not used.
  - `openingHours` shape (backend `src/shared/utils/opening-hours.util.ts`):
    `{ mon: { open: "08:00", close: "22:00" }, … }`; a missing day is a day off; `null`
    means unknown hours. The legacy form `"08:00-22:00"` per day may still occur.
  - "Now" is converted to the branch's time zone (`timezone` package; load the time zone
    database once at start). No `timezone` → the device's time.
  - A window with `close` earlier than `open` runs past midnight: at 01:10 on Tuesday the
    branch is open on Monday's window. Check today's window and yesterday's. Reference:
    backend `todayHoursOf` in `src/shared/utils/location-card.util.ts`.
  - Branch methods take `now` explicitly: `workingHoursOn(now)`, `isOpenAt(now)`.
  - The value is computed when a screen builds; no ticker, it does not change on screen
    by itself.
- Distance and sorting by distance: decide during implementation — in the app (from the
  branch coordinates and the user's position; the list has no pagination, all branches
  come at once) or by the API (`lat`/`lng`, `distanceKm`). Either way distance lives in
  the list state, not in `Branch`. Without a position: the API order (the admin's
  order).

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
- Proposed: draw the QR in the app from the card number (e.g. `qr_flutter`) instead of
  showing the PNG the API sends.

## 13. Questions for the backend

- Move the cart between branches: keep the lines, re-price, mark what is unavailable
  (`available` / `unavailableReason` already exist) instead of clearing it.
- Return the user's cart without a branch, with the branch it is in (needed to restore
  the active branch on start).
- Quantity per add-on: the design has steppers on add-ons; the API selects an option at
  most once (`restrictions` on options exist in the POS data and are ignored).
- Portion per size: the design shows the portion next to the price and it should follow
  the chosen size; the API has one portion per product.
- A fixed shape for `nutritionalInfo` (the design shows calories, proteins, fats,
  carbohydrates) and `ingredients`.
- A product in more than one category (e.g. an iced latte under both "Iced Coffee" and
  "Iced Drinks"); the API allows one.
- Data for the "Anything else?" rail on the product screen (no endpoint yet).
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
