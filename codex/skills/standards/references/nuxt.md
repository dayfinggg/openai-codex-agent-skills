# Nuxt 4 quality reference

Use this as a practical baseline for Nuxt 4.x applications.
Treat the repository's Nuxt version, `nuxt.config.ts`, modules, deployment target, tests, and local conventions as the binding contract.
Apply [vue.md](vue.md) for Vue component and reactivity rules, and apply the separate web-ui and TypeScript standards for generic concerns.
This reference follows the Nuxt 4.x documentation observed on 2026-08-30; verify installed versions before using version-gated APIs.

## Nuxt architecture

- Use Nuxt as the full-stack Vue framework when the application needs convention-based routing, SSR, server handlers, or hybrid delivery. [N1]
- Keep the default universal rendering choice unless product requirements justify SPA, prerendered, or hybrid routes.
- Treat Nitro as the server engine and keep its request and deployment concerns separate from Vue component code. [N1]
- Use file-based routing, code splitting, auto-imports, and Nuxt data primitives instead of rebuilding those mechanisms locally.
- Keep pages thin: a page coordinates route inputs, layout, data, and feature components rather than becoming a second service layer.
- Keep `nuxt.config.ts`, `public/`, `server/`, `shared/`, `layers/`, `modules/`, and generated output at the project root.
- Use the Nuxt 4 `app/` directory as the default source directory for application code. [N2]

## Directory ownership

- Put route pages in `app/pages/`; let file names express URL ownership and keep route-specific orchestration there.
- Put reusable UI in `app/components/`; Nuxt auto-imports components and derives names from paths, so name files consistently. [N3]
- Put Vue composables in `app/composables/` and pure helpers in `app/utils/`; keep their runtime context requirements explicit.
- Put layout shells in `app/layouts/`, route middleware in `app/middleware/`, and app plugins in `app/plugins/`.
- Put build-processed assets in `app/assets/` and directly served immutable files in `public/`.
- Put API handlers, server routes, server middleware, and server utilities in `server/`; define handlers with the Nitro server API. [N6]
- Put code shared by the app and Nitro in `shared/`, and keep it free of browser-only and server-only imports. [N2]
- Use `layers/` for a deliberately reusable application layer, theme, or domain package, not as a second arbitrary source tree. [N11]
- Keep `.nuxt/` and `.output/` generated and ignored; never edit generated files as a source of truth.
- Keep tests in the repository's established locations and separate unit, Nuxt-runtime, and end-to-end environments. [N10]

## Auto-imports and context

- Nuxt auto-imports Vue APIs, components, composables, utilities, and configured module exports while preserving generated typings and tree-shaking. [N3]
- Use auto-imports for conventional local code and use explicit `#imports` or `#components` imports when a dependency boundary or ambiguous name needs to be visible.
- Name local composables descriptively and keep their implementation in `app/composables/` so discovery remains predictable.
- Call Nuxt composables synchronously from setup, plugins, or route middleware; do not call context-dependent APIs at module evaluation time. [N3]
- Do not place `useRuntimeConfig`, `useRoute`, `useFetch`, or another context-dependent call in a top-level exported constant.
- Treat app and Nitro auto-imports as separate contexts even when their names look similar.
- Do not import app components, composables, or app-only utilities into `server/` code, and do not import server-only code into the app. [N6]

## Rendering and hydration

- Nuxt uses universal rendering by default and supports client-only rendering, prerendering, route rules, hybrid caching, and edge deployment. [N4]
- Select `ssr: false` only for genuinely client-only routes; use route rules for intentional per-route prerendering, caching, or hybrid rendering.
- Assume setup and render code can run on the server and again in the browser during hydration.
- Guard `window`, `document`, `localStorage`, layout measurement, and other browser APIs with `import.meta.client` or a client lifecycle hook.
- Use `import.meta.server` for server-only work and `.client` or `.server` suffixes when a file has one fixed environment. [N5]
- Use `onMounted` for client-only effects and clean up listeners, observers, and timers when the component unmounts.
- Do not start cleanup-dependent timers or subscriptions in root setup code that also runs during SSR. [N5]
- Keep server and client renders deterministic; do not render unseeded random values, current time, or client-localized values in SSR markup.
- Avoid invalid HTML nesting because browser parsing can change the DOM before hydration.
- Use `<ClientOnly>` or a `.client.vue` component for widgets that cannot render meaningful server markup.
- Treat hydration mismatch warnings as defects and fix the differing data, markup, or timing instead of hiding the warning.
- Remember that route middleware and pages can run on both server and client, so keep environment-specific work explicitly guarded. [N5]

