# Idiomatic Kotlin for Backend Work

This reference favors explicit contracts, local invariants, readable control flow, and predictable lifecycles.
Use the repository's build, API, and deployment constraints as part of the design.
Keep framework, transport, persistence, and serialization details at boundaries when the domain does not need them.
Prefer the smallest abstraction that makes a responsibility clear and testable.

## Rule precedence

When guidance conflicts, apply the following order.

1. Compiler errors, language semantics, runtime safety, and public compatibility come first.
2. Repository instructions, build files, CI checks, `.editorconfig`, and configured analyzers define the project contract.
3. Kotlin's official coding conventions and API guidance define the default style.
4. Maintainer guidance and team idioms refine the default when the project has no stronger rule.
5. Personal preference comes last.

Do not silence a project check merely to match a generic style guide.
Document a necessary suppression at the narrowest scope and explain the invariant that justifies it.

## Backend defaults

Use `val` by default and make mutation local, deliberate, and owned by one component.
Expose `List`, `Set`, and `Map` when callers only need to read; expose `Mutable*` only when mutation is part of the contract.
Remember that `val` prevents reassignment of a reference, but a referenced mutable object can still change.
Use constructor parameters to make required dependencies and invariants visible at the call site.
Keep domain functions deterministic where possible, and isolate I/O, clocks, randomness, and framework callbacks behind small interfaces.
Use named types for important identifiers, units, and states rather than passing interchangeable primitive values.
On the JVM, `@JvmInline value class` is a concise option for type-safe wrappers around simple values.
Prefer meaningful named data classes over `Pair` or `Triple` when a value crosses a boundary or has domain meaning.
Use the standard library's collection operations for simple transformations, but choose a loop when a chain hides control flow or costs matter.
Use `require` for invalid arguments and `check` for invalid object state at the point where the invariant is known.

## Null safety

Use a non-null type unless absence is a real state that callers must handle.
Make nullable values enter at a boundary, then validate or map them into a non-null domain type.
Prefer an explicit `if` when the null branch contains meaningful work or logging.
Use `?.` for a short optional chain and `?:` when a clear fallback or early return exists.
Let smart casts narrow a stable value after an explicit null check.
Treat `!!` as an assertion of a locally proven invariant, not as routine null handling.
If `!!` is unavoidable at an adapter boundary, keep it close to the check and make the failure message or test explain the invariant.
Do not use nullable booleans for three states unless all three states are intentional and documented.
Prefer `value == true` or `value == false` when a nullable boolean is unavoidable in a condition.
Use `filterNotNull`, `mapNotNull`, or a domain parser when a collection contains optional input.
Do not confuse a read-only collection type with deep immutability.
Convert Java platform types immediately at the boundary when their nullability is not trusted.
Annotate Java APIs with supported nullability annotations so Kotlin sees actual nullable or non-nullable types.

## Data classes and sealed types

Use a data class for a value whose identity is its declared data, such as a request, response, command, or immutable domain snapshot.
Only primary-constructor properties participate in generated `equals`, `hashCode`, `toString`, `componentN`, and `copy` methods.
Keep equality-defining properties in the primary constructor and place derived or lifecycle state in the body only intentionally.
Remember that `copy()` is shallow, so mutable members remain shared between the original and the copy.
Prefer `val` properties and read-only collection views in data classes that cross threads or module boundaries.
Do not expose a data class as a long-lived public library contract when generated members would freeze implementation details.
Use an interface with explicit properties when clients need a stable API that can evolve independently of storage.

Use a sealed class or interface when the set of direct alternatives is deliberately closed.
Pair sealed types with an exhaustive `when` so adding an alternative produces a compiler-visible review point.
Use nested implementations for small hierarchies that should be discoverable beside the sealed type.
Use top-level implementations when the hierarchy has several levels or the types need independent names.
Treat sealed alternatives in public APIs as compatibility commitments because exhaustive client `when` expressions can break when cases change.
Choose an open interface, enum-like object, or explicit unknown case when future extension is expected.
Use sealed result or error types when the caller must handle a finite set of expected outcomes.
Use exceptions for exceptional failures that should propagate through the call stack, not as an untyped substitute for every domain outcome.

## Extension functions

Use an extension when behavior naturally belongs to a receiver but the receiver's source cannot or should not be changed.
An extension does not add a member, state, or override point to the receiver type.
Remember that extension dispatch is static and uses the receiver's declared type; a real member takes precedence over an extension with the same signature.
Do not use an extension to imply dynamic polymorphism or access private receiver state.
Use an extension for a pure conversion, query, adapter, or small domain operation with an obvious receiver.
Keep side effects visible in the name and call site instead of hiding I/O in a generic extension.
Define a nullable-receiver extension only when its null behavior is useful and unsurprising.
Place broadly useful extensions with the type they serve, and client-specific extensions next to that client.
Avoid a catch-all `Utils.kt` file and avoid making dozens of unrelated types appear to share one API.
Use a member or a dedicated service when the operation needs injected dependencies, mutable state, or a lifecycle.

