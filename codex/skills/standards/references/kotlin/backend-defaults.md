# Backend defaults

Use `val` by default and make mutation local, deliberate, and owned by one component.
Expose `List`, `Set`, and `Map` when callers only need to read; expose `Mutable*` only when mutation is part of the contract.
Remember that `val` prevents reassignment of a reference, but a referenced mutable object can still change.
Use constructor parameters to make required dependencies and invariants visible at the call site.
Keep domain functions deterministic where possible, and isolate I/O, clocks, randomness, and framework callbacks behind small interfaces.
Use named types for important identifiers, units, and states rather than passing interchangeable primitive values.
On the JVM, `@JvmInline value class` is a concise option for type-safe wrappers around simple values.
Prefer meaningful named data classes over `Pair` or `Triple` when a value crosses a boundary or has domain meaning.
Use the standard library's collection operations for simple transformations, but choose a loop when a chain hides control flow or costs matter.
Use `require` for invalid arguments and `check` for invalid object state at the point where the invariant is known.
