# GastroSuit

White-label Flutter app for restaurants and coffee shops. Project docs: `docs/README.md`.

## Run

Build values (API address, …) come from a JSON file in `config/`:

```
flutter run --dart-define-from-file=config/dev.json
```

In VS Code: Run and Debug → "GastroSuit (dev)". A personal file such as
`config/dev.local.json` is git-ignored.

## Generated code

Localization (`lib/l10n/*.arb`) regenerates on `flutter run`, or `flutter gen-l10n`.

DTOs (`json_serializable`, not added yet): when the first one arrives, generate with

```
dart run build_runner build --delete-conflicting-outputs --force-jit
```

`--force-jit` is needed: a dependency uses build hooks, which the default (AOT) build
script does not support.