## Coroutines

Mark a function `suspend` when it may suspend before returning; do not treat `suspend` as a synonym for “runs in parallel.”
Call suspending functions from another suspending function or an intentional bridge such as `runBlocking`.
Use `coroutineScope` for concurrent child work that must complete with the operation and fail it as a unit.
Use `launch` when a `Job` represents completion or cancellation and no value is returned.
Use `async` when a value is needed, and await the `Deferred` in the same structured scope.
Use `runBlocking` at a blocking entry point, adapter, or test, not inside a request path that is already coroutine-aware.
Keep every long-lived scope tied to an application, component, or request lifecycle that can cancel it.
Avoid `GlobalScope`; it has no `Job`, cannot be collectively cancelled, and loses structured-concurrency guarantees.
Do not replace `GlobalScope` with an unowned `CoroutineScope()`; give an owned scope a clear lifetime and cancellation path.
Let child coroutines inherit the caller's context unless the operation has a documented dispatcher requirement.
Use `Dispatchers.Default` for CPU-bound work and a bounded or injected I/O dispatcher for blocking calls.
Keep blocking Java or database calls off an event-loop thread by moving them at the adapter boundary with `withContext`.
Inject dispatchers or a coroutine context when code needs deterministic tests or a non-default execution policy.
Do not put a new unrelated `Job` into a child builder's context because it breaks parent-child cancellation.
Use `SupervisorJob` or `supervisorScope` only when sibling failures are intentionally independent and each failure is observed.
Remember that cancellation is cooperative; suspending calls normally check it, while tight non-suspending loops may need `ensureActive`.
Release resources in `finally` or `use`, and make cleanup cancellation-safe without hiding cancellation from callers.
Use `CoroutineExceptionHandler` for failures with no normal propagation path, not as a replacement for local recovery logic.

## Errors and outcomes

Kotlin exceptions are unchecked, so function names, KDoc, and result types must communicate meaningful failure behavior.
Catch the narrowest exception that you can recover from and preserve the original cause when translating it.
Do not catch an exception only to log and rethrow without adding context or changing ownership.
Use `require` for caller input, `check` for an object's current state, and a domain exception for a meaningful exceptional boundary.
Use `Result<T>` when success or failure is a value that the immediate caller must compose or inspect.
Remember that `Result` stores an arbitrary `Throwable`; it does not replace a domain-specific error model when error categories matter.
Use `runCatching` only around the operation whose failures belong in the returned `Result`.
In coroutine code, do not swallow `CancellationException` inside broad catches or `runCatching`; rethrow it or call `ensureActive` before handling other failures.
Map infrastructure exceptions to stable application errors at a boundary, and avoid exposing vendor exception classes from domain APIs.
Include useful, non-sensitive context in error messages and never log credentials, tokens, or personal data.
Use sealed errors for expected finite alternatives such as validation, authorization, or known business conflicts.
Use exceptions for unexpected infrastructure failures, broken invariants, and failures that should abort the current operation.
Test both the error category and the externally visible behavior, not only the exception message.

## Packages, modules, and Gradle

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

## Java interop

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

## Detekt, ktlint, and project policy

Use ktlint for the project's Kotlin formatting and style rules, and use detekt for configured inspections, smells, and complexity checks.
Treat `.editorconfig`, detekt YAML, Gradle task wiring, and CI as executable project policy rather than optional advice.
Ktlint reads `.editorconfig` files along the path, with a project-root file normally providing shared defaults and nested files narrowing scope.
Run the repository's pinned formatter command instead of inventing a local ktlint version or rule set.
Review formatter diffs and avoid formatting unrelated files in a feature change.
Use a ktlint baseline only as a migration record; new violations should not be added silently.
Detekt custom configuration can replace default values unless `buildUponDefaultConfig` is enabled, so inspect the actual project configuration before interpreting a finding.
Enable detekt configuration validation when practical so misspelled or deprecated first-party rules fail early.
If the detekt plugin is wired conventionally, its analysis task participates in `gradle check`; verify the repository task graph before assuming this.
Treat a baseline as known debt that needs ownership, not as permission to ignore new findings.
Prefer a narrow suppression with a reason over a global rule disable, and revisit suppressions when the surrounding design changes.

## Testing

Test pure domain code with fast unit tests that assert invariants, outcomes, and boundary cases.
Use `kotlin.test` when framework-independent assertions or multiplatform sharing matter, and use the project's configured JUnit or TestNG adapter.
Use descriptive test names, including backticks where the repository permits them, and keep one behavioral reason per test.
Test nullable input, malformed transport data, empty collections, duplicate values, and invalid state explicitly.
Test every sealed branch and verify that mapping code preserves the intended domain meaning.
Use fakes for stable ports and integration tests for real serialization, HTTP, database, messaging, and transaction behavior.
Use `runTest` and `TestScope` for coroutine tests so delays and child jobs are controlled by a test scheduler.
Inject dispatchers or scopes into code under test rather than hard-coding global dispatchers.
Exercise cancellation, timeout, sibling failure, and cleanup paths because happy-path coroutine tests miss lifecycle bugs.
Avoid real sleeps and global scopes in tests; they make ordering, leaks, and failures nondeterministic.
Run the same Gradle test task that CI runs, including static analysis when the build makes it part of verification.

