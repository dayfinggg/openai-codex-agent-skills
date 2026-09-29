# Tailwind CSS

## Current practice (Tailwind 4 and later)

- CSS-first setup: `@import "tailwindcss";` in the main stylesheet, with the `@tailwindcss/vite` or `@tailwindcss/postcss` plugin. No `tailwind.config.js` is needed.
- Design tokens in CSS with `@theme { --color-brand-500: oklch(...); --font-display: ...; }`. Every token becomes a utility and a CSS variable.
- Custom utilities with `@utility`, not `@layer utilities`.
- Opacity through the slash modifier: `bg-black/50`.
- Border and ring colors default to `currentColor`, so set the color explicitly.

## Renamed utilities

| Old | Current |
|---|---|
| `shadow-sm` | `shadow-xs` |
| `rounded-sm` | `rounded-xs` |
| `outline-none` | `outline-hidden` |
| `ring` | `ring-3` |
| `flex-shrink-*`, `flex-grow-*` | `shrink-*`, `grow-*` |
| `bg-opacity-*` | slash modifier |

## Outdated patterns

Do not write `@tailwind base`, `@tailwind components`, `@tailwind utilities`, a setup that relies only on `tailwind.config.js`, or the old utility names above. Tailwind 4 does not support Sass, Less or Stylus.
