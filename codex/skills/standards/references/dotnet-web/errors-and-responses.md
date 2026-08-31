# Errors and responses

- Enable the Developer Exception Page only in `Development`.
- In non-development environments use `UseExceptionHandler` and a consistent RFC 7807 `ProblemDetails` response.
- Register `AddProblemDetails` when Minimal APIs and controllers need a common error format.
- Map expected domain outcomes to deliberate `4xx` results and reserve `5xx` responses for unexpected server failures.
- Do not use exceptions for normal branching or validation decisions.
- Never return stack traces, connection strings, tokens, or other sensitive details to clients.
- Log the complete server-side exception with a request or trace identifier while returning a safe client payload.
