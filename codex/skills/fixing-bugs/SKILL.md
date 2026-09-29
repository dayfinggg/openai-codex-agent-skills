---
name: fixing-bugs
description: Investigate errors, regressions, wrong output or flaky behavior and fix their cause when requested. Diagnosis-only requests stop at the explanation.
---

# Fixing bugs

Establish the reported failure with a reproduction, failing test, trace or relevant logs. Record the input and environment that matter. Start from the first causal error rather than treating downstream errors as independent bugs.

If the problem does not reproduce, compare working and failing environments and gather evidence. Do not invent a patch or demand a perfect local reproduction when logs already establish the cause. Use read-only production inspection unless changes are authorized.

Test one hypothesis with the smallest decisive probe. Narrow by input, layer or history as appropriate. Use git bisect only when the repository state allows it without disturbing user work. Search for related occurrences to understand impact, but change only the requested scope.

When a fix is requested, remove the cause with the smallest change. Add a focused regression test when it is practical and use existing test facilities. Verify that the test distinguishes broken and fixed behavior when safe, without blindly reverting a shared working tree. Rerun the reproduction and affected checks, expanding to the full suite for shared impact or project requirements.

Do not weaken assertions, swallow failures or special-case reported inputs to make checks green. A retry, guard or timeout belongs only when its behavior addresses the established cause.

When attempts contradict the hypothesis, discard your failed experiments without touching user changes, reread the evidence and change the hypothesis. Continue while meaningful authorized investigation remains. Report a concrete blocker rather than stopping after an arbitrary attempt count.

Remove temporary debugging artifacts. Report the cause, actual fix or diagnosis, supporting verification and any remaining uncertainty.
