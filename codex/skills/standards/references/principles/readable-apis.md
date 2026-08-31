# Readable APIs

- A caller should understand what an operation does, costs, mutates, returns, and can fail from its name, signature, and focused documentation.
- Name behavior rather than a private mechanism, and distinguish local work from network, disk, blocking, caching, or destructive work.
- Prefer explicit result values and structured options over hidden output mutation and positional booleans.
- Use domain types or enums when primitives would permit invalid states or make a call ambiguous.
- Keep public visibility narrow and hide representation so implementations can change without forcing callers to change.
- Document preconditions, postconditions, side effects, ownership, errors, panics, and cancellation when they are not obvious.
- Make units, bounds, cardinality, ordering requirements, call sequencing, ownership, mutation, and side effects visible through types, names, signatures, result shapes, validation, or focused contract tests.
- Replace domain-specific magic literals with named constants, enums, or domain types when the name carries policy or prevents confusion. Do not mechanically name universally obvious mathematical constants or one-off local values.
- Keep naming and word order consistent with the surrounding ecosystem because consistency makes APIs predictable.
- Use a test or example call site as a design probe for awkward names and accidental implementation dependencies.
- The [Google C++ Style Guide](https://google.github.io/styleguide/cppguide) favors return values, clear parameter meaning, focused functions, and usage-oriented API documentation when a public contract requires it.
- Google's [Go naming decisions](https://google.github.io/styleguide/go/decisions.html) relate name length to scope and reject meaningless package names and ambiguous abbreviations.
- The [Rust API Guidelines](https://rust-lang.github.io/api-guidelines/) treat naming, predictability, documentation, type safety, and future-proofing as interoperability concerns.
