# Performance and rendering

- Profile first with Angular DevTools or the Angular track in Chrome DevTools, then optimize the measured bottleneck.
- Let OnPush skip unchanged subtrees, and notify Angular through signal reads, template events, input updates, `AsyncPipe`, or `markForCheck`.
- Avoid expensive function calls, allocations, and unbounded work in templates or lifecycle hooks.
- Use a stable `track` key and immutable collection updates for large or frequently changing lists.
- Lazy-load secondary routes and defer below-the-fold or interaction-only code to reduce initial JavaScript.
- Use `NgOptimizedImage` for application images, prioritizing the LCP image and lazy-loading non-critical images.
- Consider SSR or SSG for content that needs a fast first paint or search indexing, and enable hydration to reuse server DOM.
- Keep server and client DOM identical during hydration; avoid direct DOM mutation and browser globals in shared render paths.
- Use `afterNextRender` or `afterEveryRender` for browser-only work and prefer platform providers over template platform checks.
- In zoneless applications, connect reactive-form or third-party Observable updates to a signal or an explicit change notification.
- Remove ZoneJS only after testing all libraries and both production and test bootstraps; legacy zone-dependent code may need migration.
