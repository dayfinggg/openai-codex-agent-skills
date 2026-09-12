# PHP quality and compatibility

Use this guide for changed PHP code and scoped reviews. Read [Version compatibility](version-compatibility.md) first to establish the supported runtime and dependency range. Modern recommendations are conditional on that range, not permission to raise it or rewrite legacy code.

Inspect `composer.json`, the lock file, CI, deployment configuration, and extension requirements. If they disagree, preserve the declared support contract and establish which environments actually run the code. Do not infer production PHP from the local CLI. For projects without Composer, use their existing runtime contract rather than introducing Composer solely for this guide.

For greenfield work, choose a currently supported stable release compatible with deployment and dependencies. For maintenance, preserve every promised version, including end-of-life versions, and report concrete support limitations without silently upgrading. Official sources were reviewed on 2026-09-12. Recheck support status and version-specific documentation when making a decision.

## Reference map

- [Version compatibility](version-compatibility.md): syntax gates, legacy alternatives, dependency and runtime checks.
- [Caching and invalidation](caching-and-invalidation.md): keys, TTL, consistency, concurrency, and failure behavior.
- [Data and serialization](data-and-serialization.md): money, dates, JSON, and durable payload contracts.
- [Persistence and concurrency](persistence-and-concurrency.md): queries, transactions, races, and migrations.
- [Runtime and background work](runtime-and-background-work.md): workers, queues, OPcache, configuration, and observability.
- [File and style rules](file-and-style-rules.md)
- [Strict, explicit types](strict-explicit-types.md)
- [Errors and exceptions](errors-and-exceptions.md)
- [HTTP, persistence, and session boundaries](http-persistence-and-session-boundaries.md)
- [Dependency injection and design](dependency-injection-and-design.md)
- [Packages, modules, and Composer](packages-modules-and-composer.md)
- [Static analysis](static-analysis.md)
- [Testing](testing.md)
- [Naming and documentation](naming-and-documentation.md)
- [Size and cohesion heuristics](size-and-cohesion-heuristics.md)
- [Practical CI order](practical-ci-order.md)
- [Sources](sources.md)

Read only the relevant topic files after compatibility. Combine with [Laravel](../laravel/index.md) or [Symfony](../symfony/index.md) for those frameworks, using documentation for the installed major version. Their modern examples do not override an older project's contract. Use [security](../security/index.md) and the relevant database reference for affected boundaries rather than duplicating a full security or SQL audit.
