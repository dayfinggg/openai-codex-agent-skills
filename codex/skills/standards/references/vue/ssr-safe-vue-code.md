# SSR-safe Vue code

- SSR renders components to HTML and hydrates that markup into an interactive client application. [V6]
- Treat shared application code as universal code that must run without assuming either browser or server globals.
- Guard `window`, `document`, `localStorage`, layout measurement, and other browser APIs with a client lifecycle hook or a framework boundary.
- Use `onMounted` for client-only effects and use `onUnmounted` or `onBeforeUnmount` for cleanup.
- Keep server and client renders deterministic; do not render unseeded random values, current time, or client-localized values in SSR markup.
- Avoid invalid HTML nesting because browser parsing can change the DOM before hydration.
- Treat hydration mismatch warnings as defects and fix the differing data, markup, or timing instead of hiding the warning.
- Do not start timers, observers, or subscriptions in root setup code when SSR cannot run their cleanup hook.
- Keep user-specific state out of module singletons and shared caches.
- Use framework-provided SSR-aware data and state primitives when the application uses a Vue SSR framework.
