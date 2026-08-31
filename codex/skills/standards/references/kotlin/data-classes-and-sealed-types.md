# Data classes and sealed types

Use a data class for a value whose identity is its declared data, such as a request, response, command, or immutable domain snapshot.
Only primary-constructor properties participate in generated `equals`, `hashCode`, `toString`, `componentN`, and `copy` methods.
Keep equality-defining properties in the primary constructor and place derived or lifecycle state in the body only intentionally.
Remember that `copy()` is shallow, so mutable members remain shared between the original and the copy.
Prefer `val` properties and read-only collection views in data classes that cross threads or module boundaries.
Do not expose a data class as a long-lived public library contract when generated members would freeze implementation details.
Use an interface with explicit properties when clients need a stable API that can evolve independently of storage.

Use a sealed class or interface when the set of direct alternatives is deliberately closed.
Pair sealed types with an exhaustive `when` so adding an alternative produces a compiler-visible review point.
Use nested implementations for small hierarchies that should be discoverable beside the sealed type.
Use top-level implementations when the hierarchy has several levels or the types need independent names.
Treat sealed alternatives in public APIs as compatibility commitments because exhaustive client `when` expressions can break when cases change.
Choose an open interface, enum-like object, or explicit unknown case when future extension is expected.
Use sealed result or error types when the caller must handle a finite set of expected outcomes.
Use exceptions for exceptional failures that should propagate through the call stack, not as an untyped substitute for every domain outcome.
