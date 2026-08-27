# Verification Protocol

## Define the test surface

1. Record the conformance target, supported browsers and devices, assistive-technology combinations, affected pages and components, complete user processes, technologies relied on, states, themes, languages, and known third-party boundaries.
2. Test representative real content, longest expected labels and errors, empty and dense data, validation failures, asynchronous delays, permission states, and each responsive layout. A component passing in isolation does not prove the integrated task.
3. Treat WCAG conformance as a full-page and complete-process claim. A targeted change can be verified against applicable criteria without claiming the entire product conforms.

## Automated checks

1. Run the project's existing HTML, framework, accessibility, type, lint, component, and browser checks at the narrowest affected scope. Add an automated rule only when it detects a deterministic regression with acceptable signal.
2. Use automated tools to catch issues such as invalid or conflicting ARIA, missing names and labels, duplicate identifiers, forbidden focus relationships, some contrast failures, and detectable structural errors.
3. Review every reported issue in context and verify the fix manually. Do not suppress a rule merely to improve a score, and do not report a tool warning as a confirmed user barrier without evidence.
4. Automated tools cannot determine overall accessibility. They cannot reliably judge meaningful sequence, complete keyboard behavior, focus placement, accessible-name quality, alternative-text purpose, error clarity, cognitive demands, screen-reader usefulness, or whether a task is completable.
5. Keep automated regression tests behavior-focused. Assert roles, accessible names, state, focus movement, keyboard results, and visible outcomes; do not assert implementation-specific ARIA when native semantics can satisfy the behavior.

## Keyboard and focus test

1. Put the pointer aside. Traverse forward and backward from the browser chrome through the complete flow. Reach every control, skip repeated regions, operate native and composite controls with expected keys, and escape every temporary surface.
2. Verify focus order follows task and reading order, the focused item is always discernible and not hidden, focus does not reset after ordinary updates, and disabled or hidden controls do not create dead stops.
3. Open and close dialogs, menus, disclosures, popovers, date pickers, and route transitions. Verify initial focus, containment only for true modals, Escape behavior, return focus, and preservation of the user's work.
4. Trigger invalid input, asynchronous status, loading completion, deletion, insertion, sorting, filtering, and errors. Verify users can find the change without unexpected focus theft.

## Zoom, reflow, visual, and input test

1. Test browser zoom to 200 percent and 400 percent or an equivalent 320 CSS-pixel viewport. Check for loss, overlap, clipping, obscured focus, inaccessible controls, and horizontal scrolling of ordinary text.
2. Apply WCAG text-spacing overrides and representative long localized text. Test required left-to-right and right-to-left directions, enlarged system text on mobile where supported, and orientation changes.
3. Measure text, placeholder, link, state, icon, border, chart, and focus contrast in every theme and interaction state. Test forced-colors or high-contrast mode when it is in the supported platform matrix.
4. Enable reduced motion before load and during interaction. Confirm nonessential transitions, parallax, auto-scroll, and animated route changes are removed or safely replaced without hiding state changes.
5. Test mouse, coarse pointer, touch, and stylus behavior as applicable. Measure target bounds and spacing, verify an alternative to dragging and multipoint gestures, and ensure hover content is also reachable by focus and can be dismissed.

## Screen-reader test

1. Use supported real combinations, such as NVDA with Firefox or Chrome on Windows, Narrator with Edge on Windows, or VoiceOver with Safari on Apple platforms. Select the smallest matrix that covers the changed technology and product support commitments.
2. Learn the screen reader's browse or scan mode and forms or interaction mode before testing. Do not mistake unfamiliar tester operation for an application defect.
3. Navigate by headings, landmarks, links, buttons, form controls, errors, tables, and regions rather than only reading linearly. Verify that structure supports efficient discovery and that repeated controls are distinguishable.
4. For each interactive component, confirm useful name, role, state, value, instructions, keyboard behavior, and changed-state announcement. For dialogs, verify title, context, initial focus, contained interaction, close behavior, and return focus.
5. Check forms from label through instruction, input, invalid state, error, correction, and success. Check live updates once without duplicate, stale, overly verbose, or missing announcements.
6. Judge whether the task is understandable and completable, not whether one product speaks an exact expected sentence. Screen readers and browser combinations can convey equivalent information differently.

## Content and cognitive test

1. Inspect images without seeing them and verify that alternatives convey function or meaning without redundant prefixes. Confirm complex graphics have equivalent data and decorative images stay silent.
2. Review captions against the media, including speaker changes and meaningful sounds. Verify transcript completeness, visual description, and accessible player controls.
3. Navigate data tables by row and column headers. Verify caption, header associations, sorting state, abbreviations, totals, and responsive behavior remain understandable.
4. Read instructions, labels, errors, help, authentication, timeouts, and destructive confirmations as a first-time user. Remove unexplained terms, inconsistent names, memory burdens, ambiguous recovery, and unnecessary re-entry.

## Evidence and limitations

1. Record the tested revision, environment, viewport, browser, operating system, assistive-technology version and settings, input method, state, steps, expected result, actual result, and evidence for each material invariant.
2. Separate confirmed failures, tool warnings needing review, product limitations, third-party defects, and tests not performed. Never convert an incomplete check into a conformance claim.
3. An accessibility overlay or injected runtime fixer cannot replace source remediation or this test protocol. If inaccessible third-party content cannot be changed, provide an equivalent path where possible, isolate impact, document the limitation, and escalate it to the owner.
