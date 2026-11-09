---
name: design
description: Vocabulary and method for designing deep modules, which hide a lot of behavior behind a small interface at a clean seam. Use it whenever you add a module, service, or class, change an interface or a boundary between parts, decide where a seam goes, make code testable, merge shallow modules, or compare interface designs.
---

<overview>
Design deep modules. A deep module puts a lot of behavior behind a small interface. That interface sits at a clean seam, and tests cross it. Use this language and these principles wherever code is designed or restructured. The aim is leverage for callers, locality for maintainers, and testability for everyone.
</overview>

<glossary>
Use these terms exactly, and do not substitute "component", "service", "API", or "boundary". Consistent language is the point of the glossary.

A module is anything with an interface and an implementation. The term is deliberately scale-agnostic. It covers a function, class, package, or tier-spanning slice. Do not call it a unit, component, or service.

The interface is everything a caller must know to use the module correctly. It includes the type signature and also invariants, ordering constraints, and error modes. Required configuration and performance characteristics belong to it too. Do not call it an API or a signature, because those words cover only the type-level surface.

The implementation is the body of code inside a module. It differs from an adapter. A Postgres repository is a small adapter with a large implementation, and an in-memory fake is the reverse. Say "adapter" when the seam is the topic, and "implementation" otherwise.

Depth is leverage at the interface. It is the amount of behavior a caller or test can exercise per unit of interface it must learn. A module is deep when a lot of behavior sits behind a small interface. It is shallow when the interface is nearly as complex as the implementation.

A seam is a place where you can alter behavior without editing in that place. The term comes from Michael Feathers. A seam is the location where a module's interface lives. Where the seam goes is its own design decision, separate from what goes behind it. Do not call it a boundary, because DDD uses that word for bounded contexts.

An adapter is a concrete thing that satisfies an interface at a seam. The term names the role it plays, the slot it fills, and not what is inside it.

Leverage is what callers get from depth. They get more capability per unit of interface they learn. One implementation pays back across many call sites and many tests.

Locality is what maintainers get from depth. Change, bugs, knowledge, and verification concentrate in one place instead of spreading across callers. A fix in that one place fixes every caller.
</glossary>

<relationships>
The terms relate in fixed ways.
- A module has exactly one interface, the surface it presents to callers and tests.
- Depth is a property of a module, measured against its interface.
- A seam is where a module's interface lives.
- An adapter sits at a seam and satisfies the interface.
- Depth produces leverage for callers and locality for maintainers.
</relationships>

<deep_and_shallow>
A deep module has a small interface over a large implementation. Its few methods take simple parameters and hide complex logic. A shallow module has a large interface over a thin implementation that mostly passes calls through. Avoid shallow modules.

Three questions help when you design an interface.
- Can the number of methods shrink?
- Can the parameters get simpler?
- Can more complexity move inside?
</deep_and_shallow>

<principles>
- Depth is a property of the interface, not the implementation. A deep module can be built from small, mockable, swappable parts, as long as they stay out of the interface. Such a module can have internal seams as well as the external seam at its interface. Internal seams stay private to the implementation and serve its own tests.
- The deletion test checks whether a module earns its place. Imagine deleting it. If complexity vanishes, the module was a pass-through. If complexity reappears across many callers, it was earning its keep.
- The interface is the test surface. Callers and tests cross the same seam. If you want to test past the interface, the module probably has the wrong shape.
- One adapter means a hypothetical seam, and two adapters mean a real one. Do not add a seam unless something actually varies across it.
</principles>

<designing_for_testability>
Good interfaces make testing natural. Three rules help.

The first rule is to accept dependencies instead of creating them. This version is testable.

```typescript
function processOrder(order, paymentGateway) {}
```

This version is hard to test.

```typescript
function processOrder(order) {
  const gateway = new StripeGateway();
}
```

The second rule is to return results instead of producing side effects. This version is testable.

```typescript
function calculateDiscount(cart): Discount {}
```

This version is hard to test.

```typescript
function applyDiscount(cart): void {
  cart.total -= discount;
}
```

The third rule is a small surface area. Fewer methods need fewer tests, and fewer parameters need simpler test setup.
</designing_for_testability>

<rejected_framings>
This skill rejects three common framings.
- Ousterhout frames depth as the ratio of implementation lines to interface lines. That rewards padding the implementation, so this skill measures depth as leverage instead.
- "Interface" as the TypeScript `interface` keyword or a class's public methods is too narrow. Here the interface includes every fact a caller must know.
- "Boundary" is overloaded with DDD's bounded context. Say seam or interface instead.
</rejected_framings>

<going_deeper>
- [DEEPENING.md](references/DEEPENING.md) covers how to deepen a cluster of modules given its dependencies, with dependency categories, seam discipline, and the test strategy of replacing old tests. Read it whole before you merge modules or move a seam.
- [DESIGN-IT-TWICE.md](references/DESIGN-IT-TWICE.md) runs parallel sub-agents that design an interface in radically different ways. Read it when the user wants to compare alternative interfaces on depth, locality, and seam placement.
</going_deeper>
