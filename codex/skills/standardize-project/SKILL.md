---
name: standardize-project
description: Normalize repository layout, naming, boundaries, generated artifacts, and quality-tool configuration when conventions conflict or drift. Exclude new-project setup, features, behavior changes, migrations, and rewrites.
---

# Standardize Project

Normalize an existing repository around one coherent, evidence-backed set of conventions. Preserve observable behavior, supported environments, and user-owned changes throughout the work.

## Establish the Baseline

1. Inspect applicable instructions, version-control status, repository roots, workspaces, manifests, lockfiles, build files, quality-tool configuration, CI workflows, generated-file markers, and supported runtime versions.
2. Identify the dominant ecosystem from enforced configuration and executable evidence. Prefer repository and CI requirements over personal preference or generic convention.
3. Trace how local development, CI, packaging, deployment, code generation, and release workflows consume the files under consideration.
4. Run the narrowest relevant existing checks before editing. Record pre-existing failures and keep them distinct from regressions.
5. Distinguish accidental inconsistency from intentional exceptions required by compatibility, platform, package, deployment, or generated-code boundaries.

## Define the Normalization

1. Name each verified inconsistency and the existing convention that should replace it.
2. Select the smallest coherent change that removes the inconsistency without leaving competing conventions active.
3. Preserve public APIs, command behavior, package identities, import paths, serialized formats, data, side effects, supported versions, and deployment contracts unless the user explicitly authorizes a separate change.
4. Reuse the repository's established formatter, linter, test runner, build system, and package manager when they satisfy the requirement. Do not replace or upgrade tools merely to match preference.
5. Exclude new-project setup, feature work, behavioral refactoring, dependency migration, platform migration, and cosmetic cleanup that is not necessary for the selected normalization.

## Apply the Change

1. Change authoritative source configuration instead of generated output. Regenerate artifacts only through the established generator.
2. Update one independently verifiable slice at a time. Keep configuration, scripts, imports, paths, CI commands, and documentation consumed by tooling consistent within each slice.
3. Consolidate duplicated configuration only after proving that its semantics and consumers match. Preserve scoped overrides that serve a verified boundary.
4. Move or rename files only when layout or naming inconsistency is part of the request. Update every affected reference atomically and account for case-sensitive filesystems.
5. Preserve vendored, generated, third-party, migration-history, and lock files unless their established source or workflow requires an update.
6. Remove obsolete configuration only after confirming that no local, CI, packaging, deployment, generation, or editor workflow still consumes it.
7. Avoid repository-wide formatting, line-ending churn, mass renames, speculative module boundaries, new abstraction layers, and unrelated cleanup.

## Validate Incrementally

1. Run the focused configuration check, formatter verification, linter, type checker, tests, and build relevant to each completed slice.
2. Investigate failures before expanding the change. Compare them with the recorded baseline and revise the normalization when behavior or compatibility drifts.
3. Verify that documented local commands and CI invoke compatible entry points, configuration, paths, and supported versions.
4. Inspect the final diff for accidental behavior changes, user-change loss, case-only path hazards, stale references, unexpected lockfile changes, edited generated output, and unrelated formatting.
5. Report the convention adopted, the inconsistencies removed, the checks run, pre-existing failures, and any validation limits without claiming broader standardization than the evidence supports.

## Guardrails

- Preserve dirty-worktree changes and avoid overwriting concurrent edits.
- Prefer a partial, coherent normalization over a broad conversion that cannot be validated safely.
- Do not introduce a second tool for a responsibility already covered by an accepted project tool.
- Do not infer conventions from popularity when the repository supplies contrary evidence.
- Stop and separate the work when success requires changing product behavior, public contracts, supported platforms, or dependency strategy.
