# Testing

- Use unit tests for pure data transformations, reducers, validators, and server helpers.
- Use component tests for Client Component rendering, interactions, callbacks, context, and accessible output.
- Use integration tests for several units working through providers, caches, Server Actions, or data adapters.
- Use Playwright or another browser runner for navigation, forms, hydration, streaming, focus, and critical user journeys. [Next.js Playwright example](https://github.com/vercel/next.js/tree/canary/examples/with-playwright)
- Next.js notes that async Server Components are not fully supported by common unit runners, so prefer end-to-end coverage for them. [Next.js testing guide](https://github.com/vercel/next.js/blob/canary/docs/01-app/02-guides/testing/index.mdx?plain=1)
- Test the production build when behavior depends on prerendering, RSC payloads, route handlers, or runtime data.
- Assert user-visible roles, labels, text, URLs, and outcomes instead of private component state or implementation details.
- Cover loading, empty, error, unauthorized, slow, and recovery states for every data-dependent route.
- Include keyboard and route-announcement checks for custom navigation and interactive components.
- Keep tests close to their owning route or feature, and use the official examples as setup references instead of stale snippets. [Next.js Jest example](https://github.com/vercel/next.js/tree/canary/examples/with-jest) [Next.js Playwright example](https://github.com/vercel/next.js/tree/canary/examples/with-playwright)
- Run lint, type checking, focused tests, accessibility checks, `next build`, and a production-like smoke test before shipping a boundary change.
