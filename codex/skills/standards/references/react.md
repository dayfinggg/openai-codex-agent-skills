# React standards

This reference covers current function-component React, Hooks, and React Compiler guidance.
Use framework-specific rules for routing, server rendering, data fetching, and deployment in `nextjs.md`.
- The React documentation currently labels the latest major line 19.2, so verify the installed version before relying on a new API. [React versions](https://react.dev/versions)

## Architectural model

- Build a component tree from the interface and its visual states before deciding where state belongs. [Thinking in React](https://react.dev/learn/thinking-in-react)
- Build the static UI with props first, then add the smallest state model that makes interaction possible. [Thinking in React](https://react.dev/learn/thinking-in-react)
- Keep data flow explicit from parent to child and use callbacks for deliberate inverse flow. [Thinking in React](https://react.dev/learn/thinking-in-react)
- Treat a component as a pure function of props, state, and context that returns JSX.
- React updates the screen through trigger, render, and commit phases; a render does not imply a DOM mutation. [Render and commit](https://react.dev/learn/render-and-commit)
- Keep render calculations pure, deterministic, and free of mutations to objects owned by another render. [Keeping components pure](https://react.dev/learn/keeping-components-pure)
- React may call render logic more than once in development or concurrent work, so render code must be safe to restart.
- Keep side effects in event handlers or Effects, never as incidental work during render.
- Use one responsibility per meaningful boundary and separate UI composition from business rules when the split clarifies ownership. Do not create mandatory layers without a current need.
- Keep business rules and request orchestration out of a component when they obscure the component's rendering responsibility.
- Prefer a narrow hook, service, or adapter boundary only when it gives the behavior a clear owner and focused tests.

## Component boundaries

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

## State placement

- Store only changing data that cannot be derived from props, existing state, or another authoritative source. [Choosing the state structure](https://react.dev/learn/choosing-the-state-structure)
- Derive filtered, sorted, formatted, and validity values during render instead of storing duplicates. [You might not need an Effect](https://react.dev/learn/you-might-not-need-an-effect)
- Prefer local state for drafts, hover state, open menus, and other transient interaction details. [React memo](https://react.dev/reference/react/memo)
- Lift state to the closest common parent when sibling components must stay synchronized. [Sharing state](https://react.dev/learn/sharing-state-between-components)
- Keep state above that parent only when a real consumer needs the same source of truth.
- Use a reducer when related transitions are spread across many handlers or the state shape has meaningful invariants. [Managing state](https://react.dev/learn/managing-state)
- Use context for genuinely cross-cutting values, not as a default replacement for local state or props.
- Use refs for DOM handles or mutable values that must persist without scheduling a render. [Escape hatches](https://react.dev/learn/escape-hatches)
- Treat a state key as part of the component's identity, and reset it deliberately rather than clearing fields from an Effect.
- Do not mirror server responses or derived props into local state without an explicit independent lifecycle.
- Add an external store only when multiple distant consumers need coordinated mutable state that local ownership and context cannot express.

## Hooks, Effects, and events

- Call Hooks only at the top level of React functions or custom Hooks, before conditional returns. [Rules of Hooks](https://react.dev/reference/rules/rules-of-hooks)
- An Effect synchronizes React with an external system such as a subscription, timer, DOM API, or third-party widget. [useEffect](https://react.dev/reference/react/useEffect)
- Do not use an Effect to derive render data, mirror props, or handle an event that the event handler already knows occurred. [You might not need an Effect](https://react.dev/learn/you-might-not-need-an-effect)
- Put mutations, action-specific analytics, and notifications in the event handler or command that knows the user action.
- Declare every reactive dependency and restructure the code instead of suppressing the dependency lint rule. [useEffect dependencies](https://react.dev/reference/react/useEffect)
- Return cleanup that fully undoes setup, including unsubscribe, abort, disconnect, and listener removal operations.
- Make setup and cleanup symmetric so Strict Mode's extra development cycle is harmless. [useEffect](https://react.dev/reference/react/useEffect)
- Effects run only on the client and cannot provide server-rendered data. [useEffect](https://react.dev/reference/react/useEffect)
- Use `useLayoutEffect` only for measured DOM work that must happen before paint; prefer `useEffect` otherwise.
- If a manual client fetch is unavoidable, prevent stale responses from winning and handle cancellation, loading, error, and unmount cases.
- Prefer a framework data API or a maintained client cache over repeated mount-time fetch Effects because those approaches can preload, deduplicate, cache, and render data earlier. [useEffect data fetching](https://react.dev/reference/react/useEffect)
- Each render's handlers and Effects capture that render's props and state; use a ref only when intentionally reading a mutable latest value. [Dan Abramov on useEffect](https://overreacted.io/a-complete-guide-to-useeffect/)

## Rendering and performance

- Keep render functions free of I/O, subscriptions, timers, mutations, and logging that changes behavior.
- Fix impure rendering, duplicated state, broad context, and unnecessary Effects before optimizing re-renders.
- Measure the user interaction and identify the slow calculation or component before adding memoization. [React useMemo](https://react.dev/reference/react/useMemo)
- Use `memo` only when a component re-renders often with the same props and its render is measurably expensive. [React memo](https://react.dev/reference/react/memo)
- Use `useMemo` for a proven expensive calculation, a stable prop needed by `memo`, or a deliberately stable Hook dependency.
- Use `useCallback` for a stable function contract, not to prevent ordinary function allocation.
- Treat memoization as a performance optimization, never as a correctness fix or semantic guarantee. [React memo](https://react.dev/reference/react/memo)
- React Compiler can automate much component and calculation memoization in supported builds, but it does not relax purity or measurement requirements. [React Compiler](https://react.dev/learn/react-compiler/introduction)
- Test performance in a production build on representative devices and throttled CPU or network conditions. [React useMemo](https://react.dev/reference/react/useMemo)
- Check browser performance tools and React DevTools before changing component boundaries. Extra renders and misplaced calculations are common causes of slow interactions.
- Remove unused dependencies and code before adding a performance library. Choose ready-made UI libraries by fit, weight, and behavior rather than habit.
- Keep large lists, expensive calculations, and third-party widgets behind boundaries that can be optimized independently.

## Testing

- Unit-test pure transformations, reducers, validators, and data helpers without rendering a component.
- Component-test rendered states, user interactions, callbacks, Hook behavior, and accessible output through the public UI.
- Integration-test several units through their real provider, context, store, or data adapter when those boundaries carry behavior.
- Assert roles, labels, visible text, and outcomes instead of private state, implementation functions, or incidental markup.
- Test loading, empty, error, disabled, and recovery states whenever the component can reach them.
- Include cleanup and Strict Mode coverage for every component that owns an external subscription or widget.
- Keep test setup self-contained until repeated setup genuinely obscures the behavior under test. [Avoid nesting when testing](https://kentcdodds.com/blog/avoid-nesting-when-youre-testing)
- Prefer a small amount of repeated test setup over a shared fixture that hides state transitions and assumptions.
- Keep tests near their owning feature or component when that improves discovery and change locality.
- Use browser tests for flows that depend on navigation, hydration, real focus behavior, or a framework server boundary.
- Treat tests and reusable APIs as part of component design rather than cleanup after implementation.

## File and module organization

- Keep a file around one cohesive component, Hook, domain policy, adapter, or test concern.
- Split a file when it has multiple independent reasons to change or requires unrelated dependencies.
- Keep a larger file when extraction would create shallow wrappers or scatter one invariant across navigation-heavy fragments.
- Separate UI composition from business rules and I/O when the split makes ownership and tests clearer.
- Keep imports directed from shared primitives to features and from features to screens; avoid cycles and route-to-route knowledge.
- Put a narrow public surface at the module boundary and keep implementation details private.
- Create only folders the project needs now. A maximal directory tree hides ownership and slows discovery.
- Group files by feature or change path when a screen, its state logic, data access, and tests usually change together.
- Keep constants and configuration separate from component render logic when doing so prevents accidental recreation or hidden environment coupling.
- Load heavy modules or data only when a current interaction needs them, and verify that the deferred boundary improves the measured path.
- Avoid barrel files or generic utility folders when they create unclear ownership or broad dependency graphs.

## Abstraction timing

- Prefer visible, semantic duplication over an abstraction whose future use cases are unknown. [AHA Programming](https://kentcdodds.com/blog/aha-programming)
- Optimize for change first and let several real uses reveal the stable concept and variation.
- Extract when a repeated behavior has a stable name, owner, inputs, and invariant.
- Keep component APIs narrow; do not add flags and configuration for unrelated consumers.
- Prefer composition and focused custom Hooks over a mega-component with conditional branches for every screen.
- Keep route- or feature-specific components specific until another feature demonstrates the same contract.
- Do not add a state library, adapter, factory, or design-system layer solely to avoid a few repeated lines.
- Do not use Effects, memoization, or indirection to hide a state-ownership or data-flow problem.
- Revisit boundaries after real usage exposes change pressure, testing pain, or duplicated knowledge.

## Sources

### Official React documentation

- [React versions](https://react.dev/versions)
- [Your first component](https://react.dev/learn/your-first-component)
- [Thinking in React](https://react.dev/learn/thinking-in-react)
- [Render and commit](https://react.dev/learn/render-and-commit)
- [Keeping components pure](https://react.dev/learn/keeping-components-pure)
- [Managing state](https://react.dev/learn/managing-state), [choosing state](https://react.dev/learn/choosing-the-state-structure), and [sharing state](https://react.dev/learn/sharing-state-between-components)
- [Preserving and resetting state](https://react.dev/learn/preserving-and-resetting-state)
- [Escape hatches](https://react.dev/learn/escape-hatches)
- [Rules of Hooks](https://react.dev/reference/rules/rules-of-hooks)
- [useEffect](https://react.dev/reference/react/useEffect) and [You might not need an Effect](https://react.dev/learn/you-might-not-need-an-effect)
- [memo](https://react.dev/reference/react/memo) and [useMemo](https://react.dev/reference/react/useMemo)
- [React Compiler](https://react.dev/learn/react-compiler/introduction)

### Practitioner guidance

- [Dan Abramov: A complete guide to useEffect](https://overreacted.io/a-complete-guide-to-useeffect/)
- [Kent C. Dodds: AHA Programming](https://kentcdodds.com/blog/aha-programming)
- [Kent C. Dodds: Avoid nesting when testing](https://kentcdodds.com/blog/avoid-nesting-when-youre-testing)

### Talks and community material

- [React Conf 2024 RSC talk](https://conf2024.react.dev/talks/16)
