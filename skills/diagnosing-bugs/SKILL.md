---
name: diagnosing-bugs
description: Gives a root-cause method for defects that reproduces, locates and explains the failure before fixing it at its source. Use when something fails or behaves unexpectedly, such as an error, crash, failing or flaky test, wrong result, regression or slowdown, when the user asks why something happens, and before a fix whose cause is unknown. Use before investigating a failure or editing a fix whose cause is not yet known.
---

# Diagnosing bugs

Change code once you can say why the failure happens, because a fix before the explanation is a guess.

## Reproduce

Make the failure happen on demand with the smallest command, input or test, and record the exact error text. In a stack trace, the frame that matters is often the first one in the project's own code. When it does not reproduce, compare versions, configuration, data and environment between where it fails and where it works.

## Locate

- `git log` and `git diff` on the affected files often show the cause, and `git bisect` finds the commit when a known good state exists.
- Write down two or three explanations that fit the facts. Test the cheapest first with a check that can prove it wrong, such as a log line, a debugger, a smaller input or a temporary assertion.
- Change one thing between runs, and trust a measurement over a reading of the code.

## Explain

State which value or state is wrong, where it becomes wrong and why. The cause is found when this accounts for every symptom.

## Fix and guard

- Fix the value where it becomes wrong, because a check where the symptom shows leaves the wrong value in the system.
- Rerun the reproduction and see it pass. In a repository with tests, add one that fails without the fix.
- Fix the same mistake in neighbouring code and its copies, and remove the logging and temporary code you added.

## Gotchas

- A retry, a sleep or a broad catch hides the symptom and keeps the cause. Find the cause instead.
- A flaky test usually comes from shared state, timing or ordering. Run it alone and in a loop to tell which.
- When two fixes in a row fail, the explanation is wrong, so return to the facts. Ask the user only when choosing between explanations needs knowledge only they have.
