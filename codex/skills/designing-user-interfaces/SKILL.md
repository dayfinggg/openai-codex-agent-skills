---
name: designing-user-interfaces
description: Builds and reviews web and mobile interfaces to WCAG 2.2 AA with design tokens. Use when creating or changing screens, components, layouts, CSS, or interface copy, implementing a design, or reviewing accessibility.
---

# Designing user interfaces

The project's design system, brand guide, or Figma file wins over this skill, and its tokens and components come first.

## Layout and type

- Each screen has one primary action, the most prominent element.
- Spacing follows a 4 or 8 unit scale. Body text lines run about 45 to 75 characters.
- Lay out mobile first. Content reflows without horizontal scrolling down to 320 CSS pixels and works at 200 percent zoom.
- Use one or two typefaces and five to seven sizes. Body text is at least 16 CSS pixels on the web and 17 pt on iOS, with line height 1.4 to 1.6.

## Color

- Colors are semantic tokens by role, such as `surface`, `text-primary`, and `danger`, never by hue. Dark mode gets its own tuned palette.
- Text contrast is at least 4.5:1. Large text (24 CSS pixels, or 18.66 bold), icons, input borders, and focus indicators need 3:1.
- Color is never the only signal, and the accent color marks only interactive and important elements.

## Components and states

- Interactive components have default, hover, focus, pressed, disabled, and loading states, plus selected or error where relevant.
- Buttons name the result, as in "Save changes", not "OK" or "Submit". Destructive actions look distinct and sit apart. Prefer undo to a confirmation dialog for reversible actions.
- Touch targets are at least 44 by 44 pt on Apple platforms, 48 by 48 dp on Android, and 24 by 24 CSS pixels on the web, with 44 preferred for touch.
- Design every screen's empty, loading, error, and edge states, such as very long names, one item, thousands of items, and offline. Waits over about one second get skeletons or progress without layout jumps.

## Forms and motion

- Every field has a visible label, and placeholders are hints only. Use the right input types and `autocomplete` values.
- Validate on blur or submit, not per keystroke, show the error next to the field with how to fix it, and keep the entered data. When most fields are required, mark the optional ones.
- Motion explains change in roughly 150 to 300 milliseconds, never blocks input, and becomes a fade or nothing under reduced motion.

## Security

Render untrusted data only through the framework's escaping, never `innerHTML`, `dangerouslySetInnerHTML`, `v-html`, or raw template output. Links and image sources from user data allow only `https` and `http`. Stay compatible with a strict CSP, with no inline scripts or handlers.

## Avoiding a generic look

Unless the brand asks for them, avoid cream or beige page backgrounds, italic accent words in headlines, numbered "01 02 03" section labels, monospace labels for ordinary text, pill-shaped buttons everywhere, decorative gradients, and gratuitous glassmorphism. Derive the look from the product's purpose, audience, and brand.

## Reference files

- [reference/accessibility.md](reference/accessibility.md), read before building or reviewing any screen.
- [reference/platforms.md](reference/platforms.md), read the section for the target platform.
- [reference/design-systems.md](reference/design-systems.md), read when tokens or a Figma file are involved.
