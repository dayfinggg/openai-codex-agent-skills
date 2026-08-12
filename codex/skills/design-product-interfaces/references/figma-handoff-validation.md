# Figma, Handoff, and Validation

Use this reference to keep design files responsive, systematic, inspectable, and ready for implementation.

## Structure the Figma file

1. Use clear pages and sections for explorations, approved flows, components, and handoff. Mark obsolete work instead of leaving competing final states unlabeled.
2. Name frames, layers, components, properties, variables, and modes semantically. Mirror repository terminology when a code design system already exists.
3. Use Auto Layout for content-driven relationships. Prefer hug, fill, minimum, and maximum behavior over fixed positioning; ignore Auto Layout only for intentional overlays or spatial relationships.
4. Nest layouts only when each frame expresses a real group or resizing rule. Avoid wrapper layers that exist solely to reproduce arbitrary geometry.
5. Resize every major frame and replace labels, data, and media with short, long, missing, and localized examples. Repair overflow, clipping, accidental reordering, and brittle fixed dimensions before handoff.

## Encode the system

1. Map recurring color, spacing, sizing, typography, radius, elevation, and motion decisions to existing styles or semantic variables where supported.
2. Use modes for verified contexts such as theme, contrast, density, platform, or brand. Do not duplicate frames when a mode or component property represents the variation accurately.
3. Create components for repeated, governed interface elements. Use variants and component properties for meaningful state, size, emphasis, or configuration axes.
4. Keep component sets comprehensible. Avoid combinatorial variants for unrelated content or every possible layout.
5. Link design tokens and components to code conventions when available. Preserve source-of-truth ownership instead of silently creating a second system.

## Prototype critical behavior

1. Prototype the shortest path that proves navigation, sequence, overlays, focus transitions, state changes, and recovery for critical or ambiguous flows.
2. Include failure, cancellation, destructive confirmation, loading, and return paths when they affect the design decision.
3. Use motion to explain causality or spatial continuity. Record reduced-motion behavior and avoid polishing transitions before the flow is sound.
4. Treat a prototype as a behavioral model, not evidence that implementation, accessibility, or user validation has passed.

## Hand off decisions, not screenshots

1. Annotate behavior, content rules, state transitions, responsive changes, truncation and overflow, localization, accessibility, data constraints, and unresolved questions.
2. Supply a state matrix and acceptance criteria for behavior that cannot be inferred from a static frame.
3. Mark reviewed frames or sections ready only after their design, content, components, states, annotations, and product-specific visual thesis agree. If art direction is outside scope or unresolved, record that explicitly rather than implying readiness.
4. Use Dev Mode inspection and version comparison where available. Do not treat generated code snippets as production implementation without repository-aware review.

## Validate the design

1. Inspect at actual display size rather than relying on a zoomed-out canvas. Check hierarchy, type rendering, control prominence, density, and visual rhythm.
2. Compare compact, intermediate, and expanded viewports plus relevant orientation and input changes. Choose exact widths from observed content failures, not a universal breakpoint list. Without a resizable artifact or representative content, document the intended transitions and defer numeric widths.
3. Exercise realistic content extremes, localization, right-to-left layout when relevant, empty and error states, text resize, zoom, reflow, reduced motion, and forced colors.
4. Compare the implementation visually with the approved design when code exists, then inspect behavior in the browser or target platform. Assign browser tests and user testing to the implementation or validation workflow.
5. Record what was inspected, deviations accepted, defects found, open assumptions, and tests still required. Do not call the design polished or validated without this evidence.

## Evidence classes

1. Treat Figma documentation as tool mechanics, not design-quality rules.
2. Treat local design-system libraries, code mappings, approved components, and handoff conventions as project requirements when verified.
3. Treat viewport choices, component boundaries, and fidelity as project decisions justified by content and delivery risk.

## Sources

1. [Figma: Guide to Auto Layout](https://help.figma.com/hc/en-us/articles/360040451373-Guide-to-auto-layout)
2. [Figma: Guide to Variables](https://help.figma.com/hc/en-us/articles/15339657135383-Guide-to-variables-in-Figma)
3. [Figma: Guide to Components](https://help.figma.com/hc/en-us/articles/360038662654-Guide-to-components-in-Figma)
4. [Figma: Create and Use Variants](https://help.figma.com/hc/en-us/articles/360056440594-Create-and-use-variants)
5. [Figma: Guide to Prototyping](https://help.figma.com/hc/en-us/articles/360040314193-Guide-to-prototyping-in-Figma)
6. [Figma: Guide to Dev Mode](https://help.figma.com/hc/en-us/articles/15023124644247-Guide-to-Dev-Mode)
7. [Figma Developer Docs: Structure a File for Better Code](https://developers.figma.com/docs/figma-mcp-server/structure-figma-file/)
