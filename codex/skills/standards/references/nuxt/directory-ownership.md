# Directory ownership

- Put route pages in `app/pages/`; let file names express URL ownership and keep route-specific orchestration there.
- Put reusable UI in `app/components/`; Nuxt auto-imports components and derives names from paths, so name files consistently. [N3]
- Put Vue composables in `app/composables/` and pure helpers in `app/utils/`; keep their runtime context requirements explicit.
- Put layout shells in `app/layouts/`, route middleware in `app/middleware/`, and app plugins in `app/plugins/`.
- Put build-processed assets in `app/assets/` and directly served immutable files in `public/`.
- Put API handlers, server routes, server middleware, and server utilities in `server/`; define handlers with the Nitro server API. [N6]
- Put code shared by the app and Nitro in `shared/`, and keep it free of browser-only and server-only imports. [N2]
- Use `layers/` for a deliberately reusable application layer, theme, or domain package, not as a second arbitrary source tree. [N11]
- Keep `.nuxt/` and `.output/` generated and ignored; never edit generated files as a source of truth.
- Keep tests in the repository's established locations and separate unit, Nuxt-runtime, and end-to-end environments. [N10]
