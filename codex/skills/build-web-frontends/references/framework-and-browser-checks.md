# Framework and Browser Checks

Read only the sections relevant to the current change. Follow the repository's supported framework version and established conventions over generic preferences.

## React

- Keep render logic pure. Use effects to synchronize with external systems, not to derive render data or mirror props into state.
- Preserve hook ordering and component identity. Use stable semantic keys, and clean up subscriptions, observers, timers, and requests.
- Keep controlled and uncontrolled ownership consistent across a form control's lifetime.
- Follow the project's established client, server-component, Suspense, routing, and data-cache boundaries. Do not move code across them without a verified requirement.
- Add memoization only after identifying repeated expensive work or identity-sensitive consumers.

## Vue

- Follow the repository's Options API or Composition API convention. Do not migrate component style incidentally.
- Use computed values for derivation and watchers for side effects. Scope and clean up watchers, event listeners, and asynchronous work.
- Preserve reactive access through the project's established `ref`, `reactive`, store, and composable patterns.
- Keep props read-only and emit explicit domain events instead of mutating parent-owned state indirectly.
- Use stable keys and preserve component identity when collections change.

## Svelte

- Use syntax and reactivity supported by the repository's Svelte version. Do not mix legacy and current patterns without an existing precedent.
- Derive values through the established reactive primitives. Reserve effects for external synchronization and clean up every subscription or listener.
- Keep writable state local when possible. Use context or stores only when ownership genuinely spans component boundaries.
- Preserve keyed identity for reorderable collections and guard browser-only APIs during server rendering.

## Plain Web Projects

- Prefer semantic HTML, CSS layout, and small ES modules. Use progressive enhancement when the existing application supports it.
- Keep event delegation and DOM ownership explicit. Remove listeners and observers when their owning view is destroyed.
- Use `textContent` or escaping template behavior for untrusted text. Sanitize only when trusted product requirements allow authored HTML.
- Introduce custom elements, a framework, or a state library only when the repository already uses them or the request establishes a demonstrated need.

## Accessibility

- Prefer native elements and semantics. Add ARIA only when native HTML cannot express the required role, name, state, or relationship.
- Ensure every interactive element has an accessible name and keyboard behavior equivalent to pointer behavior.
- Associate labels, instructions, and errors with their controls. Announce meaningful asynchronous status changes without creating noisy live regions.
- Move focus only after a deliberate context change such as opening a dialog, completing navigation, or surfacing a blocking validation error. Restore it when a temporary surface closes.
- Preserve visible focus, sufficient non-color cues, logical reading order, zoom and text reflow, reduced motion, and usable controls at supported viewport sizes.
- Test with the keyboard and the browser accessibility tree. Use the project's accessibility checker when configured, but do not add a new tool solely for the change.

## Data and Browser Security

- Treat API responses as untrusted at the rendering boundary. Validate assumptions before dereferencing data and render failures explicitly.
- Never ship server secrets, private credentials, or authorization decisions to the client. Follow the existing authentication, cookie, CSRF, and content-security contracts.
- Validate user-controlled navigation targets, message origins, file metadata, and storage data before use.
- Avoid raw HTML injection. When product requirements require rich HTML, use the repository's vetted sanitizer and test unsafe input.
- Prevent stale requests from replacing newer results. Abort work or compare request identity according to the project's data client.

## Focused Tests

- Prefer queries by role, name, label, text, and visible state. Avoid selectors tied to component internals or styling unless styling is the contract.
- Test interactions from the user's boundary, including keyboard input, validation, pending state, success, and material failure recovery.
- Mock at stable external boundaries. Do not mock the component behavior under test or duplicate framework internals.
- Use browser tests for navigation, focus management, responsive interaction, real rendering, and integrations that component tests cannot establish reliably.
- Keep snapshots narrow and intentional. Prefer explicit behavioral assertions for dynamic interfaces.
