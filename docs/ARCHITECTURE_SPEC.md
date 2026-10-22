# GastroSuit — Architecture Specification

Status: canonical · Version 1.0 · 2026-10-21

## 0. About this document

This document defines how the application is structured: which layers exist, what each
one owns, and how they interact. It states rules, not implementations.

- **No code.** Reference implementations are the code itself; illustrative examples live in
  the Flutter knowledge base (`C:\knowledge\flutter-kb\`).
- **No library versions.** Versions live in `pubspec.yaml`; the reasoning behind each tool
  choice lives in the knowledge base ADRs.
- **Rules are stated positively.** A rule describes how things are done; doing it
  differently is the violation. A rule exists only if it prevents a concrete problem.
- Anything not covered here is decided during development and, if it turns out to be
  structural, added here.

Related documents:
- `DOMAIN_SPEC.md` — domain entities and their meaning
- `SCREENS_SPEC.md` — screen inventory and behaviour
- `API_SPEC.md` — backend endpoints and contracts
- `BUNDLE.md` — how to read the design handoff

---

## 1. Stack

- **Riverpod** — state management and dependency injection
- **Freezed** — domain entities and state classes
- **json_serializable** — DTO parsing
- **Dio** — HTTP
- **go_router** — navigation
- **flutter_secure_storage** — auth token persistence
- **gen-l10n (ARB)** — localization

---

## 2. Layers

```text
lib/
├── core/             infrastructure: config, network, auth, navigation, di, utils
├── design_system/    tokens, theme, domain-agnostic components
├── domain/           entities, repository interfaces, domain state
├── data/             DTOs, repository implementations
├── features/         screens, screen controllers, feature widgets, shared_widgets
├── l10n/             ARB translation files
└── main.dart         startup and async initialization
```

| Layer | Owns | Depends on |
|---|---|---|
| `core` | Infrastructure shared by the whole app; knows no feature | — |
| `design_system` | Visual tokens, theme, components with no domain knowledge | — |
| `domain` | What the app works with: entities, repository contracts, shared state. Pure Dart, no Flutter widgets, no HTTP, no JSON | `core` |
| `data` | How data is fetched: API calls, DTOs, mapping to entities | `domain`, `core` |
| `features` | What the user sees: screens and their state | `domain`, `design_system`, `core` |

Features never use `data` directly; they reach data only through repository interfaces
and domain state.

---

## 3. Core

```text
core/
  config/       environment config (dev / prod), selected at build time via --dart-define
  network/      ApiClient (single wrapper over Dio), interceptors, AppException
  auth/         token storage, auth state
  navigation/   router, tab shell, route definitions
  di/           repository providers (interface → implementation)
  utils/        formatters and small helpers with no layer of their own
```

- `ApiClient` is the only HTTP entry point. Only the data layer uses it.
- Cross-cutting request concerns (auth header, locale header, error translation, logging)
  are interceptors, not repository code.
- The auth token is stored in `core/auth` and attached by an interceptor. Repositories and
  features never handle the token.
- Infrastructure that needs async initialization (token storage, API client) is created in
  `main` before `runApp` and injected via `ProviderScope` overrides. Consumers receive a
  ready instance synchronously.

---

## 4. Domain

```text
domain/
  entities/       immutable business models
  repositories/   repository interfaces
  state/          domain state (state shared across screens)
```

- Entities are immutable and know nothing about JSON or the API.
- A repository interface describes what the domain needs, in domain terms. It returns
  entities and throws only `AppException`.
- The entity inventory and its meaning are defined in `DOMAIN_SPEC.md`; fields are defined
  in code.

---

## 5. Data

```text
data/
  dto/            one DTO per API response shape
  repositories/   one implementation per domain repository interface
```

- A DTO mirrors the API response and maps itself to a domain entity (`toDomain()`).
  Normalization (defaults, nulls, enum mapping) happens in that mapping.
- DTOs never leave the data layer.
- A repository implementation uses `ApiClient`, parses into DTOs and returns entities.
- Transport failures (HTTP status, timeout, no connection, malformed response) are
  translated into `AppException` in one place in the network layer. Nothing above the data
  layer sees Dio types.

---

## 6. State

There are two kinds of state, separated by **how many screens consume it**:

- **Domain state** — read by two or more screens. Lives in `domain/state/`.
- **Screen state** — read by one screen. Lives in that screen's controller, even when it
  holds entities.

Rules:
- Data that is obviously shared from the start (cart, user, loyalty, selected branch) goes
  to domain state immediately; consumer counting is for the unclear cases.
- When screen state gains a second consumer, moving it to domain state is part of that
  change.
- How long state lives is a separate decision from where it lives. Keeping data alive
  across navigation is done by provider lifetime (`autoDispose` or not), not by promoting
  it to domain state.
- Each piece of data has one owner. A controller may derive what its screen needs from
  domain state by watching it; it does not keep its own copy.
- A screen gets a controller only when it has state of its own. A screen that only
  displays domain state reads it directly.

---

## 7. Features

```text
features/<feature>/presentation/
  <screen>/
    <screen>_screen.dart
    <screen>_controller.dart      only if the screen has its own state
    widgets/                      widgets used by this screen only
  widgets/                        widgets shared by several screens of this feature
```

- A feature groups related screens. A multi-step flow (sign-up, checkout) is one feature
  with one folder per step.
- Every navigation target is a `*Screen` widget.
- A complex widget may have its own controller, placed next to it.
- Bottom sheets and dialogs follow the same placement rules as screens and widgets.

---

## 8. Reusable widgets

Two places:

| Place | Contains | Knows the domain |
|---|---|---|
| `design_system/components/` | Visual building blocks | No — props are plain values |
| `features/shared_widgets/` | Widgets with domain meaning used by several features | Yes — may take entities |

- Reusable widgets hold no state and read no providers: state comes in as props, actions
  go out as callbacks. The screen that uses them wires them to state.
- A widget lives at the lowest level that covers its consumers: one screen →
  `<screen>/widgets/`; several screens of one feature → `<feature>/presentation/widgets/`;
  several features → `shared_widgets/`. It moves up when a new consumer appears, not in
  advance.
- The design handoff's component list does not decide placement; these rules do.

---

## 9. Navigation

- Route configuration lives in `core/navigation/`. Features define screens, not routes.
- Main sections are tabs in a shell that preserves each tab's navigation stack. Screens do
  not render the tab bar.
- Access control (signed in, guest, public) is decided by router redirects driven by auth
  state, not by screens.
- Deep links and push payloads are mapped to routes in one place.
- Routes are referenced through route definitions (constants or builder functions), never
  through string literals in features.

---

## 10. Dependency injection

- A provider is declared next to the class it provides.
- Providers that bind a repository interface to its implementation are collected in
  `core/di/`.
- Features and domain state read repositories only through these providers; nobody
  constructs `ApiClient` or a repository implementation directly.

---

## 11. Errors

- The application has one error type, `AppException`, with a kind (e.g. no connection,
  timeout, unauthorized, validation, server) and an optional server message.
- The data layer is the only place that creates it from transport failures.
- The code that receives an error decides what to do with it (roll back, show an error
  state, retry). How an error is presented to the user is a design decision made per case.

---

## 12. Design system and theme

- Every visual value in features comes from design system tokens.
- Brand-dependent values live in a `ThemeExtension` and are read only through
  `Theme.of(context)` (via context aliases). Brand-independent tokens (gray ramp, status
  colors, spacing, radius, sizing, typography) are plain constants.
- Typography is applied through context aliases; features do not build their own text
  styles.
- The design handoff defines what things look like; this document and `BUNDLE.md` define
  how they map into code.

---

## 13. Localization

- Every user-facing string comes from ARB translation files; widgets contain no literal
  UI text.
- The selected language is application state, persisted locally.
- If the backend serves localized content, the language is sent with requests by an
  interceptor, not by each repository.

---

## 14. Deviations from the knowledge base

| Knowledge base | This project | Why |
|---|---|---|
| [[adr-001-riverpod-for-state-management]]: Riverpod 2.x | Current Riverpod | The ADR itself calls for re-evaluation once 3.x ships; versions are not an architectural concern |
| [[adr-003-freezed-for-models]]: DTOs use Freezed + json_serializable | DTOs use json_serializable only | A DTO lives for one parse-and-map; Freezed's equality and `copyWith` are never used there and double the generated code |
| [[domain-vs-screen-state]]: controllers must not proxy domain data | Controllers may derive from domain state by watching it; they must not store a copy | The harm is a stale second copy, not data passing through a controller; filtering and sorting in a controller is legitimate |
| [[layered-architecture]]: three places for shared widgets (`design_system`, `shared/widgets`, `features/shared_widgets`) | Two places (`design_system/components`, `features/shared_widgets`) | Domain-agnostic helpers belong to the design system; the third place had no clear boundary |
| [[centralized-network-error-notification]]: one root SnackBar for failed mutations | Not adopted by default | Error presentation depends on the design, which may differ per case; revisit if many places end up showing errors the same way |
