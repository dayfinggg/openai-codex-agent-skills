# C# and .NET code standards

Use this guide as a practical default for production C# code.
Treat a repository's existing conventions as the local authority when they are deliberate and documented.
Treat the Framework Design Guidelines as trade-offs, not laws; Microsoft notes that some of those pages are old.
Prefer correctness, clear contracts, diagnosability, and maintainability before micro-optimizations.

## Quality baseline

- Target a supported .NET framework and language version chosen by the product's support policy.
- Keep builds reproducible; check in `global.json` when a repository must use a known SDK.
- Keep compiler, nullable, analyzer, and test output clean in CI.
- Use modern language features when they make intent clearer, not merely because they are new.
- Make every public behavior explicit in types, names, validation, documentation, or tests.
- Avoid cleverness, hidden global state, and abstractions that do not serve a real caller.

## Style and naming

- Follow the project's `.editorconfig`; use four spaces and one consistent brace style.
- Prefer Allman braces, explicit visibility, and imports at the top of the file unless local style says otherwise.
- Name types and public members with PascalCase and parameters and locals with camelCase.
- Prefix private or internal instance fields with `_`; use `s_` for static fields when that is the repository convention.
- Use `I` for interfaces, `Async` for methods returning awaitable types, and `Exception` for exception types.
- Use singular names for ordinary enums and plural names for flags enums.
- Choose descriptive names and prefer clarity over abbreviations or unnecessary brevity.
- Use `var` only when the type is obvious from the right-hand side and the declaration remains easy to scan.
- Prefer `nameof` to duplicated parameter or member-name strings.
- Keep methods and types easy to scan; avoid deeply nested conditionals and long argument lists.
- Do not reformat an unrelated file; match the file's established style before applying a general rule.

## Nullable reference types

- Enable nullable analysis with `<Nullable>enable</Nullable>` at the project or repository level.
- Treat `string` as a non-null contract and `string?` as an intentional maybe-null contract.
- Initialize every non-nullable field and property on every valid construction path.
- Check nullable values at the boundary where absence is handled, then keep the core non-nullable.
- Use nullable analysis attributes when a method's result depends on an argument or a boolean test.
- Use the null-forgiving operator `!` sparingly; it disables a compiler safeguard at that expression.
- Remember that nullable reference types are compile-time analysis; they do not change runtime types or runtime null behavior.
- Validate data from serialization, reflection, configuration, and other unannotated boundaries at runtime.
- Do not assume `default` structs or newly allocated reference arrays contain initialized non-nullable members.

## Asynchronous code

- Use the Task-based Asynchronous Pattern for new asynchronous APIs.
- Return `Task` or `Task<T>` by default; reserve `ValueTask` for measured allocation-sensitive paths with compatible consumers.
- Add `Async` to asynchronous operation names and never append it to a synchronous method.
- `async` enables `await`; it does not by itself move work to another thread.
- Await every task whose completion, exception, or cancellation matters.
- Do not use `.Result`, `.Wait()`, or other blocking waits to bridge asynchronous code without a documented boundary.
- Prefer async all the way through the call chain; keep synchronous wrappers rare and deliberate.
- Use `async void` only for event handlers or framework callbacks that require that signature.
- Keep an async event handler thin and delegate its logic to a testable `Task`-returning method.
- Start independent operations before awaiting them and compose them with `Task.WhenAll` when concurrency is safe.
- Pass a `CancellationToken` for operations that genuinely support cancellation, usually as `cancellationToken`.
- Treat cancellation as cooperative; pass the token down, observe it, clean up, and preserve cancellation semantics.
- Dispose every `CancellationTokenSource` that the code owns.
- Use `ConfigureAwait(false)` in context-free library code when the library does not need a captured context; preserve context where the application requires it.
- Do not drop a task for background work unless an owner tracks its lifetime, observes failures, and coordinates shutdown.
- Await a `ValueTask` once, or convert it once with `AsTask()`; do not cache or await the same `ValueTask` repeatedly.

## Resource ownership and disposal

- Dispose resources that the type owns; document ownership when a dependency is borrowed or transferred.
- Prefer `using` and `await using` scopes so cleanup runs when the body exits through success, return, or exception.
- Implement `IDisposable` only when the type owns disposable or unmanaged resources, or when a base-class contract requires it.
- For a non-sealed disposable base class, use a non-virtual public `Dispose()` and a protected virtual `Dispose(bool)` pattern.
- Make disposal idempotent and reject operations that cannot work after disposal with `ObjectDisposedException`.
- Prefer `SafeHandle` to hand-written finalizers for unmanaged handles.
- Treat finalizers as an advanced last resort; they delay cleanup and complicate object-state assumptions.
- Implement `IAsyncDisposable` when cleanup itself must await asynchronous work.
- A type with both synchronous and asynchronous resources will often need both `IDisposable` and `IAsyncDisposable` paths.
- For a non-sealed async-disposable base class, centralize overridable cleanup in `DisposeAsyncCore()`.
- Never make callers guess whether they must dispose an object; state lifetime rules in the API documentation and tests.

