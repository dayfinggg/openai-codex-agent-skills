# Packages, modules, and Gradle

Match package names to the source directory and keep package names lowercase without underscores.
Name a file after its single main type or after the cohesive set of top-level declarations it contains.
Do not create meaningless names such as `Util.kt`; name files after their responsibility.
Use `internal` to keep implementation details visible within one compiled module while exposing a narrow public surface.
Remember that a Gradle source set is a Kotlin module for `internal` visibility, and its test source set can access `main` internals.
Start with one Gradle project when the code is small, then split into focused subprojects when independent ownership, dependencies, testing, or release boundaries justify it.
Define subprojects in `settings.gradle(.kts)` and keep each subproject's build logic and dependencies local to that subproject.
Prefer dependency direction from adapters and entry points toward stable domain contracts, and prevent cycles with module boundaries.
Use `implementation` for dependencies needed internally and `api` only when a dependency's types are part of the module's public API.
Keep transport DTOs, persistence records, and domain values distinct when their change rates or invariants differ.
