# Framework-independent web UI

Use this reference for HTML, CSS, forms, accessibility, responsive UI, and browser-facing interactions.
Treat semantic meaning, user needs, browser behavior, and measured evidence as higher priorities than visual novelty.
Prefer native platform behavior and the smallest complete solution.
Verify both the rendered result and the underlying document, accessibility tree, and CSS behavior.

## Semantic HTML

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

## Accessibility

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

## Forms

- Use one `<form>` per coherent submission task and never nest forms.
- Group related controls with `<fieldset>` and label each group with `<legend>`.
- Associate every control with a visible `<label>` using matching `for` and `id` values, or use an explicit equivalent when a visible label cannot be shown.
- Do not use placeholder text as the only label; it disappears during input and has weak contrast in many user agents.
- Choose the input type that matches the data, such as `email`, `tel`, `url`, `date`, or `number`, and use `inputmode` only to refine input method.
- Give submitted controls stable `name` values and provide appropriate `autocomplete` tokens for information the user may reuse.
- Set `type="button"` for non-submitting buttons and state the intended submit behavior explicitly.
- Use native constraints such as `required`, `min`, `max`, `minlength`, `maxlength`, `pattern`, and the appropriate input type when they express the rule.
- Explain required formats before submission and show errors in text that identifies the field and the correction.
- Associate dynamic help and errors with `aria-describedby` or the relevant native relationship, and update focus deliberately after failed submission.
- Treat client-side validation as feedback, not as a security boundary; validate and authorize again on the server.
- Do not submit on change unless the behavior is expected, announced, and usable from a keyboard and assistive technology.
- Preserve entered values and useful focus when a submission or network request fails.

## Responsive design

- Include the viewport metadata needed for a mobile user agent to lay out the page at the device width.
- Let content determine breakpoints; add a media query when the content or interaction actually needs a change.
- Build a usable narrow layout first, then add enhancements for wider space rather than maintaining device-specific copies.
- Prefer normal flow, intrinsic sizing, flexible tracks, `minmax()`, `clamp()`, `min()`, `max()`, and `fit-content()` over fixed canvas coordinates.
- Constrain reading measure with `max-inline-size` and keep widths, gaps, and padding flexible.
- Use `@media` for viewport or user-preference conditions and `@container` for a component's available space.
- Provide a useful fallback before a container-query or other modern feature, then gate the enhancement with `@supports` when necessary.
- Use logical properties and values such as `inline-size`, `block-size`, `margin-inline`, and `inset-block` when direction or writing mode can vary.
- Make replaced content shrink safely with an appropriate aspect ratio, `max-inline-size: 100%`, and `block-size: auto` where applicable.
- Avoid fixed heights for content containers; allow longer labels, translations, zoom, and user text to expand them.
- Test narrow, wide, tall, short, zoomed, touch, keyboard, RTL, and vertical-writing contexts when they are in scope.
- Keep responsive rules close to the component rules they modify so later changes do not drift from their owner.

## Cascade, layers, and tokens

- Reason about cascade origin, importance, layer order, specificity, scoping proximity, and source order in that sequence.
- Declare an intentional layer order, such as reset, base, components, utilities, and overrides, before rules grow numerous.
- Keep selector specificity low so a component can be changed without `!important` or selector escalation.
- Prefer classes, attributes, and state pseudo-classes over IDs and long descendant chains for styling.
- Use `:where()` to keep a shared selector easy to override and `@scope` when a supported subtree boundary expresses ownership more clearly.
- Keep third-party CSS in a named low-priority layer when it must be included, and document any deliberate exception.
- Avoid network `@import`; use stylesheet links or the build system so dependencies are visible and loadable earlier.
- Keep declarations, media queries, and feature queries near the rule or component they own.
- Use custom properties for repeated, meaningful design decisions such as color roles, spacing steps, radii, and type scales.
- Name tokens by purpose, such as `--surface-raised` or `--space-3`, rather than by a temporary color or component location.
- Define global tokens at `:root`, override them at a clear theme or component boundary, and supply fallbacks where support or inheritance can fail.
- Do not create a token for every one-off value; a token should represent a repeated decision or a stable customization point.

## Layout and component styling

- Use normal flow for documents, Flexbox for one-dimensional distribution, and Grid for two-dimensional relationships.
- Use `gap`, alignment properties, and intrinsic sizing before adding spacer elements, empty nodes, or margin hacks.
- Reserve absolute positioning for overlays or elements whose removal from flow is intentional, not for the primary page skeleton.
- Treat `z-index` as a small, documented stacking scale; avoid arbitrary large values that hide ownership problems.
- Give each component a clear root, parts, states, and variants; keep its contract independent of unrelated page structure.
- Choose one naming convention and apply it consistently; lowercase dashed names and a component prefix are readable defaults.
- Name classes by role or purpose, such as `.card__title` or `.button--danger`, not by current color, position, or pixel dimensions.
- Use separate behavior hooks such as `.js-*` or `data-*` when script selectors should not carry styling meaning.
- Scope component selectors to their root, avoid brittle DOM-depth chains, and avoid styling arbitrary descendants that the component does not own.
- Use explicit state attributes or classes, including reflected ARIA state where appropriate, instead of inferring state from incidental markup.
- Keep variants small and composable; split a component when variants need incompatible semantics or lifecycle rules.

