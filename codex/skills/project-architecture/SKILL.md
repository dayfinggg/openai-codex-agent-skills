---
name: project-architecture
description: Choose project, package, module, test, and artifact boundaries for new or substantially restructured work.
---

Use this skill when starting a project, adding a subsystem, restructuring packages or workspaces, crossing ownership boundaries, or deciding where substantial new code belongs. Skip isolated edits that fit the current structure.

Map the existing tree and read applicable repository guidance, manifests, build and CI configuration, architecture records, tests, and nearby examples before choosing a layout. Follow the project's language and toolchain conventions rather than imposing a generic tree.

Choose the smallest structure that gives each responsibility clear ownership. Prefer boundaries that improve cohesion, information hiding, change locality, dependency direction, and stable public seams. Create a package, module, service, or workspace only when its independent contract, dependency set, build or release lifecycle, access boundary, or ownership justifies it. Do not create speculative layers or generic catch-all folders for future scale.

Treat an interface as its full observable contract, including inputs, outputs, invariants, errors, ordering, compatibility, configuration, and relevant resource limits. Put tests and generated artifacts where the existing toolchain and ownership model expect them. Declare dependencies through the ecosystem manifest and update required lockfiles together. Never track live secrets or hand-edit generated outputs when a source generator is authoritative.

Before handoff, inspect the complete structural diff for misplaced files, accidental generated artifacts, broken build or test discovery, and documentation that must change with the structure.

Read [references/examples.md](references/examples.md) when choosing between plausible layouts. Read [references/official-sources.md](references/official-sources.md) only when a design claim needs external grounding.
