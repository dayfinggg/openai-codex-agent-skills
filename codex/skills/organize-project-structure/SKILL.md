---
name: organize-project-structure
description: Choose or change repository file and directory layout, feature-versus-layer placement, colocation, framework-constrained filenames, public entry points, barrels, tests, migrations, configs, and generated-code locations. Use when filesystem organization or naming is the primary deliverable after responsibilities are settled; skip architecture boundary decisions, domain or UI design, and ordinary implementation that follows an established layout.
---

# Organize Project Structure

## Establish the structure question

1. Confirm that the primary outcome is a file tree, placement rule, filename, move, or public entry point within already settled responsibilities. If the task changes module, data, runtime, deployment, security, or team-ownership contracts, resolve that decision with `design-project-architecture` first. If business meaning or consistency ownership is unclear, use `domain-modeling`. If the user-facing experience is unsettled, use `design-ui-ux`. Use `clarify-and-specify` only when evidence leaves a material decision unresolved.
2. Do not activate this workflow for ordinary implementation that merely adds a file beside established peers. Follow the existing layout directly unless the layout choice itself is material to the request.

## Discover the repository grammar

1. Find the owning application or package root from its manifest and build boundary. Read scoped repository instructions and the configurations for generators, routing, module resolution, tests, ORM or migrations, formatting, and code generation.
2. Determine the exact language, framework, versions, package manager, runtime, and generator from local definitions. Inspect at least two or three neighboring files of the same role when they exist, including their imports, exports, registration, tests, and consumers.
3. Resolve conflicts in this order: mechanically required contract, scoped instructions and configured tools, coherent precedent in the owning package or feature, official generator for the installed version, language convention, then clarity as a tie-breaker. Do not copy an obvious typo merely for consistency or rename an unusual public path before tracing its consumers.

## Choose the smallest sufficient layout

1. Treat the settled architecture boundary as an input. Identify the owning deployable, package, feature, data owner, internal surface, and supported public surface. A directory does not create ownership or encapsulation by itself.
2. Compare feature folders, layer folders, colocation, or a hybrid only when more than one remains viable. Prefer the existing coherent pattern. Use feature colocation when change-coupled files belong to one capability, layer folders when the framework or small application makes them clearer, and framework topology whenever paths drive runtime discovery.
3. Trace every new package, shared folder, barrel, entry point, config layer, or generated boundary to a current owner and consumer. Do not create `common`, `shared`, `lib`, `utils`, a new layer, or a package for hypothetical reuse. Do not mass-rename, reformat, or reorganize unrelated files to make the tree symmetrical.
4. Read [ecosystem grammars and example trees](references/ecosystem-layouts.md) only for the stack being organized. Preserve mechanically significant names such as Next.js route files, Python import modules, test-runner patterns, package entry points, and migration identifiers.

## Name files by actual role

- In NestJS, use `<feature-or-concept>[.<qualifier>].<role>[.<test-kind>].ts` only when the file has that role. `user.service.ts` is an injectable service, `auth.controller.ts` is a transport controller, `foo.repository.ts` owns a persistence contract or adapter, `*.module.ts` declares a Nest `@Module()`, `*.schema.ts` defines a specific runtime or persistence schema, and `*.dto.ts` defines a transport-shaped boundary contract. Do not add an empty repository wrapper or call helpers a service to satisfy a suffix.
- Never create the misspelled suffix `serivces`. Treat `lib.serivces.ts` as an error or unresolved existing public path, not a convention. Do not create `lib.services.ts` without a named domain or technical owner and a real aggregation responsibility. Use `lib.service.ts` only when one actual `LibService`-style role and the local framework precedent support it.
- Do not transfer Nest dot suffixes to React, Next.js, Python, Go, Java, or C#. Follow each ecosystem's import, routing, autoloading, symbol, and filename grammar.

## Place boundary and lifecycle artifacts

- Create a barrel only for an intentional consumer-facing boundary. Prefer explicit exports. Keep same-feature Nest providers on direct imports rather than routing internal imports through a same-directory barrel. Treat package manifest exports, framework module exports, documented Python names, and routes as the real public contracts.
- Follow the configured runner's test discovery and the owning package's placement. Colocate narrow unit or component tests when that is the local pattern. Keep integration, end-to-end, and cross-service contract tests in their real environment or contract boundary.
- Keep migrations with the service or package that owns the data. Preserve tool-defined ordering and history. Review new generated migrations before first application, but do not rename or edit applied migrations as ordinary refactoring.
- Preserve canonical tool config names. Keep repository-wide policy at the root and package-specific targets beside their owner. Create a shared config package only for multiple current consumers with a maintained contract.
- Distinguish scaffolded retained source, reproducible derived output, and generated reviewable history. Edit scaffolded source normally after generation. Change derived output through its source and generator. Treat migration history according to its tool and application state.

## Verify the resulting tree

Inspect the full tree and diff. Verify affected imports, package exports, route or module discovery, generator output paths, test discovery, migration status, and configured build or type checks. For a move or rename, trace all consumers and preserve public compatibility or complete the explicitly required migration. Remove any directory, barrel, wrapper, or alias that lacks a current owner, consumer, or mechanical requirement.

Finish when each changed path has an owner and actual role, framework and language contracts still resolve, public and historical paths are accounted for, and no unrelated reorganization or speculative layer remains.
