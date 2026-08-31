# Testing

- Start tests early and cover pure logic, component behavior, and end-to-end user flows at their natural boundaries. [V9]
- Use Vitest for unit tests in Vite-based Vue projects and use `@vue/test-utils` for component mounting. [V9]
- Unit-test pure functions and headless composables with direct inputs and observable outputs.
- Mount composables in a host component when they depend on lifecycle hooks or provide/inject.
- Test components through rendered DOM, props, events, slots, and user interactions rather than private refs or methods.
- Avoid mocking child components by default; preserve the interaction that the user actually experiences.
- Use browser-based end-to-end tests for navigation and multi-page behavior that unit and component tests cannot observe.
- Assert loading, empty, error, retry, cancellation, and success states for asynchronous UI.
- Reset stores, mocks, timers, and browser storage between tests.
- Include an SSR or hydration regression test whenever a change touches platform APIs, payload serialization, or initial markup.
