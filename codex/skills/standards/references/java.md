# Modern Java Code Quality Standard

This reference defines a practical baseline for modern Java code.
It favors correctness, explicit contracts, readable design, and easy maintenance.
Apply the repository's own build and compatibility policy before adopting newer syntax.
Treat every rule below as a default that can be changed when a documented constraint requires it.

## Scope and authority

- The Java release declared by the project is the language and API baseline.
- The repository build, CI checks, formatter, and local style guide outrank this reference.
- Resolve remaining choices in this order: language and API contracts, repository policy, this reference, then personal preference.
- Record deliberate exceptions beside the code or in the issue that owns the constraint.
- Use permanent language features by default and treat preview features as explicit project decisions.
- Keep source files in UTF-8 with an explicit package declaration.
- Use one top-level class, interface, enum, or record per file.
- Mark every legal override with @Override.
- Do not use finalizers.
- Enable compiler warnings and static analysis, but make a check an error only when it is actionable.
- Prefer standard-library types and behavior that the target Java release documents.

## Package and class design

- A package should group a coherent domain or feature, not act as a general-purpose dumping ground.
- Package boundaries should express dependency direction and hide implementation details.
- Use lowercase package names without underscores.
- Use globally unique package names for distributed libraries.
- Keep classes package-private or private unless another package needs the type.
- Treat every public type and member as a compatibility commitment.
- In a modular project, export only packages that form the supported module API.
- Use package-info.java for package documentation and package-level annotations.
- Avoid the unnamed package outside small, temporary programs.
- Prefer classes with one clear responsibility and one coherent invariant.
- Keep data, the operations that preserve its invariant, and their validation together.
- Prefer composition and delegation over inheritance used only for code reuse.
- Expose an interface when callers need a capability or substitution boundary.
- Inherit only when the subtype relationship, behavioral contract, and extension points are stable.
- Make a class final by default unless an explicit extension contract requires otherwise.
- Use protected members sparingly because they enlarge the extension surface.
- Keep constructors small, validate inputs, and do not publish this before construction finishes.
- Use private final fields for dependencies and state unless controlled mutation is required.
- Keep member order logical, and keep overloads and constructors contiguous.
- Use names that state domain meaning, units, and side effects rather than implementation details.
- Add Javadoc for visible API types, members, record components, nullability, side effects, and thread-safety guarantees.

## Immutability and value semantics

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

## Records and sealed types

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

## Exceptions and resources

- Define failure behavior in the method contract, including recoverability and relevant context.
- Use a checked exception for a recoverable condition that callers must explicitly handle and that belongs in the API contract.
- Use an unchecked exception for violated preconditions, invalid state, or programmer errors.
- Create domain-specific exception types when callers need to distinguish recovery paths.
- Throw the most specific meaningful exception and include safe, actionable context.
- Preserve the original cause when translating or adding context.
- Catch only when the code can recover, translate at a boundary, clean up, or add required context.
- Catch narrow exception types; do not use a blanket catch for convenience.
- Do not catch Throwable or Error except at a deliberate process boundary that rethrows or terminates safely.
- Do not ignore a caught exception; document the rare intentional no-op.
- Log an exception once at the boundary that can act on it, rather than logging and rethrowing at every layer.
- Do not use exceptions, null, or magic sentinel values for ordinary branching.
- Use try-with-resources for every AutoCloseable resource.
- Preserve suppressed exceptions when resource cleanup fails.
- Propagate InterruptedException or restore the interrupt status after catching it.
- Keep secrets, tokens, and personal data out of exception messages and logs.

## Concurrency

- Document whether each public type is immutable, thread-safe, confined, or externally synchronized.
- Prefer immutable data, thread confinement, and message passing over shared mutable state.
- Use java.util.concurrent executors, synchronizers, atomics, and concurrent collections instead of ad hoc protocols.
- Own every ExecutorService and close or shut it down on the lifecycle that created it.
- Bound queues, permits, connection pools, and retries according to the capacity of downstream systems.
- Use an atomic variable for one independent state transition and a lock or actor for a multi-field invariant.
- Treat volatile as a visibility and ordering tool, not as atomicity for compound operations.
- Synchronize on a private, stable lock rather than this or an object owned by another component.
- Do not hold locks while doing I/O, waiting indefinitely, or invoking unknown callbacks.
- Define cancellation, timeout, interruption, and failure propagation for every asynchronous operation.
- Make publication safe before another thread can observe an object.
- Test race-sensitive behavior with coordination primitives and bounded timeouts, not arbitrary sleeps.
- Use virtual threads for high-throughput tasks that spend most of their time waiting on I/O.
- Virtual threads provide scale, not faster CPU execution, and are not a replacement for CPU scheduling.
- Create a new virtual thread per task rather than pooling virtual threads.
- Bound scarce external resources even when the number of virtual threads is large.
- Use thread-local state sparingly because one JVM can host millions of virtual threads.

