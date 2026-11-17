# React Client Components and transitions

Verify React and Next.js API signatures and behavior in documentation matching the installed versions.

## Client boundaries and Effects

- Keep `'use client'` boundaries narrow. Pass only serializable props from server-rendered code, and keep request-specific state out of module-level variables.
- Use Effects to synchronize with external systems. Derive render output from props and state rather than adding an Effect that mirrors state.
- Consider Strict Mode and hydration when reviewing Effects. A setup and cleanup cycle may happen more than once; make subscriptions and side effects safe for that lifecycle.
- Check the installed docs before using a new hook, the React Compiler, or an experimental feature. Do not add memoization or a compiler configuration as a routine optimization.
- Place client-only dynamic imports inside a Client Component when required by the framework, and retain an appropriate Suspense boundary.

## Actions and Transitions

- Async state transitions may need a second transition around updates after an `await`, depending on the installed React version. Prevent stale responses from overwriting newer user actions.
- Bound server action arguments arrive from the client and must be treated as untrusted. Keep secrets out of arguments and closures, and authorize the target object inside each action.
- Read request context before scheduling an `after()` callback when the framework requires it. Check whether the callback runs at request time, build time, or revalidation time for the route.

## View transitions

- Confirm framework and browser support before using React or document-level view transitions. Ensure the non-transition path still works.
- Keep transition names unique among simultaneously mounted elements. Remove temporary names when they are no longer needed.
- A Suspense fallback may render before the destination content, changing which element receives an entry transition. Inspect both prefetched and non-prefetched navigation.
- View transitions do not automatically move focus. Restore a logical focus target after navigation removes the focused element.
- Respect reduced-motion preferences and keep the page interactive while the transition runs.
