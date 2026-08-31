# Abstraction timing

- Begin with the smallest component or function that makes ownership obvious.
- Extract a composable when stateful logic is reused or when a large component has a coherent logical concern.
- Extract a utility when the behavior is pure and does not need Vue lifecycle or context.
- Introduce a store only when state is shared across boundaries or needs store-level actions and tooling.
- Do not create a wrapper component for a single element, a single prop rename, or a one-line call with no policy.
- Prefer explicit domain names over generic `Base`, `Common`, or `Manager` buckets that hide ownership.
- Keep abstractions close to their first consumer until a second use proves the contract.
- Delete an abstraction when it adds indirection or context coupling without reducing repeated complexity. [M1]
