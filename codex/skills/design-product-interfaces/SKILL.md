---
name: design-product-interfaces
description: Design, critique, or prepare Figma handoffs when product-interface judgment remains. Use for flows, hierarchy, art direction, states, and accessibility; exclude fixed-design builds and standalone bitmap work.
---

# Design Product Interfaces

Lead design-stage product-interface decisions. Produce a coherent, usable product specification rather than decoration or an isolated mood board.

## Work from evidence

1. Inspect the product, repository, content, users, primary tasks, platform constraints, brand, and existing design system before proposing changes. Preserve established patterns unless the task authorizes a redesign.
2. Distinguish normative requirements, platform guidance, contextual heuristics, and project decisions. Resolve conflicts in that order, while treating verified project constraints as binding.
3. Proceed from missing details with bounded, explicit assumptions and reversible choices. Do not invent product capabilities, metrics, testimonials, logos, research findings, test results, or stakeholder decisions.
4. Do not claim accessibility conformance, user validation, or visual polish without the corresponding evidence and checks.

## Load references deliberately

1. Read [visual-direction.md](references/visual-direction.md) when establishing or critiquing art direction, brand expression, imagery, color, shape, or visual hierarchy.
2. Read [typography-layout.md](references/typography-layout.md) when defining type roles, spacing, density, grids, responsive behavior, or localization resilience.
3. Read [interaction-accessibility.md](references/interaction-accessibility.md) when designing flows, controls, states, feedback, motion, or accessibility acceptance criteria.
4. Read [figma-handoff-validation.md](references/figma-handoff-validation.md) when working in Figma, preparing annotated specifications, or validating a design for implementation.

## Design the interface

1. Frame the users, jobs, context, content, primary outcome, critical constraints, and failure costs. Prioritize the dominant task instead of giving every element equal weight.
2. Map product information architecture, navigation, core flows, decision points, recovery paths, and progressive disclosure before styling screens.
3. For every direction or critique, document at least one representative operational flow from entry through progress, success, cancellation or interruption, recovery, and return. Cover loading, empty, permission, offline or synchronization failure, and other relevant states; explicitly mark genuinely inapplicable states.
4. When no design exists, choose one product-specific visual thesis tied to audience, content, platform, and brand. Consider credible alternatives, then commit to the direction with the clearest rationale.
5. Establish semantic type, color, spacing, shape, elevation, imagery, iconography, and motion roles. Choose actual values from content, platform conventions, existing tokens, and testing; do not impose universal pixel scales, grids, breakpoints, line lengths, or animation timings.
6. Build content-first hierarchy with readable type roles, contextual line measure, grouping by proximity, intentional density, real representative content, and room for localization, zoom, text growth, and data extremes.
7. Define applicable default, hover, focus, pressed, selected, disabled, loading, empty, error, success, offline, and permission states. Specify transitions, system feedback, recovery, and destructive-action safeguards.
8. Make critiques implementation-ready: define replacement semantic type roles, density, and compact, intermediate, and expanded transformations instead of stopping at motif removal or container rearrangement.
9. Keep conventional controls recognizable. Create distinctiveness through product content, hierarchy, voice, art direction, data, and brand rather than unfamiliar interaction mechanics.
10. Treat gradients, glass effects, glows, bento grids, cards, pills, oversized type, illustrations, and motion as review triggers, not bans. Keep a motif only when it materially supports brand, content, hierarchy, or interaction; remove it when nothing meaningful worsens.
11. Reject card soup, nested containers without structural purpose, equal-weight layouts, vague copy, fake social proof, decorative charts, generic AI imagery, arbitrary typeface defaults, and missing states.
12. Adapt structure and density to the platform and available space. Verify the design at actual size, with representative content, and across compact, intermediate, and expanded viewports rather than scaling one canvas mechanically. Without a resizable artifact or representative content, name the intended transitions but leave exact numeric breakpoints unresolved.

## Meet design-stage accessibility

1. Use WCAG 2.2 AA as the web baseline and applicable platform accessibility guidance elsewhere.
2. Define acceptance criteria for keyboard operation, logical and visible focus, focus not obscured, contrast, non-color cues, target operability, text resize, zoom, reflow, reduced motion, forced colors, labels, errors, and status feedback where applicable.
3. Require manual checks for keyboard, focus, zoom, reflow, reduced motion, and forced colors. Treat automated tools as supporting evidence, not proof.

## Prepare the handoff

1. In Figma, use Auto Layout, semantic variables, components, variants, modes, and clear layer names where relevant. Resize frames and replace content to expose brittle constraints before handoff.
2. Deliver the visual thesis, flow and hierarchy, annotated screens, component and token decisions, state matrix, responsive rules, accessibility criteria, assumptions, and unresolved risks at the fidelity the task needs.
3. A Figma handoff is not ready until it identifies where the product-specific visual thesis is recorded and shows at least three domain-specific manifestations across type, color, geometry, data, imagery, or motion. Otherwise mark art direction explicitly outside scope or unresolved.
4. Separate verified facts from design decisions and validation still required. Do not mark work ready when critical content, states, responsive behavior, or acceptance criteria remain undefined.

## Gate delivery

Before the final response, audit the result against these completion fields:

1. One continuous primary flow explicitly names entry, progress, success, cancellation or interruption, failure and recovery, and the return destination. Fragmented state notes do not satisfy this field.
2. Semantic type roles are named with their hierarchy and use. Density is specified through concrete spacing, control, row, content, and disclosure behavior across compact, intermediate, and expanded layouts; adjectives alone do not satisfy this field.
3. Compare the selected direction with one credible alternative across every named axis: typography, geometry, data treatment, surfaces, imagery, and motion. For each axis, state the chosen treatment, the alternative, why the choice supports the product, and what materially worsens if it is removed or reduced. Treat restraint or intentional absence as a choice that still requires this removal test.
4. Use the exact layout names compact, intermediate, and expanded when mapping responsive behavior. Every missing field is identified as genuinely inapplicable, outside scope, or an unresolved blocker with a reason. Do not claim the design or handoff is complete while a required field is absent.

## Respect ownership boundaries

1. Use this skill only while product-interface judgment remains. For a fixed approved UI with no unresolved design decisions, use `$build-web-frontends` and `$engineer-production-code` without redesign. For design-and-build work, apply this skill first, then those implementation skills.
2. Use `$imagegen` for standalone bitmap rendering or editing. This skill may define interface direction and asset constraints before raster delivery, but it does not render the bitmap.
3. Use `$initialize-project` for project scaffolding and `$design-software-architecture` for software architecture. Keep product information architecture in this skill.
4. Assign browser validation and moderated or unmoderated user testing to the implementation or validation workflow; define their acceptance criteria here without claiming their results.
