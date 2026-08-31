# Component boundaries

- Give a component one coherent visual or behavioral responsibility, not an arbitrary number of DOM nodes.
- Split when state, lifecycle, data dependency, error behavior, or render policy can change independently.
- Keep a component together when extraction would only add pass-through props and hide the behavior being changed.
- Make component APIs small and name props after domain meaning or user events.
- Pass rendered children or slots when a wrapper should not know the details of its content. [React memo](https://react.dev/reference/react/memo)
- Keep reusable primitives independent from one screen's data fetching and business rules.
- Define components at module scope; nested component definitions recreate identity and can reset state unexpectedly. [Your first component](https://react.dev/learn/your-first-component)
- Use stable domain keys for list items so state follows an item across insertion, deletion, and reordering.
- Use a key to reset state only when a change of identity should create a fresh component instance. [Preserving and resetting state](https://react.dev/learn/preserving-and-resetting-state)
- Add an error or Suspense boundary where failure or latency should stop, not around an unrelated parent tree.
- Use custom Hooks to expose a declarative behavior when multiple components share the same stateful logic.
- Do not extract every wrapper, heading, or one-line expression without an independent responsibility.
