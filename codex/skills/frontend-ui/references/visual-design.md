# Visual design choices

This reference adapts selected material from Google Chrome Modern Web Guidance 1.0. The user's brief and the project's design system always take precedence.

## Before implementation

Identify the subject, audience, and main action from the brief. Use real product content and the existing brand as evidence. When the brief leaves a materially important design choice open, make a reversible choice that fits the product and show the result rather than inventing a new design system.

Choose typography, color, spacing, and layout for the content. Avoid template-like decoration by default, such as irrelevant numbered labels, repeated pill buttons, identical card grids, decorative gradients, unnecessary motion, or icon-only controls. Use these patterns when the brief or product system calls for them.

## Consistent components

- Reuse semantic design tokens and established component variants. Change theme tokens before accumulating one-off overrides.
- Use a card only when the content needs to read as a single object. Use simple spacing and alignment for ordinary groups.
- Make headings, body text, labels, and controls legible at narrow widths and increased text size.
- Use emphasis for the content's hierarchy, not as decoration. Keep a component's corner radius, typography, and spacing consistent with related controls.

## Interface copy

- Use words the user recognizes. A button says the action it performs, and success messages use the same action name.
- Explain what failed and how to recover. Make empty states identify a useful next action.
- Prefer plain, direct wording over sales language or internal system terms.

## Inspect the result

When the browser is available, inspect an actual rendered page at relevant viewport sizes and themes. Check the primary path, focus, loading, empty, and error states. Compare the result with the user's request and existing system, then correct visible mismatches before finishing.
