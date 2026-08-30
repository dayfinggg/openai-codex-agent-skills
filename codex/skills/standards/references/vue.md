# Vue 3 quality reference

Use this as a practical baseline for Vue 3 applications.
Treat the repository's Vue version, build configuration, tests, and local conventions as the binding contract.
Apply the separate web-ui and TypeScript standards for generic HTML, CSS, accessibility, and typing rules.

## Architecture and API style

- Use Vue's declarative, component-based model instead of manual DOM mutation.
- Prefer Single-File Components for build-tool projects; keep template, logic, and styles close when that improves comprehension. [V1]
- Use Composition API with `<script setup>` for new full applications unless an existing module has a deliberate Options API convention. [V1][V3]
- Treat a component tree as the UI composition boundary, with clear input, output, and ownership of rendered markup. [V2]
- Prefer one-way data flow: pass state through props and report intent through emitted events.
- Use slots when a parent owns content structure but a child owns layout or behavior.
- Keep business rules independent of Vue where practical so they can run in a plain unit test.
- Keep pages and root components orchestration-focused rather than turning them into a second domain layer.
- Use Options API for low-complexity progressive enhancement or established code that already depends on it.

## Composition API and reactivity

- Use `ref` for independently replaceable reactive values and use `reactive` for a cohesive mutable object.
- Use `computed` for derived state; do not duplicate a value that can be derived from existing state.
- Use `watch` for an explicit source and side effect; use `watchEffect` when automatic dependency tracking makes the intent clearer.
- Keep computed getters pure and free of mutations, I/O, and lifecycle work.
- Remember that refs use `.value` in script and are unwrapped in templates when exposed at the top level.
- Register lifecycle hooks from setup code and pair every subscription, timer, observer, or listener with teardown.
- Keep setup code ordered by concern, with state, derived values, actions, effects, and public exposure easy to locate.
- Name composables with camelCase names beginning with `use`; state the concern rather than the implementation. [V4]
- Accept plain values, refs, or getters when a reusable composable benefits from reactive inputs.
- Normalize such inputs with `toValue` and track them through `watch` or `watchEffect` when changes must trigger work. [V4]
- Call composables synchronously from `<script setup>` or `setup()` so Vue can attach effects to the active component instance.
- A composable that uses lifecycle hooks or dependency injection needs a host instance; never call it from arbitrary module scope. [V4]
- Return the smallest useful public surface, normally refs for state and named functions for mutations.
- Make asynchronous composables expose pending, success, and error states and make cancellation or cleanup explicit.
- Use explicit public contracts for props, emitted events, composable inputs, and returned records when the project uses TypeScript.
- Do not mix Options API and Composition API in one component without a migration or integration reason.

## Component and composable boundaries

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

## State management

- Keep state local until multiple views genuinely need the same source of truth.
- Lift state to a common parent for a small tree; use props and events before introducing a store.
- Use a feature composable for reusable local or feature-scoped state.
- Use a small reactive store for simple SPA-wide state and centralize mutations in named actions. [V5]
- Use Pinia or another established store when domain state needs explicit actions, plugins, devtools, or cross-feature coordination.
- Never export mutable module-level reactive state from SSR code; one server module instance can serve many requests.
- Create per-request stores and provide or inject them, or use a store designed for SSR isolation. [V6]
- Keep server data, URL state, form state, and ephemeral UI state separate so each has an appropriate lifetime.
- Persist state only through an explicit boundary such as a cookie or client storage, and guard browser-only storage access.
- Expose read-only state where callers only need observation and expose actions where callers may mutate it.

## SSR-safe Vue code

