# Data fetching

- Use `$fetch` for event-driven mutations, browser-only interactions, and server code that needs a direct request.
- Use `useFetch` for a URL-based request in setup, a plugin, or route middleware; it wraps `$fetch` and carries SSR data through the Nuxt payload. [N7]
- Use `useAsyncData` when the source is an arbitrary async function, a third-party client, or a multi-step query. [N8]
- Do not use `useFetch` as a replacement for `$fetch` inside a click handler or another post-mount event.
- Keep `useAsyncData` handlers side-effect free and return a truthy value so SSR and client hydration remain predictable. [N8]
- Use an explicit stable key when data is shared, wrapped by a custom composable, or invalidated from another component.
- Keep `deep`, `transform`, `pick`, `default`, and cache options compatible across calls that share a key.
- Use reactive URLs, keys, or `watch` sources for refetching; set `watch: false` when a reactive option must not trigger a request.
- Pass the provided abort signal to `$fetch` or another cancellable client so navigation and deduplication can stop stale work. [N8]
- Use `lazy: true` when navigation should not wait for non-critical data, and render an explicit pending state.
- Use `server: false` only when data is intentionally client-only, and handle the initial undefined or pending state.
- Use `pick` or `transform` to reduce serialized payload fields, while remembering that the upstream request still fetches its original response.
- Use `status` and `error` to render loading, success, and failure states rather than inferring status from `data` alone.
- Use `refresh`, `execute`, `clear`, and `useNuxtData` for explicit invalidation and cached-data coordination. [N8][N12]
- Avoid request waterfalls by starting independent fetches together and placing dependent fetches behind the actual dependency.
- Validate and normalize route parameters, query values, request bodies, and external responses at their boundaries.
- Keep credentials and private runtime configuration on the server; expose only intentionally public values to the client.
