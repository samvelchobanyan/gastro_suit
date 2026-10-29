# GastroSuit — Domain Specification

Status: in progress · 2026-10-29

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

### 1.4 Related values

**ProductChoice** (value) — what was chosen: the product (id and name), the size if
any, the chosen options (each with its group, name and surcharge). It is part of a cart
line and of an order line, and is what "Buy again" re-adds to the cart.

The choice being assembled on the product screen is screen state. It works against the
full product (groups, limits, availability) and becomes a `ProductChoice` when the
product is added to the cart.

### 1.5 Open questions for the backend

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

To be written: the branch entity (composition and rules).
