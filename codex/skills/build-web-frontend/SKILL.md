---
name: build-web-frontend
description: Build or change production web user interfaces. Use for pages, components, forms, client state, responsive layouts, accessibility, browser behavior, frontend performance, and interaction tests.
---

# Build Web Frontend

## Workflow

1. Inspect the framework, design system, routes, state model, browser support, tests, and existing visual patterns.
2. Define user tasks and states, including loading, empty, error, disabled, success, and interrupted flows.
3. Use semantic HTML and native controls first. Preserve keyboard access, focus order, visible focus, labels, names, roles, contrast, zoom, and reduced-motion preferences.
4. Build responsive layouts from content needs. Keep one source of truth for state and validate forms on both client and trusted server boundary.
5. Respect server and client boundaries, cancellation, stale responses, navigation, localization, and recovery from partial failure.
6. Avoid unnecessary dependencies and client work. Measure relevant Core Web Vitals before performance claims.
7. Verify behavior at representative viewport sizes with keyboard and browser checks. Add focused component, integration, and end-to-end tests according to risk.

Do not recreate an established design system or use ARIA to replace a suitable native element.

Read [frontend practices](references/practices.md) for accessibility and performance standards.