## Progressive enhancement

- Make the content and essential task work in semantic HTML before adding CSS and JavaScript.
- Use feature detection, not browser sniffing; test the declaration or API that the enhancement actually needs.
- Write a usable fallback first, then add new CSS inside `@supports` or add behavior after capability detection.
- Remember that unsupported CSS declarations are discarded, while an invalid selector list can discard the whole rule; use forgiving selectors where appropriate.
- Let native links, forms, buttons, validation, history, and focus behavior provide the baseline before intercepting them.
- Do not hide essential content behind a client-only render or turn a working control into a loading placeholder.
- Provide an understandable alternative when an enhancement cannot run, and test the page with CSS and JavaScript disabled.

## Performance

- Measure the user path before optimizing; use browser traces, network waterfalls, and real-user data rather than intuition.
- Keep the DOM, critical CSS, selector work, and shipped assets proportional to the page's actual needs.
- Remember that stylesheets can block first render; remove unused CSS, split genuinely route-specific CSS, and avoid oversized critical styles.
- Avoid unnecessary layout work and layout thrashing; batch DOM reads separately from writes and profile before choosing a workaround.
- Reserve image and media space with intrinsic dimensions or aspect ratios to reduce layout shifts.
- Prefer CSS and native HTML for simple visual states; do not add a dependency or client-side abstraction for a trivial platform feature.
- Do not apply `will-change`, forced layers, or compositor-oriented tricks globally; verify the cost and benefit in a trace.
- Load noncritical resources only when they are needed, but do not lazy-load content required for the initial user-visible result.
- Treat Lighthouse and DevTools as diagnostic tools, and use field data or RUM to judge real-world Core Web Vitals.
- Use browser-engineer guidance as a hypothesis, then confirm the cost in the target browser with a trace.

## Verification

- Run the project's formatter, linter, build, and focused tests, then inspect the final HTML and CSS diff.
- Validate HTML and CSS with the Nu Html Checker or the repository's equivalent conformance checker.
- Test with keyboard only from entry to completion, including menus, dialogs, errors, and dynamically inserted content.
- Check the accessibility tree for names, roles, values, landmarks, heading levels, descriptions, and live updates.
- Test at 200 percent text or page zoom, narrow reflow, long labels, large text, high contrast, forced colors, and reduced motion.
- Test loading and interaction on a throttled connection with empty and warm caches to expose shifts and blocking work.
- Test representative current engines and devices, and consult compatibility data before adopting a feature that lacks a safe fallback.
- Combine automated audits with manual review; automated tools cannot judge every label, reading order, interaction, or user expectation.
- Test meaningful states such as empty, loading, success, failure, disabled, selected, invalid, and permission-limited states.
- Use maintained W3C APG and MDN CSS examples as executable references, and keep validation or lint checks in CI where appropriate.

## Avoiding utility and abstraction excess

- Keep semantic component classes as the primary styling contract when they make the UI easier to read and change.
- Use utilities for genuinely repeated single-purpose rules or layout primitives, not as a class for every declaration.
- Do not encode page meaning in a pile of presentational classes that obscures the component's structure and state.
- Do not add a wrapper, variant, token, mixin, utility, or design-system layer without a current use and a clear owner.
- Prefer a small amount of visible repetition over a generic abstraction with flags, hidden coupling, or unused extension points.
- Reuse stable knowledge, not coincidental selector shapes; split abstractions when callers need incompatible behavior.
- Delete unused CSS, markup, dependencies, and hooks instead of preserving them for hypothetical future screens.
- Record exceptions when compatibility, browser behavior, or measured performance justifies a less obvious rule.

## Sources

### Web standards and official documentation

