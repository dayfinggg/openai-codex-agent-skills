# Layout and component styling

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
