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

## 7. Menu state — agreed in principle, details with the implementation agent

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

## 8. Riverpod — proposed

- Current Riverpod (3.x): family arguments arrive through the notifier's constructor.
- Load data with `AsyncNotifier` (`AsyncValue` loading / data / error, async `build`)
  instead of go_sport's `Notifier` + `Future.microtask(load)` + hand-written `isLoading`
  / `error` fields. Reasons: exhaustive states ([[non-exhaustive-loading-guard]]),
  stale loads dropped on argument change or dispose, the error keeps its `AppException`
  type.
- go_sport precedent for a shared parametrised provider: `scheduleControllerProvider`
  (family by date, three consumers).

## 9. Questions for the backend

- Move the cart between branches: keep the lines, re-price, mark what is unavailable
  (`available` / `unavailableReason` already exist) instead of clearing it.
- Return the user's cart without a branch, with the branch it is in (needed to restore
  the active branch on start).
- Quantity per add-on (`restrictions` on options exist in the POS data and are ignored).
- Portion per size.
- A fixed shape for `nutritionalInfo` and `ingredients`.
- A product in more than one category.
- `docs/mobile/FLOWS.md` is referenced by the Swagger and the collection but is not in
  the repository.
