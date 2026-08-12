# Interaction, States, and Accessibility

Use this reference to make flows complete, feedback legible, recovery possible, and accessibility verifiable at the design stage.

## Model the interaction

1. Start each flow from a realistic entry point and carry it through progress, success, cancellation or interruption, failure, recovery, and return. For visual-direction and critique work, include at least one such operational flow and explicitly mark genuinely irrelevant states.
2. Keep system status visible. Match feedback timing and prominence to user impact without relying on animation or color alone.
3. Preserve user control with clear exits, undo where feasible, confirmation for costly irreversible actions, and retained input after recoverable errors.
4. Prefer recognition over recall. Keep instructions, constraints, formats, and relevant context near the decision they affect.
5. Use familiar control patterns for familiar actions. Introduce a custom interaction only when standard patterns cannot meet a verified task and its keyboard, touch, pointer, and assistive behavior can be specified.

## Complete states and content

1. Define default, hover, focus, pressed, selected, disabled, loading, empty, error, success, offline, and permission states only where applicable.
2. Distinguish unavailable from in-progress actions. Explain why an action is disabled when the reason is not evident and provide a path forward.
3. Make loading preserve context and layout when possible. Avoid indefinite spinners when progress, staged content, or a retry path is more informative.
4. Make empty states explain what the area is for and what meaningful next action exists. Do not turn every empty state into promotional decoration.
5. Place error identification and recovery guidance near the cause, preserve valid input, and summarize multiple errors when navigation requires it.

## Design to an accessibility baseline

1. Use WCAG 2.2 Level AA as the baseline for web interfaces. Apply additional product, legal, and platform requirements when they are verified.
2. Specify logical reading and focus order, visible focus treatment, focus that is not obscured, keyboard reachability, bypass or navigation behavior, and focus restoration after overlays or dynamic changes.
3. Meet applicable text, non-text, focus, and state contrast requirements. Communicate meaning with text, shape, position, iconography, or pattern in addition to color.
4. Ensure controls and targets remain operable with touch, pointer, keyboard, zoom, text resize, reflow, display scaling, and reduced dexterity. Derive exact target values from the applicable standard and platform rather than memory.
5. Support text alternatives, programmatic labels, names and roles, instructions, error associations, and status announcements in the specification. Assign semantic HTML and ARIA implementation to `$build-web-frontends`.
6. Avoid motion that is essential to comprehension. Provide a reduced-motion behavior, pause or stop controls where required, and safe alternatives for flashing or vestibular effects.
7. Check forced-colors and high-contrast modes where relevant. Do not use transparent or background-dependent treatments that erase controls, focus, or state.

## Validate without overclaiming

1. Perform manual keyboard, focus, zoom, text-resize, reflow, reduced-motion, and forced-colors checks when an implementation exists.
2. Use automated accessibility tools to find detectable failures, then inspect the remaining criteria manually.
3. Use the WAI-ARIA Authoring Practices Guide as implementation pattern guidance, not as proof of WCAG conformance.
4. Report the checks actually performed, unresolved risks, and assistive-technology testing still required. Never claim conformance from a mockup or automated scan alone.

## Evidence classes

1. Treat WCAG 2.2 success criteria as normative for a stated conformance target.
2. Treat WAI-ARIA APG and platform HIG patterns as implementation and platform guidance.
3. Treat usability heuristics as contextual diagnostics and verify them against user tasks and product evidence.

## Sources

1. [Web Content Accessibility Guidelines 2.2](https://www.w3.org/TR/WCAG22/)
2. [WAI-ARIA Authoring Practices Guide](https://www.w3.org/WAI/ARIA/apg/)
3. [Apple HIG: Accessibility](https://developer.apple.com/design/human-interface-guidelines/accessibility)
4. [Apple HIG: Motion](https://developer.apple.com/design/human-interface-guidelines/motion)
5. [Nielsen Norman Group: Ten Usability Heuristics](https://www.nngroup.com/articles/ten-usability-heuristics/)
6. [GOV.UK Design System: Accessibility](https://design-system.service.gov.uk/accessibility/)
7. [U.S. Web Design System: Accessibility](https://designsystem.digital.gov/documentation/accessibility/)
