---
name: javascript
description: Applies current JavaScript, browser, and React practice, with performance rules ranked by impact. Use it when writing, reviewing, or refactoring JavaScript or JSX, React components, hooks, or Server Components, or a Next.js app. Use it when fixing slow pages, request waterfalls, large bundles, extra re-renders, layout thrashing, or hydration mismatches. Use it when choosing a recent ECMAScript feature for the project's target runtimes.
---

<project_first>
The project's own tools and versions come first, as `code_rules` in the coding instructions requires. Before you apply any rule here, read five things in the project.

1. Read `package.json` and the lockfile for the installed versions of React, React DOM, Next.js, and the data-fetching libraries.
2. Find the bundler and its config, such as Vite, webpack, Rollup, esbuild, Turbopack, or the Next.js config.
3. Read the `browserslist` setting or the build target, which decides the language features and APIs you may use.
4. Check whether React Compiler is on, through `babel-plugin-react-compiler` in the dependencies or a `reactCompiler` option in the framework config.
5. Read nearby components for the patterns the project already uses, and match them.

Some rules name a library, such as SWR, TanStack Query, `lru-cache`, or `better-all`. Use that library only when the project already has it. Otherwise use the plain JavaScript form the rule shows.
</project_first>

<boundary>
This skill covers the JavaScript language, browser APIs, React, and Next.js. Types, generics, and `tsconfig.json` belong to the `typescript` skill. The Node.js runtime belongs to the `node` skill. For server frameworks, use their documentation for the installed version.
</boundary>

<nextjs>
Next.js 16.2 and later ship [version-matched docs](https://nextjs.org/docs/app/guides/ai-agents) inside the package at `node_modules/next/dist/docs/`. The folder mirrors the structure of nextjs.org/docs, with `01-app/`, `02-pages/`, and `03-architecture/`. For Next.js work, check the installed `next` version first. On 16.2 or later, read the relevant guide in that folder before you write code. Its APIs may differ from your training data.

In a monorepo, resolve `node_modules/next` from the app's own directory, because the repo root may not see it. Next.js 16.1 and earlier have no bundled docs. For those versions and for the error pages under `/docs/messages`, fetch the page from nextjs.org/docs. Each page has a Markdown version at its `.md` URL.

From 16.3, `next dev` writes a managed block between `nextjs-agent-rules` markers into `AGENTS.md` when it detects a coding agent. Mention that change to the user instead of reverting it. This skill holds no Next.js rules of its own. The React rules in the reference files still apply inside Next.js apps.
</nextjs>

<react>
React 19.3 is the current release. React 19.2 added `<Activity>` and `useEffectEvent`. React 19.3 made `<ViewTransition>` and `<Fragment ref>` stable and added `addTransitionType` and `browser()` from `react-dom`. Check the installed version before you use any of these.

React Compiler 1.0 is stable and memoizes components and values on its own. When the project has it on, write new code without `memo`, `useMemo`, or `useCallback`. Keep them only where a value must stay stable as an effect dependency. Leave existing memoization in place, because removing it can change the compiled output. Rules in the reference files that add manual memoization apply only to projects without the compiler.
</react>

<priorities>
The reference files rank rules by their effect on load time and responsiveness. Fix the higher categories first, because a single request waterfall or a large bundle costs more than many extra re-renders.

| Category | Impact | Reference file |
|---|---|---|
| Request waterfalls | Critical | [react-async-and-bundle.md](references/react-async-and-bundle.md) |
| Bundle size | Critical | [react-async-and-bundle.md](references/react-async-and-bundle.md) |
| Server rendering and Server Components | High | [react-server.md](references/react-server.md) |
| Script loading, resource hints, long lists | High | [js-performance.md](references/js-performance.md) |
| Re-renders and rendering | Medium | [react-rendering.md](references/react-rendering.md) |
| DOM, storage, and JavaScript hot paths | Low to medium | [js-performance.md](references/js-performance.md) |

Read [react-async-and-bundle.md](references/react-async-and-bundle.md) when code awaits several independent operations or when a page loads too much JavaScript. Read [react-server.md](references/react-server.md) when you write Server Components, Server Actions, server-side caches, or props that cross the server and client boundary. Read [react-rendering.md](references/react-rendering.md) when you write hooks, effects, state updates, or components that render too often or mismatch on hydration. Read [js-performance.md](references/js-performance.md) when you add scripts or preloads, render long lists, or touch the DOM, storage, or a hot loop.
</priorities>

<ecmascript>
ES2025 and ES2026 add features that older training data lacks. They come from the [TC39 finished proposals list](https://github.com/tc39/proposals/blob/main/finished-proposals.md). Use one only when the project's target runtimes support it. The `browserslist` setting, the Node.js version, or the TypeScript `lib` setting shows this. Otherwise keep the older form or a polyfill the project already has.

These features are in ES2025.

- Iterator helpers such as `map`, `filter`, `take`, `drop`, `flatMap`, and `toArray` work lazily on any iterator. `Iterator.from()` wraps an iterable.
- `Set` has `union`, `intersection`, `difference`, `symmetricDifference`, `isSubsetOf`, `isSupersetOf`, and `isDisjointFrom`.
- `Promise.try(fn)` calls `fn` and always returns a promise, even when `fn` throws synchronously.
- `RegExp.escape(text)` escapes a string for safe use inside a regular expression.
- Import attributes load JSON modules with `import data from "./data.json" with { type: "json" }`.
- RegExp modifiers change flags inside a group, as in `(?i:abc)`.
- Named capture groups may repeat across alternatives, as in `(?<year>\d{4})-\d{2}|\d{2}-(?<year>\d{4})`.
- `Float16Array`, `Math.f16round`, and the `DataView` methods `getFloat16` and `setFloat16` handle half-precision floats.

These features are in ES2026.

- `Array.fromAsync(source)` collects an async iterable into an array.
- `Error.isError(value)` detects real errors across realms, where `instanceof Error` fails.
- `Math.sumPrecise(numbers)` sums an iterable of numbers without rounding error between steps.
- `Uint8Array.fromBase64`, `Uint8Array.fromHex`, `toBase64`, `toHex`, `setFromBase64`, and `setFromHex` convert bytes without `atob` or `btoa`.
- `Iterator.concat(...iterables)` chains several iterables into one lazy iterator.
- A `JSON.parse` reviver gets a third `context` argument with the raw `source` text. `JSON.rawJSON` makes `JSON.stringify` emit raw JSON text.
- `Map` and `WeakMap` have `getOrInsert(key, value)` and `getOrInsertComputed(key, callback)`, and the callback runs only for a missing key.
</ecmascript>