- [WHATWG HTML Living Standard: DOM and semantics](https://html.spec.whatwg.org/multipage/dom.html)
- [WHATWG HTML Living Standard: forms](https://html.spec.whatwg.org/multipage/forms.html)
- [MDN: HTML elements reference](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements)
- [MDN: HTML as a basis for accessibility](https://developer.mozilla.org/en-US/docs/Learn_web_development/Core/Accessibility/HTML)
- [MDN: Forms and buttons in HTML](https://developer.mozilla.org/en-US/docs/Learn_web_development/Core/Structuring_content/HTML_forms)
- [MDN: How to structure a web form](https://developer.mozilla.org/en-US/docs/Learn_web_development/Extensions/Forms/How_to_structure_a_web_form)
- [MDN: Constraint Validation API](https://developer.mozilla.org/en-US/docs/Web/HTML/Guides/Constraint_validation)
- [MDN: `autocomplete` attribute](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Attributes/autocomplete)
- [W3C WAI: Developing for Web Accessibility](https://www.w3.org/WAI/tips/developing/)
- [W3C WAI: Labeling Controls](https://www.w3.org/WAI/tutorials/forms/labels/)
- [W3C WAI APG: Accessible Names and Descriptions](https://www.w3.org/WAI/ARIA/apg/practices/names-and-descriptions/)
- [W3C WAI APG: HTML Sectioning Elements and Landmarks](https://www.w3.org/WAI/content-assets/wai-aria-practices/patterns/landmarks/examples/HTML5.html)
- [W3C: Web Content Accessibility Guidelines 2.2](https://www.w3.org/TR/WCAG22/)
- [W3C: WCAG 2.2 Understanding Resize Text](https://www.w3.org/WAI/WCAG22/Understanding/resize-text)
- [W3C: WCAG 2.2 Understanding Non-text Contrast](https://www.w3.org/WAI/WCAG22/Understanding/non-text-contrast.html)
- [MDN: Cascade layers](https://developer.mozilla.org/en-US/docs/Learn_web_development/Core/Styling_basics/Cascade_layers)
- [MDN: Specificity](https://developer.mozilla.org/en-US/docs/Web/CSS/Guides/Cascade/Specificity)
- [MDN: CSS custom properties](https://developer.mozilla.org/en-US/docs/Web/CSS/Guides/Cascading_variables/Using_custom_properties)
- [MDN: Grid layout basics](https://developer.mozilla.org/en-US/docs/Web/CSS/Guides/Grid_layout/Basic_concepts)
- [MDN: Flexbox basics](https://developer.mozilla.org/en-US/docs/Web/CSS/Guides/Flexible_box_layout/Basic_concepts)
- [MDN: Logical properties and values](https://developer.mozilla.org/en-US/docs/Web/CSS/Guides/Logical_properties_and_values/Basic_concepts)
- [MDN: `@scope`](https://developer.mozilla.org/en-US/docs/Web/CSS/Reference/At-rules/@scope)
- [MDN: Feature queries and progressive enhancement](https://developer.mozilla.org/en-US/docs/Web/CSS/Guides/Conditional_rules/Using_feature_queries)
- [MDN: Progressive enhancement glossary](https://developer.mozilla.org/en-US/docs/Glossary/Progressive_Enhancement)
- [MDN: Keyboard-navigable JavaScript widgets](https://developer.mozilla.org/en-US/docs/Web/Accessibility/Guides/Keyboard-navigable_JavaScript_widgets)
- [MDN: `prefers-reduced-motion`](https://developer.mozilla.org/en-US/docs/Web/CSS/Reference/At-rules/@media/prefers-reduced-motion)
- [web.dev: Responsive web design basics](https://web.dev/articles/responsive-web-design-basics)
- [web.dev: Accessibility](https://web.dev/learn/design/accessibility)
- [web.dev: Optimize resource loading](https://web.dev/learn/performance/optimize-resource-loading?hl=en)
- [web.dev: Understand the critical path](https://web.dev/learn/performance/understanding-the-critical-path?hl=en)
- [web.dev: Avoid large, complex layouts and layout thrashing](https://web.dev/articles/avoid-large-complex-layouts-and-layout-thrashing?hl=en)
- [web.dev: Core Web Vitals workflows](https://web.dev/articles/vitals-tools)
- [Chrome for Developers: Inside look at a modern web browser](https://developer.chrome.com/blog/inside-browser-part3)

### Maintainer examples

- [W3C APG GitHub repository](https://github.com/w3c/aria-practices)
- [W3C APG Code Guide on GitHub](https://github.com/w3c/aria-practices/wiki/Code-Guide)
- [MDN CSS examples on GitHub](https://github.com/mdn/css-examples)
- [Nu Html Checker on GitHub](https://github.com/validator/validator)

### Practitioner talks and articles

- [Jake Archibald: Progressive enhancement is faster](https://jakearchibald.com/2013/progressive-enhancement-is-faster/)
- [Jake Archibald: Solving rendering performance puzzles](https://jakearchibald.com/2013/solving-rendering-perf-puzzles/)
- [Jake Archibald: Don't use flexbox for overall page layout](https://jakearchibald.com/2014/dont-use-flexbox-for-page-layout/)
- [Rachel Andrew: CSS Layout from the Inside Out talk](https://2021.stateofthebrowser.com/speakers/rachel-andrew/)
- [Andy Bell: Be the browser's mentor, not its micromanager talk](https://heypresents.com/talks/be-the-browser-s-mentor-not-its-micromanager)
