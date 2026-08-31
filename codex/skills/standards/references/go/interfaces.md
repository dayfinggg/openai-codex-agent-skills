# Interfaces

An interface describes behavior, and a type satisfies it implicitly; use that structural property to reduce coupling.[1][5]
Begin with a concrete implementation and a real consumer; do not invent an interface before a use case exists.[2][5]
The consumer usually owns the interface and should list only the methods it actually uses.[2][5]
Use an interface when several implementations must serve one consumer, when a consumer needs to hide a large surface, or when a real boundary requires it.[5]
Do not define an implementor-side interface solely to make mocking convenient; test the real public API or define the consumer's small interface.[2][5]
Prefer one or two method interfaces that compose cleanly; larger interfaces are harder to implement and substitute.[1][5]
Return concrete types by default so callers retain useful methods and future implementations can grow without interface churn.[2][5]
Return an interface when it is the product or protocol, when runtime choice requires it, or when exposing extra methods would break an invariant.[5]
Make interface contracts, edge cases, ownership, error semantics, and concurrency expectations visible in types, tests, or public API documentation when callers need details that the signature cannot express.[5][26]
Use compile-time interface assertions at unusual implementation boundaries, not as decoration on every satisfying type.[1]
The standard library's `io.Reader`, `io.Writer`, and composed interfaces are a verified model of small, capability-focused contracts.[26]
