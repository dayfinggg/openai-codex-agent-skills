# Rendering, navigation, and streaming

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
