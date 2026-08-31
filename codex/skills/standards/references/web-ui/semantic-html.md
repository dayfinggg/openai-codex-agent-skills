# Semantic HTML

- Start every document with `<!doctype html>`, a UTF-8 declaration, a useful `<title>`, and the correct `lang` value.
- Choose elements by meaning, not by their default appearance or the convenience of a selector.
- Use `<main>` for the dominant content, `<nav>` for navigation, `<article>` for independently reusable content, and `<aside>` for indirectly related content.
- Use `<section>` only for a meaningful standalone section, and give it a heading in the normal case.
- Build a heading hierarchy that reflects the content tree; do not choose a heading level only to obtain a font size.
- Keep source order equal to reading and interaction order; do not make CSS `order` or grid placement contradict the document.
- Use `<a href>` for navigation and `<button>` for actions, including actions implemented by JavaScript.
- Use lists for lists, tables for tabular data, `<figure>` and `<figcaption>` for figures, and `<time>` for machine-readable dates.
- Use `<div>` and `<span>` as generic containers only when no more specific element fits.
- Give informational images useful `alt` text, functional images an action-oriented name, and decorative images `alt=""`.
- Keep markup shallow when an extra wrapper has no semantic, layout, or scripting purpose.
