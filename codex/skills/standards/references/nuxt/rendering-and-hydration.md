# Rendering and hydration

- Nuxt uses universal rendering by default and supports client-only rendering, prerendering, route rules, hybrid caching, and edge deployment. [N4]
- Select `ssr: false` only for genuinely client-only routes; use route rules for intentional per-route prerendering, caching, or hybrid rendering.
- Assume setup and render code can run on the server and again in the browser during hydration.
- Guard `window`, `document`, `localStorage`, layout measurement, and other browser APIs with `import.meta.client` or a client lifecycle hook.
- Use `import.meta.server` for server-only work and `.client` or `.server` suffixes when a file has one fixed environment. [N5]
- Use `onMounted` for client-only effects and clean up listeners, observers, and timers when the component unmounts.
- Do not start cleanup-dependent timers or subscriptions in root setup code that also runs during SSR. [N5]
- Keep server and client renders deterministic; do not render unseeded random values, current time, or client-localized values in SSR markup.
- Avoid invalid HTML nesting because browser parsing can change the DOM before hydration.
- Use `<ClientOnly>` or a `.client.vue` component for widgets that cannot render meaningful server markup.
- Treat hydration mismatch warnings as defects and fix the differing data, markup, or timing instead of hiding the warning.
- Remember that route middleware and pages can run on both server and client, so keep environment-specific work explicitly guarded. [N5]
