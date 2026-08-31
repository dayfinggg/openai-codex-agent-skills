# Immutability, records, and collections

- Prefer immutable state for values, configuration, messages, and data crossing concurrency or ownership boundaries.
- Use `readonly` fields and `get` or `init` accessors unless mutation is part of the invariant.
- Use a record when the type primarily stores data and equal values should compare equal.
- Choose `record class` for reference semantics or inheritance and `record struct` only for small, self-contained value semantics.
- Do not mistake a record for deep immutability; arrays and mutable child objects can still be shared and changed.
- Use classes for identity-based entities whose equality and lifecycle are reference-oriented.
- Prefer generic collections for type safety; use concurrent collections for concurrent mutation and immutable collections when snapshots or thread-safe immutability matter.
- Copy mutable inputs when retaining them would let callers change an invariant after validation.
- Return a read-only or immutable representation when callers must not mutate owned state.
- Avoid mutable structs; make value types small, self-contained, and safe to copy.