## Size and cohesion heuristics

There is no universal line-count limit for a Kotlin class or file.
Kotlin's conventions encourage colocating declarations that are semantically close while keeping a file to a reasonable size, described as no more than a few hundred lines.
Split a file when readers need separate mental models, when declarations change for different reasons, or when unrelated imports dominate.
Keep a sealed hierarchy and its small data alternatives together when that makes all cases visible at a glance.
Keep an extension with its receiver when the extension is part of that receiver's normal vocabulary; keep client-only adapters with the client.
Split a class when it owns multiple lifecycles, requires many unrelated dependencies, or needs unrelated fixtures to test its methods.
Keep a function to one coherent operation and introduce named helpers when nesting or branching hides the operation's contract.
Use expression bodies for genuinely single-expression functions, not to compress multi-step logic into a hard-to-read line.
Organize class members by reading flow and related behavior rather than alphabetically.
Let cohesion, dependency direction, testability, and change isolation decide when to split or combine code.

## Sources

### Official Kotlin and JetBrains documentation

- [Kotlin coding conventions](https://kotlinlang.org/docs/coding-conventions.html)
- [Kotlin idioms](https://kotlinlang.org/docs/idioms.html)
- [Kotlin null safety](https://kotlinlang.org/docs/null-safety.html)
- [Kotlin collections overview](https://kotlinlang.org/docs/collections-overview.html)
- [Kotlin collection operations](https://kotlinlang.org/docs/collection-operations.html)
- [Kotlin API guidelines: predictability](https://kotlinlang.org/docs/api-guidelines-predictability.html)
- [Kotlin data classes](https://kotlinlang.org/docs/data-classes.html)
- [Kotlin sealed classes and interfaces](https://kotlinlang.org/docs/sealed-classes.html)
- [Kotlin extensions](https://kotlinlang.org/docs/extensions.html)
- [Kotlin coroutines basics](https://kotlinlang.org/docs/coroutines-basics.html)
- [Kotlin coroutine context and dispatchers](https://kotlinlang.org/docs/coroutine-context-and-dispatchers.html)
- [Kotlin coroutine exception handling](https://kotlinlang.org/docs/exception-handling.html)
- [Kotlin `kotlinx.coroutines` API](https://kotlinlang.org/api/kotlinx.coroutines/kotlinx-coroutines-core/kotlinx.coroutines/)
- [Kotlin `GlobalScope` API](https://kotlinlang.org/api/kotlinx.coroutines/kotlinx-coroutines-core/kotlinx.coroutines/-global-scope/)
- [Kotlin `Result` API](https://kotlinlang.org/api/core/kotlin-stdlib/kotlin/-result/)
- [Kotlin `runCatching` API](https://kotlinlang.org/api/core/kotlin-stdlib/kotlin/run-catching.html)
- [Kotlin Java interop](https://kotlinlang.org/docs/java-interop.html)
- [Kotlin to Java interop](https://kotlinlang.org/docs/java-to-kotlin-interop.html)
- [Kotlin visibility modifiers](https://kotlinlang.org/docs/visibility-modifiers.html)
- [Kotlin packages and imports](https://kotlinlang.org/docs/packages.html)
- [Kotlin Gradle project configuration](https://kotlinlang.org/docs/gradle-configure-project.html)
- [Gradle multi-project builds](https://docs.gradle.org/current/userguide/multi_project_builds.html)
- [Kotlin `kotlin.test` API](https://kotlinlang.org/api/core/kotlin-test/)
- [Kotlin JUnit testing tutorial](https://kotlinlang.org/docs/jvm-test-using-junit.html)
- [kotlinx.coroutines test README](https://github.com/Kotlin/kotlinx.coroutines/blob/master/kotlinx-coroutines-test/README.md)
- [Detekt configuration](https://detekt.dev/docs/introduction/configurations/)
- [Detekt Gradle plugin](https://detekt.dev/docs/gettingstarted/gradle/)
- [Ktlint CLI and `.editorconfig` documentation](https://github.com/ktlint/ktlint/blob/master/documentation/release-latest/docs/install/cli.md)
- [JetBrains Kotlin API development guidance](https://github.com/JetBrains/kotlin/blob/master/analysis/docs/contribution-guide/api-development.md)

### Maintainer examples

- [Kotlin maintained examples](https://github.com/Kotlin/kotlin-examples)
- [Ktor maintained samples](https://github.com/ktorio/ktor-samples/tree/main/jwt-auth-tests)

### Practitioner talks and articles

- [Roman Elizarov, Structured concurrency](https://elizarov.medium.com/structured-concurrency-722d765aa952)
- [Roman Elizarov, KotlinConf 2017 coroutine talk](https://devconf.net/talk/kotlinconf-2017-introduction-to-coroutines-by-roman-elizarov)
