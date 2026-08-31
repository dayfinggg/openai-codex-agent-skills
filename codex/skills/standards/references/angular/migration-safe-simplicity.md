# Migration-safe simplicity

- Prefer stable public Angular APIs over private internals, experimental features, and framework-wide custom abstractions.
- Keep Angular core and CLI majors aligned, and update one supported major at a time with `ng update`.
- Read the versioning page and changelog before upgrading; deprecated APIs remain for at least one major release, but removal occurs only in a major release.
- For an NgModule application, run the standalone schematic in order: convert declarations, remove unnecessary modules, then switch bootstrap APIs.
- Build, test, lint, format, and review the diff after each migration step rather than batching unrelated edits.
- Preserve NgModule interop when a library or team boundary still needs it; migration is optional and can be incremental.
- For older components that depend on eager checks, make `ChangeDetectionStrategy.Eager` explicit instead of relying on an old default.
- Keep public component inputs and outputs narrow and typed so future refactors do not require callers to understand internals.
- Prefer direct composition, explicit imports, and one source of truth over clever base classes or global flags.
- Record the Angular version and browser or SSR assumptions near unusual compatibility code, then delete the workaround when its migration aid is no longer needed.
