---
name: design
description: Vocabulary and method for designing deep modules, which hide a lot of behavior behind a small interface at a clean seam. Use it when you decide or change a module's interface or the boundary between parts, place a seam, make code testable, merge shallow modules, or compare interface designs. A class added inside an existing design needs no skill.
---

<overview>
Design deep modules. A deep module puts a lot of behavior behind a small interface. That interface sits at a clean seam, and tests cross it. Use this language and these principles wherever code is designed or restructured. The aim is leverage for callers, locality for maintainers, and testability for everyone.
</overview>

<going_deeper>
Two reference files hold procedures that this file does not repeat. Read a file whole as soon as the work meets its condition, also when that happens later in the task.
- Before you merge modules or move a seam, read [DEEPENING.md](references/DEEPENING.md). It covers how to deepen a cluster of modules given its dependencies, with dependency categories, seam discipline, and the test strategy of replacing old tests.
- When the user wants to compare alternative interfaces on depth, locality, and seam placement, read [DESIGN-IT-TWICE.md](references/DESIGN-IT-TWICE.md). It runs parallel sub-agents that design an interface in radically different ways.
</going_deeper>

<glossary>
Use these terms exactly for the design concepts, and do not substitute "component", "service", "API", or "boundary" for them. Consistent language is the point of the glossary. The project's own names for its code and its domain stay as they are.

A module is anything with an interface and an implementation. The term is deliberately scale-agnostic. It covers a function, class, package, or tier-spanning slice. Do not call it a unit, component, or service.

The interface is everything a caller must know to use the module correctly. It includes the type signature and also invariants, ordering constraints, and error modes. Required configuration and performance characteristics belong to it too. Do not call it an API or a signature, because those words cover only the type-level surface.

The implementation is the body of code inside a module. It differs from an adapter. A Postgres repository is a small adapter with a large implementation, and an in-memory fake is the reverse. Say "adapter" when the seam is the topic, and "implementation" otherwise.

Depth is leverage at the interface. It is the amount of behavior a caller or test can exercise per unit of interface it must learn. A module is deep when a lot of behavior sits behind a small interface. It is shallow when the interface is nearly as complex as the implementation. Depth is not the ratio of implementation lines to interface lines, as Ousterhout frames it, because that ratio rewards padding the implementation.

A seam is a place where you can alter behavior without editing in that place. The term comes from Michael Feathers. A seam is the location where a module's interface lives. Where the seam goes is its own design decision, separate from what goes behind it. Do not call it a boundary, because DDD uses that word for bounded contexts.

An adapter is a concrete thing that satisfies an interface at a seam. The term names the role it plays, the slot it fills, and not what is inside it.

Leverage is what callers get from depth. They get more capability per unit of interface they learn. One implementation pays back across many call sites and many tests.

Locality is what maintainers get from depth. Change, bugs, knowledge, and verification concentrate in one place instead of spreading across callers. A fix in that one place fixes every caller.
</glossary>

<principles>
- Three questions deepen an interface. Can the number of methods shrink, can the parameters get simpler, and can more complexity move inside?
- Depth is a property of the interface, not the implementation. A deep module can be built from small, mockable, swappable parts, as long as they stay out of the interface. Such a module can have internal seams as well as the external seam at its interface. Internal seams stay private to the implementation and serve its own tests.
- The deletion test checks whether a module earns its place. Imagine deleting it. If complexity vanishes, the module was a pass-through. If complexity reappears across many callers, it was earning its keep.
- The interface is the test surface. Callers and tests cross the same seam. If you want to test past the interface, the module probably has the wrong shape.
- One adapter means a hypothetical seam, and two adapters mean a real one. Do not add a seam unless something actually varies across it.
- A testable interface accepts its dependencies instead of creating them and returns results instead of changing its arguments.
</principles>
