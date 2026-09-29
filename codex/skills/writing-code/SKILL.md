---
name: writing-code
description: Write or change code using project conventions and language-specific guidance. Use for implementation, scripts or substantial code examples, not a simple file lookup or prose edit.
---

# Writing code

Preserve the existing stack, public contracts and unrelated user work. Prefer correct behavior, the smallest coherent change, readable names and direct control flow over speculative abstractions.

For implementation decisions about errors, state, resources or concurrency, read [principles.md](principles.md). Read only the applicable language reference:
- PHP: [languages/php.md](languages/php.md).
- Python: [languages/python.md](languages/python.md).
- TypeScript or JavaScript: [languages/typescript.md](languages/typescript.md).
- HTML or CSS: [languages/css.md](languages/css.md).
- Bash or POSIX shell: [languages/shell.md](languages/shell.md). For PowerShell, use native cmdlets, literal paths and the session's Windows safety rules.

Reference examples are version-specific preferences, not permission to upgrade dependencies, replace established tooling or impose new linter settings. Check the project's manifest and installed APIs before using a feature. Consult official documentation when local evidence leaves a version-sensitive choice unresolved.

Use another skill only for the actual operation it helps with, such as a schema migration, visual design or debugging. Adding a file does not automatically need an architecture review, and a small code explanation does not need the full implementation workflow.

Run the project's relevant checks for the changed surface. Expand verification for shared contracts or project requirements, not automatically after every minor edit. Do not create notes, plans or documentation files unless requested or required by the project.
