# Accessibility

- Start with native HTML semantics; add ARIA only when native HTML cannot express the required widget or state.
- Give every interactive element an accessible name, role, state, and value that remain accurate as the UI changes.
- Prefer visible text and native `<label>`, `<legend>`, `<caption>`, and heading relationships over invisible naming workarounds.
- Make every interaction available from a keyboard without a pointer, timing trick, or custom key sequence.
- Preserve a logical tab order; avoid positive `tabindex` values and use roving focus only for a widget that needs it.
- Keep the browser focus indicator visible, obvious, and not hidden behind sticky headers or overlays.
- Use `:focus-visible` for keyboard-focused styling when pointer focus should look different, but do not remove `:focus` without an equivalent indicator.
- Do not convey meaning through color alone; pair color with text, shape, position, or another persistent cue.
- Check text contrast, control contrast, and focus contrast against WCAG 2.2 requirements for the product's conformance target.
- Let text resize to at least 200 percent without clipped content, overlapping controls, or lost functionality.
- Make content reflow at narrow widths without unnecessary two-dimensional scrolling; preserve two-dimensional scrolling only when the content requires it.
- Honor `prefers-reduced-motion`; remove or replace nonessential movement rather than merely slowing every animation.
- Support high contrast, forced colors, dark mode, and user styles without encoding essential information in backgrounds alone.
- Add a skip link or another bypass mechanism when repeated navigation would otherwise delay the main content.
- Keep error, status, and loading messages perceivable and associated with the affected control or region.
- Inspect landmarks and the accessibility tree instead of assuming that visually correct markup is accessible.
