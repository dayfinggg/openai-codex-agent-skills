# Accessible interface implementation

This is a practical checklist, not a conformance determination. Confirm legal or contractual requirements with the applicable policy owner.

## Keyboard and focus

- Prefer native buttons, links, inputs, and disclosure controls. Do not add positive `tabindex` values or JavaScript key handlers to native controls.
- Keep a visible focus indicator with sufficient contrast. Check that sticky content does not completely cover the focused control.
- After a control or view disappears, move focus to a logical neighbor or its trigger. Move focus into newly opened content only when the action calls for it.
- Provide a single-pointer alternative for drag-only interactions. Keep the page scrollable when adding touch gestures.

## Names, labels, and announcements

- Give controls accessible names that describe their action. Keep the visible label text in the accessible name.
- Associate visible labels with their inputs. Use concise error messages and associate each message with its field.
- Use a live region only when an asynchronous state change needs announcement. Avoid repeatedly announcing noisy updates or content inside an inert region.
- Hide decorative images and icons from assistive technology. Give informative images meaningful alternatives.

## Contrast and visual settings

- Check text, icons, boundaries, focus indicators, and states against their adjacent colors in each theme. Do not convey meaning by color alone.
- Test forced-colors mode, text-spacing overrides, and 200% zoom. Use system colors and non-shadow boundaries where forced-colors mode removes author styling.
- Reflow content at a narrow viewport without clipping text or requiring horizontal page scrolling. Avoid fixed heights on content that may wrap.
- Keep content usable with browser zoom and text enlargement. Do not disable zoom.

## Motion and media

- Honor reduced-motion preferences and retain the final state if animation is skipped.
- Give users a way to pause qualifying auto-moving content. Avoid rapid flashing.
- Provide captions for speech in video. Decorative motion must not block keyboard use or hide information.

## Testing

Automated accessibility checks find only some defects. For the changed user flow, use keyboard-only navigation and inspect focus, names, labels, errors, zoom, high contrast, and a screen reader when the required tooling is available. Report the manual checks that you could not run.
