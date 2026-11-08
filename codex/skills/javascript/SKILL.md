---
name: javascript
description: Change JavaScript, browser, React, or Next.js behavior, or diagnose frontend performance.
---

Establish the project's runtime targets and relevant package versions. Check React Compiler configuration before changing memoization.
For Next.js, use the installed package's version-matched documentation when available, otherwise the official docs for that version.
Use these references only for the affected behavior.
- Request waterfalls and bundle size use [react-async-and-bundle.md](references/react-async-and-bundle.md).
- Server Components, Server Actions, and server caches use [react-server.md](references/react-server.md).
- Hooks, effects, rendering, and hydration use [react-rendering.md](references/react-rendering.md).
- DOM access, storage, scripts, and hot paths use [js-performance.md](references/js-performance.md).

Check new language features against the target runtimes and the [TC39 finished proposals](https://github.com/tc39/proposals/blob/main/finished-proposals.md).
Type-system work belongs to typescript. Node runtime behavior belongs to node.
