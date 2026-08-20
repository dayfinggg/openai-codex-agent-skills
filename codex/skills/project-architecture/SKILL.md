---
name: project-architecture
description: Organize project structure, modules, tests, and artifacts for new or substantially restructured work.
---

Use this skill when starting a project, restructuring a repository, adding a subsystem, crossing module boundaries, or fixing misplaced files. Skip it for an isolated edit that fits the existing structure.

Map the existing tree before choosing a layout. Read applicable `AGENTS.md`, `CONTRIBUTING`, `README`, architecture records, manifests, build files, CI, tests, and nearby examples. Follow the language and toolchain conventions and the repository's established naming. Do not impose a generic tree when the project already has a coherent one.

Keep the root discoverable and sparse. Put project identity, manifests, build entrypoints, and project-wide tooling at the root. Give production source, tests and fixtures, documentation, scripts, configuration, generated files, build outputs, artifacts, caches, and secret placeholders clear ownership and placement. A small project may use a flat source layout when its toolchain expects it; a larger project may use conventional source, test, documentation, and script directories. Name files and modules after cohesive responsibilities. Avoid speculative `utils`, `misc`, `common`, or `helpers` folders.

Choose module seams by cohesion, information hiding, ownership, change locality, and dependency direction. Expose narrow public entrypoints and keep callers away from internals. Treat an interface as its full contract, including inputs, outputs, invariants, ordering, errors, configuration, compatibility, and resource limits. Keep unit, integration, functional, and end-to-end tests separate when their runtime or ownership differs; otherwise follow local convention. Test behavior through the public seam.

Use the smallest layout that fits the project. Keep a simple project simple. Use feature-oriented slices when changes repeatedly cross layers, and use separate projects or workspaces only when independent builds, ownership, releases, access, or dependencies justify them. Do not create layers, packages, or folders for hypothetical future scale. Keep broad refactors separate from behavior changes when practical.

Declare dependencies in the ecosystem's manifest and update its lockfile atomically when required. Treat generated files as outputs of declared inputs, configuration, dependency versions, environment assumptions, and deterministic tools. Do not hand-edit generated output. Ignore build directories, caches, local databases, editor state, and secrets. Never track live secrets; track only placeholders or approved encrypted artifacts. Before handoff, inspect the complete diff and all tracked, untracked, and generated files, update affected documentation, and remove temporary artifacts.

Read [references/examples.md](references/examples.md) when choosing between a small layout, a multi-package layout, a feature slice, or a derived-file boundary.
