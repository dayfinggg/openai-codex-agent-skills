---
name: designing-architecture
description: Design module boundaries, ownership or project layout for a new project, a multi-component feature or requested restructuring. Skip isolated edits and routine file placement.
---

# Designing architecture

Follow an existing project's organization. A materially different structure belongs in a requested redesign or an explicit user decision, not incidental cleanup. For a new project or substantial feature layout, read [layouts.md](layouts.md) as examples, not a required tree.

Group new code around the concept or feature it owns while respecting framework conventions. Keep public interfaces small. Separate substantial domain rules from transport and persistence when it reduces coupling, without introducing layers for a trivial handler.

Validate external input at the boundary and pass meaningful values inward. Read configuration in a coherent place. Add interfaces, factories or shared libraries only when current consumers, alternate implementations or a concrete test boundary need them.

Follow the project's localization system. For a new localized interface, put visible text in its language resources. Do not introduce a translation system into a one-language task that does not need it.

Split files by responsibility when growth obscures ownership or changes become coupled. Existing linter limits govern. Line counts are warning signs, not reasons to split cohesive code or change project configuration.

Check affected consumers and contracts. Preserve behavior in a requested refactor, or make intended behavior changes and their verification explicit.
