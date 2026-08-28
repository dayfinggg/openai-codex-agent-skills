---
name: design
description: Direct product UX and visual design for interfaces, pages, dashboards, forms, and design systems. Use for new interfaces that require design decisions, redesigns, visual audits, design-system work, or pixel-accurate acceptance; do not invoke for routine frontend implementation that preserves an established design.
---

# Design

Create an interface that belongs to this product, audience, task, and content. Make it useful before expressive, with a clear visual point of view that preserves familiarity, accessibility, and speed of comprehension.

## Own the design boundary

This skill owns user goals, flow, information architecture, content hierarchy, composition, visual language, interaction states, responsive priorities, accessibility intent, and visual acceptance. The frontend skill owns framework, component, state, data, rendering, compatibility, performance, and build decisions. The accessibility skill owns barrier prevention, semantic and assistive-technology behavior, and conformance evidence.

Routine implementation that preserves an established design belongs to frontend. Activate this skill only when a visual, interaction, information-architecture, or product-experience decision is material, or when visual acceptance must be evaluated. When several skills apply, express design decisions as measurable experience criteria instead of prescribing engineering structure.

Preserve an existing design system, brand, reference, and product language unless the request changes them. A redesign must remain recognizably related to the product and its users.

## Ground the direction

1. Identify the primary users, task, frequency, environment, expertise, device mix, constraints, and decision or action the screen must enable.
2. Inspect existing screens, tokens, components, content, data shape, brand assets, interaction conventions, and visual references before choosing a direction.
3. Define what the user must understand, see, or do first. Map the material states and transitions, including loading, partial, empty, validation, failure, success, disabled, permission, and narrow-viewport states when applicable.
4. State the art direction through concrete composition, density, typography, color, imagery, and interaction choices. Avoid mood words that do not constrain a decision.

Do not invent metrics, testimonials, customers, activity, alerts, avatars, charts, or content to fill a screen. Use task-derived sample data. When a prototype needs records but no data contract exists, use generic structural records, derive displayed totals from them, and label the dataset as demonstrative.

On product and operational screens, summaries, filters, onboarding, and explanation must not delay the primary work below the first mobile viewport. Collapse, reorder, or move secondary information when needed.

## Remove generated-UI defaults

- Do not add a generic marketing hero when the product, service, or evidence can communicate value directly.
- Do not place every section, statistic, control, or sentence in rounded cards or nest cards to manufacture hierarchy. Use grouping, alignment, whitespace, rules, tables, and shared surfaces; every container needs a real semantic or interaction boundary.
- Avoid decorative gradients, blobs, glows, glass panels, ornaments, random accents, oversized background shapes, and filler icons, shadows, motion, or illustrations unless they clarify hierarchy, state, brand, data, or action.
- Avoid oversized headings, sparse first screens, interchangeable metric tiles, feature grids, testimonial strips, badge clouds, pill-heavy navigation, and repeated calls to action without a product-specific reason.
- Do not narrate obvious gestures, implementation, or acceptance criteria in the interface. Use familiar controls, direct labels, contextual help, and visible state feedback.
- Remove promotional language, vague claims, generic reassurance, forced enthusiasm, fake charts, and text that could appear unchanged in another product.

Avoiding generic output does not mean a sterile gray wireframe. Use deliberate proportion, contrast, typography, imagery, rhythm, and occasional asymmetry. Make one or two strong choices and support them consistently.

## Load conditional guidance

Read only the references triggered by the task:

1. Read [visual foundations](references/foundations.md) when changing typography, spacing, grid, color, density, responsive behavior, localization, or design-system tokens.
2. Read [product patterns](references/product-patterns.md) when designing forms, dashboards, navigation, workflows, empty or loading states, errors, permissions, destructive actions, or dense operational UI.
3. Read [visual verification](references/visual-qa.md) before implementing a material visual change, matching a reference, declaring a rendered design complete, or performing screenshot, responsive, pixel, or visual-regression review.

Visual evidence is required for affected visual behavior, but its scope must match the change and available project tooling.

## Render, inspect, and revise

Do not judge changed visual behavior from source code alone.

1. Run the real application or narrowest faithful preview with representative content and deterministic state.
2. Capture the affected states at viewports that can expose the changed risk. Use desktop and mobile when responsive composition, priority, wrapping, or navigation changed; do not require unrelated viewports for a fixed local change.
3. Inspect hierarchy, balance, density, line length, wrapping, clipping, overlap, alignment, controls, focus, and first-screen priority as applicable.
4. Measure DOM geometry and computed styles when exact dimensions or alignment are part of acceptance, a supplied reference must be matched, or inspection cannot resolve the question.
5. Create an annotated overlay or pixel guide only for pixel-accurate work, repeated alignment drift, or a reference comparison where it answers a concrete question.
6. Fix the largest structural problem first, render again, and recheck every affected state or viewport. Reuse established visual-regression infrastructure; do not add a framework or broad baseline set for one narrow change.
7. Keep temporary screenshots, overlays, measurements, and baselines out of production assets unless requested.

Report only checks actually performed. Name material viewports, states, artifacts, overflow and font results, and geometry or comparison evidence. If rendering tools are unavailable, report the limitation instead of treating source inspection as visual proof.

## Final audit

Reject or revise the result if any applicable answer is no.

1. Can the intended user identify the screen's purpose and primary action immediately?
2. Does information order match the user's task rather than implementation structure?
3. Does the interface have a product-specific direction without generic heroes, card grids, gradients, fake data, or decorative filler?
4. Are typography, spacing, grid, color, density, and states internally consistent with the existing or compact token system?
5. Do loading, empty, partial, error, success, disabled, focus, hover, and permission states explain what happened and the next action?
6. Does content reflow across affected viewports without overflow, clipping, overlap, inaccessible targets, or lost priority?
7. Do contrast, focus, semantics, status feedback, zoom, text resizing, keyboard use, and reduced motion meet the applicable accessibility standard?
8. Can the layout tolerate required localization, longer text, formats, and right-to-left direction?
9. Was the affected visual behavior rendered and inspected with proportionate evidence, and were material defects corrected?
