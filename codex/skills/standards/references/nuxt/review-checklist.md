# Review checklist

- Can a reader identify the app, server, state, data, rendering, and test owner for every changed behavior?
- Does the code behave correctly on the server, during hydration, and after client navigation?
- Are Nuxt composables called in a valid context and are app and Nitro imports kept separate?
- Are payload size, caching, cancellation, errors, and request isolation explicit?
- Does the production build use the intended route rules and delivery mode?
- Did the change preserve a small public surface and avoid a wrapper that hides Nuxt semantics?
