# Key naming

- Redis keys are binary-safe and Redis has no built-in namespace, so collisions are an application responsibility.
- Use a stable, documented shape such as `app:environment:tenant:entity:id:variant`.
- Use lower-case, ASCII-safe segments and a consistent delimiter, normally `:`.
- Prefix keys by application and environment when deployments share an instance.
- Validate tenant and user-derived segments for length and allowed characters before composing a key.
- Never put secrets or unnecessary personal data in key names because keys appear in logs, metrics, and diagnostics.
- Treat key names as a compatibility surface. Changing them requires a migration or dual-read plan.
- Keep names readable and reasonably short, but do not remove segments that prevent collisions or clarify ownership.
- Use `SCAN` with a cursor for administrative iteration and make the operation safe to repeat because results can duplicate.
- Avoid `KEYS` in request paths because a large scan can block the server. Reserve it for controlled diagnostics.
- Check command complexity before applying a range, set algebra, sort, or full-collection read to an unbounded value.
