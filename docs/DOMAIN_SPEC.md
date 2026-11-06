# GastroSuit — Domain Specification

Status: in progress · 2026-10-30

## 0. About this document

This document defines what the application works with: its entities, what they mean,
what they consist of and the rules that hold for them. Field-level details live in code.

- An **entity** has its own identity and exists on its own: it is loaded by itself and
  referenced by id from elsewhere. Two entities are the same when their ids match.
- A **value class** is part of an entity or describes data copied between entities. It has
  no life of its own. Two values are the same when their content matches.
- The domain model follows the application, not the API. The data layer maps API
  responses into it.

Related documents: `ARCHITECTURE_SPEC.md` (where these classes live and how state is
owned), `API_SPEC.md` (the wire format).

---

## 1. Product

### 1.1 Meaning

A product is an item that can be ordered, as it is offered in the menu of one branch.
A product exists only within a branch menu; buying is always a product at a branch.

### 1.2 Composition

**Product** (entity)
- identity, category (exactly one), name
- description and image, both optional
- price — the base price; for a product with sizes, the price of the smallest size
- availability at the branch
- portion — amount and unit (e.g. 300 ml), optional
- nutrition — calories, proteins, fats, carbohydrates, optional
- tags, featured flag, display order
- sizes — a list of `ProductSize`, empty when the product has one size
- option groups — a list of `ProductOptionGroup`, empty when the product has no add-ons

**ProductSize** (value, part of a product)
- identity, name, final price of that size, whether it is the default

**ProductOptionGroup** (value, part of a product) — one question asked when ordering
("Which milk?", "Any syrup?")
- identity, name, minimum and maximum number of options that may be chosen (no maximum
  means no limit), its options

**ProductOption** (value, part of a group) — one answer to that question
- identity, name, surcharge (0 means free), availability, whether it is pre-selected

### 1.3 Rules

- A product with sizes always has exactly one default size: the one the API marks, else
  the smallest. Sizes are ordered from the cheapest.
- The price of a size is final, not a surcharge. The price of a chosen product is the
  size price (or the base price) plus the surcharges of the chosen options.
- A group is required when its minimum is at least 1, and single-choice when its maximum
  is 1. A group is paid when any of its options has a surcharge.
- An option is selected at most once; there is no quantity per option.
- Favourites are not part of the product: they are the user's set of product ids,
  resolved against the loaded menu.

### 1.4 Open questions for the backend

- Quantity per add-on (shown in the design, not supported by the API).
- Portion per size (the API has one portion per product).
- A fixed shape for nutrition and ingredients (both are free-form POS objects).
- A product in more than one category (the API allows one).

---

## 2. Menu

**Menu** (value) — what one branch offers: its categories and products. A menu is
identified by its branch and has no life of its own.

- Categories form at most two levels (category → subcategory). Each product belongs to
  exactly one category.
- Several menus may be loaded at once: the active branch's menu and the menu of a branch
  the user is browsing.

---

## 3. Branch

### 3.1 Meaning

A branch is a place of the restaurant or coffee chain where the user picks up an order.
Each branch has its own menu (prices and availability).

### 3.2 Composition

