# Java interop

Kotlin can call ordinary Java APIs directly, and Java bean getters and setters appear as Kotlin properties.
Treat unannotated Java types as platform types and validate or wrap them before they enter core code.
Prefer `@Nullable`, `@NotNull`, JSpecify, or the annotation family already used by the Java project.
Remember that Kotlin `internal` becomes public bytecode with mangled names, so it is not a security boundary for Java callers.
Use `@Throws` when Java callers must see a checked exception in the generated signature.
Use `@JvmName` to give file-level functions a stable Java facade name when the default `FileNameKt` name is unsuitable.
Use `@JvmStatic` only when Java callers genuinely need a static member instead of a companion-object call.
Use `@JvmOverloads` sparingly because generated overloads enlarge the Java API and can create ambiguous evolution paths.
Keep Java-facing APIs explicit about nullability, overloads, default methods, collection mutability, and binary compatibility.
Add Java-side compilation or integration tests when Kotlin code is a public library or is called by existing Java modules.
