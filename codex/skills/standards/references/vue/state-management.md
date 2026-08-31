# State management

- Keep state local until multiple views genuinely need the same source of truth.
- Lift state to a common parent for a small tree; use props and events before introducing a store.
- Use a feature composable for reusable local or feature-scoped state.
- Use a small reactive store for simple SPA-wide state and centralize mutations in named actions. [V5]
- Use Pinia or another established store when domain state needs explicit actions, plugins, devtools, or cross-feature coordination.
- Never export mutable module-level reactive state from SSR code; one server module instance can serve many requests.
- Create per-request stores and provide or inject them, or use a store designed for SSR isolation. [V6]
- Keep server data, URL state, form state, and ephemeral UI state separate so each has an appropriate lifetime.
- Persist state only through an explicit boundary such as a cookie or client storage, and guard browser-only storage access.
- Expose read-only state where callers only need observation and expose actions where callers may mutate it.
