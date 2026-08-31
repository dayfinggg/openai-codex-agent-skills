# Rust engineering standards

Use this reference as a design and review checklist for production Rust.
Prefer designs whose ownership, validity, failure, and concurrency rules are visible in types.
Encode invariants in types where practical. Keep runtime validation for external input, environmental state, and conditions that cannot be known at compile time.
Prefer the simplest correct standard-library abstraction before adding a dependency or a custom layer.
Keep behavior unsurprising, names conventional, and public APIs smaller than their implementations.

## Reference map

- [Idiomatic Rust](idiomatic-rust.md)
- [Ownership-driven design](ownership-driven-design.md)
- [Error types and failure policy](error-types-and-failure-policy.md)
- [Traits and generics](traits-and-generics.md)
- [Modules and crate boundaries](modules-and-crate-boundaries.md)
- [Public API guidelines](public-api-guidelines.md)
- [Async and concurrency](async-and-concurrency.md)
- [Formatting, linting, and tests](formatting-linting-and-tests.md)
- [Unsafe boundaries](unsafe-boundaries.md)
- [Size and cohesion heuristics](size-and-cohesion-heuristics.md)
- [Verified examples and maintainer guidance](verified-examples-and-maintainer-guidance.md)
- [Sources](sources.md)
