---
name: verifying-work
description: Shows how to prove a change works, from the project's own checks to exercising the change the way the user meets it. Use after changing code, a script, configuration or a build, before calling a task done, fixed or working, and when the user asks to test, check or make sure something works. Use before the first check of a change, and at the latest before a commit, a deploy or the final answer.
---

# Verifying work

A change is verified when a check that could have failed shows it working.

## Find the project's checks

Look in the manifest scripts, a `Makefile` or task file, the CI configuration and the contributing notes, and run those commands as written. Install missing declared dependencies with the project's own package manager.

## Run them in order

1. The formatter and the linter, then the type checker.
2. The tests that cover the change, then the full suite, in the background when it is slow.
3. The build.
4. The change itself, the way the user meets it. Run the command with real arguments, call the endpoint, open the page and use the feature at the sizes it is used, or read the service logs right after a deploy. Try the main path, one edge case and one input that should fail. A development server that never exits runs in the background, and a background command that exits once the server answers tells you when it is ready.

Only step 4 shows that the change does what was asked. When the project has no check for the change, exercise it with a throwaway script and delete it afterwards.

## Read the result

- A command that printed an error and exited with success has failed.
- A run that collected no tests, or a check that never started, verified nothing.
- A subagent's report that it is done is a claim. Read the diff, output or source behind it and run the check yourself.
- Before the final answer, match each requested outcome to evidence you observed, read the final diff, and remove edits the task did not need.
- When a check fails, fix the code and keep the check as strict as it was.
- Compare the result with what the documentation and the standards require, and keep each point it misses for the final answer.
- "Should work" marks a check that did not run. Run it, or name it in the final answer with the reason.

## Clean up

Remove the temporary files, test data, caches and build output the checks produced. `git status --short --ignored` shows ignored files that a plain `git status` hides, such as test runner, linter and type checker caches. Keep installed dependencies, and stop every process you started, such as a development server.
