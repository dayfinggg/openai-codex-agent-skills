---
name: react-next
description: Diagnose or change Next.js App Router behavior in route.ts, proxy.ts, next.config files, or use client, use server, and use cache boundaries. Use for framework-specific streaming, hydration, revalidation, and prerender errors. Use typescript-javascript for general language and toolchain work.
license: MIT
---

# Next.js App Router and React boundaries

Read the installed `next`, `react`, and `react-dom` versions and relevant framework configuration before making a framework-specific change. Prefer the installed package's documentation, then the official documentation for that version. The release-specific details in these references are leads, not substitutes for current docs.

Read [references/cache-components.md](references/cache-components.md) when using or migrating `'use cache'`, Cache Components, cache handlers, or revalidation. Read [references/react-client.md](references/react-client.md) when implementing Client Components, Effects, Transitions, view transitions, Server Action arguments, or `after()` behavior.

Follow the router and rendering model that the project already uses. Keep server-only data and secrets on the server, pass serializable values across the Server and Client Component boundary, and put user-specific authorization in each callable server entry point rather than only in its UI. Preserve current behavior unless the task changes it.

After a change, run the focused project checks and use the installed framework's development or production path that exercises the affected behavior. Inspect the browser result for hydration, streaming, or first-render changes when available. Do not rely on a build alone for request-time behavior.
