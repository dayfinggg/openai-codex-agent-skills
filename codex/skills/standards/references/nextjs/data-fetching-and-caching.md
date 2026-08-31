# Data fetching and caching

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
