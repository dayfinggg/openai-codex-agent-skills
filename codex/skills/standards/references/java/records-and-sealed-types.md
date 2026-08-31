# Records and sealed types

- Use a record when the type is primarily a transparent carrier of a fixed set of values.
- Do not use a record when identity, lifecycle mutation, subclassing, or representation hiding is central.
- Records are shallowly immutable, so mutable component references still require defensive copies.
- Validate, normalize, and copy mutable components in the canonical constructor.
- Remember that generated equality and hashing use all record components.
- Keep record components small, semantically named, and suitable for the public API.
- Use a sealed class or interface when the permitted alternatives are a deliberate closed domain.
- Do not seal a type when downstream users must add implementations.
- Make every direct subtype final, sealed, or non-sealed as its extension policy requires.
- Keep permitted subtypes in the package or module required by the language rules.
- Use exhaustive pattern matching or switch logic to make closed-domain changes compiler-visible.
- Review a sealed hierarchy as one API because adding a permitted subtype can affect clients.
- Records became permanent in Java 16 through JEP 395, and sealed types became permanent in Java 17 through JEP 409.
