---
name: designing-user-interfaces
description: Designs, builds, and reviews user interfaces for web and mobile with usability heuristics, WCAG 2.2 AA, and design tokens. Use when creating or changing screens, pages, components, layouts, CSS, or interface copy, turning a design into code, or reviewing accessibility.
---

# Designing user interfaces

A good interface lets people reach their goal quickly, without confusion, errors, or effort spent on the interface itself. Clarity beats decoration, familiar patterns beat novelty, and every element must earn its place. When the project has a design system, brand guide, or Figma file, follow it over this skill and use its tokens and components.

## Usability principles

These are Nielsen's ten heuristics in working form.

1. **Show system status.** Every action gets visible feedback, such as a pressed state, a spinner, a progress bar, or a confirmation.
2. **Speak the user's language.** Use words and concepts from the user's world, not internal or technical terms.
3. **Give control and freedom.** Provide undo, cancel, back, and clear exits. Prefer undo over confirmation dialogs for reversible actions.
4. **Be consistent.** The same thing looks and behaves the same everywhere, and platform conventions are respected.
5. **Prevent errors.** Use constraints, sensible defaults, inline validation, and confirmation only for destructive or costly actions.
6. **Prefer recognition over recall.** Keep options, recent items, and context visible instead of making people remember them.
7. **Support novices and experts.** Make the simple path obvious and offer shortcuts, keyboard support, and bulk actions for frequent users.
8. **Keep it minimal.** Remove or hide what most users rarely need, because every extra element competes with the important ones.
9. **Make errors recoverable.** Error messages say what happened, why, and how to fix it, in plain language, next to the problem.
10. **Help in context.** Hints, empty states, and tooltips explain the task where it happens.

## Visual hierarchy and layout

- Decide the single primary action of each screen and make it the most prominent element. Secondary actions are visibly quieter.
- Build hierarchy with size, weight, spacing, and position before color.
- Use a spacing scale based on 4 or 8 units and apply it consistently. Related items sit closer together than unrelated ones.
- Align elements to a grid and keep a small number of alignment lines.
- Keep text lines readable, about 45 to 75 characters wide for body text.
- Lay out mobile first, then add columns as space grows. Content must reflow without horizontal scrolling down to 320 CSS pixels wide.

## Typography

- Use one or two typefaces, preferably the platform's system font for apps (SF Pro on Apple platforms, Roboto or the brand font on Android).
- Use a limited type scale, for example five to seven sizes, with clear steps between levels.
- Body text is at least 16 CSS pixels on the web and 17 points on iOS, with line height about 1.4 to 1.6 for body text.
- Support user text scaling, Dynamic Type on Apple platforms, font scaling on Android, and zoom to 200 percent on the web without loss of content.

## Color

- Define colors as semantic tokens by role (`background`, `surface`, `text-primary`, `accent`, `danger`), not by hue, so themes and dark mode work.
- Text contrast is at least 4.5:1, and 3:1 for large text (24 CSS pixels, or 18.66 bold) and for icons, borders of inputs, and focus indicators.
- Never use color as the only signal. Pair it with text, an icon, or a pattern.
- Use the accent color for interactive and important elements only, so it keeps its meaning.
- Support dark mode with its own tuned palette, not inverted colors.

## Components and states

- Every interactive component has default, hover, focus, pressed, disabled, and loading states, and selected or error where relevant.
- Buttons are labeled with verbs that name the result ("Save changes", "Delete project"), not "OK" or "Submit".
- Destructive actions are visually distinct, separated from safe actions, and reversible or confirmed.
- Touch targets are at least 44 by 44 points on Apple platforms, 48 by 48 dp on Android, and 24 by 24 CSS pixels on the web, with 44 or more preferred for touch.
- Use native or well-known controls before inventing custom ones.

## Screens beyond the happy path

Design every screen for these states, not only the full one.

- **Empty.** Explain what will appear here and offer the action that fills it.
- **Loading.** Show skeletons or progress for waits over about one second, and keep the layout from jumping.
- **Error.** Say what went wrong and offer a retry or another way forward.
- **Partial and edge content.** Very long names, missing images, one item, thousands of items, slow networks.
- **Offline or no permission,** where it applies.

