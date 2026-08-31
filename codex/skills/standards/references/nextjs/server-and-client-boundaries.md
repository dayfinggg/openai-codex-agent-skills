# Server and client boundaries

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
