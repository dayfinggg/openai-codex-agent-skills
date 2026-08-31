# Idiomatic Kotlin for Backend Work

This reference favors explicit contracts, local invariants, readable control flow, and predictable lifecycles.
Use the repository's build, API, and deployment constraints as part of the design.
Keep framework, transport, persistence, and serialization details at boundaries when the domain does not need them.
Prefer the smallest abstraction that makes a responsibility clear and testable.

## Reference map

- [Rule precedence](rule-precedence.md)
- [Backend defaults](backend-defaults.md)
- [Null safety](null-safety.md)
- [Data classes and sealed types](data-classes-and-sealed-types.md)
- [Extension functions](extension-functions.md)
- [Coroutines](coroutines.md)
- [Errors and outcomes](errors-and-outcomes.md)
- [Packages, modules, and Gradle](packages-modules-and-gradle.md)
- [Java interop](java-interop.md)
- [Detekt, ktlint, and project policy](detekt-ktlint-and-project-policy.md)
- [Testing](testing.md)
- [Size and cohesion heuristics](size-and-cohesion-heuristics.md)
- [Sources](sources.md)
