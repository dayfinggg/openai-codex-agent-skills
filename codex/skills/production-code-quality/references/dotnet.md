# .NET

Honor the target framework, language version, nullable configuration, the closest `.editorconfig`, global analyzer configuration, `Directory.Build.props` or `Directory.Build.targets`, formatter, package policy, solution or project boundary, and test framework. Run a repository script first. Otherwise check the selected solution or project with `dotnet format path/to/project.csproj --verify-no-changes`; do not broaden to every solution or restore dependencies when repository policy requires an offline or narrower command.

When no repository formatting policy exists, use this C# fallback derived from Microsoft sample conventions: four-space indentation, spaces rather than tabs, and the shared line-width row in [code shape and naming](code-shape-and-naming.md). This is a local fallback, not a C# language requirement. Use that reference unchanged for function, type, file, nesting, complexity, and parameter thresholds.

Use `PascalCase` for types, namespaces, methods, properties, events, constants, and public members, `camelCase` for parameters and local variables, and `_camelCase` for private instance fields when no closer naming rule applies. Prefix interfaces with `I`. Treat `s_` and `t_` field prefixes as repository-selectable conventions rather than universal requirements. Name an ordinary `.cs` file for its primary type. Preserve generated files, partial-type suffixes, Razor conventions, resource pairings, and framework discovery names.

Enable nullable reference types for new code and express absence deliberately. Prefer immutable data, pattern matching, records, and asynchronous APIs when they simplify behavior. Use `async` end to end, propagate `CancellationToken`, avoid blocking waits, and distinguish CPU-bound from I/O-bound work.

Dispose owned resources deterministically with `using` or `await using`. Preserve exception causes, catch only when adding meaningful recovery or context, and avoid exceptions for expected control flow. Keep dependency-injection boundaries explicit without introducing interfaces that have no substitutable role.

For libraries, evaluate source, binary, and behavioral compatibility before changing public members, nullability, virtual dispatch, serialization, or dependency versions.

Primary references: [C# conventions](https://learn.microsoft.com/dotnet/csharp/fundamentals/coding-style/coding-conventions), [C# identifier naming](https://learn.microsoft.com/dotnet/csharp/fundamentals/coding-style/identifier-names), [`dotnet format`](https://learn.microsoft.com/dotnet/core/tools/dotnet-format), [.NET design guidelines](https://learn.microsoft.com/dotnet/standard/design-guidelines/), and [.NET compatibility rules](https://learn.microsoft.com/dotnet/core/compatibility/library-change-rules).
