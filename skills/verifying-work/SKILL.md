---
name: verifying-work
description: Shows how to prove that a change works before it is reported as done. Use after writing or changing code, a script, a configuration file or a build, before saying that a task is finished, fixed or working, and when the user asks to test, check or make sure that something works.
---

# Verifying work

Work is done when a check that could have failed shows that it works. The report then names that check.

## Find the project's checks

Look where the project defines them, which is in the scripts in the manifest, a `Makefile` or task file, the CI configuration, and the contributing notes. Use those commands as written. Install the declared dependencies with the project's own package manager when they are missing.

## Run them in this order

Run the formatter and the linter first, then the type checker, then the tests that cover what you changed, then the full test suite when it is fast, then the build. Each step catches what the next one would report less clearly.

Then exercise the change itself. Types and unit tests show that the code is consistent, and only a run shows that it does what was asked. Run the command with real arguments, call the endpoint, or open the page in a browser and use the feature. Try the main path, one edge case and one input that should fail.

When the project has no checks for the change, write a throwaway script or command that exercises it, and remove it afterwards.

## Read the result

Read the output. A command that printed an error and returned success has failed. A test run that collected no tests has verified nothing, and neither has a check that did not start. A subagent's report that its task is done is a claim, so read its diff and run the check yourself before you pass it on.

When a check fails, fix the code. Do not loosen the check, skip the test or widen a type until the error goes away.

After three rounds of fixing with the same check still failing, stop repeating the fix. The explanation behind it is wrong, so go back to the facts and find the cause before the next change. Ask the user only for knowledge that only they have.

## Report

Say in one sentence how the change was verified, with the command and what it showed. When a check could not run here, name it and give the reason. Words such as "should work" stand for a check that was not run.

## Clean up

Remove the temporary files, test data, caches and build output that the verification produced. Ignored files do not show in a plain `git status`, so list them with `git status --short --ignored` and remove the cache directories that your checks created, such as those of the test runner, the linter and the type checker. Installed dependencies stay. Stop every process you started, such as a development server.
