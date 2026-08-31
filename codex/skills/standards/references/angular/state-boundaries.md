# State boundaries

- Keep ephemeral view state, such as an open panel or pending selection, in the owning component.
- Keep state shared by sibling or routed components in a narrowly scoped service with a small public API.
- Keep server state near its data-access boundary and represent loading, success, empty, and error states explicitly.
- Put durable navigation state in route parameters or query parameters so links and reloads preserve intent.
- Prefer one authoritative writable signal or Observable for each piece of state.
- Derive filters, counts, labels, and view models instead of storing duplicate copies.
- Introduce a global store only when cross-feature coordination, persistence, devtools, or replay justify its cost.
- Do not put HTTP calls, subscriptions, or DOM code in a `computed` derivation.
