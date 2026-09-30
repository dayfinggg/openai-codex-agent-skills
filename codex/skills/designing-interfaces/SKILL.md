---
name: designing-interfaces
description: Design or restyle a web interface using the existing design system or a deliberate product-specific direction. Use for visual layout, typography, color, copy or accessibility changes.
---

# Designing interfaces

## Choose a direction before writing markup

1. If the project already has a design system, tokens, brand colors or existing pages, follow them. Consistency beats novelty.
2. Otherwise derive the direction from the product itself: its subject, its audience and the one job the page must do. A tax tool, a bakery and a developer CLI should not look alike.
3. Choose the relevant palette, type, spacing and layout internally before implementation. Keep the choices specific to the product without requiring a written plan or a fixed number of tokens.
4. The user's own words always win, even when they ask for a look listed below.

## Defaults to avoid

These patterns mark a page as generated. Use one only when the brief or the subject calls for it.

- Cream or off-white background with a serif display face and a terracotta or amber accent.
- Near-black background with a single neon green, vermilion or purple accent and glows.
- Purple, indigo or blue gradients, gradient text, radial halos and glassmorphism.
- Inter, Roboto, Arial or Space Grotesk picked without a reason.
- An italic, bold or colored accent word inside a headline.
- ALL-CAPS eyebrow labels, a badge above the main heading, and "A · B · C" meta strings.
- Numbered "01 / 02 / 03" sections when the content is not a real sequence.
- Monospace labels for data that is not code.
- Pill-shaped buttons everywhere and arrows on every button.
- A centered hero with a big number, small label and stats row.
- Identical rounded cards with an icon tile on top in a three-column grid, one radius and one soft shadow on everything.
- Fade-and-slide-up on every section and a hover lift on every card.
- Emoji used as icons.
- Filler copy such as "supercharge", "seamless", "world-class" or lorem ipsum.

## Baseline every page meets

- Text contrast at least 4.5:1, large text and UI component boundaries at least 3:1.
- Interactive targets at least 24 by 24 CSS pixels, primary touch targets about 44 pixels.
- A visible focus indicator on every interactive element.
- Body line length between 45 and 80 characters, body line height around 1.5.
- One spacing scale and one type scale used everywhere, with clear size jumps between levels.
- Works at 320 CSS pixels wide without horizontal scrolling, then scales up.
- Motion supports the interaction and respects `prefers-reduced-motion: reduce`.
- Dark mode, when present, follows `prefers-color-scheme` and gets its own tuned palette.
- Semantic landmarks (`header`, `nav`, `main`, `footer`), headings in order, labels on every input.
- Real, specific content. Buttons say what happens ("Save changes", not "Submit"), errors say how to fix the problem, text in sentence case.

## Review before finishing

Check the changed surface in a browser when available, as `testing-code`'s `browser-checks.md` describes. Fix relevant mismatches with the request and accessibility baseline. Remove decoration only when it is unnecessary within the requested scope, not to satisfy a quota.
