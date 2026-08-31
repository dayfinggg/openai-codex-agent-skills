# Abstraction timing

- Begin with the smallest Nuxt primitive that makes ownership and execution context obvious.
- Extract a custom composable only when it preserves the underlying Nuxt context and has a coherent current caller.
- Do not wrap `useFetch` or `useAsyncData` with a generic helper that hides keys, options, errors, or cancellation.
- Introduce a layer or module only when code is intentionally reusable across applications or teams.
- Keep feature-specific server handlers and app components close to their owning feature until reuse proves a wider boundary.
- Prefer explicit domain names over generic `Base`, `Common`, or `Manager` buckets that hide ownership.
- Delete an abstraction when it adds indirection, context coupling, or component instances without reducing repeated complexity.
