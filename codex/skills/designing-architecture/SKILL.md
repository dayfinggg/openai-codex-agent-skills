---
name: designing-architecture
description: Design module boundaries, ownership or project layout for a new project, a multi-component feature or requested restructuring. Skip isolated edits and routine file placement.
---

# Designing architecture

Follow the project's organization and framework conventions. A materially different structure belongs in a requested redesign or an explicit user decision, not incidental cleanup. Read [layouts.md](layouts.md) when choosing a new layout, resolving unclear ownership or decomposing mixed responsibilities. Its trees are examples, not required scaffolding.

Before substantial implementation, identify the affected capabilities, their responsibilities, public contracts and dependency direction. Decide where rules, mutable state and external resources belong before growing the entry point. Use a brief working map, not a mandatory architecture document. Keep a cohesive small feature together when further separation adds only indirection.

Give each module a clear responsibility and keep its internals private. Group code that changes for the same reason. Separate substantial domain rules, transport, presentation and persistence where their changes or dependencies differ. Keep startup code focused on composition and lifecycle, rather than accumulating feature rules. Do not split code merely by function count or file size.

For each shared state or resource, identify the authoritative owner, permitted mutations and lifetime. Make dependencies explicit. Assign acquisition and cleanup, including error or cancellation paths, rather than sharing unowned connections, timers or mutable globals. Reuse the framework's lifecycle mechanisms without introducing a custom framework.

Validate external input at the boundary and pass meaningful values inward. Read configuration coherently. Introduce interfaces, factories, layers or shared libraries only for current consumers, a real alternate implementation or a concrete test boundary. Do not create pass-through wrappers or speculative extension points.

Recheck boundaries as responsibilities emerge. A growing file prompts inspection for unrelated reasons to change, interleaved side effects, hidden state ownership or tests needing unrelated setup. Extract a coherent responsibility when these signals justify it. Follow existing linter limits, but do not impose universal line caps or change configuration to manufacture compliance.

Follow the project's localization system. For a new localized interface, put visible text in its language resources. Do not introduce a translation system into a one-language task that does not need it.

Trace affected consumers and the real execution path after extraction. Check public contracts, dependency cycles, state transitions and resource cleanup. Preserve behavior in a requested refactor, or make intended behavior changes and their verification explicit.
