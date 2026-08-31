# State placement

- Store only changing data that cannot be derived from props, existing state, or another authoritative source. [Choosing the state structure](https://react.dev/learn/choosing-the-state-structure)
- Derive filtered, sorted, formatted, and validity values during render instead of storing duplicates. [You might not need an Effect](https://react.dev/learn/you-might-not-need-an-effect)
- Prefer local state for drafts, hover state, open menus, and other transient interaction details. [React memo](https://react.dev/reference/react/memo)
- Lift state to the closest common parent when sibling components must stay synchronized. [Sharing state](https://react.dev/learn/sharing-state-between-components)
- Keep state above that parent only when a real consumer needs the same source of truth.
- Use a reducer when related transitions are spread across many handlers or the state shape has meaningful invariants. [Managing state](https://react.dev/learn/managing-state)
- Use context for genuinely cross-cutting values, not as a default replacement for local state or props.
- Use refs for DOM handles or mutable values that must persist without scheduling a render. [Escape hatches](https://react.dev/learn/escape-hatches)
- Treat a state key as part of the component's identity, and reset it deliberately rather than clearing fields from an Effect.
- Do not mirror server responses or derived props into local state without an explicit independent lifecycle.
- Add an external store only when multiple distant consumers need coordinated mutable state that local ownership and context cannot express.
