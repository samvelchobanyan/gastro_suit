# Prompts for Claude Design

## Full export

> Export every component and every screen as JSON following `_format/FORMAT.md` exactly.
>
> One file per component in `components/`, one per screen in `screens/`.
>
> Tokens stay as they are: `tokens/*.css` and `_ds_manifest.json`. Add the export date to
> the manifest.
>
> Three rules matter most:
> 1. Use the keys, key order and names from FORMAT.md. Do not rename, do not add keys.
> 2. Every value is a token reference, a number, or a word from the closed lists. No prose
>    in layout fields — prose goes only in `description` and `notes`.
> 3. Every token reference must exist in `_ds_manifest.json`.

First run only — add one line at the end, review the result, fold any fixes into FORMAT.md,
then run again without it:

> Start with one component only: `Voucher`. Stop and return it before doing the rest.

## Updating after a design change

> Here is `<Name>.json` from the previous export. The design has changed: <what changed>.
> Update the file to match. Keep the structure, keys and slot names as they are — change
> only the values and nodes affected by the design change.
