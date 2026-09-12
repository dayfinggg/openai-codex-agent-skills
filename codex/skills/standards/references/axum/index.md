# Axum framework reference

Consult the [Rust reference](../rust/index.md) only for relevant language-wide ownership, error, async, testing, or abstraction decisions not covered by loaded guidance.
This reference adds Axum, Tower, and Tokio integration details without repeating that baseline.
Read documentation that matches the Axum version in `Cargo.lock`.
Use release documentation matching `Cargo.lock`, not assumptions from the development branch [A12].

## Reference map

- [Application shape and state](application-shape-and-state.md)
- [Extractors and handlers](extractors-and-handlers.md)
- [Routing and middleware](routing-and-middleware.md)
- [Errors](errors.md)
- [Async and concurrency](async-and-concurrency.md)
- [Database boundary](database-boundary.md)
- [Security](security.md)
- [Observability](observability.md)
- [Testing and shutdown](testing-and-shutdown.md)
- [Sources](sources.md)
