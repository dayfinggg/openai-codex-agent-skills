# Validation and forms
- Put reusable Validator constraints on the underlying object, command DTO, or value object rather than only on a form field.
- Separate input-shape constraints from domain invariants that require a use-case decision or repository query.
- Use a dedicated form type when a form is complex or reused, and keep a simple form readable in one action.
- Process a form only after `isSubmitted()` and `isValid()` succeed.
- Keep form types focused on mapping and presentation concerns, not multi-step business orchestration.
- Use validation groups for genuinely different workflows and document which group the use case expects.
- Validate messages, console input, and imported data as well as browser forms.
- Return a stable API error shape instead of exposing raw constraint internals to clients.