## State and request isolation

- Use `useState` for small Nuxt-shared state that must survive SSR into hydration; keep its value JSON-serializable. [N9]
- Never export `const state = ref()` from module scope in an SSR application because requests can share that object.
- Create per-request state in Nuxt context or use a store designed for SSR isolation.
- Use Pinia when domain state needs explicit actions, plugins, devtools, or cross-feature coordination, following the Vue state boundary in [vue.md](vue.md).
- Keep server data, URL state, form state, and ephemeral UI state separate so each has an appropriate lifetime.
- Persist state only through an explicit cookie or client-storage boundary and guard browser-only storage access.
- Do not put classes, functions, symbols, or other non-serializable values in `useState` without a deliberate payload serializer. [N9]
- Keep user-specific state out of shared prerendered responses and shared caches unless the isolation policy is explicit.

## Data fetching

- Use `$fetch` for event-driven mutations, browser-only interactions, and server code that needs a direct request.
- Use `useFetch` for a URL-based request in setup, a plugin, or route middleware; it wraps `$fetch` and carries SSR data through the Nuxt payload. [N7]
- Use `useAsyncData` when the source is an arbitrary async function, a third-party client, or a multi-step query. [N8]
- Do not use `useFetch` as a replacement for `$fetch` inside a click handler or another post-mount event.
- Keep `useAsyncData` handlers side-effect free and return a truthy value so SSR and client hydration remain predictable. [N8]
- Use an explicit stable key when data is shared, wrapped by a custom composable, or invalidated from another component.
- Keep `deep`, `transform`, `pick`, `default`, and cache options compatible across calls that share a key.
- Use reactive URLs, keys, or `watch` sources for refetching; set `watch: false` when a reactive option must not trigger a request.
- Pass the provided abort signal to `$fetch` or another cancellable client so navigation and deduplication can stop stale work. [N8]
- Use `lazy: true` when navigation should not wait for non-critical data, and render an explicit pending state.
- Use `server: false` only when data is intentionally client-only, and handle the initial undefined or pending state.
- Use `pick` or `transform` to reduce serialized payload fields, while remembering that the upstream request still fetches its original response.
- Use `status` and `error` to render loading, success, and failure states rather than inferring status from `data` alone.
- Use `refresh`, `execute`, `clear`, and `useNuxtData` for explicit invalidation and cached-data coordination. [N8][N12]
- Avoid request waterfalls by starting independent fetches together and placing dependent fetches behind the actual dependency.
- Validate and normalize route parameters, query values, request bodies, and external responses at their boundaries.
- Keep credentials and private runtime configuration on the server; expose only intentionally public values to the client.

## Server boundaries

- Put HTTP API handlers under `server/api/`, route handlers under `server/routes/`, and cross-request middleware under `server/middleware/`.
- Export handlers with `defineEventHandler` or its supported alias and return a response or promise through the Nitro contract. [N6]
- Keep authentication, authorization, parsing, validation, serialization, and error mapping at the server boundary.
- Keep server middleware from returning a response accidentally when it is intended only to enrich the request context. [N5]
- Put reusable server-only helpers in `server/utils/` and shared app/server helpers in `shared/`.
- Do not use app auto-imports as a reason to cross the app and Nitro boundary.

## Performance and delivery

- Prefer SSR or prerendering for content that must appear quickly or be indexed, and use client-only delivery for private tools that need it.
- Keep route payloads small with `pick`, `transform`, `lazy`, and client-only boundaries when the full response is not needed in HTML.
- Lazy-load non-critical route features and components, and confirm the resulting network waterfall in a production build.
- Use route rules for intentional prerendering, stale-while-revalidate, ISR, redirects, headers, or client-only route sections. [N4]
- Profile hydration cost, JavaScript bundles, server response time, and largest content element on representative devices.
- Do not add global caches, custom fetch wrappers, or hydration tricks without a measured problem and an invalidation plan.
- Prefer Nuxt primitives over one-line wrappers that hide whether a request is server-safe, cached, lazy, or client-only.

