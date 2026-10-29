# Project docs

| Document | Defines | Status |
|---|---|---|
| `ARCHITECTURE_SPEC.md` | Structure, layers, how they interact | Canonical |
| `DOMAIN_SPEC.md` | Domain entities: meaning, relationships, invariants | In progress: Product, Menu |
| `SCREENS_SPEC.md` | Screen inventory: purpose and behaviour | To be written (from the design handoff) |
| `API_SPEC.md` | Backend endpoints, auth, error format, localization | To be written (from Swagger / Postman) |
| `DESIGN_SYSTEM.md` | Tokens, theme, brand layer, typography usage | To be written (from the design handoff) |
| `BUNDLE.md` | How to read the design handoff | To be written |
| `IMPLEMENTATION_NOTES.md` | Implementation details agreed in architecture sessions, to start development from | Working notes |
| `guestpilot-api.swagger.json` | Backend OpenAPI export | Reference |
| `design_export/FORMAT.md` | JSON export format agreed with the design team | Carried over; check against the new handoff |
| `design_export/PROMPT.md` | Prompts for exporting from Claude Design | Carried over |

Precedence on conflict: `CLAUDE.md` → these docs → the Flutter knowledge base.
Deviations from the knowledge base are listed in `ARCHITECTURE_SPEC.md` §14.
