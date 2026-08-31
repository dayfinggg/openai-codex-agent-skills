# Architectural model

- Model the application as nested route segments with layouts, pages, loading UI, errors, and route handlers.
- The `app` directory defines App Router segments, and `src/app` is an optional location for the same code. [Project structure](https://github.com/vercel/next.js/blob/canary/docs/01-app/01-getting-started/02-project-structure.mdx?plain=1)
- A folder becomes a public route only when it contains a `page` or `route` file, so route-local implementation files can be colocated safely. [Project structure](https://github.com/vercel/next.js/blob/canary/docs/01-app/01-getting-started/02-project-structure.mdx?plain=1)
- Use layouts for stable shared UI and pages for route-specific composition; keep the route tree aligned with user-visible navigation.
- In the App Router, layouts and pages are Server Components by default. [Server and Client Components](https://github.com/vercel/next.js/blob/canary/docs/01-app/01-getting-started/05-server-and-client-components.mdx)
- Think of a route as a composition of server-rendered content, client islands, data dependencies, and Suspense boundaries.
- Client and server rendering are not mutually exclusive; Client Components can be prerendered on the first load and hydrated in the browser. [Server and Client Components](https://github.com/vercel/next.js/blob/canary/docs/01-app/01-getting-started/05-server-and-client-components.mdx)
- Treat the RSC payload, HTML, and client JavaScript as separate delivery products with separate size and latency budgets.
- Use the versioned Next.js docs as the authority for framework behavior, and use conceptual talks only to explain the model. [React Conf RSC talk](https://conf2024.react.dev/talks/16)
