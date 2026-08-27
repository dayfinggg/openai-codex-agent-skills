# Frontend Quality

Read only the sections that match the current risk.

## Accessibility

- Treat WCAG 2.2 at the project's required conformance level as testable acceptance criteria, not a final automated score.
- Prefer native semantics. Add ARIA only when native HTML cannot express the widget, and implement the complete Authoring Practices interaction rather than isolated attributes.
- Verify accessible name, role, value, description, status announcements, heading and landmark structure, alternative text, contrast, zoom and reflow, visible focus, focus order, target size, reduced motion, and keyboard operation where applicable.
- Keep focus predictable. Opening, closing, submitting, navigating, inserting content, and reporting errors must not strand or silently relocate the user.
- Combine automated checks with keyboard use and browser accessibility-tree inspection. Automated tools cannot prove that language, focus behavior, alternative text, or task flow is correct.

## Performance

- Measure the affected user flow before optimizing. Use field data when available and lab traces to explain causes. Evaluate Core Web Vitals at the relevant 75th percentile, segmented by mobile and desktop, rather than relying on a single local run.
- Reduce work before tuning it. Limit shipped JavaScript, hydration, main-thread tasks, duplicate requests, layout work, third-party code, oversized media, and render-blocking resources.
- Keep the likely LCP resource discoverable and appropriately prioritized. Set media dimensions and reserve asynchronous space to prevent layout shifts. Keep interaction handlers short and yield or move work when measured main-thread blocking affects responsiveness.
- Re-profile after a material change. Do not claim improvement from bundle size alone, a synthetic score alone, or a framework feature without measuring the user-facing result.

## Security And Browser APIs

- Treat URL data, storage, messages, API responses, uploaded content, and third-party data as untrusted. Rely on framework escaping, use context-appropriate output encoding, and avoid string-to-HTML or string-to-code sinks.
- If rich untrusted HTML is an explicit requirement, use the project's maintained sanitizer with a restrictive policy. Do not bypass escaping merely to preserve markup.
- Use Content Security Policy as defense in depth, not a substitute for safe code. Adopt Trusted Types when the browser support and application risk justify constraining DOM injection sinks.
- Never ship secrets, private credentials, privileged query logic, or hidden authorization assumptions to the browser. Client-side visibility checks do not replace server-side authorization.
- Validate untrusted destinations and schemes before navigation or resource loading. Follow the application's CSRF, cookie, origin, and credential policies for mutations.
- Use feature detection and the project's browser support matrix. Abort fetches whose result is obsolete, remove global listeners, clear timers, release observers, and avoid leaving work attached to unmounted interfaces.
- Preserve browser history semantics. A state change that users perceive as navigation must have a coherent URL, title, back and forward behavior, and restoration strategy.

## Tests

- Test observable behavior through the same names, roles, text, and controls a user perceives. Avoid assertions on component internals, private state, CSS classes, or incidental DOM shape.
- Put pure transformation and state-transition logic under focused unit tests. Use component or integration tests for rendering and interaction contracts. Use end-to-end tests for critical cross-route or server-integrated flows.
- Cover the highest-risk success and failure paths, including validation, retry, authorization, stale requests, navigation restoration, and progressive behavior when they are part of the feature.
- Prefer accessible queries and resilient locators. Keep tests isolated, control data and external services, use web-first waiting, and avoid arbitrary sleeps.
- Run visual regression tests only in a controlled browser, operating system, font, viewport, animation, and data environment. Review changed pixels as evidence, not as automatic proof of correctness.

## Build And Dependencies

- Use the installed build system and its production mode. Confirm browser targets, environment-variable exposure, asset base paths, server and client entry separation, source maps, and deployment-specific chunk behavior.
- Split by routes and genuinely optional heavy capabilities. Do not fragment small synchronous code into network overhead, and do not defer code required for the first useful interaction.
- Preserve module side effects accurately so tree shaking does not remove required CSS or initialization. Inspect the actual production output when a dependency or client boundary materially changes it.
- Before adding a package, compare the stable platform API and installed utilities. Check compatibility, transitive cost, maintenance, security posture, licensing when required, and whether the package crosses the server-client boundary.

## Production Validation

1. Run the repository's relevant formatter, type checker, lint, tests, and production build without introducing a new toolchain.
2. Exercise the changed flow with realistic data at supported narrow and wide widths, keyboard-only input, text zoom, long content, and at least one failure path.
3. Verify expected network requests, response handling, cancellation, cache behavior, navigation, document title, focus, and history.
4. Check the console, hydration output, accessibility tree, layout overflow, media sizing, and loading transitions.
5. Inspect performance traces or production bundles only when the change plausibly affects them, and compare against a recorded baseline or budget.
