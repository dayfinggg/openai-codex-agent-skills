---
name: research
description: Research an engineering API, version, configuration, or integration question against primary sources and report findings in chat.
---

Read [local host integration](../.shared/host-integration.md) before applying this workflow.

Investigate the engineering question directly using primary sources.

1. Recover the exact question, installed dependency versions, relevant integration, and constraints from the current conversation and repository.
2. Read the relevant official documentation, specification, source code, or first-party API. A search snippet or page title does not establish the governing behavior.
3. Match sources to the installed or explicitly selected version. Trace disputed or consequential claims back to their owner and reconcile material disagreements.
4. Compare documented behavior with the actual integration and identify which finding changes the implementation decision. Do not expand into unrelated recommendations.
5. Preserve the distinction between verified facts, inference, and unavailable evidence. Continue independent research while a genuinely necessary clarification is pending.
6. Return concise, sourced findings in chat. Create a Markdown research file only when the user explicitly requests that deliverable. Use a background or separate agent only when explicitly authorized.

Finish when the question is answered to the precision required for the user's task. More sources are useful only when they resolve a material uncertainty.