## Testing

- Use `@nuxt/test-utils` for tests that need auto-imports, plugins, async setup, server routes, or a Nuxt runtime. [N10]
- Keep fast pure unit tests in a plain Node environment and isolate Nuxt-runtime tests in their configured environment.
- Use `@vue/test-utils` for components that do not require Nuxt context and use Nuxt helpers when context is part of the behavior.
- Use browser-based end-to-end tests for navigation, routing, hydration, public assets, and request handling across pages.
- Assert loading, empty, error, retry, cancellation, and success states for asynchronous UI.
- Reset stores, global Nuxt state, mocks, timers, and browser storage between tests.
- Include an SSR or hydration regression test whenever a change touches platform APIs, payload serialization, initial markup, or route rules.
- Exercise the official Nuxt examples when a framework behavior is unclear instead of copying an unverified community pattern. [E1]

## Abstraction timing

- Begin with the smallest Nuxt primitive that makes ownership and execution context obvious.
- Extract a custom composable only when it preserves the underlying Nuxt context and has a coherent current caller.
- Do not wrap `useFetch` or `useAsyncData` with a generic helper that hides keys, options, errors, or cancellation.
- Introduce a layer or module only when code is intentionally reusable across applications or teams.
- Keep feature-specific server handlers and app components close to their owning feature until reuse proves a wider boundary.
- Prefer explicit domain names over generic `Base`, `Common`, or `Manager` buckets that hide ownership.
- Delete an abstraction when it adds indirection, context coupling, or component instances without reducing repeated complexity.

## Review checklist

- Can a reader identify the app, server, state, data, rendering, and test owner for every changed behavior?
- Does the code behave correctly on the server, during hydration, and after client navigation?
- Are Nuxt composables called in a valid context and are app and Nitro imports kept separate?
- Are payload size, caching, cancellation, errors, and request isolation explicit?
- Does the production build use the intended route rules and delivery mode?
- Did the change preserve a small public surface and avoid a wrapper that hides Nuxt semantics?

## Sources

### Official Nuxt documentation

- [N1: Nuxt 4 Introduction](https://nuxt.com/docs/4.x/getting-started/introduction)
- [N2: Nuxt 4 Upgrade and Directory Structure](https://nuxt.com/docs/4.x/getting-started/upgrade)
- [N3: Nuxt 4 Auto-imports](https://nuxt.com/docs/4.x/guide/concepts/auto-imports)
- [N4: Nuxt 4 Rendering Modes](https://nuxt.com/docs/4.x/guide/concepts/rendering)
- [N6: Nuxt 4 Server Directory](https://nuxt.com/docs/4.x/directory-structure/server)
- [N10: Nuxt 4 Testing](https://nuxt.com/docs/4.x/getting-started/testing)
- [N11: Nuxt 4 Layers](https://nuxt.com/docs/4.x/directory-structure/layers)

### Maintainer source and examples

- [N5: Nuxt Lifecycle source](https://github.com/nuxt/nuxt/blob/main/docs/3.guide/1.concepts/2.nuxt-lifecycle.md)
- [N7: Nuxt 4 `useFetch` source documentation](https://github.com/nuxt/nuxt/blob/main/docs/4.api/2.composables/use-fetch.md)
- [N8: Nuxt 4 `useAsyncData` source documentation](https://github.com/nuxt/nuxt/blob/main/docs/4.api/2.composables/use-async-data.md)
- [N9: Nuxt 4 `useState` source documentation](https://github.com/nuxt/nuxt/blob/main/docs/4.api/2.composables/use-state.md)
- [N12: Nuxt 4 `useNuxtData` source documentation](https://github.com/nuxt/nuxt/blob/main/docs/4.api/2.composables/use-nuxt-data.md)
- [E1: Official Nuxt Examples repository](https://github.com/nuxt/examples)

### Practitioner talk

- [T1: Alexander Lichter, “The Art of Rendering Modes”](https://www.lichter.io/speaking/2023-10-26-rendering-modes-front-end-focus/)