## Exceptions and failure contracts

- Throw the most specific predefined exception that describes a caller error or invalid object state.
- Use `ArgumentNullException.ThrowIfNull` and related guard helpers for public argument validation.
- Validate usage errors synchronously before entering the asynchronous part of a task-returning method.
- Catch an exception only when the code can recover, restore a known state, add useful context, or perform required cleanup.
- Catch specific exception types and order derived catches before base catches.
- Use `throw;` to rethrow without destroying the original stack; wrap with an inner exception when changing abstraction level.
- Avoid catching `Exception` as routine control flow and never silently swallow failures.
- Use a `Try...` or another explicit result contract for expected absence when the API semantics support it.
- Do not use exceptions for ordinary branching or validation that can be performed cheaply before the operation.
- Keep exception messages clear, actionable, and free of secrets; include relevant parameter or operation context.
- Do not throw from `finally`, `Dispose`, `Equals`, `GetHashCode`, or `ToString` except for unavoidable critical failures.
- Define a custom exception only when an existing type cannot express the contract; end its name with `Exception` and provide standard constructors.

## Immutability, records, and collections

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

## Public API design

- Design from the top caller scenarios; write the intended call-site before committing the public shape.
- Keep the public surface small, discoverable, and stable; every public member creates compatibility and documentation cost.
- Accept the least-derived input type that provides the needed operations and return a useful, appropriately specific type.
- Validate public and protected arguments, including enum values that may contain undefined underlying integers.
- Keep related overloads consistent in parameter order, names, cancellation behavior, and exception behavior.
- Prefer a single options object or cohesive record when many parameters travel together; avoid multiple Boolean switches.
- Use properties for cheap state without surprising side effects; use methods for work, conversion, expensive computation, or observable effects.
- Expose fields only for deliberate constants or immutable data; use properties to preserve implementation freedom.
- Make inheritance, virtual members, interfaces, and extension points intentional rather than accidental.
- Preserve an existing synchronous API when adding a separate asynchronous counterpart unless a breaking change is explicitly approved.
- Document ownership, threading, nullability, cancellation, disposal, ordering, and performance assumptions that callers must know.

## Project layout and build files

- A useful default layout is `src/` for production projects, `tests/` for test projects, and `docs/` or `eng/` for supporting material.
- Keep one clear responsibility per project; keep unit tests separate from integration or end-to-end tests.
- Put repository-wide `.editorconfig`, `Directory.Build.props`, and `Directory.Build.targets` at the intended common root.
- Remember that MSBuild applies the first applicable `Directory.Build.props` found while walking upward, so keep nested overrides explicit.
- Use SDK-style projects and rely on the SDK's default source globs unless a deliberate include or exclude is needed.
- Do not duplicate implicit `Compile`, resource, or content items; duplicate globs can fail the build.
- Keep project references directional: tests may reference production, while production should not reference tests.
- Pin or document the SDK and target frameworks, and update them deliberately with CI and dependency checks.

## Analyzers, formatters, and CI

- Enable the SDK's .NET analyzers and select an analysis level appropriate for the repository's migration stage.
- Configure style and severity in version-controlled `.editorconfig` or global analyzer configuration files.
- Escalate agreed correctness, reliability, security, and API-contract rules to build failures in CI.
- Do not blanket-suppress diagnostics; scope each suppression and explain why the rule does not apply.
- Run `dotnet format` locally and `dotnet format --verify-no-changes` in CI when formatting is a repository contract.
- Treat formatter output as mechanical; review analyzer fixes for changed behavior before committing them.
- Use the verified dotnet/runtime layout and `Directory.Build.props` as examples, not as a universal configuration to copy unchanged.
- A normal validation pass is `dotnet restore`, `dotnet build`, `dotnet test`, and formatter verification.

## Testing

- A good unit test is fast, isolated, repeatable, self-checking, and timely to write.
- Name tests by unit, scenario, and expected behavior; keep Arrange, Act, and Assert visually distinct.
- Keep unit tests independent of databases, networks, file systems, clocks, and process-global state; cover those through integration tests.
- Test public contracts, not private implementation details.
- Test nullability boundaries, argument validation, cancellation, disposal, exception translation, and concurrent behavior where applicable.
- Make asynchronous tests return `Task` and await the operation under test.
- Add a regression test that demonstrates a bug before or alongside its fix.
- Use coverage to find untested behavior; do not treat a percentage target as proof of quality.