**Branch** (entity)
- identity, name
- description and photo, both optional
- address; city and district, optional (used to filter the list)
- coordinates, optional (map, distance to the user)
- time zone, optional (the device's time is used without it)
- opening hours for the week: per day an opening and a closing time; a missing day is a
  day off; absent altogether when the hours are unknown
- rating: average and number of ratings, optional
- whether it accepts tips

### 3.3 Rules

- Working hours for a day and whether the branch is open are computed for a given moment
  on the branch's own clock. A window whose closing time is earlier than its opening time
  runs past midnight, so the previous day's window counts in the early hours.
- Distance is not part of the branch: it depends on where the user is.
- Ordering availability (taking orders, from the app, temporarily closed, ordering hours)
  is pending the design (`DESIGN_PRODUCT_QUESTIONS.md`).

---

## 4. ProductChoice

**ProductChoice** (value) — what was chosen for one product: the product (id and name),
the size if any, and the chosen add-ons. Each chosen add-on: id, group id, name,
surcharge.

- It groups the "what was chosen" fields that a cart line and an order line share, and
  is what "Buy again" re-adds to the cart.
- Two choices are equal when the product, the size and the add-ons are equal.
- It carries no quantity and no line prices; those belong to the line that holds it.

---

## 5. Cart

### 5.1 Meaning

The cart is what the user is about to order. Each user has one cart; it lives on the
server and belongs to one branch, the active branch.

### 5.2 Composition

**Cart** (entity, one per user)
- identity (absent while the server holds no cart yet), branch, lines, total
- computed: whether it is empty, the number of items (sum of quantities), whether any
  line is unavailable

**CartLine** (part of a cart)
- identity of the line (used to change its quantity or remove it), the `ProductChoice`,
  image, quantity, unit price (with add-ons), line total
- availability at the cart's branch and, when unavailable, the reason

### 5.3 Rules

- Adding sends the choice, the quantity (1 by default) and the branch. The server prices
  the line; prices are never sent.
- Adding a choice already in the cart increases that line's quantity instead of creating
  a second line.
- A line's choice does not change; only its quantity does. Changing the choice replaces
  the line.
- Prices and availability in the cart are the server's, re-checked on every read. Every
  change returns the whole cart, which replaces the one held.
- An order cannot be placed while any line is unavailable.
- The cart moves with the active branch (see `IMPLEMENTATION_NOTES.md`, default and
  active branch).

---

## 6. Story

### 6.1 Meaning

A story is a short sequence of pictures the restaurant shows on the home screen, with an
optional button that leads into the app or to a web page.

### 6.2 Composition

**Story** (entity)
- identity, title (optional), cover image, slides (pictures in order, at least one)
- link — where its button leads (optional: no link, no button)
- whether the user has seen it

**AppLink** (value) — where a tap leads: a type (product, menu category, web address)
and its target (the product id, the category id or the address). The type and the
target exist only together. Shared with banners.

### 6.3 Rules

- Stories are shown in the order the server returns them.
- "Seen" means seen since the story last changed; the server keeps track of that.
- Opening a story marks it seen at once; the server is told without waiting for it.
- A link to a product or a category opens it in the active branch.

---

## 7. Banner

### 7.1 Meaning

A banner is a promotional picture on the home screen. A tap may lead into the app or to
a web page.

### 7.2 Composition

**Banner** (entity)
- identity, image
- title (optional): the picture's text for accessibility, not shown
- link (optional, `AppLink`): no link — the banner is not tappable

### 7.3 Rules

- Banners are shown in the order the server returns them; the server returns only the
  banners on show now.

---

## 8. Loyalty card

### 8.1 Meaning

The loyalty card is the user's place in the restaurant's loyalty programme: the points
they have collected, their loyalty tier, and the card the cashier scans at the counter.
How points are earned is the POS's business, not the app's.

Loyalty tiers are not the tiers of a paid membership; membership is a separate concept,
described when it is designed.

### 8.2 Composition

**LoyaltyCard** (entity, one per user)
- points
- tier (optional, `LoyaltyTier`)
- card number — what the cashier scans; the QR code shows this number

**LoyaltyTier** (value)
- name
- percent (optional; pending the backend)

### 8.3 Rules

- There is one points balance (see `DESIGN_PRODUCT_QUESTIONS.md`, points and cashback).
- Balances are the POS's and are read live; the app never computes or adjusts them.

---

## 9. Wallet

### 9.1 Meaning

The wallet holds the user's money at the restaurant: what they topped up themselves,
what a friend sent them, what the organisation credited. It is money, not a reward, and
is kept apart from loyalty points.

### 9.2 Composition

**Wallet** (entity, one per user)
- balance — the total, in the currency of the instance

### 9.3 Rules

- Money in the wallet does not expire (a decision of the sessions; the PRD allows gift
  and promo value to expire — see `DESIGN_PRODUCT_QUESTIONS.md`).
- Topping up is an action, not part of the wallet. Its limits (minimum and maximum
  amount) are a setting of the instance, not of the wallet.
- The balance is the POS's and is read live; the app never computes it.

---

## 10. Order

### 10.1 Meaning

An order is what the user bought: placed from the cart, sent to one branch, and kept in
the history. After it is placed its contents and prices do not change; only its status
does.

### 10.2 Composition

**Order** (entity)
- identity, order number
- status (see 10.3)
- date and time it was placed
- fulfilment type (pickup only for now)
- branch — the branch as it was when the order was placed (identity, name)
- comment for the kitchen (optional)
- lines
- discount (0 when none), tip (0 when none)
- total — what the order cost the user: items minus discount plus tip, however it was
  paid (card, balance or both)

**OrderLine** (part of an order)
- the `ProductChoice` (name and chosen options as they were when ordered)
- quantity, unit price with add-ons, line total — as they were when ordered

### 10.3 Rules

- Status, as the user sees it: awaiting payment, accepted, preparing, ready, collected,
  cancelled, payment failed. An unknown status is shown as accepted.
- Prices, names and the branch of an order are the ones at the time it was placed; they
  never follow later changes of the menu or the branch.
- An order line's product may have left the menu since; the line keeps its name.
