---
name: architecture
description: Design project and module structure, system boundaries, dependency rules, or architecture and spec documents. Use for architecture changes and system design, not a single module API or implementation plan.
license: MIT
---

# Architecture

This skill covers where code goes, how modules stay apart, which architecture style to pick, how a system handles failure and load, and how decisions and specs are recorded. The version snapshot is dated 2026-11-17. Check installed tool versions and their version-matched docs before using a command.

## References

Each linked file holds details for one branch. Open the full file with the tools available in this Codex session before taking that branch.

- [references/boundary-tools.md](references/boundary-tools.md): read when adding, configuring, upgrading or debugging a dependency-boundary or cycle check.
- [references/spec-formats.md](references/spec-formats.md): read when the repo has `.specify/`, `.kiro/` or `openspec/`, or the user asks for spec-driven development.
- [references/system-design.md](references/system-design.md): read when designing or reviewing how a service handles failure, load, data ownership, interface changes or operation, when splitting a service out, or when replacing a legacy system.

## Check first

- Before moving or adding modules, read what the repo already decided: ADRs (`docs/decisions/`, `docs/adr/`, `doc/arch/`), specs (`.specify/`, `.kiro/`, `openspec/`) and boundary configs (`.dependency-cruiser.*`, `boundaries/` settings in `eslint.config.*`, `tags` in `project.json`, `boundaries` in `turbo.json`, `deptrac.php` or `deptrac.yaml`, `[tool.importlinter]`, ArchUnit tests, `deny.toml`).
- `git config core.ignorecase` prints `true` on a checkout where a wrong-case file name passes locally and fails on Linux.

## Module design

- Information hiding (Parnas): a module hides the design decision most likely to change, such as a storage format, a provider or a pricing rule. Decompose by those decisions, not by the steps of processing (read, parse, save).
- Cohesion and coupling: concepts that change together share a module, and a module can be understood without reading its neighbours. Test a boundary on a real change: one user story should touch mostly one module.
- Split a module on a second reason to change, meaning a second person or source that asks for changes (single responsibility, Martin), not on its length. A deep module, with a small interface over much functionality, beats several shallow ones that only pass calls through (Ousterhout).
- Bounded context (Evans): one model and one vocabulary hold inside an explicit boundary of team, code and schema. Use it when several teams share a large domain. One team with a small model does not need it.
- Top-level folders name the domain, not the framework, and use cases run in tests without the web server or the database.
- Share code between modules only for one concept with one owner, because a wrong shared abstraction costs more than duplication.

## Layout

- Follow the layout the project already has. In a new project use the standard layout of its ecosystem, not one folder for every file or one file for all code.
- In new code, put business capabilities at the top level (`billing/`, `catalog/`) and technical roles inside each. Top-level `controllers/`, `services/` and `utils/` folders spread every change across the tree.
- Give each module one public entry point and import only that from outside: its `index.ts`, a package's `exports` map, a Python package's `__init__.py` with `__all__`, a Rust crate root with internals at `pub(crate)`. Add no re-export `index` files in subfolders.
- JS and TS workspaces: deployables in `apps/*`, libraries and shared configs in `packages/*`, one level deep. Depend on a sibling with `"workspace:*"` and import it by name, not by a `../` path. Packages extend a shared tsconfig package, so the root needs no `tsconfig.json`.
- Rust workspaces: a virtual root manifest with `members = ["crates/*"]` and crates flat under `crates/`. `[profile.*]` and `[patch]` work only in the root manifest.
- Python: `src/<package>/`, tests in `tests/`, pytest with `--import-mode=importlib`. The default `prepend` mode fails with "import file mismatch" when two test files share a name.
- PHP: PSR-4 maps a namespace prefix to a base directory, each sub-namespace to a subdirectory of the same case and the class to the file name. Tests go under `autoload-dev`. In CI run `composer dump-autoload --optimize --dry-run --strict-psr --strict-ambiguous` (`--strict-ambiguous` needs 2.8+), which fails on mapping errors, on a class found in two files and on paths that differ only in case.
- Use one term per domain concept in module names, code, tests, specs and UI, so one search finds all of it. Create no `utils`, `helpers`, `common` or `misc` modules.

## Boundaries

- Every dependency rule is a check that fails CI, an architectural fitness function: an automated test that a characteristic you chose still holds. Domain code imports no framework, database or HTTP code, adapters import the domain, and a feature reaches another only through its entry point. Tool choice and syntax are in [references/boundary-tools.md](references/boundary-tools.md).
- Write the fix into the rule's message, since the agent that breaks a rule reads only the error: dependency-cruiser `comment` (shown with `--output-type err-long`), import-linter `broken_contract_guidance` (2.14+), eslint-plugin-boundaries `message`. Name the ADR behind the rule.
- Adding a rule to existing code: baseline today's violations and fail only on new ones. Shrinking the baseline is routine, growing it is the user's call.
- `disallowWorkspaceCycles: true` in `pnpm-workspace.yaml` turns a package cycle into an install failure. Cargo rejects crate cycles itself.

