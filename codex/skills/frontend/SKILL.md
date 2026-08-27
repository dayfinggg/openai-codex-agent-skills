---
name: frontend
description: Build and maintain production frontend interfaces using the project's actual framework, browser platform, design system, routing, data, accessibility, and validation conventions. Use for pages, components, forms, client state, data loading, rendering strategy, responsive behavior, and frontend integration; do not use for visual art direction alone or backend-only work.
---

# Frontend

Implement the requested user-visible behavior inside the existing product language, framework, design system, and browser targets. Own the engineering implementation, not visual art direction. When no new visual direction is supplied, preserve the current visual language instead of inventing a theme or redesigning adjacent screens.

## Establish The Contract

1. Inspect manifests, lockfiles, framework and bundler configuration, route definitions, entry points, shared components, tokens, data clients, tests, and browser support before editing.
2. Trace the complete user flow and its data contract. Identify the authoritative source for content, validation, permissions, navigation, and persistence.
3. Define only the states the flow can actually enter, including initial, loading, empty, partial, success, recoverable error, terminal error, offline, stale, unauthorized, or forbidden states when relevant.
4. State the changed behavior and the narrowest observable acceptance checks across supported viewport sizes, input methods, locales, rendering environments, and failure paths.
5. Verify current official documentation for the exact project versions before using framework APIs, browser features, configuration keys, or build behavior.

Do not turn an ordinary feature into a framework migration, design-system replacement, routing rewrite, state-library adoption, or broad cleanup.

## Prefer The Web Platform

Start with semantic HTML and native browser behavior. Use links for navigation, buttons for actions, native form controls where they satisfy the interaction, and document structure that remains meaningful before styling or scripting.

Use CSS for layout, responsiveness, presentation state, and supported interaction behavior before adding JavaScript. Follow the project's tokens and cascade strategy. Prefer content-driven layouts, intrinsic sizing, logical properties, fluid media, and component-level container queries where they solve the actual constraint.

Add client JavaScript only for behavior the platform baseline cannot provide or the product explicitly requires. Preserve a useful HTML baseline when the flow can reasonably submit, navigate, read, or recover without JavaScript. Choose static rendering, server rendering, server components, islands, or client rendering per route from content freshness, personalization, interactivity, infrastructure, and failure behavior. Hydrate the smallest interactive surface that meets the requirement.

Do not add a dependency when the installed stack or a stable browser API already solves the problem. Add one only for a demonstrated gap, compatible maintenance profile, acceptable client cost, and clear reduction in project complexity.

## Bound Components And State

Create components around stable behavior, data ownership, reuse, independent loading or error behavior, or a useful testing boundary. Do not split components merely by DOM depth or arbitrary line count, and do not accumulate unrelated responsibilities in a page-sized component.

Keep one authoritative source for each value. Derive computable values during rendering, keep shareable navigation state in the URL, leave remote data under the established server-state or route-data mechanism, and avoid mirroring props or responses into local state. Model mutually exclusive asynchronous states so impossible combinations cannot occur. Use effects only to synchronize with an external system, and always clean up requests, subscriptions, timers, and global listeners.

Use the router or framework data primitive when it already coordinates navigation, cancellation, errors, caching, and rendering. Start independent requests together, prevent stale responses from winning races, check failure status explicitly, and cache only with a defined freshness and invalidation contract.

Read [application mechanics](references/application.md) only when the change involves document semantics, CSS structure, responsive behavior, components, forms, routing, data flow, rendering, interface states, or internationalization.

## Render Product UI, Not Development Instructions

Every visible state must communicate the user's situation and available action in product language. Keep loading feedback proportional to expected delay, preserve layout where possible, use a skeleton only when the final structure is known, make empty states truthful, and give recoverable failures a real recovery path. Never expose stack traces, raw server errors, implementation notes, acceptance criteria, file paths, component names, prompts, placeholders, lorem ipsum, or instructions that compensate for a missing usable control.

Use the approved design or existing product patterns. In discretionary work, build the clearest content hierarchy from established primitives rather than defaulting to a generic dashboard shell. Do not introduce card grids for every section, decorative metric tiles, oversized hero copy, floating sidebars, pill navigation, arbitrary gradients, excessive rounded containers or shadows, fake charts, redundant icons, or status badges without domain meaning. Do not present invented data as production truth; connect the real contract, use explicitly authorized fixtures or demo data, or render an honest empty state.

## Apply Cross-Cutting Quality

Read [frontend quality](references/quality.md) only when the task affects accessibility, performance, security, browser APIs, tests, bundling, dependencies, or production validation.

Validate the smallest changed behavior first, then the relevant production build, types, linting, component or integration tests, and browser flow. Exercise keyboard operation, narrow and wide layouts, long and localized content, loading and failure behavior, back and forward navigation, and supported browsers when the change can affect them. Check for hydration mismatches, uncaught errors, unexpected requests, inaccessible names or focus, horizontal overflow, layout shifts, and stale updates.

## Final Audit

Reject the implementation if any applicable answer is no:

1. Does the interface complete the requested user flow with real data and truthful states?
2. Does the markup express the content and interaction before presentation details?
3. Is the layout robust to supported widths, content growth, text direction, zoom, and input methods?
4. Are component boundaries and state ownership simpler than the behavior they coordinate?
5. Is client JavaScript limited to the interactive surface that needs it?
6. Do navigation, forms, data loading, cancellation, errors, and recovery follow the installed framework's contracts?
7. Can keyboard and assistive-technology users perceive and operate the changed flow?
8. Are security, performance, bundle cost, tests, and production-build behavior proportionate and verified?
9. Is every visible element part of the product rather than a generic pattern, fake artifact, or developer-facing instruction?
