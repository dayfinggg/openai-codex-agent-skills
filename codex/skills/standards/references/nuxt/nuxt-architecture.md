# Nuxt architecture

- Use Nuxt as the full-stack Vue framework when the application needs convention-based routing, SSR, server handlers, or hybrid delivery. [N1]
- Keep the default universal rendering choice unless product requirements justify SPA, prerendered, or hybrid routes.
- Treat Nitro as the server engine and keep its request and deployment concerns separate from Vue component code. [N1]
- Use file-based routing, code splitting, auto-imports, and Nuxt data primitives instead of rebuilding those mechanisms locally.
- Keep pages thin: a page coordinates route inputs, layout, data, and feature components rather than becoming a second service layer.
- Keep `nuxt.config.ts`, `public/`, `server/`, `shared/`, `layers/`, `modules/`, and generated output at the project root.
- Use the Nuxt 4 `app/` directory as the default source directory for application code. [N2]
