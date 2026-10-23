# Design systems, tokens, and Figma

## Design tokens

Use the Design Tokens Community Group format, stable since version 2025.10, as the vendor-neutral JSON that Figma plugins and Style Dictionary exchange.

| Tier | Example | Purpose |
|---|---|---|
| Primitive | `color.blue.600 = #2563eb` | Raw palette and scales, never used directly in components |
| Semantic | `color.action.primary = {color.blue.600}` | Roles, which change per theme or brand |
| Component | `button.primary.background = {color.action.primary}` | Only when a component needs its own override |

- Name by role, as in `space.md` and `text.secondary`, not by value such as `space-16` or `gray-text`.
- Themes such as light, dark, high contrast, and brands remap semantic tokens to other primitives.
- Keep one source of truth and generate CSS variables, Swift, and Kotlin from it.

## Figma structure

- Variables in collections, primitives in one and semantic tokens in another, with modes for light and dark, brands, and density. Text and effect styles where variables cannot express the value.
- Nested auto layout with spacing variables for gaps and padding.
- Component properties for text, icons, and booleans, variants only for real structural or state differences, and slots or instance swap for flexible content.
- Component and property names match the code, as in `Button` with `variant=primary` and `size=md`.

## From Figma to code

1. Read the design's variables and components, not raw pixel values. Map every color, size, and spacing to an existing token, and flag values that match no token instead of hard-coding them.
2. Reuse existing code components that match Figma components.
3. Recreate auto layout as flexbox or grid with the same gaps and alignment.
4. Implement all states and responsive behavior even when the design shows one, and ask when behavior is unclear.
5. Compare the result with the design at several widths.
