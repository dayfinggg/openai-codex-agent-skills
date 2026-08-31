# Performance and delivery

- Prefer SSR or prerendering for content that must appear quickly or be indexed, and use client-only delivery for private tools that need it.
- Keep route payloads small with `pick`, `transform`, `lazy`, and client-only boundaries when the full response is not needed in HTML.
- Lazy-load non-critical route features and components, and confirm the resulting network waterfall in a production build.
- Use route rules for intentional prerendering, stale-while-revalidate, ISR, redirects, headers, or client-only route sections. [N4]
- Profile hydration cost, JavaScript bundles, server response time, and largest content element on representative devices.
- Do not add global caches, custom fetch wrappers, or hydration tricks without a measured problem and an invalidation plan.
- Prefer Nuxt primitives over one-line wrappers that hide whether a request is server-safe, cached, lazy, or client-only.
