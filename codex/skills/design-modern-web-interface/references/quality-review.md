# Quality Review

## Review the rendered interface

Inspect the first viewport and the complete page in a real browser. Test near 320–390px, 768–900px, and 1280–1440px, plus every width where content collides. Check 200% zoom, keyboard-only use, visible and unobscured focus, reduced motion, long content, required languages, and console errors.

Verify information hierarchy, reading order, line length, font loading, glyph coverage, alignment, spacing rhythm, density, image crop, contrast, target size, sticky elements, overflow, and perceived performance. Ensure every interactive element has a clear hover, focus, active, selected, disabled, loading, success, and error treatment as relevant.

Test loading, empty, partial data, validation failure, network failure, permission limits, conflict, offline or retry states when the product can encounter them. A polished happy path is incomplete.

## Detect generated-design clichés

Look for convergence with unrelated generated sites:

- blue-purple aurora or mesh gradient without a brand reason;
- huge centered hero, pill badge, gradient word, two buttons, floating mockup, three equal feature cards, logo strip, fake metrics, testimonials, and final glow call to action;
- full-screen dark photograph, thin white navigation, huge serif title, and tiny uppercase eyebrow used as automatic “premium” design;
- Inter with JetBrains Mono, Manrope with Prata or Playfair, or another fashionable pair chosen without language and product analysis;
- every group in a rounded card, pill controls everywhere, glass and backdrop blur on ordinary surfaces, excessive shadows, floating blobs, glow, and random gradients;
- a rounded summary strip containing four bordered metric cells, a rounded search field beside a rounded filter button, and a second rounded panel around the main table;
- emoji or mixed icon families, generic stock or generated images, placeholder copy, invented company claims, and arbitrary decorative charts;
- `hover: scale(1.05)`, fade-up, stagger, parallax, or reveal on nearly every element;
- tiny metadata, weak gray text, poor focus, hidden overflow, and a desktop layout merely shrunk for mobile.

These patterns are not forbidden in isolation. Keep one only when it has a clear information, interaction, material, or brand role. Remove accumulated effects. As a final test, temporarily imagine all radii, borders, shadows, and tinted panels removed. If the hierarchy collapses, repair typography, alignment, grouping, and spacing before restoring only the necessary treatments.

## Protect content integrity

Use realistic product-specific content. Do not present fabricated clients, awards, testimonials, reviews, financial results, medical outcomes, addresses, or performance figures as real. Clearly fictional demonstration data is acceptable for a prototype.

Use original or properly licensed assets. Do not imitate a living designer, studio, or named product. Keep generated imagery consistent in perspective, lighting, material, crop, and art direction, and inspect it for distortions and embedded text.

## Completion test

The result is ready only when it works without animation, remains understandable without color, supports the primary task at every tested width, and expresses a product-specific direction without sacrificing familiar behavior.

Remove any element that does not improve meaning, usability, hierarchy, or the chosen character. Recheck after removal. Clean design comes from resolved relationships, not from adding fewer arbitrary decorations.

Sources: [WCAG 2.2](https://www.w3.org/TR/WCAG22/), [WebAIM designer checklist](https://webaim.org/resources/designers/), [web.dev Core Web Vitals](https://web.dev/articles/vitals), [web.dev CSS and Web Vitals](https://web.dev/articles/css-web-vitals), [Apple accessibility](https://developer.apple.com/design/human-interface-guidelines/accessibility/), [SmoothUI on AI design slop](https://smoothui.dev/blog/ai-design-slop), [Agent's Design on templated AI UI](https://agent-design.com/blog/stop-ai-ui-looking-templated).
