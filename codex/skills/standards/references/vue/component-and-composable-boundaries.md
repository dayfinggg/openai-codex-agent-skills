# Component and composable boundaries

- Let a component own rendering, DOM semantics, user interaction, and presentation-specific state.
- Keep props read-only from the child's perspective; emit a semantic event when the parent owns the mutation.
- Keep event names and payloads semantic, such as `submit` or `remove`, rather than exposing child implementation details.
- Use `provide` and `inject` for a tree-scoped dependency, such as a form context or service, not as a hidden global store.
- Put reusable stateful behavior in a composable and keep pure transformations in ordinary functions.
- Pass dependencies into composables instead of importing request-specific or mutable state from module scope.
- Keep composables free of template assumptions so several components can use the same behavior.
- Avoid reaching into parent or child component instances with template refs as a general communication channel.
- Expose imperative component methods only when a real DOM or widget boundary requires them.
- Keep a component's public props and events stable enough that callers do not need its internal state graph.
- Generate unique IDs with Vue's `useId` when rendered labels, descriptions, and controls need stable relationships.
- Keep component tests and callers dependent on rendered behavior, not private refs or methods.