## Forms

- Ask only for what is needed, in a logical order, in a single column.
- Every field has a visible label. Placeholders are hints, never labels.
- Use the correct input types and autocomplete attributes so keyboards and password managers help.
- Validate when a field loses focus or on submit, not on each keystroke, show errors next to the field, and keep the entered data.
- Mark optional fields rather than required ones when most fields are required.
- Never ask for the same information twice in one flow.

## Accessibility

Meet WCAG 2.2 level AA as the baseline. The essentials are semantic structure, full keyboard operation with a visible focus indicator that is never hidden behind sticky elements, text alternatives for meaningful images, accessible names for every control, sufficient contrast, support for text scaling and reduced motion, and alternatives to dragging and to complex gestures. Test with a keyboard and a screen reader. Details are in [references/accessibility.md](references/accessibility.md).

## Security in the interface

Cross-site scripting is the first entry in the CWE Top 25 2025, so the interface layer carries part of the defense. The writing-secure-code skill covers the rest.

- Render untrusted data only through the framework's automatic escaping. Never pass it to `innerHTML`, `dangerouslySetInnerHTML`, `v-html`, or a raw template output.
- Allow only `https` and `http` schemes in links and image sources built from user data.
- Keep the page compatible with a strict Content Security Policy, with no inline scripts or inline event handlers.
- Keep secrets out of client code and storage, and treat hidden or disabled controls as convenience only, because every permission is checked on the server.

## Motion

- Use motion to explain change, such as where something came from or went, and keep it short, roughly 150 to 300 milliseconds for interface transitions.
- Never block input while an animation plays.
- Respect reduced motion settings by replacing movement with fades or no animation.

## Interface writing

- Use short, specific, sentence-case text in the user's language and tone.
- Front-load the important words in headings, buttons, and messages.
- Keep terminology consistent, so one action has one name everywhere.
- Error messages never blame the user and always include the way out.

## Avoiding a generic look

Without direction, generated interfaces tend to fall into the same defaults. Unless the brand asks for them, avoid cream or beige page backgrounds, italic accent words inside headlines, numbered "01 02 03" section labels, monospace labels for ordinary text, pill-shaped buttons everywhere, decorative gradients, and gratuitous glassmorphism. Derive the look from the product's purpose, audience, and brand, and keep it restrained and consistent.

## Workflow

1. Identify the users, their main task on this screen, the platform, and the existing design system.
2. Sketch the structure, meaning content priority, the primary action, and navigation, before styling.
3. Build with the design system's tokens and components, or define a minimal token set first.
4. Design all states from the list above.
5. Check accessibility with keyboard, screen reader, contrast, zoom, and reduced motion.
6. Review against the checklist and fix what fails.

## Checklist

- [ ] Each screen has one clear primary action and an obvious next step
- [ ] Spacing, type, and color come from tokens on a consistent scale
- [ ] Contrast meets 4.5:1 for text and 3:1 for large text and controls
- [ ] All interactive states exist, including focus and loading
- [ ] Empty, loading, error, and edge content states are designed
- [ ] Forms have visible labels, correct input types, and helpful inline errors
- [ ] Everything works with a keyboard and has accessible names
- [ ] Touch targets meet the platform minimum
- [ ] Layout works from small phones to wide screens and at 200 percent zoom
- [ ] Reduced motion, dark mode, and text scaling are respected
- [ ] Copy is short, specific, and consistent
- [ ] Untrusted data is rendered only through automatic escaping, and no secret reaches the client

## Reference files

Read them before the first change, the accessibility file, the platforms file for the target platform, the examples file, and the design systems file when tokens or Figma are involved.

- [references/accessibility.md](references/accessibility.md) covers WCAG 2.2 AA requirements, semantic HTML and ARIA, and testing.
- [references/platforms.md](references/platforms.md) covers Apple Human Interface Guidelines, Material Design 3, and web conventions.
- [references/design-systems.md](references/design-systems.md) covers design tokens, Figma structure, and handoff from Figma to code.
- [examples.md](examples.md) has illustrative token, button, form, and empty state code.
