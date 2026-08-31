# Error prevention and recovery

- Preserve user-entered data across validation errors, authentication renewal, navigation mistakes, and transient network failures.
- Prefer reversible actions and undo for common low-risk changes. Use confirmation when the consequence is costly, irreversible, or hard to inspect afterward.
- Explain an error in the user's vocabulary, identify what happened, keep useful context, and provide a concrete recovery action.
- Validate near the point of entry without interrupting ordinary input, then validate again at submission and on the server.
- Design empty, partial, offline, permission-denied, timeout, conflict, and stale-data states as part of the normal journey.
- Never make a user repeat work because the system lost ownership of state during a recoverable failure.
