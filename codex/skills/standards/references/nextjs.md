# Next.js standards

This reference covers the current Next.js App Router and its React Server Component model.
Check the installed Next.js version because caching, prerendering, and server-function defaults evolve.
- Next.js is a React framework for full-stack applications; the App Router is the newer router while the Pages Router remains supported. [Next.js documentation](https://nextjs.org/docs)

## Architectural model

- Model the application as nested route segments with layouts, pages, loading UI, errors, and route handlers.
- The `app` directory defines App Router segments, and `src/app` is an optional location for the same code. [Project structure](https://github.com/vercel/next.js/blob/canary/docs/01-app/01-getting-started/02-project-structure.mdx?plain=1)
- A folder becomes a public route only when it contains a `page` or `route` file, so route-local implementation files can be colocated safely. [Project structure](https://github.com/vercel/next.js/blob/canary/docs/01-app/01-getting-started/02-project-structure.mdx?plain=1)
- Use layouts for stable shared UI and pages for route-specific composition; keep the route tree aligned with user-visible navigation.
- In the App Router, layouts and pages are Server Components by default. [Server and Client Components](https://github.com/vercel/next.js/blob/canary/docs/01-app/01-getting-started/05-server-and-client-components.mdx)
- Think of a route as a composition of server-rendered content, client islands, data dependencies, and Suspense boundaries.
- Client and server rendering are not mutually exclusive; Client Components can be prerendered on the first load and hydrated in the browser. [Server and Client Components](https://github.com/vercel/next.js/blob/canary/docs/01-app/01-getting-started/05-server-and-client-components.mdx)
- Treat the RSC payload, HTML, and client JavaScript as separate delivery products with separate size and latency budgets.
- Use the versioned Next.js docs as the authority for framework behavior, and use conceptual talks only to explain the model. [React Conf RSC talk](https://conf2024.react.dev/talks/16)

## Server and client boundaries

- Use Server Components for secure data access, secrets, static or SEO-sensitive markup, and reducing browser JavaScript.
- Use Client Components only for state, event handlers, Effects, browser APIs, or custom Hooks.
- Put `'use client'` at the smallest client entry point instead of marking a whole page or layout client-side. [Server and Client Components](https://github.com/vercel/next.js/blob/canary/docs/01-app/01-getting-started/05-server-and-client-components.mdx)
- A `'use client'` entry point includes its imported client module graph in the browser bundle, so review every dependency it pulls across the boundary.
- Props crossing the boundary must be serializable; pass IDs, data objects, or rendered children rather than live server objects or ordinary functions.
- Compose a Client Component inside a Server Component, and pass server-rendered children when the interactive shell should not own the content.
- Keep providers as deep as practical so static ancestors remain optimizable. [Server and Client Components](https://github.com/vercel/next.js/blob/canary/docs/01-app/01-getting-started/05-server-and-client-components.mdx)
- Context is not available directly in Server Components; expose it through a small Client Component provider.
- Mark server-only data modules with `server-only` when accidental client imports could expose secrets or Node-only code.
- Keep browser-only modules behind a Client Component boundary and avoid reading `window`, `document`, or storage during server rendering.
- Keep boundary props stable and narrow because the boundary is an API with serialization, bundle, and hydration costs.
- Vercel's guidance recommends client components at the leaves, not as a default wrapper for the entire page tree. [Vercel performance guide](https://vercel.com/blog/guide-to-fast-websites-with-next-js-tips-for-maximizing-server-speeds)

## Data fetching and caching

- Fetch from a Server Component when the data source is reachable securely on the server and does not require browser-only state. [Fetching data](https://github.com/vercel/next.js/blob/canary/docs/01-app/01-getting-started/06-fetching-data.mdx)
- Keep a query near the component that renders its result rather than centralizing all route data in one page function.
- The current fetching guide memoizes identical `fetch` calls within a React tree, but request caching is a separate choice. [Fetching data](https://github.com/vercel/next.js/blob/canary/docs/01-app/01-getting-started/06-fetching-data.mdx)
- Choose freshness explicitly and document the lifetime, invalidation, and authorization rules for cached data.
- With Cache Components enabled, use `use cache` and a cache lifetime for stable data, and use `Suspense` to stream fresh uncached data. [Caching](https://github.com/vercel/next.js/blob/canary/docs/01-app/01-getting-started/08-caching.mdx)
- If the installed version uses a previous caching model, follow that version's documented revalidation and opt-out APIs rather than assuming `use cache` is available.
- Start independent requests before awaiting them and use `Promise.all` when one failure should fail the group. [Fetching data](https://github.com/vercel/next.js/blob/canary/docs/01-app/01-getting-started/06-fetching-data.mdx)
- Use `Promise.allSettled` when independent panels can render separate success and failure states.
- Use `React.cache` for per-request reuse of a data function when several Server Components need the same result.
- Do not call a Route Handler from a Server Component when direct server data access is available; avoid the extra HTTP hop. [Production checklist](https://github.com/vercel/next.js/blob/canary/docs/01-app/02-guides/production-checklist.mdx?plain=1)
- Fetch in a Client Component only when the browser needs live refetching, user-driven queries, browser credentials, or a client cache.
- Pass a server-created promise to a Client Component and read it with React's `use` API when streaming data across the boundary is useful.
- Use a maintained client cache such as SWR or TanStack Query for client revalidation, deduplication, optimistic updates, and live data.
- Authenticate and authorize every server data read and Server Action at the data boundary, not only in a layout, page, or client check. [Production checklist](https://github.com/vercel/next.js/blob/canary/docs/01-app/02-guides/production-checklist.mdx?plain=1)
- Do not copy server data into unrelated local state unless the copy has an independent editing or snapshot lifecycle.

## Rendering, navigation, and streaming

- Next.js can prerender static output, render request-time content, and stream unresolved subtrees; verify which mode the production build produces.
- With Cache Components, design a static shell for immediate content and place runtime or uncached reads behind Suspense. [Rendering philosophy](https://github.com/vercel/next.js/blob/canary/docs/01-app/02-guides/rendering-philosophy.mdx?plain=1)
- Use `loading.tsx` for a route-segment fallback and `<Suspense>` for a smaller data or component boundary.
- Put a boundary around slow independent work so fast navigation and useful content are not blocked.
- Make loading UI meaningful and geometrically close to the final UI so users understand progress and layout shift stays low.
- Layouts are shared and can remain mounted across navigation; do not put request-specific or expensive work in a broad layout without evidence.
- Use route groups such as `(marketing)` to organize segments or scope a layout and loading policy without changing the URL. [Project structure](https://github.com/vercel/next.js/blob/canary/docs/01-app/01-getting-started/02-project-structure.mdx?plain=1)
- Use `<Link>` for normal internal navigation so Next.js can prefetch and transition between routes efficiently. [Production checklist](https://github.com/vercel/next.js/blob/canary/docs/01-app/02-guides/production-checklist.mdx?plain=1)
- Preserve interruptible navigation by allowing fallback UI to appear before slow route data resolves.
- Remember that a first load can include HTML, an RSC payload, and hydrated Client Components, while later navigation primarily uses the RSC payload and client code.
- Run `next build` and `next start` to catch prerender failures and measure behavior outside development mode.

## Accessibility

- Use semantic HTML and native controls before adding ARIA; a native button carries keyboard behavior that a clickable `div` does not. [Next.js accessibility](https://nextjs.org/docs/architecture/accessibility)
- Give every form control an accessible name through a visible label or a correctly associated `htmlFor` and `id`.
- Provide meaningful image alternatives, clear headings, landmarks, and descriptive link text in route output.
- Ensure custom controls are reachable and operable with keyboard focus, visible focus indicators, and expected key bindings.
- Manage focus when dialogs, menus, conditional content, and client navigation would otherwise disorient users.
- Give each route a unique descriptive title and useful first heading because Next.js uses them for route announcements. [Next.js accessibility](https://nextjs.org/docs/architecture/accessibility)
- Expose validation, loading, status, and server errors to assistive technology instead of relying only on color, motion, or position.
- Check color contrast and honor `prefers-reduced-motion` for animated route and loading states.
- Use ARIA patterns only with the keyboard behavior and state semantics required by the pattern. [WAI-ARIA APG](https://www.w3.org/WAI/ARIA/apg/)
- Run `eslint-plugin-jsx-a11y`, keyboard checks, and representative screen-reader flows; automated lint is not proof of usable interaction.

## Performance and production

- Set budgets for LCP, INP, CLS, response time, RSC payload size, and client JavaScript before optimizing.
- Keep Client Components and third-party dependencies out of broad module graphs to reduce download, parse, and hydration work. [Vercel performance guide](https://vercel.com/blog/guide-to-fast-websites-with-next-js-tips-for-maximizing-server-speeds)
- Lazy-load heavy Client Components and libraries that are not needed for the initial interaction. [Next.js lazy loading](https://github.com/vercel/next.js/blob/canary/docs/01-app/02-guides/lazy-loading.mdx?plain=1)
- Use the Image, Font, and Script components when they solve sizing, font delivery, or third-party scheduling problems. [Production checklist](https://github.com/vercel/next.js/blob/canary/docs/01-app/02-guides/production-checklist.mdx?plain=1)
- Avoid loading analytics, chat, maps, editors, and other heavy third-party code in the initial route unless the product requires it immediately.
- Parallelize independent server work and stream slow sections instead of creating request waterfalls.
- Prefer local state and narrow client boundaries before adding memoization or a global state library.
- Measure with production builds, representative devices, and throttled network conditions because development and desktop results mislead. [Vercel performance guide](https://vercel.com/blog/guide-to-fast-websites-with-next-js-tips-for-maximizing-server-speeds)
- Use React DevTools, browser performance tools, route output, and bundle analysis to locate the actual bottleneck.
- Treat `next build` output and field Core Web Vitals as evidence for rendering and dependency decisions. [Production checklist](https://github.com/vercel/next.js/blob/canary/docs/01-app/02-guides/production-checklist.mdx?plain=1)
- Keep image dimensions, skeleton geometry, and font loading stable to prevent layout shift.
- Remove unused dependencies and code before introducing a performance abstraction or framework plugin.

## File organization

- Use `layout`, `page`, `loading`, `error`, `not-found`, and `route` files only for their documented route responsibilities. [Project structure](https://github.com/vercel/next.js/blob/canary/docs/01-app/01-getting-started/02-project-structure.mdx?plain=1)
- Colocate route-specific components, tests, styles, and data helpers when that keeps ownership clear; non-special files are not automatically routes.
- Use private folders such as `_components` for explicit implementation details and route groups such as `(shop)` for organization without URL changes.
- Keep shared `components`, `lib`, `hooks`, and `styles` directories only for genuinely cross-feature code; their names have no framework significance.
- Prefer feature-first organization when a route, its state, data, and tests usually change together.
- Keep a server-only data access layer separate from browser-facing UI modules and mark it with `server-only` when appropriate.
- Keep dependencies directed from shared primitives to features and routes, not between unrelated routes.
- Put tests in a colocated App Router folder or a root `__tests__` tree according to discovery and ownership needs. [Next.js Jest example](https://github.com/vercel/next.js/tree/canary/examples/with-jest)
- Do not create a maximal directory hierarchy before the application has the concepts that need those folders.
- Keep route files thin enough to show composition, data ownership, and boundary placement without hiding them behind generic wrappers.

## Testing

- Use unit tests for pure data transformations, reducers, validators, and server helpers.
- Use component tests for Client Component rendering, interactions, callbacks, context, and accessible output.
- Use integration tests for several units working through providers, caches, Server Actions, or data adapters.
- Use Playwright or another browser runner for navigation, forms, hydration, streaming, focus, and critical user journeys. [Next.js Playwright example](https://github.com/vercel/next.js/tree/canary/examples/with-playwright)
- Next.js notes that async Server Components are not fully supported by common unit runners, so prefer end-to-end coverage for them. [Next.js testing guide](https://github.com/vercel/next.js/blob/canary/docs/01-app/02-guides/testing/index.mdx?plain=1)
- Test the production build when behavior depends on prerendering, RSC payloads, route handlers, or runtime data.
- Assert user-visible roles, labels, text, URLs, and outcomes instead of private component state or implementation details.
- Cover loading, empty, error, unauthorized, slow, and recovery states for every data-dependent route.
- Include keyboard and route-announcement checks for custom navigation and interactive components.
- Keep tests close to their owning route or feature, and use the official examples as setup references instead of stale snippets. [Next.js Jest example](https://github.com/vercel/next.js/tree/canary/examples/with-jest) [Next.js Playwright example](https://github.com/vercel/next.js/tree/canary/examples/with-playwright)
- Run lint, type checking, focused tests, accessibility checks, `next build`, and a production-like smoke test before shipping a boundary change.

## Change discipline

- Add a route group, provider, data abstraction, or client boundary only when it solves a current URL, ownership, performance, security, or testing problem.
- Prefer the framework's special files and composition patterns over wrappers that merely forward props.
- Keep a cache policy close to the data it governs and record its freshness and invalidation assumptions.
- Keep client boundaries narrow until a measured interaction or shared behavior justifies moving them upward.
- Revisit route and module boundaries after real usage exposes repeated change, slow builds, awkward tests, or duplicated policy.

## Sources

### Official Next.js and React documentation

- [Next.js documentation](https://nextjs.org/docs)
- [Next.js project structure](https://github.com/vercel/next.js/blob/canary/docs/01-app/01-getting-started/02-project-structure.mdx?plain=1)
- [Next.js Server and Client Components](https://github.com/vercel/next.js/blob/canary/docs/01-app/01-getting-started/05-server-and-client-components.mdx)
- [Next.js fetching data](https://github.com/vercel/next.js/blob/canary/docs/01-app/01-getting-started/06-fetching-data.mdx)
- [Next.js caching](https://github.com/vercel/next.js/blob/canary/docs/01-app/01-getting-started/08-caching.mdx)
- [Next.js rendering philosophy](https://github.com/vercel/next.js/blob/canary/docs/01-app/02-guides/rendering-philosophy.mdx?plain=1)
- [Next.js production checklist](https://github.com/vercel/next.js/blob/canary/docs/01-app/02-guides/production-checklist.mdx?plain=1)
- [Next.js lazy loading](https://github.com/vercel/next.js/blob/canary/docs/01-app/02-guides/lazy-loading.mdx?plain=1)
- [Next.js testing guide](https://github.com/vercel/next.js/blob/canary/docs/01-app/02-guides/testing/index.mdx?plain=1)
- [Next.js accessibility](https://nextjs.org/docs/architecture/accessibility)
- [WAI-ARIA Authoring Practices Guide](https://www.w3.org/WAI/ARIA/apg/)

### Maintainer examples

- [Next.js Jest example](https://github.com/vercel/next.js/tree/canary/examples/with-jest)
- [Next.js Playwright example](https://github.com/vercel/next.js/tree/canary/examples/with-playwright)

### Practitioner and community material

- [Vercel: Understanding React Server Components](https://vercel.com/blog/understanding-react-server-components)
- [Vercel: Guide to fast websites with Next.js](https://vercel.com/blog/guide-to-fast-websites-with-next-js-tips-for-maximizing-server-speeds)
- [React Conf 2024 RSC talk](https://conf2024.react.dev/talks/16)