## Size and cohesion heuristics

- Treat line count as a review signal, never as a correctness threshold.
- Split a method when it has multiple conceptual jobs, deep branching, repeated setup, or a name that needs “and”.
- Split a type when it has multiple reasons to change, unrelated dependencies, or state that different methods do not share.
- Keep one main abstraction per file when that improves navigation; group tightly related small declarations only when their relationship is obvious.
- Prefer cohesive modules whose fields, invariants, vocabulary, and tests point to one purpose.
- Extract code only when the extracted name improves the reader's model or isolates a meaningful boundary.
- Replace growing parameter lists with a cohesive options type, not with an anonymous bag of unrelated settings.
- Review large diffs and large classes for ownership, testability, and dependency direction before applying mechanical decomposition.

## Sources

### Official .NET and C# documentation

- [Common C# code conventions](https://learn.microsoft.com/en-us/dotnet/csharp/fundamentals/coding-style/coding-conventions)
- [C# identifier naming rules and conventions](https://learn.microsoft.com/en-us/dotnet/csharp/fundamentals/coding-style/identifier-names)
- [Framework design guidelines](https://learn.microsoft.com/en-us/dotnet/standard/design-guidelines/)
- [Framework parameter design](https://learn.microsoft.com/en-us/dotnet/standard/design-guidelines/parameter-design)
- [Framework member design](https://learn.microsoft.com/en-us/dotnet/standard/design-guidelines/member)
- [Framework dispose pattern](https://learn.microsoft.com/en-us/dotnet/standard/design-guidelines/dispose-pattern)
- [Implement a Dispose method](https://learn.microsoft.com/en-us/dotnet/standard/garbage-collection/implementing-dispose)
- [Implement a DisposeAsync method](https://learn.microsoft.com/en-us/dotnet/standard/garbage-collection/implementing-disposeasync)
- [Nullable reference types](https://learn.microsoft.com/en-us/dotnet/csharp/fundamentals/null-safety/nullable-reference-types)
- [Task-based Asynchronous Pattern](https://learn.microsoft.com/en-us/dotnet/standard/asynchronous-programming-patterns/task-based-asynchronous-pattern-tap)
- [Asynchronous programming with async and await](https://learn.microsoft.com/en-us/dotnet/csharp/asynchronous-programming/)
- [Cancellation in managed threads](https://learn.microsoft.com/en-us/dotnet/standard/threading/cancellation-in-managed-threads)
- [Async/Await best practices, Stephen Cleary](https://learn.microsoft.com/en-us/archive/msdn-magazine/2013/march/async-await-best-practices-in-asynchronous-programming)
- [Understanding ValueTask, Stephen Toub](https://devblogs.microsoft.com/dotnet/understanding-the-whys-whats-and-whens-of-valuetask/)
- [C# record types](https://learn.microsoft.com/en-us/dotnet/csharp/fundamentals/types/records)
- [Collections and data structures](https://learn.microsoft.com/en-us/dotnet/standard/collections/)
- [Best practices for exceptions](https://learn.microsoft.com/en-us/dotnet/standard/exceptions/best-practices-for-exceptions)
- [Code analysis in .NET](https://learn.microsoft.com/en-us/dotnet/fundamentals/code-analysis/overview)
- [dotnet format command](https://learn.microsoft.com/en-us/dotnet/core/tools/dotnet-format)
- [.NET project SDK overview](https://learn.microsoft.com/en-us/dotnet/core/project-sdk/overview)
- [Customize the build by folder](https://learn.microsoft.com/en-us/visualstudio/msbuild/customize-by-directory?view=visualstudio)
- [Select which .NET version to use](https://learn.microsoft.com/en-us/dotnet/core/versions/selection)
- [Unit testing best practices](https://learn.microsoft.com/en-us/dotnet/core/testing/unit-testing-best-practices)

### Maintainer repositories and examples

- [dotnet/runtime C# coding style](https://github.com/dotnet/runtime/blob/main/docs/coding-guidelines/coding-style.md)
- [dotnet/runtime contribution guidance](https://github.com/dotnet/runtime/blob/main/CONTRIBUTING.md)
- [dotnet/runtime Directory.Build.props](https://github.com/dotnet/runtime/blob/main/Directory.Build.props)

### Microsoft maintainer talk

- [Writing async/await from scratch with Stephen Toub](https://learn.microsoft.com/en-us/shows/on-dotnet/writing-async-await-from-scratch-in-csharp-with-stephen-toub)