## Streams

- Use streams for clear transformations, filtering, and reductions over data.
- Use a loop when control flow, checked exceptions, mutation, or early exits would be clearer.
- A stream pipeline is lazy, consumable once, and separate from the source collection.
- Keep stream behavior non-interfering and stateless.
- Do not modify a non-concurrent source while its stream pipeline runs.
- Avoid side effects in map, filter, peek, and other behavioral parameters.
- Prefer collect or reduce over mutating an external accumulator from forEach.
- Use one terminal operation and do not retain a stream for later traversal.
- Treat encounter order as a contract; choose ordered or unordered processing deliberately.
- Keep streams sequential by default.
- Use parallel streams only after measuring a meaningful workload with associative, stateless operations.
- Verify that parallel reduction, ordering, allocation, and merge costs improve the real workload.
- Close streams backed by files, sockets, or other resources with try-with-resources.
- Choose a mutable or unmodifiable collector according to the API contract.
- Use primitive streams for measured numeric hot paths where boxing is material.

## Null handling

- Choose one project-wide nullness policy and state it at public boundaries.
- Use a consistent nullness system such as JSpecify when the toolchain supports it.
- Mark new packages or classes as null-marked and annotate genuine nullable values explicitly.
- Adopt nullness annotations incrementally from low-dependency code toward its callers.
- Reject invalid non-null inputs at the boundary with Objects.requireNonNull and a useful parameter name.
- Never return null from a method whose contract promises an Optional.
- Use Optional primarily as a return type when absence is a meaningful result.
- Do not use Optional fields or parameters unless the surrounding API convention explicitly requires them.
- Distinguish absent, empty, unknown, and invalid values instead of collapsing them into null.
- Prefer empty collections when empty has the same meaning as no result.
- Annotate or adapt external APIs whose nullness contract is not visible to the checker.
- Keep null checks close to the boundary so the rest of the code can rely on a stable invariant.

## Testing

- Test observable behavior and contracts rather than private implementation structure.
- Keep each test focused on one behavior with clear arrange, act, and assert phases.
- Cover normal inputs, boundaries, invalid inputs, state transitions, and documented failure modes.
- Assert exception type and cause when they are part of the contract.
- Use parameterized tests for a behavior matrix instead of duplicated test methods.
- Keep unit tests isolated, deterministic, and fast.
- Use fakes, fixed clocks, controlled executors, and local resources instead of sleeps and network calls.
- Use integration or contract tests for persistence, serialization, network, and framework boundaries.
- Exercise cancellation, interruption, cleanup, and concurrency limits where those behaviors matter.
- Use bounded waits and latches for concurrent tests, and report timeout context on failure.
- Reset global state and avoid test-order or wall-clock dependencies.
- Name a test class after its subject and end the name with Test.
- Run tests through the project build as well as an IDE.
- Use mutation, property-based, or fuzz testing when parsing, security, or combinatorial input risk justifies it.

## Build and formatter precedence

- Inspect the project build files, wrapper, toolchain declaration, CI workflow, and formatter configuration before editing code.
- Use the repository's Maven or Gradle wrapper when one exists.
- For Maven, run the project-selected verification phase, commonly mvn verify.
- For Gradle, run the project-selected lifecycle, commonly check for verification and build for assembly plus verification.
- Attach custom test, lint, and formatter checks to the build lifecycle so CI runs them.
- Precedence is repository formatter and CI, project style guide, this reference, IDE settings, then personal preference.
- Pin formatter and analysis versions, and run them with a JDK that can parse the project's source level.
- Choose one formatter for Java source and do not mix competing formatters in the same module.
- Run format checks in CI and format only files intentionally changed by the task.
- Treat compiler warnings, tests, static analysis, packaging, and documentation checks as merge gates when the project does.
- Keep wrapper versions and toolchains reproducible, and document any local-only command.
- Add a narrow suppression only with a reason, owner, and removal condition.

## Size and cohesion heuristics

