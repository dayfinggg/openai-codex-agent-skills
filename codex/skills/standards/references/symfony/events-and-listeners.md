# Events and listeners
- Dispatch a typed event for a meaningful fact or extension point that other code may observe.
- Keep event payloads small and stable, with identifiers or immutable snapshots instead of mutable entity graphs.
- Use listeners or subscribers for optional reactions such as notifications, indexing, analytics, or integrations.
- Use `#[AsEventListener]` or autoconfigured subscribers instead of repetitive manual registration.
- Use a subscriber when one class intentionally owns several related subscriptions.
- Use listener priorities sparingly and document the ordering when behavior depends on it.
- Keep `kernel.*` listeners focused on HTTP cross-cutting work such as request metadata or exception responses.
- Do not hide a required, ordered business step inside an event listener.
- Inspect registrations with `debug:event-dispatcher` when event behavior is unclear.
