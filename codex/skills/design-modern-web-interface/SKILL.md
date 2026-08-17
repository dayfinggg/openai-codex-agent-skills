---
name: design-modern-web-interface
description: Design or redesign clean, distinctive, modern web pages and product interfaces. Use for landing pages, marketing sites, dashboards, portals, applications, portfolios, design systems, visual refreshes, and vague requests to make a web experience beautiful, premium, minimal, polished, or contemporary. Apply alongside build-web-frontend when implementation is requested.
---

# Design Modern Web Interface

## Workflow

1. Inspect the product, audience, content, brand, platform, existing system, and technical constraints. Classify the surface as editorial, marketing, commerce, data-rich product, workflow tool, portfolio, or another real use case.
2. When direction is vague, do not ask for arbitrary taste. Infer one restrained art direction from the product, then define its idea, typography, palette, grid, density, imagery, surfaces, and motion before coding.
3. Build information hierarchy and user flow from realistic content. Select a composition suited to the surface instead of defaulting to a full-screen photographic hero, oversized slogan, card grid, or fixed dashboard sidebar.
4. Establish reusable tokens for typography, spacing, layout, color, borders, radius, elevation, and motion. Keep general text around 16–18px, dense product text 14–16px, metadata at least 12px, and primary display text normally 40–72px with about 96px as a justified wide-screen exception. Start from the reference defaults, then change them only for a clear product or brand reason.
5. Render no user-visible text below 12px, including badges, counters, table headings, captions, timestamps, chart labels, and helper text. Increase space or recompose the layout instead of shrinking text.
6. Begin with a flat canvas, strong alignment, controlled measure, useful whitespace, limited color, familiar controls, and one distinctive idea. Do not enclose a section in a card or add a border, radius, shadow, blur, or tinted panel unless it represents an independent interactive unit, real grouping boundary, overlay, or elevation. Flatten the layout when spacing and dividers communicate the structure.
7. Design responsive behavior, not scaled screenshots. Recompose navigation, hierarchy, data, controls, and density for narrow, medium, and wide containers. Use content-driven media queries for page structure and container queries for reusable components.
8. Use brief, coordinated motion for feedback, continuity, hierarchy, and emphasis. Keep it interruptible, compositor-friendly, and optional through reduced-motion preferences.
9. Implement semantic structure, complete states, visible focus, readable type, sufficient contrast, comfortable targets, keyboard access, resilient text scaling, and suitable Cyrillic or other required glyph coverage.
10. Inspect the rendered result in a real browser at narrow, medium, and wide sizes, 200% zoom, keyboard-only use, and reduced motion. Check overflow, long text, loading, images, hierarchy, balance, typography, and whether the result still resembles a generic generated template. Refine before completion.

Do not imitate a named designer or product. Avoid recognizable generated-design formulas: giant type on every page, serif italics as automatic “luxury,” browser-default Georgia, Times, or Arial as automatic brand typography, Inter or Manrope chosen automatically, Manrope paired with Prata or Playfair by default, blue-purple gradients, glowing blobs, excessive glass, pills, cards, rounded containers, fake testimonials or metrics, tiny uppercase labels, arbitrary icons, and animation on every element.

Read the relevant references before implementation:

- [Typography](references/typography.md) for font selection, scales, text roles, language coverage, and loading.
- [Layout and spacing](references/layout-spacing.md) for grids, containers, density, controls, and responsive behavior.
- [Color and surfaces](references/color-surfaces.md) for semantic palettes, contrast, dark themes, borders, radius, and elevation.
- [Motion](references/motion.md) for durations, easing, choreography, scroll behavior, and reduced-motion alternatives.
- [Interface patterns](references/interface-patterns.md) for marketing, product, data, commerce, editorial, portfolio, form, and mobile surfaces.
- [Quality review](references/quality-review.md) for browser checks, accessibility, content integrity, and generated-design anti-patterns.
