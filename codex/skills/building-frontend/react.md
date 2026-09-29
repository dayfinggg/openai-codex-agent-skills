# React

## Current practice (React 19 and later)

- Function components only. Pass `ref` as a regular prop, without `forwardRef`.
- Render context with `<Context value={...}>`, without `.Provider`.
- Forms and mutations with Actions: `<form action={fn}>`, `useActionState` for result and pending state, `useFormStatus` in nested submit buttons, `useOptimistic` for instant feedback.
- `use()` reads a promise or context, also after an early return.
- With React Compiler enabled, do not add `useMemo`, `useCallback` or `memo` by default. Add them only when a measurement shows a need. Keep existing ones unless you test their removal.
- Start new apps with a framework (Next.js or React Router) rather than a bare bundler setup.

## Effects

An Effect only synchronizes with a system outside React. Compute derived values during render, reset state with a `key`, put event logic in event handlers, read external stores with `useSyncExternalStore`, and fetch data through the framework or a data library rather than in `useEffect`.

## Outdated patterns

Do not write class components, `forwardRef`, `<Context.Provider>`, `useEffect` for derived state, events or data fetching, chains of Effects, default memoization in compiler-enabled code, or Create React App.
