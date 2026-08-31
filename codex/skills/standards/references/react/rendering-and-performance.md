# Rendering and performance

- Keep render functions free of I/O, subscriptions, timers, mutations, and logging that changes behavior.
- Fix impure rendering, duplicated state, broad context, and unnecessary Effects before optimizing re-renders.
- Measure the user interaction and identify the slow calculation or component before adding memoization. [React useMemo](https://react.dev/reference/react/useMemo)
- Use `memo` only when a component re-renders often with the same props and its render is measurably expensive. [React memo](https://react.dev/reference/react/memo)
- Use `useMemo` for a proven expensive calculation, a stable prop needed by `memo`, or a deliberately stable Hook dependency.
- Use `useCallback` for a stable function contract, not to prevent ordinary function allocation.
- Treat memoization as a performance optimization, never as a correctness fix or semantic guarantee. [React memo](https://react.dev/reference/react/memo)
- React Compiler can automate much component and calculation memoization in supported builds, but it does not relax purity or measurement requirements. [React Compiler](https://react.dev/learn/react-compiler/introduction)
- Test performance in a production build on representative devices and throttled CPU or network conditions. [React useMemo](https://react.dev/reference/react/useMemo)
- Check browser performance tools and React DevTools before changing component boundaries. Extra renders and misplaced calculations are common causes of slow interactions.
- Remove unused dependencies and code before adding a performance library. Choose ready-made UI libraries by fit, weight, and behavior rather than habit.
- Keep large lists, expensive calculations, and third-party widgets behind boundaries that can be optimized independently.
