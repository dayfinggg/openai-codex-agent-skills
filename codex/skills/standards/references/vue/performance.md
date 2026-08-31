# Performance

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
