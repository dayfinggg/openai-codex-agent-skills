# Progressive enhancement

- Make the content and essential task work in semantic HTML before adding CSS and JavaScript.
- Use feature detection, not browser sniffing; test the declaration or API that the enhancement actually needs.
- Write a usable fallback first, then add new CSS inside `@supports` or add behavior after capability detection.
- Remember that unsupported CSS declarations are discarded, while an invalid selector list can discard the whole rule; use forgiving selectors where appropriate.
- Let native links, forms, buttons, validation, history, and focus behavior provide the baseline before intercepting them.
- Do not hide essential content behind a client-only render or turn a working control into a loading placeholder.
- Provide an understandable alternative when an enhancement cannot run, and test the page with CSS and JavaScript disabled.
