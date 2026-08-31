# Immutability and value semantics

- Prefer immutable state because it reduces aliasing, synchronization, and test setup.
- A final reference prevents reassignment but does not make the referenced object immutable.
- Make immutable classes final, initialize all state in the constructor, and provide no mutators.
- Copy mutable inputs at ownership boundaries and return snapshots or immutable views.
- Use List.copyOf, Set.copyOf, or Map.copyOf when a detached unmodifiable snapshot is the contract.
- Use Collections.unmodifiableX only when a live read-only view is intentionally exposed.
- An unmodifiable collection is not immutable when its elements can still change.
- Do not expose mutable arrays, collections, buffers, or collaborators through public accessors.
- Keep mutable implementation state behind methods that enforce the class invariant.
- Do not use mutable static fields for shared configuration or request state.
- Define equals and hashCode from stable value identity, and never mutate a key while it is in a hash-based collection.
- Document whether returned collections are ordered, nullable, modifiable, or snapshots.
