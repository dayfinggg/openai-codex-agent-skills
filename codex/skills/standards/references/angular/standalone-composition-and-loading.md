# Standalone composition and loading

- Import only the declarations a template uses so the dependency graph stays visible and tree-shakable.
- Prefer the built-in `@if`, `@for`, and `@switch` blocks over legacy structural syntax in new templates.
- Use `loadComponent` for a lazy page and `loadChildren` for a lazy route tree.
- Keep the main landing page eager when its immediate availability outweighs the initial bundle cost.
- Lazy-load secondary features, and measure whether nested lazy boundaries add more requests than value.
- Use `@defer` for non-critical standalone components, directives, pipes, and their component styles.
- Give deferred content a stable placeholder, loading state, and error state when users can observe the transition.
- Do not defer above-the-fold content without preserving its dimensions, because replacement can cause layout shift.
- Import a deferred component directly rather than through a barrel when a separate lazy chunk matters.
- Keep NgModule-based third-party dependencies at the boundary until the library offers a standalone-compatible API.
