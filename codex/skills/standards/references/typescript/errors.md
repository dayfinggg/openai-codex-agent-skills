# Errors

- Throw `Error` instances or deliberate subclasses, not strings or arbitrary primitives.
- Catch as `unknown` and narrow with `instanceof`, a stable discriminator, or a validated predicate. [S6][S9]
- Identify Node.js failures by stable error codes where available, not by mutable human-readable messages. [S28]
- Preserve causal information when adding context, using `cause` or a typed equivalent. [S28]
- Handle an error at the layer that can recover, translate, retry, report, or terminate meaningfully.
- Do not catch an error only to rethrow it unchanged or to return a misleading success value.
- Never swallow an error without recording why it is safe and what signal replaces it.
- Distinguish expected validation or business failures from programmer defects and infrastructure failures.
- Keep error messages free of secrets, tokens, raw credentials, and unbounded external payloads.
- Test both the error value exposed to callers and the side effects of failure paths.
