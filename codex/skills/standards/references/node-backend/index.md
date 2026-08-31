# Framework-neutral Node.js backend standards

Use these rules for HTTP services built directly on Node.js or behind a thin adapter.
Keep transport concerns at the edge and keep application behavior independent of the adapter.
Choose the smallest complete design that makes ownership, failure, and operations obvious.

## Reference map

- [Request boundary](request-boundary.md)
- [Validation and representation](validation-and-representation.md)
- [Error policy](error-policy.md)
- [Async lifecycle](async-lifecycle.md)
- [Dependency boundaries](dependency-boundaries.md)
- [Context and observability](context-and-observability.md)
- [Security and performance](security-and-performance.md)
- [Testing](testing.md)
- [Design checkpoint](design-checkpoint.md)
- [Sources](sources.md)
