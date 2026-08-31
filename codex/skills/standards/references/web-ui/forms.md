# Forms

- Use one `<form>` per coherent submission task and never nest forms.
- Group related controls with `<fieldset>` and label each group with `<legend>`.
- Associate every control with a visible `<label>` using matching `for` and `id` values, or use an explicit equivalent when a visible label cannot be shown.
- Do not use placeholder text as the only label; it disappears during input and has weak contrast in many user agents.
- Choose the input type that matches the data, such as `email`, `tel`, `url`, `date`, or `number`, and use `inputmode` only to refine input method.
- Give submitted controls stable `name` values and provide appropriate `autocomplete` tokens for information the user may reuse.
- Set `type="button"` for non-submitting buttons and state the intended submit behavior explicitly.
- Use native constraints such as `required`, `min`, `max`, `minlength`, `maxlength`, `pattern`, and the appropriate input type when they express the rule.
- Explain required formats before submission and show errors in text that identifies the field and the correction.
- Associate dynamic help and errors with `aria-describedby` or the relevant native relationship, and update focus deliberately after failed submission.
- Treat client-side validation as feedback, not as a security boundary; validate and authorize again on the server.
- Do not submit on change unless the behavior is expected, announced, and usable from a keyboard and assistive technology.
- Preserve entered values and useful focus when a submission or network request fails.
