# Vue and Nuxt

## Current practice (Vue 3.5 and later)

- Single-File Components with `<script setup lang="ts">` and the Composition API.
- Type-based `defineProps<Props>()` with reactive destructuring for defaults: `const { size = "md" } = defineProps<Props>()`.
- `defineEmits<Emits>()`, `defineModel()` for `v-model`, `defineSlots` and generic components where they add type safety.
- Pinia for shared state. Composables (`useX`) for reusable logic.
- Nuxt for server rendering and routing when the app needs them.

## Official style guide essentials

Multi-word component names, detailed prop types, `:key` on every `v-for`, never `v-if` on the same element as `v-for`, scoped or module styles, PascalCase component files, simple template expressions with logic moved to `computed`.

## Outdated patterns

Do not write the Options API in new application code, Vuex, `withDefaults`, a manual `modelValue` prop with `update:modelValue` emit instead of `defineModel`, runtime-only prop declarations in TypeScript code, or Vue 2 syntax.