## Architecture style

- Default to a modular monolith: one deployable, modules by business capability, each module the only reader and writer of its own tables.
- Inside a module whose features share little logic, use vertical slices: one folder per use case with its handler, validation, data access and tests.
- Add a port with adapters only at a boundary you do not own (payment provider, broker, clock) or where two real implementations exist. A repository interface with one implementation over your own database is a layer without a seam.
- Layering (interface, application, domain, infrastructure) is the dependency rule inside a module, not the top-level folder structure.
- Use events between modules only when the producer must not know its consumers or the work must survive a consumer being down.
- Split out a service only when a separate team owns and deploys it, it needs different scaling, availability or release cadence, its module boundary has stayed stable, and the platform already provisions, monitors and deploys services automatically. A shared database, lockstep deploys or chains of synchronous calls make a distributed monolith.

## Decisions and specs

- Decisions go in `docs/decisions/NNNN-title-with-dashes.md` in MADR 4.0.0 format, unless the repo has another folder or template. Numbers only increase and are never reused.
- Write an ADR for a decision that is costly to reverse or invisible in code: the style, a boundary rule, data ownership, a rejected obvious option. Skip routine choices.
- Never rewrite the decision of an accepted ADR, because the record is the history. Write a new one and set the old status to `superseded by ADR-NNNN`. Fix typos and links in place. An ADR you write stays `proposed` until the user accepts it.
- Fill MADR's Confirmation section with the check that enforces the decision (a lint rule name, a test).
- C4: System Context and Container diagrams suffice for most teams. Add a Component diagram only where it explains something, and skip the Code level. A C4 container is a separately running application or data store, not a Docker container.
- Keep diagrams as text (Structurizr DSL, Mermaid, PlantUML) beside the ADRs so they diff in pull requests. In arc42, keep the 12-section structure, fill only the sections readers need, and let section 9 point to the ADRs.
- Use the repo's existing spec format (Spec Kit, Kiro, OpenSpec) and add no second one. Without one, use the installed `planning` skill. Adopt a format only when the user asks or specs must stay a current contract after the change ships.
- A spec states observable behavior: inputs, outputs, errors, constraints. Libraries, class names and steps belong in the plan or design file.

## Generated code

- Keep generated code in the project's designated directory or suffix, mark it as generated in `.gitattributes` where appropriate, and change the generator input rather than generated output.
- Check the current tool's documented exclusion controls before configuring an indexer or search tool. Do not transfer Claude-specific `.claude/settings.json` controls to Codex.

## Gotchas

- A case-only rename with plain `mv` on Windows or macOS leaves Git tracking the old name, so imports pass locally and fail on Linux. Use `git mv old.ts Old.ts`.
- Two tracked paths that differ only in case lose one file on Windows and macOS checkouts. List them with `git ls-files | sort -f | uniq -di`.
- `tsc` rejects a wrong-case import (`forceConsistentCasingInFileNames` defaults to true), but bundlers, test runners and Node.js resolve it on a case-insensitive file system, so only the Linux build fails.
- An `index.ts` that re-exports a folder makes Vite load every re-exported file and is the usual knot in import cycles. `ReferenceError: Cannot access 'X' before initialization` at import time is an ESM cycle. Import the file directly.
- `ImportError: cannot import name 'X' from partially initialized module` is a Python cycle. Move the shared code into a lower module. An import inside a function only hides the cycle. Imports under `if TYPE_CHECKING:` are fine.
- A Python module named like a stdlib or installed package (`random.py`, `email.py`, `types.py`) shadows it. Python 3.13 and later add "consider renaming" to the error.
- Vitest's default include `**/*.{test,spec}.?(c|m)[jt]s?(x)` also matches Playwright specs and compiled tests in `dist/`, since its default exclude covers only `node_modules` and `.git`. Set Playwright `testDir: './e2e'` and Vitest `exclude: [...configDefaults.exclude, 'e2e/**', 'dist/**']`, because `exclude` replaces the default. "Playwright Test did not expect test() to be called here" is the symptom.
- Jest runs every file under `__tests__/` as a test, so a helper there fails with "Your test suite must contain at least one test". Keep helpers outside it.
- Each `tests/*.rs` file is its own crate in Rust. Shared helpers go in `tests/common/mod.rs`, not `tests/common.rs`.
- Turborepo errors on nested packages such as `apps/a` and `apps/a/b`. Group with a `packages/group/*` glob and no `package.json` in `packages/group/`.
- pnpm's `linkWorkspacePackages` defaults to false, so a plain version range for a workspace package can install a same-named package from the registry. Use `workspace:*`.

For the API and seam of one module, keep the analysis limited to that interface and its callers. Use `planning` to break an approved change into tasks. Use the relevant language skill for implementation details, and `database` when the design changes persistent data.
