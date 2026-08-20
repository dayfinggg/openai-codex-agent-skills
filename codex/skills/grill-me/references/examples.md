# Trigger examples

Use the first pattern only when the unresolved choice can change the implementation materially.

## Confirm before acting

User request

```text
Make authentication safer and easier to use.
```

After inspecting the repository, form one concrete hypothesis.

```text
Hypothesis: you want to keep the current sign-in method and add stronger session protection.

Which direction is correct?
1. Keep the current sign-in method and harden sessions (Recommended)
2. Replace the identity flow with an external provider
```

Offer the first option as the recommendation only when repository evidence supports it. The choices must be mutually exclusive. Wait for the answer before asking about dependent choices.

## Continue with a clear task

User request

```text
Fix the null check in the parser and add a regression test.
```

Inspect the parser and implement the focused fix when the expected behavior is already clear from the code and tests. Do not start an interview.

## Ask one question, not a questionnaire

```text
Which compatibility target should the new public interface preserve?

1. Existing callers only (Recommended)
2. Existing callers and the documented next version
```

If the host question tool is unavailable, send one plain-text question with the same choices. Do not replace the question with a table of unresolved decisions.
