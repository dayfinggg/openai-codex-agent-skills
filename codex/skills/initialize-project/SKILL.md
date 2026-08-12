---
name: initialize-project
description: Bootstrap a new project with minimal structure, tooling, tests, and a verified smoke path after its stack and runtime are set. Exclude existing-project cleanup; combine with a language or framework skill when available.
---

# Initialize Project

Create the smallest idiomatic project that can be built, checked, tested, and run for its intended purpose. Preserve any existing user files and keep generated scope proportional to stated requirements.

## Establish the baseline

- Confirm the deliverable, language and framework, supported runtime versions, package or build tool, deployment target, and repository context.
- Inspect the destination and its parent workspace before generating files. Inherit applicable workspace configuration and avoid creating a nested repository or competing toolchain by accident.
- Resolve only choices that affect the initial structure. Ask for missing material decisions through the question tool when a safe default cannot be inferred.
- Verify current commands, supported versions, and configuration syntax in primary documentation when they may have changed. Prefer the installed compatible toolchain unless the request requires an upgrade.
- Use an official initializer when it produces a smaller and more reliable baseline than manual creation. Inspect its output and remove optional examples, telemetry, duplicated tooling, and unused dependencies.

## Design the minimum structure

- Follow the primary ecosystem's conventional source, test, and configuration layout.
- Add only files required to install or restore dependencies, build or execute the deliverable, enforce requested quality checks, test one real behavior, and exclude generated or private data.
- Choose one formatter and one primary lint path. Add a separate type checker only when the compiler or language tooling does not already provide the required checks.
- Keep application configuration separate from credentials. Read secrets from the runtime environment or the target platform's secret mechanism; never fabricate secret values.
- Add ignore rules for generated outputs, dependency caches, local environment files, credentials, and editor artifacts that are not intentionally shared.
- Commit lockfiles according to the ecosystem's current convention and the artifact type. Do not pin extra tools or dependencies without a reproducibility or compatibility reason.
- Apply relevant language and framework skills to source and test files. Apply `$engineer-production-code` when available for the production-code baseline.

Do not add speculative layers, placeholder features, sample screens or endpoints, unfinished task markers, empty abstractions, duplicate configuration, convenience dependencies, CI, containers, deployment files, licenses, or documentation unless requirements or the target ecosystem make them necessary. Create a project README only when requested or required for the intended packaging or publication workflow.

## Build a working smoke path

1. Initialize the package or build metadata with the real project identity and supported targets.
2. Create the smallest source entry point or library surface that expresses behavior required by the request; avoid demonstration-only functionality.
3. Add a focused test that exercises that behavior through a stable public boundary.
4. Configure formatting, linting, type checking, building, and testing through native project commands or the smallest conventional task runner.
5. Add runtime configuration loading only when the application needs configuration now. Fail clearly for required missing values and keep optional defaults non-sensitive.

If a generator may overwrite files, generate into a temporary location first or inspect its dry-run output, then transfer only the required changes.

## Verify the result

Run the checks supported by the project in dependency order:

1. Restore or install dependencies using the selected package manager.
2. Apply formatting, then run the non-mutating formatter check when available.
3. Run linting and static or type checks.
4. Build or package the project when applicable.
5. Run the test suite.
6. Execute the smoke path using its normal entry command.

Inspect the final tree for generated clutter, stale placeholders, unused dependencies, leaked local paths, credentials, and configuration that conflicts with a parent workspace. Report any check that could not run and the exact external prerequisite; do not claim the project is ready when verification is incomplete.
