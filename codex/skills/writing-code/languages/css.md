# HTML and CSS

## HTML

- Native elements before custom widgets: `<button>` for actions, `<a href>` for navigation, `<dialog>` opened with `showModal()` for modals, the `popover` attribute for menus and tooltips, `<details>` for disclosure.
- Every input has a visible `<label for>`. Placeholder text is not a label.
- Landmarks (`header`, `nav`, `main`, `footer`), one `h1`, headings in order, `alt` on every meaningful image, `lang` on `<html>`.
- Images with `width` and `height`, `loading="lazy"` below the fold, and modern formats.

## CSS

Use these widely supported features by default:

| Need | Use |
|---|---|
| Layout | Grid and flexbox, `subgrid` for aligned nested grids |
| Component responsiveness | Container queries (`@container`) |
| Parent and sibling state | `:has()` |
| Scoping and order | Native nesting with `&`, `@layer` instead of `!important` |
| Color | `oklch()` tokens and `color-mix()` for variants |
| Direction-independent spacing | Logical properties (`margin-inline`, `padding-block`) |
| Fluid type | `clamp(1rem, 0.9rem + 0.5vw, 1.25rem)` with rem bounds |
| Headings | `text-wrap: balance`, and `text-wrap: pretty` for body text |
| Entry animations | `@starting-style` |

Font sizes in `rem`, never fixed `px`. Design tokens as custom properties in one place.

## Outdated patterns

Do not write floats for layout, vendor prefixes for features that no longer need them, `!important` to win specificity, `<div onclick>` instead of `<button>`, jQuery for DOM work the platform already covers, or placeholder-only form fields.
