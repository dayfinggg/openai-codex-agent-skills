# State and request isolation

- Use `useState` for small Nuxt-shared state that must survive SSR into hydration; keep its value JSON-serializable. [N9]
- Never export `const state = ref()` from module scope in an SSR application because requests can share that object.
- Create per-request state in Nuxt context or use a store designed for SSR isolation.
- Use Pinia when domain state needs explicit actions, plugins, devtools, or cross-feature coordination, following the [Vue state boundary](../vue/index.md).
- Keep server data, URL state, form state, and ephemeral UI state separate so each has an appropriate lifetime.
- Persist state only through an explicit cookie or client-storage boundary and guard browser-only storage access.
- Do not put classes, functions, symbols, or other non-serializable values in `useState` without a deliberate payload serializer. [N9]
- Keep user-specific state out of shared prerendered responses and shared caches unless the isolation policy is explicit.
