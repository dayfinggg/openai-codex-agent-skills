# File organization

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
