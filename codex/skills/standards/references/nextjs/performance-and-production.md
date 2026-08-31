# Performance and production

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
