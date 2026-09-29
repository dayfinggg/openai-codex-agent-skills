# Next.js

## Current practice (Next.js 16 and later)

- App Router. Server Components by default, `"use client"` only on the smallest interactive leaf.
- `params`, `searchParams`, `cookies()`, `headers()` and `draftMode()` are async. Always `await` them.
- Request interception lives in `proxy.ts` exporting `proxy`. `middleware.ts` is deprecated.
- Turbopack is the default bundler.
- Mutations with Server Functions (`"use server"`), called from `<form action>` or event handlers. Check authentication and authorization inside every Server Function, because it is reachable by a direct POST. After a write, call `updateTag`, `revalidateTag(tag, profile)`, `revalidatePath` or `refresh`, then `redirect` if needed.
- `next/image` with `remotePatterns` for remote images. Use `loading="eager"` or `fetchPriority="high"` for the main above-the-fold image instead of `priority`.
- Fonts through `next/font`, applied in the root layout.

## Caching

Read `next.config` first. With `cacheComponents: true`, cache with `"use cache"` on a function, component or file plus `cacheLife()` and `cacheTag()`, and wrap uncached or request-specific reads in `<Suspense>`. Without it, `fetch` is not cached by default, so opt in with `cache: "force-cache"` or `next: { revalidate }`.

## Outdated patterns

Do not write the Pages Router, `getServerSideProps` or `getStaticProps` in new code, synchronous `params` or `cookies()`, `middleware.ts`, `experimental.ppr` or `dynamicIO`, one-argument `revalidateTag`, `images.domains`, the `priority` image prop, `next lint`, or code that assumes `fetch` is cached.
