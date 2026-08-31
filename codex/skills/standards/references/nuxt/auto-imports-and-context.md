# Auto-imports and context

- Nuxt auto-imports Vue APIs, components, composables, utilities, and configured module exports while preserving generated typings and tree-shaking. [N3]
- Use auto-imports for conventional local code and use explicit `#imports` or `#components` imports when a dependency boundary or ambiguous name needs to be visible.
- Name local composables descriptively and keep their implementation in `app/composables/` so discovery remains predictable.
- Call Nuxt composables synchronously from setup, plugins, or route middleware; do not call context-dependent APIs at module evaluation time. [N3]
- Do not place `useRuntimeConfig`, `useRoute`, `useFetch`, or another context-dependent call in a top-level exported constant.
- Treat app and Nitro auto-imports as separate contexts even when their names look similar.
- Do not import app components, composables, or app-only utilities into `server/` code, and do not import server-only code into the app. [N6]
