# Interaction, accessibility and verification

## Keep the task understandable

Make the current state and the result of an action visible. Use familiar domain language and specific labels. Keep common controls in recognizable locations and disclose secondary detail without hiding the primary task. Preserve an exit or reversal for recoverable actions and prevent avoidable errors before displaying a message.

Design the states the changed interaction can actually reach: initial, focused, selected, pending, empty, failed and completed as applicable. Errors explain what happened and what the user can do, without exposing internal diagnostics. Disabled controls need an understandable reason when their purpose is otherwise unclear. Do not require every simple component to implement every possible state.

## Accessible structure and input

Prefer native semantics for navigation, forms and controls. Provide accessible names, visible input labels, a logical heading hierarchy and a meaningful focus order. Test dialogs for initial focus, keyboard dismissal where appropriate and return of focus. A custom visual control must preserve the semantics and interaction of the control it replaces.

For WCAG 2.2 AA web work, check the applicable criteria and exceptions rather than treating numbers as a complete audit:

- Normal text generally needs 4.5:1 contrast. Large text needs 3:1. Relevant control or graphical information needs 3:1 under the non-text contrast criterion, not every decorative boundary.
- Pointer targets generally need 24 by 24 CSS pixels or sufficient spacing under the minimum target-size criterion. Inline links and other documented exceptions differ. Larger touch targets can improve comfort; do not confuse a 44-pixel preference with the AA minimum.
- Focus must be visible and not entirely hidden by author-created content. Sticky headers, overlays and scroll containers can hide a focused control even when its outline exists.
- Do not communicate an error, selection or status by color alone. Provide a textual or otherwise perceivable equivalent. Announce relevant asynchronous status changes without needlessly moving focus.
- Respect reduced-motion settings. Avoid unnecessary repetitive, depth or large-area motion. Where content moves automatically, evaluate the applicable pause and stop requirements.

Use platform accessibility guidance for native apps. Support relevant system text-size settings and assistive technologies. Apple-specific Dynamic Type availability varies by platform; it is not a universal web API.

## Responsive behavior

Choose layout changes from the available space and the content, not only a device name. Allow text and controls to grow, stack or wrap without losing the task hierarchy. Test relevant window sizes, long labels, localization and text enlargement. Preserve the subject of artwork rather than stretching it to an arbitrary aspect ratio.

For ordinary vertical web content, verify reflow at 320 CSS pixels and text resizing where the criteria apply. Tables, maps and other content needing a two-dimensional layout have documented exceptions. Keep such content contained and operable rather than imposing a universal prohibition on all horizontal scrolling.

## Verify the real changed path

Use available browser, app or prototype tools and the project's established checks. Exercise the action from its actual control through its result, not by setting internal state to a successful value. Compare current rendered views against supplied references. Automated accessibility scans supplement keyboard and assistive-technology checks; they do not establish complete conformance.

Check the affected widths, focus and text settings, reachable failure state, and console or network issues caused by the change. Scale this work to the changed surface. Do not add a new audit dependency, publish a Figma library, change permissions or redesign unrelated screens merely to satisfy a checklist. Report precisely what was exercised and what remains unverified.

## Sources

Reviewed on 2026-10-01. WCAG is a web standard; apply the criteria relevant to the requested conformance level and platform.

- [WCAG 2.2](https://www.w3.org/TR/WCAG22/) is the normative source for web accessibility requirements.
- [Understanding target size](https://www.w3.org/WAI/WCAG22/Understanding/target-size-minimum.html), [reflow](https://www.w3.org/WAI/WCAG22/Understanding/reflow.html) and [focus not obscured](https://www.w3.org/WAI/WCAG22/Understanding/focus-not-obscured-minimum.html) explain the relevant conditions and exceptions.
- [Apple HIG: Accessibility](https://developer.apple.com/design/human-interface-guidelines/accessibility) and its [official document data](https://developer.apple.com/tutorials/data/design/human-interface-guidelines/accessibility.json) cover platform accessibility and motion considerations.
- [Jakob Nielsen's ten usability heuristics, NN/g summary](https://media.nngroup.com/media/articles/attachments/Heuristic_Summary1_A4_compressed.pdf) supplies authored principles for understandable state, familiar language, user control and error recovery.
