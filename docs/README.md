# Project docs

| Document | Defines | Status |
|---|---|---|
| `ARCHITECTURE_SPEC.md` | Structure, layers, how they interact | Canonical |
| `DOMAIN_SPEC.md` | Domain entities: meaning, relationships, invariants | In progress: Product, Menu, Branch, ProductChoice, Cart, Story, Banner, Loyalty card, Wallet, Order, User, Voucher |
| `DESIGN_SYSTEM.md` | Tokens, colour roles and theme, typography usage | Tokens done; components added as they are reused |
| `BUNDLE.md` | How to read the design handoff | Agreed |
| `IMPLEMENTATION_NOTES.md` | Implementation details agreed in architecture sessions, to start development from | Working notes |
| `DESIGN_PRODUCT_QUESTIONS.md` | Open behaviour questions for the designer and the product owner | Open list |
| `guestpilot-api.swagger.json` | Backend OpenAPI export | Reference |
| `guestpilot-mobile.postman_collection.json` | Backend Postman collection | Reference |

Refresh the Swagger export from the dev server:
`curl -s http://37.157.212.21:3000/api/docs-json | python -m json.tool --no-ensure-ascii > docs/guestpilot-api.swagger.json`
(formatted, so a refresh shows a readable diff).

Precedence on conflict: `CLAUDE.md` → these docs → the Flutter knowledge base.
Deviations from the knowledge base are listed in `ARCHITECTURE_SPEC.md` §14.