- SSR renders components to HTML and hydrates that markup into an interactive client application. [V6]
- Treat shared application code as universal code that must run without assuming either browser or server globals.
- Guard `window`, `document`, `localStorage`, layout measurement, and other browser APIs with a client lifecycle hook or a framework boundary.
- Use `onMounted` for client-only effects and use `onUnmounted` or `onBeforeUnmount` for cleanup.
- Keep server and client renders deterministic; do not render unseeded random values, current time, or client-localized values in SSR markup.
- Avoid invalid HTML nesting because browser parsing can change the DOM before hydration.
- Treat hydration mismatch warnings as defects and fix the differing data, markup, or timing instead of hiding the warning.
- Do not start timers, observers, or subscriptions in root setup code when SSR cannot run their cleanup hook.
- Keep user-specific state out of module singletons and shared caches.
- Use framework-provided SSR-aware data and state primitives when the application uses a Vue SSR framework.

## Accessibility integration

- Let components emit semantic native elements and preserve native keyboard and focus behavior, then apply the project's web-ui standard for detailed a11y rules.
- Keep generated IDs stable when Vue-rendered labels, descriptions, or error messages are linked to controls. [V7]
- Test accessible behavior through the rendered DOM and user interaction rather than component implementation details.

## Performance

- Measure page-load and update performance before optimizing; use production metrics and browser profiling rather than intuition. [V8]
- Prefer SSR or SSG for content that must appear quickly or be indexed, and use SPA delivery for genuinely interactive private tools.
- Keep production bundles small with a build step, tree-shaking-friendly dependencies, and deliberate dependency review.
- Lazy-load route components and large features that are not needed for the first interaction.
- Keep child props stable so unrelated parent changes do not invalidate every list item.
- Use `v-once` or `v-memo` only after profiling identifies a stable subtree or expensive repeated update.
- Virtualize large lists instead of creating thousands of DOM nodes that users cannot see.
- Use `shallowRef` or `shallowReactive` for genuinely large immutable structures and replace the root when updating them.
- Avoid renderless, wrapper, and higher-order component layers when a plain function or direct markup is clearer, especially in large lists. [V8]
- Do not add memoization, custom schedulers, or global caches without a measured problem and an invalidation plan.
- Verify the production build, hydration cost, network waterfall, and largest content element on representative devices.

## Testing

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

## Abstraction timing

- Begin with the smallest component or function that makes ownership obvious.
- Extract a composable when stateful logic is reused or when a large component has a coherent logical concern.
- Extract a utility when the behavior is pure and does not need Vue lifecycle or context.
- Introduce a store only when state is shared across boundaries or needs store-level actions and tooling.
- Do not create a wrapper component for a single element, a single prop rename, or a one-line call with no policy.
- Prefer explicit domain names over generic `Base`, `Common`, or `Manager` buckets that hide ownership.
- Keep abstractions close to their first consumer until a second use proves the contract.
- Delete an abstraction when it adds indirection or context coupling without reducing repeated complexity. [M1]

## Review checklist

- Can a reader identify the rendering, state, data, and test owner for every changed behavior?
- Does the code behave correctly in setup, lifecycle cleanup, SSR, hydration, and client navigation?
- Are state mutations, asynchronous failures, cancellation, and cleanup explicit?
- Does the rendered output preserve semantic native behavior and stable relationships?
- Did the change preserve a small public surface and avoid an abstraction that profiling or reuse does not justify?

## Sources

### Official Vue documentation and specifications

- [V1: Vue.js Introduction](https://vuejs.org/guide/introduction.html)
- [V2: Vue Components Basics](https://vuejs.org/guide/essentials/component-basics.html)
- [V3: Vue Composition API FAQ](https://vuejs.org/guide/extras/composition-api-faq.html)
- [V4: Vue Composables](https://vuejs.org/guide/reusability/composables.html)
- [V5: Vue State Management](https://vuejs.org/guide/scaling-up/state-management.html)
- [V6: Vue Server-Side Rendering](https://vuejs.org/guide/scaling-up/ssr.html)
- [V7: Vue Accessibility](https://vuejs.org/guide/best-practices/accessibility.html)
- [V8: Vue Performance](https://vuejs.org/guide/best-practices/performance.html)
- [V9: Vue Testing](https://vuejs.org/guide/scaling-up/testing.html)

### Maintainer RFC

- [M1: Vue Composition API RFC](https://github.com/vuejs/rfcs/blob/master/active-rfcs/0013-composition-api.md)
