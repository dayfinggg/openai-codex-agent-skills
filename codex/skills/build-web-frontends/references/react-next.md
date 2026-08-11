# React and Next.js project fit

**Reviewed:** 2026-08-11
**Scope:** Current React and Next.js documentation. Resolve installed versions, router, renderer, bundler, and deployment runtime first.

## React

- Keep components pure during render and place effects only around external synchronization. Avoid effects for state that can be derived during render or events.
- Preserve controlled and uncontrolled input contracts. Use stable keys that identify data, not array positions when order can change.
- Scope context and memoization to measured needs. Do not add memoization by reflex or hide mutable state behind it.
- Clean up subscriptions and asynchronous work. Test concurrent and strict development behaviors supported by the installed stack.

## Next.js

- Preserve file-system routing and special files such as `page`, `layout`, `route`, `loading`, `error`, and `not-found` according to the detected router and version.
- Keep server-only secrets and capabilities out of client components. Add a client boundary only for browser APIs or interactivity that needs it.
- Understand cache, revalidation, dynamic rendering, route handlers, streaming, and runtime selection from the installed version. Do not assume defaults from another Next.js release.
- Treat generated files and build output as derived. Preserve canonical configuration and module resolution.

## Official sources

- [React documentation](https://react.dev/)
- [React managing state](https://react.dev/learn/managing-state)
- [React synchronizing with effects](https://react.dev/learn/synchronizing-with-effects)
- [Next.js documentation](https://nextjs.org/docs)
- [Next.js project structure](https://nextjs.org/docs/app/getting-started/project-structure)
- [Next.js TypeScript](https://nextjs.org/docs/app/api-reference/config/typescript)
