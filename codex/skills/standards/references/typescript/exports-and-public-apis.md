# Exports and public APIs

- Prefer named exports when no repository convention says otherwise because names remain canonical at import sites. [S23]
- Export only symbols needed by another module or by the supported package API.
- Keep the public surface small so consumers depend on stable concepts rather than implementation details. [S23]
- Avoid mutable exported bindings; expose commands or getter functions when external mutation is truly required. [S23]
- Use `import type` and `export type` where the dependency is type-only when the project enables or prefers that distinction. [S19]
- Avoid broad `export *` chains when they create name collisions, cycles, or accidental API expansion.
- Export every named type that appears in a published function, class, or value signature.
- Keep package `exports`, runtime files, and declaration files aligned for every supported subpath. [S11]
- Make exported behavior, invariants, thrown errors, cancellation, and version-sensitive constraints visible through the signature, types, tests, or public API documentation when callers need details that code cannot express.
- Treat an export change as an API change and update consumers, tests, and release notes as required.
