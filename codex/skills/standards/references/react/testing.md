# Testing

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
