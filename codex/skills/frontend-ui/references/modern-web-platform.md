# Native HTML and CSS and browser support

This reference adapts selected material from Google Chrome Modern Web Guidance 1.0. Compatibility notes are a snapshot from 2026-11-17, not a substitute for checking current browser support.

## Contents

- Platform-first choices
- Overlays and disclosure
- CSS and motion
- Forms and responsiveness
- Performance
- Further guidance

## Platform-first choices

Prefer semantic HTML and native CSS when their behavior matches the requirement. Native controls usually provide more complete keyboard, focus, accessibility-tree, and platform integration than a custom JavaScript replacement. Check the project's documented browser target and a current compatibility source before depending on newer features. Keep core behavior available when a feature is unsupported, or feature-detect and load a suitable fallback only when needed.

Useful candidates to verify include `<dialog>` and the Popover API for overlays, `<details>` for disclosure, `:has()` for parent state, `field-sizing` for content-sized controls, `:user-invalid` for post-interaction validation styling, `light-dark()` for theme tokens, `@starting-style` for transitions, and view or scroll-driven animations. Support varies by feature and browser release.

## Overlays and disclosure

- Choose an overlay by behavior. Use a modal dialog for a blocking decision, and a nonmodal popover or disclosure for content that should not block the page.
- A modal opened with `showModal()` already enters the top layer, makes the page inert, contains focus, supports the platform close action, and returns focus. Avoid adding a second focus trap or duplicate ARIA state without a demonstrated need.
- Give each dialog an accessible name and a visible close or cancel action. Move focus only when the user's action calls for it, and restore it when the dialog closes.
- Use native disclosure behavior where it fits. Keep a disclosure summary free of nested interactive controls. Use a real heading and button when a navigable heading is needed.
- A custom tooltip must meet the applicable hover and focus persistence and dismissal criteria. Do not move keyboard focus into a tooltip.

## CSS and motion

- Use the cascade deliberately. Keep component styles scoped and avoid resets that downstream components cannot override. Use logical properties where they preserve the design in right-to-left layouts.
- Use `:has()` for styling only when it is inside the project's support target. Add a fallback when unsupported browsers would lose essential behavior.
- Give long flex or grid content room to wrap. Do not use visual reordering on interactive elements when it makes the focus order disagree with the visual order.
- Animate `opacity` and transforms where practical, and honor `prefers-reduced-motion`. Keep the final state correct when an animation is skipped or unsupported.
- Do not rely on an animation or transition event to complete work unless the no-animation case also completes.

## Forms and responsiveness

- Use the right input type, `inputmode`, and `autocomplete` tokens. Provide a visible label, useful error text, and a way to paste credentials and one-time codes.
- Validate at a useful point in the interaction. On submission, identify the first invalid field or a linked error summary and move focus there when appropriate.
- Avoid custom Enter handling for ordinary forms. If handling Enter for a text field, do not submit while an IME composition is being confirmed.
- Prefer flexible dimensions and text that reflows. Preserve keyboard access, labels, and state when themes, forced colors, and text spacing change.

## Performance

- Batch DOM reads before writes, and avoid long work in an interaction handler. Yield work or move it off the main thread when measurement shows the interaction needs it.
- Give images and video a stable aspect ratio or dimensions to prevent layout shifts. Do not lazy-load the page's verified largest-content image.
- Use preload and fetch priority only for a measured critical resource. Verify responsive-image sizes and resource priorities in a browser trace.
- Treat speculation, prefetch, and prerender as enhancements. Exclude destinations that cause side effects and verify behavior in the browsers the project supports.

## Further guidance

The source reference points to Chrome's [Modern Web Guidance](https://developer.chrome.com/docs/modern-web-guidance), which publishes topic-specific web guidance and skills. Read the guide for the actual feature and verify each claim against the standards and target browsers.
