# Product patterns

Read this reference for workflows, forms, dashboards, navigation, dense tools, and non-ideal product states.

## Interaction and state model

- Define each control's rest, hover, focus-visible, active, selected, disabled, loading, success, and error behavior when those states apply. A state must be visible without relying on color alone.
- Preserve focus and context after updates. Announce asynchronous status changes to assistive technology without interrupting the user's task unnecessarily.
- Disable an action only when the reason is visible or immediately discoverable. Prefer validation and clear guidance over unexplained disabled buttons.
- Use optimistic feedback only when failure can be reversed or reconciled clearly. Show actual progress when it is known; use an indeterminate indicator only when it is not.
- For destructive or high-cost actions, prevent slips through clear labels, review, undo, or confirmation proportional to the consequence.

## Forms

- Ask only for information required to complete the current task. Group related fields, use persistent labels, state required or optional status clearly, and put format guidance before entry.
- Prefer a simple vertical reading order. Align labels, fields, hints, and validation messages. Do not use placeholder text as the only label or instruction.
- Accept reasonable input variation where ambiguity is low. Preserve entered values after validation errors.
- On failure, explain what happened and how to fix it next to the field and in an accessible summary when several errors exist. Move focus deliberately and keep the user's prior work.
- Use action labels that describe the result, such as `Send application` or `Save changes`, instead of generic labels such as `Submit`, `Continue`, or `Yes` when the outcome matters.
- Test keyboard order, autofill, zoom, long labels, browser validation behavior, mobile keyboards, error recovery, and successful completion.

## Dashboards and dense operational UI

- Define the audience, decision, time horizon, and question each dashboard answers. If a metric does not support that decision, remove it or move it to drill-down detail.
- Put the highest-value status and exceptions first. Organize detail in the user's scanning direction and preserve a clear path from overview to diagnosis and action.
- Use comparable units, scales, time windows, baselines, targets, and labels. Never fabricate numbers to make the layout look realistic.
- Choose visualizations for the comparison being made. Prefer position and length for precise comparison; avoid decorative 3D charts, unnecessary gauges, and variety for its own sake.
- Use color to identify status, threshold, or series consistently. Do not make every metric a colored card. Tables and aligned text often communicate operational detail better.
- Match density to task frequency and expertise. Expert tools can be compact, but rows, targets, focus, and important exceptions must remain legible.

## Loading, empty, partial, and error states

- A loading state should preserve the expected page structure and prevent layout jumps. Use skeletons for stable content containers, not for every button, menu, dialog, or unknown layout.
- Show available content while independent regions load when that helps the task. Distinguish loading from no data and from a failed request.
- Keep mutually exclusive states visually exclusive. An empty, permission, loading, or terminal-error message must not appear alongside stale populated content unless the interface clearly labels that content as retained context.
- An empty state must explain why the area is empty and, when possible, provide the primary next action in context. Use illustration only when it adds meaning; repeated dashboard empty states usually need compact text.
- A no-results state should preserve the query or filters and offer a useful recovery path. Do not lead to a dead end.
- An error state should use plain language, identify the affected action or data, preserve user input, and offer the next valid step. Do not blame the user or expose internal codes as the main message.
- A permission state should distinguish unavailable access from missing data or system failure and explain the supported path to request or change access.
- A success state should confirm the completed outcome and make the next likely action clear without adding celebration that conflicts with the product tone.

## Content and visible guidance

- Use the user's language and domain terms. Do not expose internal architecture, team names, implementation stages, or database concepts unless users genuinely work with them.
- Keep labels and helper text concrete. Remove copy that merely describes where an element sits, instructs an obvious click, or praises the interface.
- Put help at the decision point. Long onboarding tours and permanent instruction panels should not compensate for unclear structure or labels.
- Keep warnings proportional and actionable. If everything is emphasized, users cannot see what matters.
- Empty areas, examples, charts, and activity feeds must not imply real data, customers, or outcomes that do not exist.
