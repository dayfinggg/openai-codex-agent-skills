---
name: design
description: Direct product UX and visual design for interfaces, pages, dashboards, forms, and design systems. Use for new UI, redesigns, visual audits, interaction flows, responsive composition, product states, or pixel-accurate visual verification; own user goals, information architecture, hierarchy, typography, color, density, and art direction while leaving framework and frontend engineering decisions to the frontend skill.
---

# Design

Create an interface that belongs to this product, audience, task, and content. Make it useful before making it expressive, then give it a clear visual point of view without sacrificing familiarity, accessibility, or speed of comprehension.

## Own the design boundary

This skill owns product intent, user flow, information architecture, content hierarchy, composition, visual language, interaction states, responsive behavior, accessibility intent, and visual quality.

The frontend skill owns implementation architecture, framework patterns, component engineering, data fetching, state management, browser compatibility, performance, and build tooling. When both apply, provide design decisions and measurable acceptance criteria; do not prescribe engineering structure unless it changes the experience.

If the user supplies an existing design system, brand, reference image, or product surface, preserve it unless the request is to change it. A redesign must still feel related to the product and its users, not like a template pasted over the old interface.

## Ground the direction

1. Identify the primary users, their goal, frequency of use, environment, expertise, device mix, constraints, and the decision or action the screen must enable.
2. Inspect existing screens, tokens, components, content, data shape, brand assets, interaction conventions, and visual references before choosing a direction.
3. Define the first-screen priority: what the user must understand, see, or do without scrolling, opening help, or decoding decorative copy.
4. Map the required states and transitions, including first use, populated, loading, partial, empty, validation error, system error, success, disabled, no permission, and narrow viewport when applicable.
5. State the art direction in concrete terms such as composition, density, type treatment, color behavior, imagery, and interaction rhythm. Avoid vague mood words that do not constrain a design decision.

Do not invent product metrics, testimonials, customers, activity, alerts, avatars, charts, or content to make a screen look complete. Use truthful sample data clearly derived from the task. When a prototype needs records but no data contract exists, use generic structural records, derive every displayed count from them, and label the experience or dataset as demonstrative so it cannot be mistaken for live product truth.

On product and operational screens, supporting summaries, filters, onboarding, and explanation must not push the primary working content below the first mobile viewport. Collapse, reorder, or move secondary information when it delays the user's task.

## Remove generated-UI defaults

- Do not add a generic marketing hero to a product screen or a landing page whose value is better shown through the actual product, service, or evidence.
- Do not put every section, statistic, control, or sentence in a rounded card. Use grouping, alignment, whitespace, rules, tables, and shared surfaces before adding another container.
- Do not nest cards to manufacture hierarchy. A container must correspond to a real semantic or interaction boundary.
- Avoid decorative gradients, blurred blobs, glows, glass panels, floating ornaments, random accent lines, and oversized background shapes unless they express an established brand or content concept.
- Avoid oversized headings and sparse first screens that delay useful content. Scale type from the information hierarchy and available viewport, not from a landing-page template.
- Avoid rows of interchangeable metric cards, icon-label-feature grids, testimonial strips, badge clouds, pill-heavy navigation, and repeated call-to-action blocks without a product-specific reason.
- Do not print instructions that narrate the interface, implementation, or obvious gestures. Use familiar controls, direct labels, contextual help at the point of need, and visible state feedback.
- Do not use color, icons, shadows, motion, or illustrations as filler. Each must clarify hierarchy, state, brand, data, or action.
- Remove promotional language, vague claims, generic reassurance, forced enthusiasm, and text that could appear unchanged in another product.

Avoiding slop does not mean producing a sterile gray wireframe. Use deliberate proportion, contrast, typography, imagery, rhythm, and occasional asymmetry to create character. Make one or two strong choices and support them consistently instead of applying many weak effects.

## Load conditional guidance

Before editing, read every reference triggered by the task. The summary in this file does not replace the detailed constraints. For any rendered UI, read visual verification before the first render.

1. Read [visual foundations](references/foundations.md) when establishing or changing typography, spacing, grid, color, density, responsive behavior, localization, or design-system tokens.
2. Read [product patterns](references/product-patterns.md) when designing forms, dashboards, navigation, workflows, empty or loading states, errors, permissions, destructive actions, or dense operational UI.
3. Read [visual verification](references/visual-qa.md) before declaring any rendered interface complete, or whenever the request involves visual accuracy, screenshots, responsive QA, pixel comparison, or design review.

Load only the references that affect the request. Visual verification is required for implemented or modified UI even when the user does not explicitly ask for screenshots.

## Render, inspect, and revise

Do not judge a rendered interface from source code alone.

1. Run the real application or the narrowest faithful preview with representative content and deterministic state.
2. Capture full-page and focused screenshots at representative desktop and mobile viewports. Include every state affected by the change, not only the ideal populated state.
3. Open and inspect the screenshots. Check hierarchy, balance, density, line length, wrapping, clipping, overlap, alignment, controls, focus, and the first-screen experience.
4. Measure actual DOM geometry and computed styles for key anchors. Verify container edges, columns, gutters, repeated baselines, control dimensions, typography, spacing, scroll dimensions, and loaded fonts.
5. Produce at least one temporary annotated overlay for an implemented interface. Draw guides on the screenshot for container edges, columns, baselines, repeated component bounds, centers, and measured gaps; inspect visible drift instead of estimating it by eye.
6. Fix the largest structural problem first, render again, and repeat until screenshots and measurements satisfy the design intent. Do not mask layout problems with screenshot tolerances.
7. Recheck desktop and mobile after every structural change. A correction at one width is incomplete if it creates overflow, truncation, or a broken hierarchy at another.

Keep QA screenshots, overlays, and measurements out of production assets unless the user requests them as deliverables.

Do not claim visual verification without naming the inspected desktop and mobile viewport sizes, screenshot and overlay paths, horizontal-overflow result, loaded font result, and the key geometry measurements used to accept the layout. If a browser or screenshot tool is unavailable, report that limitation instead of treating source inspection as visual proof.

## Final audit

Reject or revise the result if any answer is no.

1. Can the intended user identify the screen's purpose and primary action immediately?
2. Does the information order match the user's task rather than the implementation or organization structure?
3. Does the interface have a product-specific visual point of view without generic heroes, card grids, gradients, fake data, or decorative filler?
4. Are typography, spacing, grid, color, density, and component states internally consistent and tied to a compact token system or the existing design system?
5. Do loading, empty, partial, error, success, disabled, focus, hover, and permission states communicate what happened and what the user can do next?
6. Does content reflow across desktop and mobile without horizontal overflow, unintended clipping, overlap, inaccessible targets, or lost priority?
7. Do contrast, focus, semantics, status feedback, zoom, text resizing, keyboard use, and reduced motion meet the applicable accessibility standard?
8. Can the layout tolerate longer localized text, different number and date formats, and right-to-left direction when the product requires localization?
9. Were the final screenshots inspected, key geometry measured, fonts verified, pixel guides used where needed, and all observed defects corrected?
