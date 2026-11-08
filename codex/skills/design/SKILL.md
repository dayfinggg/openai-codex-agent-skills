---
name: design
description: Design or compare module interfaces, test seams, and dependency boundaries.
---

A module hides an implementation behind an interface. The interface includes caller obligations, invariants, errors, and ordering.
Prefer a small interface that hides meaningful complexity. A pass-through module earns its place only when it removes complexity from callers.
A seam is a place where behavior can vary without editing the caller. Add one for a real variation or test need.
Keep internal decomposition private. Test the behavior callers rely on through the interface they use.
Use the project's established vocabulary rather than renaming concepts to fit this skill.
For merging shallow modules, read [DEEPENING.md](references/DEEPENING.md).
For explicitly requested alternative designs, read [DESIGN-IT-TWICE.md](references/DESIGN-IT-TWICE.md). Follow the runtime's delegation rules.
