# Design systems, tokens, and Figma

A design system makes design decisions once and reuses them, so product screens stay consistent and design and code stay in sync.

## Contents

- Design tokens
- Figma structure
- From Figma to code
- Component API design

## Design tokens

Tokens are named design decisions, such as colors, spacing, type, radii, shadows, and durations. The Design Tokens Community Group format reached its first stable version (2025.10), a vendor-neutral JSON format that tools such as Figma plugins and Style Dictionary can exchange.

Use three tiers.

| Tier | Example | Purpose |
|---|---|---|
| Primitive | `color.blue.600 = #2563eb` | The raw palette and scales, never used directly in components |
| Semantic | `color.action.primary = {color.blue.600}` | Roles, which change per theme or brand |
| Component | `button.primary.background = {color.action.primary}` | Only when a component needs its own override |

- Name by role, not by value, so `space.md` and `text.secondary`, not `space-16` or `gray-text`.
- Themes such as light, dark, high contrast, and brands remap semantic tokens to different primitives.
- Keep one source of truth for tokens and generate platform outputs from it, such as CSS variables, Swift, and Kotlin.

## Figma structure

- **Variables and modes.** Store tokens as variables in collections, primitives in one collection and semantic tokens in another, and use modes for light and dark, brands, and density.
- **Styles.** Use text styles and effect styles for typography and shadows when variables cannot express them.
- **Auto layout everywhere.** Build components and screens with nested auto layout so they resize like flexbox, and use spacing variables for gaps and padding.
- **Components.** Use component properties for text, icons, and booleans, variants only for real structural or state differences, and slots or instance swap for flexible content.
- **Naming.** Use the same component and property names as the code, such as `Button` with `variant=primary` and `size=md`.
- **Library organization.** Foundations (tokens, icons, type), components, patterns, and page templates, each documented with usage notes and do and don't examples.
- **Files.** Separate exploration from ready-for-development pages, and mark what is ready.

## From Figma to code

1. Read the design's variables and components, not raw pixel values. Map every color, size, and spacing to an existing token, and flag values that match no token instead of hard-coding them.
2. Reuse existing code components that match Figma components.
3. Recreate auto layout as flexbox or grid with the same gaps and alignment.
4. Implement all states and responsive behavior even when the design shows only one, and ask when behavior is unclear.
5. Compare the result against the design at several widths.

## Component API design

- Small, predictable props named after design properties (`variant`, `size`, `disabled`, `loading`).
- Sensible defaults so the common case needs no props.
- Composition over configuration, meaning children and slots instead of dozens of flags.
- Accessibility built in, so consumers cannot forget it.
- Document each component with its purpose, variants, states, and accessibility notes.
