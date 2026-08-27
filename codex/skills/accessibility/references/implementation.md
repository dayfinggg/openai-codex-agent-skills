# Implementation Invariants

## Structure and semantics

1. Give each page a descriptive title, one identifiable main region, meaningful heading hierarchy, and named repeated landmarks where users need to distinguish them. Use skip navigation when repeated content would otherwise require excessive traversal.
2. Use elements for their defined semantics and content model. A clickable non-interactive element does not become a complete button by adding `role="button"`; use a native button unless a verified constraint prevents it.
3. Keep source order meaningful without CSS. Do not use positive `tabindex`, focusable decorative elements, or `aria-hidden="true"` on an element or ancestor that contains focusable content.
4. Hide content from everyone when it is unavailable. Do not visually hide content while leaving unintended controls in the accessibility tree or tab sequence, and do not hide visible meaningful content only from assistive technology.
5. Confirm the computed accessible name, role, description, value, required, invalid, checked, pressed, selected, expanded, current, disabled, and busy states whenever the component can expose them.

## Native controls and ARIA widgets

1. Use native disclosure, dialog, select, checkbox, radio, range, details, table, and form behavior when it satisfies product and browser requirements. Native controls carry semantics, input support, focus, and platform adaptation that custom widgets must otherwise recreate.
2. When a custom widget is necessary, use the WAI-ARIA Authoring Practices pattern as a behavioral starting point, then verify it in the project's supported browser and assistive-technology combinations. APG examples are not a design system or a substitute for testing.
3. Implement the full interaction contract for the chosen pattern, including arrow keys, Home and End, Enter or Space, Escape, Tab behavior, selection rules, type-ahead, orientation, disabled items, and focus strategy where applicable.
4. Do not add redundant roles or ARIA that conflicts with native semantics. Never use ARIA to conceal a broken interaction, and never mark a surface modal unless pointer, keyboard, focus, and assistive-technology users are all constrained to it.
5. Prefer DOM focus for ordinary controls. Use roving `tabindex` or `aria-activedescendant` only for a genuine composite widget whose pattern defines it, and keep visual focus distinct from selection.

## Keyboard and focus

1. Reach every interactive control in a logical sequence with the keyboard, operate it through expected keys, reverse through it, and leave it without a trap. Pointer-only hover, drag, canvas, and gesture features need keyboard-accessible equivalents unless essential.
2. Use natural DOM order rather than manually enumerated positive `tabindex` values. Within composites, put one entry point in the page tab sequence and use the pattern's internal keys.
3. Keep a visible focus indicator for every keyboard-operable component. It must contrast with adjacent colors and remain visible over selected, invalid, disabled, dark, light, image, and high-contrast backgrounds.
4. Sticky headers, cookie notices, drawers, toasts, chat launchers, and virtual keyboards must not entirely obscure the focused component. Scroll focused content into view without disorienting motion.
5. When opening a dialog or temporary surface, place focus at the element that best supports understanding and task order, contain focus only for a true modal, provide an obvious close action, support Escape where appropriate, and return focus to the invoker or the next logical control.
6. On route or major view changes, update the document title and place or preserve focus deliberately so users can discover the new context. Do not move focus on ordinary rerenders or validation while the user is typing.

## Forms, validation, and status

1. Give every input a persistent visible label programmatically associated with the control. Placeholder text is an example or hint, not the label. Group related controls with `fieldset` and `legend` or an equivalent native relationship.
2. State required status, accepted format, constraints, and consequences before they are needed. Connect concise supplementary instructions with native semantics or `aria-describedby` when the relationship is otherwise unavailable.
3. Accept reasonable localized input formats where possible and normalize safely. Use correct input types and autocomplete tokens without preventing paste, password managers, or assistive input.
4. Identify an error in text, name the affected field, explain the problem, and provide a concrete correction. Associate the message with the input, preserve valid values, provide a findable summary for multi-field failures, and move focus only when it improves recovery.
5. Announce asynchronous success, error, progress, and result counts through an existing status region when visual updates do not receive focus. Do not repeat the same message, announce every keystroke, or use an assertive alert for routine feedback.
6. For destructive, legal, financial, or data-changing actions, provide review, confirmation, undo, or correction appropriate to the consequence. Authentication must not depend on recalling or transcribing information without an accessible alternative.

## Visual and input resilience

1. Meet WCAG 2.2 Level AA contrast for normal and large text, and non-text contrast for control boundaries, states, meaningful graphics, and focus indicators. Measure actual foreground and background colors in every relevant state and theme.
2. Support text resize to 200 percent and page zoom and reflow equivalent to a 320 CSS-pixel-wide viewport without loss, overlap, clipping, or two-dimensional scrolling except for content that inherently requires it, such as a large data table or map.
3. Allow user text-spacing overrides without clipping or loss. Avoid fixed heights for text containers, truncating required labels or errors, and layouts that depend on one font or string length.
4. Ensure pointer targets satisfy the 24 by 24 CSS-pixel Level AA target-size requirement or its defined spacing or semantic exceptions. Prefer larger targets for frequent, destructive, or mobile actions.
5. Provide a non-drag pointer alternative for drag interactions. Do not require multipoint gestures, path-specific movement, device motion, or fine timing when a simpler control can perform the task.
6. Remove or replace nonessential motion when `prefers-reduced-motion: reduce` is active. Preserve state comprehension without relying on animation, and provide pause, stop, hide, or timing controls where required.

## Content, media, tables, and language

1. Determine image alternatives from function and context. Decorative or redundant images use an empty alternative; informative images convey the same purpose; linked or button images name the action; complex charts expose equivalent structured information.
2. Captions include speech and meaningful sounds and remain synchronized and accurate. Provide transcripts and visual descriptions according to the media type and target, and verify player controls with keyboard and assistive technology.
3. Use native data-table markup with `caption`, `th`, and simple `scope` relationships where possible. For genuinely complex headers, use explicit associations. Keep table navigation, sorting state, and responsive presentation understandable without converting data cells into visual cards that lose relationships.
4. Declare the default document language and language changes. Use standard language tags, semantic `dir` handling, logical CSS properties, and bidirectional isolation for embedded user or external content.
5. Localize accessible names, descriptions, errors, status messages, captions, and alternative text together with visible content. Verify longer strings, plural forms, number and date formats, and right-to-left order.
6. Reduce cognitive load with direct language, familiar patterns, consistent help and identification, descriptive headings and links, visible instructions, recoverable timeouts, preserved work, and no unnecessary memory or puzzle demands.
