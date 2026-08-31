# Validation and authorization
- Use inline `Validator` rules for a small, local input shape.
- Use a `FormRequest` when validation, authorization, preparation, or after-validation checks deserve a named boundary.
- Keep `rules()` about input constraints and `authorize()` about whether the current caller may perform the request.
- Laravel validates a type-hinted form request before the controller method runs.
- Use custom rule objects for complex or shared constraints, and keep business invariants in the action or domain object.
- Validate command payloads again when the same action is called from a job, command, or integration.
- Use policies or `can` middleware for resource permissions, including ownership and tenant scope.
- Do not treat client-provided role fields, hidden controls, or route visibility as authorization.
