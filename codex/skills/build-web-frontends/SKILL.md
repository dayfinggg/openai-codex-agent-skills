---
name: build-web-frontends
description: "Implement browser UI in its existing stack: components, state, forms, accessibility, and tests. Preserve fixed designs; pair with $engineer-production-code and use $design-product-interfaces for open design."
---

# Build Web Frontends

Implement complete browser behavior within the existing product and repository contracts. Own implementation and verification in the repository's browser stack. Combine this workflow with `$engineer-production-code` and an applicable language or framework skill when available.

## Establish the Frontend Contract

- Inspect applicable instructions, package manifests, framework and runtime versions, nearby features, routes, API clients, styling primitives, tests, and configured quality tools.
- Determine the design authority before coding. Treat a complete supplied design or design-system specification as the implementation contract without reinterpreting its visual direction. Load `$design-product-interfaces` when product UX, information architecture, art direction, visual direction, or design specifications remain unresolved, then implement its decisions here.
- Reuse the closest established component, state, data-access, and testing patterns unless they are the source of the defect.
- Identify the affected user journey, supported rendering mode, browser targets, responsive states, design-system constraints, and observable acceptance conditions.
- Verify backend and data contracts from repository evidence. Do not invent endpoints, fields, permissions, or server behavior.
- Read [framework-and-browser-checks.md](references/framework-and-browser-checks.md) when framework semantics, accessibility, browser security, or interaction details are material.

## Define Boundaries

- Give each component one cohesive UI responsibility. Prefer composition and existing primitives over broad configurable components or new abstraction layers.
- Keep state at the narrowest owner that needs it. Derive values instead of synchronizing copies, and place server, URL, form, and persistent state in their established project layers.
- Add shared context, stores, hooks, composables, actions, or utilities only for proven cross-component behavior.
- Keep side effects at explicit integration boundaries. Clean up subscriptions and listeners, and prevent obsolete asynchronous work from overwriting newer state.
- Preserve the current framework, styling approach, design tokens, component library, routing, and data client unless the request explicitly changes them.

## Implement Complete Interaction

- Implement normal, loading, empty, error, success, disabled, and submitting states that the flow can reach. Keep transitions deterministic and preserve useful user input after recoverable failures.
- Use semantic elements and native browser behavior first. Provide accessible names, keyboard operation, visible focus, programmatic error associations, and deliberate focus movement where context changes.
- Build forms around the repository's validation and submission contracts. Prevent unintended duplicate submissions, distinguish field errors from request failures, and never rely on client validation for server trust.
- Use the established API layer. Handle cancellation or stale responses, authentication and permission failures, malformed data, and retry behavior according to request safety.
- Keep secrets and privileged decisions out of browser code. Treat URLs, storage, messages, uploaded content, and rendered markup as trust boundaries.
- Preserve the visual language. Extend existing components and tokens rather than introducing a new UI library or making unsolicited visual-design decisions.
- Support existing breakpoints, input methods, text expansion, reduced-motion preferences, and narrow viewports without hiding required actions or information.

## Protect Rendering Quality

- Keep render output deterministic across server rendering, hydration, and client updates when the project uses them.
- Optimize measured or evident bottlenecks. Fix excessive work, unstable identity, oversized payloads, layout shifts, or unnecessary network requests before adding memoization, virtualization, or caching.
- Keep list identity stable and preserve user state through updates. Avoid index keys when ordering or membership can change.
- Follow the project's code-splitting, asset, image, font, and cache conventions. Do not add performance machinery without a demonstrated benefit.

## Verify User Behavior

- Add focused component or browser tests using the repository's existing tools. Assert behavior through roles, labels, visible state, navigation, and network outcomes rather than private implementation details.
- Cover the changed happy path and material empty, error, permission, validation, cancellation, or race cases.
- Exercise the affected flow in a browser when available. Check keyboard-only operation, focus order, responsive layouts, console errors, failed requests, and loading and failure states.
- Run the narrow formatter, linter, type checker, tests, and build relevant to the change. Broaden checks only when the affected surface justifies it.
- Inspect the final diff for framework drift, duplicated state, inaccessible interaction, unhandled UI states, embedded secrets, speculative abstractions, and unrelated visual changes.
- Report backend limitations as boundaries. Do not simulate missing server behavior in production frontend code.
