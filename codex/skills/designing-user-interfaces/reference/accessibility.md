# Accessibility

WCAG 2.2 level AA is the baseline. WCAG 3 is still a draft, so do not design against it.

## Criteria new in WCAG 2.2

- The focused element is never fully hidden by sticky headers, banners, or overlays (2.4.11).
- Pointer targets are at least 24 by 24 CSS pixels, or have enough spacing around them (2.5.8).
- Every dragging action also works with single clicks or taps (2.5.7).
- Navigation and help appear in the same place across pages (3.2.6).
- People are not asked to re-enter information they already gave in the same process (3.3.7).
- Login needs no memory or puzzle test without an alternative, so allow paste and password managers (3.3.8).

## Other requirements to check

- Empty `alt=""` for decorative images, captions for video, transcripts for audio.
- Structure in code with real headings, lists, tables, and landmarks.
- User-increased text spacing causes no clipping.
- A skip link on pages with repeated navigation, no keyboard traps, and a logical focus order.
- Time limits can be extended, moving content can be paused, and nothing flashes more than three times per second.
- The page language is declared, and focus or input never triggers an unexpected change of context.
- Status messages such as "Saved" are announced without moving focus, with `role="status"` or `aria-live="polite"`.

## Semantic HTML and ARIA

- Native elements first, `button` for actions, `a` for navigation, `label` for inputs, `fieldset` and `legend` for groups, `dialog` for modals. A wrong ARIA role is worse than none.
- Icon-only buttons get an accessible name, as in `aria-label="Close"`, and decorative icons get `aria-hidden="true"`.
- Modals move focus inside, trap it while open, close on Escape, and return focus to the trigger.
- Errors link to fields with `aria-describedby`, and invalid fields carry `aria-invalid="true"`.

## Native apps

- **iOS and macOS.** Set accessibility labels, hints, and traits, and support Dynamic Type, VoiceOver, Voice Control, Full Keyboard Access, Reduce Motion, Reduce Transparency, and Increase Contrast.
- **Android.** Set `contentDescription` or Compose semantics, and support font scaling and TalkBack.

## Testing

1. Run the whole flow with only a keyboard.
2. Use a screen reader (VoiceOver, NVDA, TalkBack) on the main flows.
3. Run axe or Lighthouse, knowing it finds only part of the issues.
4. Zoom to 200 percent and narrow the window to 320 pixels.
5. Turn on reduced motion, dark mode, and increased contrast.
