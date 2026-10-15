# Accessibility

WCAG 2.2 is the current W3C recommendation, and level AA is the usual legal and contractual baseline. WCAG 3 is still a draft, so do not design against it yet.

## Contents

- Perceivable
- Operable
- Understandable
- Robust
- Semantic HTML and ARIA
- Native apps
- Testing

## Perceivable

- Text alternatives for meaningful images, empty `alt=""` for decorative ones.
- Captions for video, transcripts for audio.
- Structure conveyed in code, with real headings, lists, tables, and landmarks, not only with styling.
- Contrast of 4.5:1 for normal text, 3:1 for large text (24 CSS pixels or 18.66 bold) and for icons, input borders, and focus indicators.
- Content reflows at 320 CSS pixels wide and stays usable at 200 percent text size.
- Text spacing can be increased by the user without clipping.
- Never rely on color alone.

## Operable

- Everything works with a keyboard in a logical order, with no keyboard traps.
- A visible focus indicator on every focusable element, and the focused element is never fully hidden by sticky headers, banners, or overlays (2.4.11, new in 2.2).
- A skip link to the main content on pages with repeated navigation.
- Pointer targets at least 24 by 24 CSS pixels, or enough spacing around smaller ones (2.5.8, new in 2.2).
- Any dragging action also works with single clicks or taps (2.5.7, new in 2.2).
- Complex gestures have simple alternatives.
- Time limits can be extended, and moving or auto-updating content can be paused.
- Nothing flashes more than three times per second.

## Understandable

- The page language is declared.
- Navigation and help appear in the same place across pages (3.2.6, new in 2.2).
- Focus or input never triggers an unexpected change of context.
- Labels and instructions for every input, and errors identified in text with suggestions.
- Do not make people re-enter information they already gave in the same process (3.3.7, new in 2.2).
- Login never requires a memory or puzzle test without an alternative, so allow paste and password managers (3.3.8, new in 2.2).

## Robust

- Every control has an accessible name, a role, and a state that assistive technology can read.
- Status messages, such as "Saved" or result counts, are announced without moving focus, using `role="status"` or `aria-live="polite"`.

## Semantic HTML and ARIA

- Use native elements first, `button` for actions, `a` for navigation, `label` for inputs, `fieldset` and `legend` for groups, `dialog` for modals.
- ARIA only fills gaps. A wrong ARIA role is worse than none.
- Icon-only buttons need an accessible name, as in `aria-label="Close"`.
- Modals move focus inside, trap it while open, close on Escape, and return focus to the trigger.
- Link error messages to fields with `aria-describedby` and mark invalid fields with `aria-invalid="true"`.
- Hide decorative icons with `aria-hidden="true"`.

## Native apps

- **iOS and macOS.** Use system controls, set accessibility labels, hints, and traits, support Dynamic Type, VoiceOver, Voice Control, Full Keyboard Access, Reduce Motion, Reduce Transparency, and Increase Contrast.
- **Android.** Set `contentDescription` or Compose semantics, support font scaling and TalkBack, keep touch targets at 48 by 48 dp.

## Testing

1. Navigate the whole flow with only a keyboard.
2. Use a screen reader (VoiceOver, NVDA, TalkBack) on the main flows.
3. Run an automated checker such as axe or Lighthouse, knowing it finds only part of the issues.
4. Zoom to 200 percent and narrow the window to 320 pixels.
5. Turn on reduced motion, dark mode, and increased contrast.
