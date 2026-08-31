# Testing

- Use `@nuxt/test-utils` for tests that need auto-imports, plugins, async setup, server routes, or a Nuxt runtime. [N10]
- Keep fast pure unit tests in a plain Node environment and isolate Nuxt-runtime tests in their configured environment.
- Use `@vue/test-utils` for components that do not require Nuxt context and use Nuxt helpers when context is part of the behavior.
- Use browser-based end-to-end tests for navigation, routing, hydration, public assets, and request handling across pages.
- Assert loading, empty, error, retry, cancellation, and success states for asynchronous UI.
- Reset stores, global Nuxt state, mocks, timers, and browser storage between tests.
- Include an SSR or hydration regression test whenever a change touches platform APIs, payload serialization, initial markup, or route rules.
- Exercise the official Nuxt examples when a framework behavior is unclear instead of copying an unverified community pattern. [E1]
