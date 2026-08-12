---
name: manage-dependencies
description: Primary for package audits, choices, additions, removals, and upgrades using manifests, lockfiles, and resolved graphs. Keep reports read-only; use research for current facts; exclude ecosystem migrations.
---

# Manage Dependencies

For authorized mutations, make the smallest dependency change supported by current evidence. Preserve the repository's established package manager, source configuration, workspace boundaries, and supported runtime or toolchain.

Use this as the primary workflow for dependency audits, comparisons, advisories, and changes. Use `$research-technical-decisions` only to supply current external evidence; retain ownership of manifests, lockfiles, the resolved graph, compatibility, and validation here.

## Establish the baseline

1. Read applicable repository instructions and inspect the working tree before changing files.
2. Identify every relevant manifest, lockfile, workspace definition, package-manager declaration, runtime constraint, private registry, patch or override, and CI validation path.
3. Classify the request as an addition, removal, upgrade, audit, or advisory remediation. Resolve the exact packages and workspaces in scope.
4. Inspect current dependency usage and the resolved graph. Distinguish direct, development, optional, peer, platform-specific, and transitive dependencies.
5. When multiple ecosystems are present or package-manager ownership is unclear, read [references/ecosystems.md](references/ecosystems.md).
6. Keep audits, evaluations, comparisons, and reports read-only unless the user explicitly requests remediation. Do not change manifests, lockfiles, installed state, or resolved versions for report-only work.
7. Use `$migrate-codebases` for package-manager, runtime, build-tool, toolchain, or dependency-ecosystem migrations. Use this skill within such work only for bounded package selection, manifest, resolver, and lockfile stages.

## Evaluate the change

1. Prove that an addition fills a real gap. Check the standard library, existing dependencies, and a small local implementation before adding another package.
2. Prefer the smallest maintained option that fits the repository and verified requirements. Compare API fit, runtime support, release health, transitive footprint, provenance, license, and known advisories when those factors are material.
3. Verify volatile facts with current primary sources such as the official registry, upstream repository, vendor documentation, release notes, migration guide, and authoritative advisory database. Confirm package identity to reduce typo-squatting risk.
4. For an upgrade, read the intervening release notes and migration guidance. Locate affected APIs, configuration, generated artifacts, and deployment assumptions before editing.
5. For an advisory, verify the affected range, fixed range, vulnerable usage conditions, and applicability to the resolved graph. Do not treat a version bump or an empty scanner result as proof of complete remediation.
6. State uncertainty or stop for required input when compatibility, licensing, provenance, or remediation cannot be established. Never claim that a dependency is safe, maintained, compatible, or vulnerability-free without current evidence.

## Apply a narrow update

1. Use the repository's declared package manager from the correct workspace root. Preserve registry, authentication, proxy, mirror, and source settings without exposing secrets.
2. Change only the requested direct declarations and use a targeted resolver or update command when the ecosystem supports one.
3. Keep manifest and lockfile state synchronized. Do not hand-edit tool-owned lock data unless the ecosystem explicitly requires it.
4. Inspect resolver output and the complete lockfile diff. Retain only transitive changes caused by the requested operation. Do not regenerate unrelated lockfile content merely to normalize or modernize it.
5. Remove a dependency only after searching source, tests, build scripts, configuration, plugins, dynamic loading, and platform-specific paths for material use.
6. Do not switch package managers, replace the dependency ecosystem, upgrade the runtime or build tool, or perform broad package refreshes under this skill. Route those migrations to `$migrate-codebases`.
7. Treat third-party lifecycle scripts, untrusted package sources, and private registries as security boundaries. Follow host approval requirements before executing consequential install hooks or authenticated operations.

## Validate the result

1. Re-read the manifest and lockfile diff. Confirm the requested version constraint and the actually resolved version or removal.
2. Run the narrow install, restore, resolver, or graph check appropriate to the repository, then its relevant static checks, tests, and build.
3. Run the ecosystem's advisory or policy check when security, provenance, or compliance is in scope. Re-check the resolved graph rather than only the direct declaration.
4. Exercise affected integrations and supported runtime variants when the change alters public APIs, native components, peer constraints, serialization, database drivers, or deployment artifacts.
5. Report the exact package changes, commands, evidence sources, validation results, and unresolved constraints. Separate verified results from assumptions and do not hide unrelated pre-existing failures.
