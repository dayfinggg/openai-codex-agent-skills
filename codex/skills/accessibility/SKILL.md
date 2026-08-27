---
name: accessibility
description: Design, implement, review, and verify accessible user interfaces against the project's actual platform, assistive-technology support, and conformance target. Use automatically for any user-facing UI creation or change that can affect semantics, content, interaction, forms, visuals, media, responsive behavior, or focus; define accessibility invariants and tests without replacing frontend engineering or visual design.
---

# Accessibility

Prevent barriers in the source interface. Accessibility is a functional property of content, semantics, interaction, presentation, and platform behavior, not a post-processing layer or a score.

## Establish the applicable contract

1. Identify the interface technology, browser and device support, design system, component library, localization and writing-direction support, assistive-technology matrix, existing accessibility tests, and exact versions before changing behavior.
2. Find the declared legal, contractual, product, or organizational conformance target. If none exists, use WCAG 2.2 Level AA as the implementation baseline, while clearly avoiding a conformance claim without a complete evaluation of full pages and processes.
3. Trace the affected user task through every state and input method. Include loading, empty, validation, success, failure, disabled, expanded, selected, modal, asynchronous update, narrow viewport, zoom, long content, and localization states that can occur.
4. Translate relevant requirements into observable invariants for the changed surface. Name the user, barrier, expected behavior, test method, browser or assistive technology, and pass condition instead of adding generic accessibility acceptance text.
5. Preserve the existing design and frontend architecture unless they cause a demonstrated barrier. This skill owns accessibility requirements and proof; the design skill owns visual and experience direction, and the frontend skill owns framework, component, state, rendering, and dependency choices.

## Preserve native meaning and behavior

1. Start with valid semantic HTML and native controls. Use links for navigation, buttons for actions, headings for hierarchy, lists for collections, labels and fieldsets for forms, and data-table elements for tabular relationships.
2. Keep DOM order, reading order, focus order, and visual order logically aligned. Styling must not create an interaction sequence that contradicts the programmatic structure.
3. Prefer a native element over recreating it with scripts and ARIA. ARIA changes what assistive technology perceives; it does not add keyboard behavior, focus management, validation, or state synchronization.
4. Use ARIA only when native semantics cannot express the required interface. Apply a documented pattern, implement its complete keyboard and focus contract, keep name, role, value, properties, and states synchronized, and validate allowed role and attribute combinations.
5. Give every control an accessible name that describes its purpose. The visible label must be included in the accessible name, and repeated controls must remain distinguishable in context.
6. Expose dynamic status without stealing focus unless the task requires moving focus. Use live regions sparingly, initialize them before the update, and announce concise outcomes rather than entire rerendered containers.

Read [implementation invariants](references/implementation.md) when the change affects structure, custom widgets, keyboard behavior, focus, forms, errors, images, media, tables, language, direction, or cognitive accessibility.

## Make every task perceivable and operable

1. Support the complete task with a keyboard without timing-dependent keystrokes or traps. Keep focus visible, predictable, and unobscured; move it only when the interface context changes and restore it when a temporary surface closes.
2. Do not rely on color, position, shape, sound, hover, dragging, device motion, or a single pointer gesture as the only way to perceive information or perform an action. Provide a simple equivalent where the original interaction is not essential.
3. Maintain required text, control, state, and focus contrast in every theme and state. Preserve legibility under text resize, page zoom, narrow reflow, user text-spacing overrides, high contrast or forced colors where supported, and longer localized content.
4. Respect reduced-motion preferences and remove nonessential motion that can distract or cause illness. Pausable content, animation, auto-advance, time limits, and session expiry need controls and recovery appropriate to the task.
5. Make pointer targets satisfy the applicable minimum size or spacing, with larger practical targets for important actions. Ensure hover or focus disclosures are dismissible, hoverable, persistent while needed, and reachable without a pointer.
6. Use plain, specific language, consistent labels and navigation, recognizable controls, clear progress, forgiving input, and preservation of entered data. Do not make memory, transcription, or puzzle solving a prerequisite when a safer alternative is possible.

## Provide equivalent content

1. Write image alternatives from the image's purpose in context. Use an empty alternative for decoration, describe functional images by action, and provide nearby structured data or a long description for complex information.
2. Provide accurate captions for speech and meaningful non-speech audio, transcripts where required or useful, and audio description or an equivalent description for necessary visual information. Use a keyboard-operable accessible media player.
3. Mark data-table headers and their relationships, provide a useful caption when it identifies the table, and keep complex tables understandable at zoom and with screen-reader cell navigation. Never use data-table semantics for layout.
4. Declare the page language and language changes in content. Support correct text direction, bidirectional isolation, localized labels, formats, validation, and pronunciation without using language or flag icons as the only identifier.

## Verify behavior, not theater

1. Run automated checks early for deterministic issues, but do not interpret a clean scan as accessibility. Automated tools cannot judge the full keyboard flow, focus behavior, reading order, alternative-text quality, error clarity, screen-reader usefulness, reflow, or cognitive load.
2. Test the changed flow manually with keyboard only, representative zoom and reflow, contrast and user preferences, pointer or touch, and at least one supported browser and screen-reader combination when semantics or interaction changed.
3. Test complete tasks and all material states, not only isolated components or the populated happy path. Include invalid input, asynchronous updates, repeated controls, modal open and close, route changes, and failure recovery where relevant.
4. Inspect the accessibility tree and computed names, roles, descriptions, values, and states, but verify the actual user interaction too. Do not overfit tests to one screen reader's exact spoken phrase.
5. Never add an accessibility overlay, widget, injected toolbar, or runtime rewriting service as a substitute for correcting markup, content, styles, focus, and behavior. Treat an automated score as a regression signal, not evidence of conformance.

Read [verification protocol](references/testing.md) before declaring a user-interface change accessible or when selecting automated, keyboard, zoom, contrast, touch, motion, screen-reader, or manual tests.

## Final audit

Reject or revise the change if any applicable answer is no:

1. Can users perceive and complete the entire changed task without sight, color, sound, precise pointer movement, or a mouse alone?
2. Do native semantics, names, roles, states, relationships, reading order, and status updates match the visible interface?
3. Is keyboard focus always visible, logical, contained only where required, restored after temporary UI, and free from author-created obstruction?
4. Do labels, instructions, validation, errors, success messages, and authentication help users recover without re-entering avoidable information?
5. Does content remain usable with zoom, reflow, text spacing, high contrast, reduced motion, long translations, and required writing directions?
6. Are images, media, tables, charts, and language changes represented equivalently for assistive technology?
7. Did automated checks and the relevant manual browser, keyboard, pointer, and screen-reader task tests pass with recorded evidence and known limitations?
