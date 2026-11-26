---
name: diagnosing-bugs
description: Gives a root-cause method for defects. Use when something fails or behaves unexpectedly, such as an error, a crash, a failing or flaky test, a wrong result, a regression or a performance drop, when the user asks why something happens, and before any fix whose cause is not yet known. Load when a failure or an unexpected result first needs an explanation, before you investigate it or edit a fix.
---

# Diagnosing bugs

A fix that precedes the explanation is a guess. Find the cause first, and change code only after you can say why the failure happens.

## Reproduce

Get the failure to happen on demand, with the smallest command, input or test that shows it. Record the exact error text and where it comes from. Read the whole message and the whole stack trace. The line that matters is often the first one in your own code.

When you cannot reproduce it, say so and collect more facts, such as versions, configuration, input data, and the difference between the place where it fails and the place where it works.

## Locate

Check what changed. `git log` and `git diff` on the affected files often point at the cause, and `git bisect` finds the commit when a known good state exists.

Write down two or three explanations that fit the facts. Test the cheapest one first with a check that can prove it wrong, such as a log line, a debugger, a smaller input or a temporary assertion. Change one thing between runs. Trust a measurement over a reading of the code.

## Explain

State the cause in one or two sentences that say which value or state is wrong, where it becomes wrong, and why. If the statement does not account for every symptom, the cause is not found yet.

When the user asked only why something happens, stop here and report the cause. Fix it when they ask for a fix.

## Fix and guard

Fix the cause where it arises. A check added at the place where the symptom shows leaves the wrong value in the system.

Run the reproduction again and see it pass. In a repository that keeps tests, add a test that fails without the fix. Remove the logging and the temporary code you added.

Look for the same mistake in the code next to it and in copies of it.

## Gotchas

Do not make a failing test pass by changing the test, by adding a retry or a sleep, or by catching the error.

A flaky test has a cause too, usually shared state, timing or ordering. Run it alone and in a loop to see which.

After three failed attempts at a fix, stop. The explanation is wrong or the design is. Go back to the facts, and ask the user when the choice between explanations needs knowledge that only they have.

## Related skills

The fix and the guard are separate kinds of work. Load `clean-code` before you write the fix, `writing-tests` before you write the regression test, and `verifying-work` before you report.
