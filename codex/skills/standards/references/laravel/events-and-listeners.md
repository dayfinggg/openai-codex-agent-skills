# Events and listeners
- Use an event for a meaningful fact or an optional extension point, not for a required step whose order is business-critical.
- Keep event payloads small and stable, with identifiers or immutable snapshots instead of mutable model graphs.
- Use listeners to decouple optional notifications, indexing, analytics, or integration work from the use case.
- Queue slow listeners with `ShouldQueue` and configure after-commit behavior when they read transaction results.
- Keep listener dependencies type-hinted so Laravel can resolve them through the container.
- Use `Event::fake()` to assert dispatch without executing listeners, then test each listener independently.
- Document event ordering or propagation only when correctness depends on it.
