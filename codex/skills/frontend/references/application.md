# Application Mechanics

Read only the sections that match the current change.

## Document And CSS Structure

- Choose elements by meaning and browser behavior. Preserve one logical heading hierarchy and landmark structure. Use lists for collections, tables for genuinely tabular relationships, links for destinations, and buttons for state-changing actions.
- Keep DOM source order meaningful. Do not use CSS visual reordering to create a reading or focus order that differs from the interface.
- Prefer native controls and attributes before recreating behavior. If a custom composite widget is necessary, implement its complete keyboard, focus, name, role, state, and value contract.
- Follow the existing CSS organization. Keep selectors locally comprehensible, specificity low, and override order intentional. Use cascade layers only when the project has or needs a clear precedence boundary.
- Reuse established tokens for semantic color, typography, spacing, elevation, motion, and breakpoints. Add a token only for a recurring semantic decision, not to hide a one-off value.
- Use logical sizing, margin, padding, borders, and alignment so writing direction does not require a parallel stylesheet.
- Let content define breakpoints. Prefer grid, flexbox, intrinsic sizing, `min()`, `max()`, `clamp()`, and wrapping over device-name breakpoints. Use container queries when a reusable component adapts to its allocated space, and viewport queries when the page composition depends on the viewport.
- Provide responsive images with correct intrinsic dimensions, source selection, cropping intent, and alternative text. Do not download desktop media merely to hide or shrink it on small screens.

## Components And State

- Give a component one coherent reason to change. Keep data orchestration near the route or feature boundary and presentational composition near the content it renders.
- Prefer explicit inputs and events over hidden global coupling. Share state at the nearest common owner. Introduce context or a store only when many separated consumers need the same long-lived state and ordinary composition becomes materially worse.
- Store the minimum state needed to reconstruct the interface. Derive labels, filtered collections, totals, validation summaries, and selected objects from canonical inputs rather than synchronizing duplicates.
- Represent mutually exclusive statuses with one discriminated state instead of independent booleans. Preserve stable identifiers across updates and do not use collection position as identity when order can change.
- Do not use an effect for pure derivation, event handling, or data already provided by the route or server layer. When an effect synchronizes an external system, define its lifetime, dependencies, cleanup, and race behavior.

## Forms

- Start with a real `form`, submit control, labels, names, correct input types, `autocomplete`, `inputmode`, constraints, and a server-capable action where the architecture permits.
- Validate on the server or trusted boundary regardless of client validation. Use client validation to shorten feedback, not as the authority.
- Keep entered values after a failed submission. Associate each error with its field, summarize errors when the form is long, move focus only when it improves recovery, and avoid announcing the same error repeatedly.
- Prevent duplicate submission while preserving an understandable pending state. Do not permanently disable a valid action because an optional client enhancement failed.
- Ask only for required information. Do not impose culturally narrow assumptions about names, addresses, dates, numbers, or text length.

## Routing And Data

- Give durable, shareable views durable URLs. Encode filters, search, pagination, tabs, or selections in the URL when users should bookmark, share, refresh, or revisit them.
- Preserve deep linking, refresh, back and forward navigation, scroll behavior, document titles, and focus after route changes. Do not replace a real link with a click handler.
- Fetch at the highest route or server boundary that knows the requirement and can coordinate dependent UI. Avoid leaf-level request waterfalls when the router or rendering layer can start work earlier.
- Start independent requests concurrently. Sequence only real dependencies. Abort obsolete requests or make results ignorable, and ensure older responses cannot overwrite newer intent.
- Distinguish transport failure, non-success status, invalid payload, empty result, stale data, and authorization failure. Map internal errors to safe product messages while retaining diagnostic detail in the established observability path.
- Use the project's established cache. Define owner, key, freshness, invalidation, mutation reconciliation, and stale behavior before adding another cache.

## Rendering And Interface States

- Prefer static HTML for stable public content, server rendering for request-time content, isolated islands for sparse interactivity, and client rendering for experiences whose value genuinely depends on sustained local interaction. Hybrid choices may differ by route.
- Keep secrets, privileged data access, and server-only libraries outside the client graph. Pass only serializable data across server and client boundaries.
- Place loading and error boundaries around coherent user tasks. A boundary should preserve already useful content and avoid making unrelated regions wait or disappear.
- Use a skeleton only when its geometry matches predictable content. Reserve space for media and asynchronous regions. Prefer existing content plus localized pending feedback over blanking the screen.
- An empty state states what is empty and, when valid, the next user action. An error state distinguishes retryable from terminal failure. A permission state does not imply that missing authorization is a transient loading problem.

## Internationalization

- Use the project's message system and `Intl` APIs for locale-sensitive dates, times, numbers, currencies, plural rules, lists, and relative time. Do not assemble translatable sentences from fragments.
- Declare document and content language. Support text expansion, multi-line controls, long unbroken content, variable numeral widths, and right-to-left direction.
- When multiple locales are supported, keep locale choice user-controllable. Do not use a country flag as a language identifier or assume locale, currency, time zone, and country are interchangeable.
