# Composition API and reactivity

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
