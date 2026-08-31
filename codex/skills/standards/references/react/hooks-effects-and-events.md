# Hooks, Effects, and events

- Call Hooks only at the top level of React functions or custom Hooks, before conditional returns. [Rules of Hooks](https://react.dev/reference/rules/rules-of-hooks)
- An Effect synchronizes React with an external system such as a subscription, timer, DOM API, or third-party widget. [useEffect](https://react.dev/reference/react/useEffect)
- Do not use an Effect to derive render data, mirror props, or handle an event that the event handler already knows occurred. [You might not need an Effect](https://react.dev/learn/you-might-not-need-an-effect)
- Put mutations, action-specific analytics, and notifications in the event handler or command that knows the user action.
- Declare every reactive dependency and restructure the code instead of suppressing the dependency lint rule. [useEffect dependencies](https://react.dev/reference/react/useEffect)
- Return cleanup that fully undoes setup, including unsubscribe, abort, disconnect, and listener removal operations.
- Make setup and cleanup symmetric so Strict Mode's extra development cycle is harmless. [useEffect](https://react.dev/reference/react/useEffect)
- Effects run only on the client and cannot provide server-rendered data. [useEffect](https://react.dev/reference/react/useEffect)
- Use `useLayoutEffect` only for measured DOM work that must happen before paint; prefer `useEffect` otherwise.
- If a manual client fetch is unavoidable, prevent stale responses from winning and handle cancellation, loading, error, and unmount cases.
- Prefer a framework data API or a maintained client cache over repeated mount-time fetch Effects because those approaches can preload, deduplicate, cache, and render data earlier. [useEffect data fetching](https://react.dev/reference/react/useEffect)
- Each render's handlers and Effects capture that render's props and state; use a ref only when intentionally reading a mutable latest value. [Dan Abramov on useEffect](https://overreacted.io/a-complete-guide-to-useeffect/)
