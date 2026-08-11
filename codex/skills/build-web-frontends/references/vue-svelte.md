# Vue and Svelte project fit

**Reviewed:** 2026-08-11
**Scope:** Current Vue and Svelte documentation. Resolve installed framework, meta-framework, router, compiler, and build versions first.

## Vue

- Preserve single-file component, Composition or Options API, router, store, and style conventions already used by the package.
- Keep props one-way, emit intentional events, and derive values with computed state rather than duplicated watchers when possible.
- Use watchers for external effects with cleanup and race handling. Preserve reactivity by following exact-version rules.
- Keep component and route naming consistent with local registration and tooling. Do not impose React file or hook conventions.

## Svelte and SvelteKit

- Preserve compiler and runes or legacy syntax used by the installed version. Do not mix generation-specific state APIs without a requested migration.
- Follow SvelteKit filesystem routes and special files. Keep server-only modules and secrets in the documented server boundary.
- Use load, form action, invalidation, and navigation contracts from the installed version. Handle streaming, errors, cancellation, and progressive enhancement explicitly.
- Keep generated route types and build output derived.

## Official sources

- [Vue documentation](https://vuejs.org/guide/introduction.html)
- [Vue state management](https://vuejs.org/guide/scaling-up/state-management.html)
- [Svelte documentation](https://svelte.dev/docs/svelte/overview)
- [SvelteKit documentation](https://svelte.dev/docs/kit/introduction)
- [SvelteKit project structure](https://svelte.dev/docs/kit/project-structure)