- Java has no universal method or class size limit, so use size as a review trigger rather than an automatic failure.
- Use repository-measured thresholds only when they correlate with review or maintenance problems. Do not invent numeric limits for a project that has none.
- Review constructors with more than five collaborators, deep branching, or many mode flags.
- Extract code when the reader must inspect implementation details to discover its intent.
- Name an extracted unit after the behavior it represents, not after a vague utility role.
- A cohesive class keeps related state and the operations that preserve that state together.
- Divergent reasons to change, unrelated fields, long parameter lists, and repeated condition families signal weak cohesion.
- Split along a stable domain or ownership boundary, not merely to hit a line count.
- Do not create pass-through wrappers that add indirection without a contract or cohesive responsibility.
- Allow a longer cohesive algorithm when splitting would obscure control flow, and protect it with focused tests.
- Remove dead code and duplication before using extraction to reduce size.
- During review ask whether the type has one clear reason to change and whether its tests can isolate that responsibility.

## Sources

### Official language and API references
- [Java Language Specification 26: Packages and Modules](https://docs.oracle.com/javase/specs/jls/se26/html/jls-7.html), [Classes and Records](https://docs.oracle.com/javase/specs/jls/se26/html/jls-8.html), and [Exceptions](https://docs.oracle.com/javase/specs/jls/se26/html/jls-11.html)
- [Java SE 26 API Specification](https://docs.oracle.com/en/java/javase/26/docs/api/)
- [Record API, Java SE 26](https://docs.oracle.com/en/java/javase/26/docs/api/java.base/java/lang/Record.html) and [Oracle language changes for JEP 395 and JEP 409](https://docs.oracle.com/en/java/javase/21/language/java-language-changes-release.html)
- [JEP 395: Records](https://openjdk.org/jeps/395), [JEP 409: Sealed Classes](https://openjdk.org/jeps/409), and [JEP 444: Virtual Threads](https://openjdk.org/jeps/444)
- [Java 26 virtual threads guide](https://docs.oracle.com/en/java/javase/26/core/virtual-threads.html)
- [Thread API, Java SE 26](https://docs.oracle.com/en/java/javase/26/docs/api/java.base/java/lang/Thread.html) and [java.util.concurrent package, Java SE 26](https://docs.oracle.com/en/java/javase/26/docs/api/java.base/java/util/concurrent/package-summary.html)
- [Stream package, Java SE 26](https://docs.oracle.com/en/java/javase/26/docs/api/java.base/java/util/stream/package-summary.html)
- [Collection API, Java SE 26](https://docs.oracle.com/en/java/javase/26/docs/api/java.base/java/util/Collection.html) and [List API, Java SE 26](https://docs.oracle.com/en/java/javase/26/docs/api/java.base/java/util/List.html)
- [Objects API, Java SE 26](https://docs.oracle.com/en/java/javase/26/docs/api/java.base/java/util/Objects.html) and [Optional API, Java SE 26](https://docs.oracle.com/en/java/javase/26/docs/api/java.base/java/util/Optional.html)
- [Throwable API, Java SE 26](https://docs.oracle.com/en/java/javase/26/docs/api/java.base/java/lang/Throwable.html)
- [Try-with-resources tutorial](https://docs.oracle.com/javase/tutorial/essential/exceptions/tryResourceClose.html)

### Style, tooling, and maintainer material
- [Google Java Style Guide](https://google.github.io/styleguide/javaguide.html)
- [google-java-format README](https://github.com/google/google-java-format/blob/master/README.md)
- [JSpecify nullness specification](https://jspecify.dev/docs/spec/), [Applying JSpecify annotations](https://jspecify.dev/docs/applying/), and [JSpecify GitHub repository](https://github.com/jspecify/jspecify)
- [OpenJDK Amber records and sealed types design note](https://github.com/openjdk/amber-docs/blob/master/site/design-notes/records-and-sealed-classes.md)
- [Error Prone GitHub repository](https://github.com/google/error-prone) and [criteria for new checks](https://github.com/google/error-prone/wiki/Criteria-for-new-checks)
- [JUnit current user guide](https://docs.junit.org/current/user-guide/), [writing tests](https://docs.junit.org/6.1.3/writing-tests/intro.html), and [examples GitHub repository](https://github.com/junit-team/junit-examples)
- [Maven build lifecycle](https://maven.apache.org/guides/introduction/introduction-to-the-lifecycle) and [Gradle Java plugin](https://docs.gradle.org/current/userguide/java_plugin.html)
- [Brian Goetz: Postcards from the Peak of Complexity](https://inside.java/2024/11/03/devoxxbelgium-complexity-peak/)

### Practitioner material

- [Martin Fowler: Function Length](https://martinfowler.com/bliki/FunctionLength.html)
