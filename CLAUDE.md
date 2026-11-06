# CLAUDE.md — GastroSuit

## 1. Project context

GastroSuit is a white-label Flutter mobile app (iOS, Android) for restaurants and coffee
shops: menu and ordering, loyalty, branches. One codebase, re-skinned per client through a
swappable brand layer in the theme.

A backend exists; its API is described by Swagger and Postman collections (summarized in
`docs/API_SPEC.md` once written). The app supports several languages.

Sources of truth:
- **Project docs** (`docs/`, index in `docs/README.md`) define this project: architecture,
  domain, screens, API, design system. `docs/ARCHITECTURE_SPEC.md` is canonical for
  structure.
- **The design handoff** defines what things look like. It is read as a specification;
  its code is never ported.
- **The Flutter knowledge base** (Section 2) holds cross-project principles, patterns,
  decisions and pitfalls.

Precedence on conflict: this file → project docs → knowledge base. Every deviation from the
knowledge base is recorded in `ARCHITECTURE_SPEC.md` §14.

You (Claude Code) act as the implementation agent.

---

## 2. Knowledge base

A separate repository: **`samvelchobanyan/flutter-kb`**.

- Local session: **`C:\knowledge\flutter-kb\`**
- Cloud session: the `flutter-kb` clone attached to the session (find it next to this
  repository). If it is not attached, say so before architectural work — do not proceed
  without the wiki.

Paths below are relative to the knowledge base root. In a cloud session, commit and push
`log.md` changes to `flutter-kb` at the end of the work.

You must:
- Read `index.md` before architectural work, then the relevant pages
- Read `projects\GastroSuit\` for project-scoped ADRs once it exists
- Append candidate entries to `log.md` once the user confirms them (Section 7)

You must not create, modify or reorganize wiki pages — only the curator agent does that.

---

## 3. Design handoff

Location and structure: to be defined after the handoff is analyzed (see `docs/BUNDLE.md`
once written). The agreed JSON export format is `docs/design_export/FORMAT.md`.

Rules that hold regardless of format:
- From a component spec take: variants, size scale, states, icon slots, prop names and
  meaning, internal composition. Ignore web markup, class names, inline styles.
- React-flavoured constructs (`setState`, `{{ }}` bindings, logic classes) describe
  **intent** — what state a screen has — never how to manage it. State management follows
  `ARCHITECTURE_SPEC.md`.
- The handoff's component list and folder layout do not decide where a widget lives in
  code; `ARCHITECTURE_SPEC.md` §8 does.
- Brand-dependent values are read only through `Theme.of(context)`. A direct import removes
  the element from the re-skin, and the breakage shows up only with the second client.

---

## 4. Language convention

Communication with the user — plans, questions, reviews, explanations — is in **Russian**.

Everything written to disk — code, comments, docs, commit messages, wiki log entries — is in
**English**.

---

## 5. Six principles

**1 — The wiki is a starting point, not a final answer.** For architectural work, read the
index and the relevant pages, then reason on top of them.

**2 — Deviation from the wiki is normal, but always explicit.** Say it out loud; never
silently ignore the wiki, never follow it blindly when the context differs.

**3 — New decisions return to the wiki** as candidate entries in `log.md`, never as direct
edits.

**4 — Respect `applies_to`.** Check that a page's conditions match the task before applying
it.

**5 — Calibrate by `severity`.** `required` — deviation needs strong justification, raised
explicitly; `recommended` — usually followed, may be adapted with reason; `flexible` — one
of several valid options.

**6 — Journal decisions in the moment.** Detect decision events during the conversation and
propose candidates immediately; append them only after the user confirms (Section 7).

---

## 6. Workflow for architectural tasks

1. **Read the wiki** — index, relevant pages (`applies_to`, `severity`, "when not to
   apply"), project ADRs — and the relevant project docs.
2. **Plan** — name the wiki pages and doc sections you apply, state every deviation and
   why.
3. **Present the plan before writing code** and wait for confirmation. Sam prefers
   conceptual alignment before code.
4. **Implement** — following the project's structure, design system tokens for every
   visual value, brand values only through `Theme.of(context)`.
5. **Capture** decision events (Section 7). If a decision changes a rule in the project
   docs, propose the doc change too.

---

## 7. Continuous capture protocol

### 7.1 Decision events

- The user and you agreed on an approach
- You applied, adapted or departed from a wiki page
- You formulated an approach not in the wiki
- You found a general pitfall

### 7.2 Classification

- **Routine application** of a wiki page — mention it in the reply, no log entry
- **ADR candidate** — a choice between alternatives with justification
- **Pattern candidate** — a new or adapted reusable structure
- **Pitfall candidate** — a general trap, not project-specific
- **Project-specific decision** — candidate for a project-scoped ADR
- **Implementation detail** — no log entry

Tool / package choices → usually ADR candidates; structures → pattern candidates; concrete
code → no entry.

### 7.3 Existence check

Check the index first: exact match → mention, no entry; related page → log with a reference
to it; no match → log as new.

### 7.4 Log entry

After the user confirms the candidate (7.5), append to the end of `log.md` in the knowledge
base (Section 2):

```
## [YYYY-MM-DD] candidate | GastroSuit | <topic>
Type: <pattern | decision | pitfall | principle>
Target applies_to: <any-flutter-project | project: GastroSuit | other-scope>
What: <one sentence>
Why interesting: <why it is worth capturing>
Context: <what the conversation was about>
Source: Claude Code session <YYYY-MM-DD>, files if relevant
Suggested action: <create new page | update [[page]] | merge with [[page]]>
```

### 7.5 In the conversation

Propose a candidate in one line (in Russian) and ask whether to log it. Write the entry only
after the user confirms; a declined candidate is not logged. No candidate — say nothing.

---

## 8. Anti-patterns

- **Skipping the wiki** for architectural tasks.
- **Silent deviation** from the wiki or from the project docs.
- **Writing into the wiki** beyond `log.md`.
- **Logging routine applications** as candidates.
- **Implementing before the plan is confirmed.**
- **Hardcoding design values.** If a value is not in the design system, raise it first.
- **Speculative abstraction.** Add providers, layers or abstractions only for a concrete
  need. A rule or structure must prevent a real problem; ceremony for the sake of
  regulation is rejected.
- **Porting code from the design handoff.** It is web code; Flutter is written from it.
- **Reading brand values outside `Theme.of(context)`.**
