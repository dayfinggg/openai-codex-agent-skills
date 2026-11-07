---
name: debugging
description: Diagnosis loop for hard bugs and performance regressions. Use when something is broken, throwing, failing, flaky, giving wrong output, or slow, and the cause is not clear from the error and the code it points to. Use it before changing code to fix such a bug.
---

<overview>
This is a discipline for hard bugs. A fault whose cause the error already shows needs only the `debugging` block of the coding instructions. Skip a phase of this skill only when you can name the reason.

When you explore the codebase, read `GLOSSARY.md` if it exists. It gives a clear mental model of the relevant modules. Also check the ADRs in the area you touch.
</overview>

<redact>
This skill has you show commands, outputs, and captured artifacts. Redact every secret first, and write `<REDACTED>` in its place. Build loops against environment variables, so the credential stays in the environment and out of what you show. Captured artifacts carry auth headers, so quote only the lines that carry the signal.

If the redacted output is not enough to diagnose the bug, say so and ask the user.
</redact>

<phase_1_feedback_loop>
The feedback loop is the skill, and everything else is mechanical. A tight pass or fail signal goes red on this specific bug. With such a signal, you will find the cause. Bisection, hypothesis testing, and instrumentation all just consume it. Without one, no amount of staring at code will save you.

Most of the effort in a hard bug belongs here.

<ways_to_build_a_loop>
These ways to construct a loop come in roughly this order of preference.
1. A failing test at whatever seam reaches the bug, such as unit, integration, or e2e.
2. A curl or HTTP script against a running dev server.
3. A CLI invocation with a fixture input, diffing stdout against a known-good snapshot.
4. A headless browser script (Playwright or Puppeteer) that drives the UI and asserts on DOM, console, or network.
5. A replay of a captured trace. Save a real network request, payload, or event log to disk. Then replay it through the code path in isolation.
6. A throwaway harness. Spin up a minimal subset of the system, such as one service with mocked dependencies. It exercises the bug code path with a single function call.
7. A property or fuzz loop. If the bug is "sometimes wrong output", run 1000 random inputs and look for the failure mode.
8. A bisection harness. If the bug appeared between two known states, such as commits, datasets, or versions, automate the check. The harness boots at state X, checks, and repeats, so you can `git bisect run` it.
9. A differential loop. Run the same input through the old and new version, or through two configs, and diff the outputs.
10. A HITL bash script, as the last resort. If a human must click, drive them with `scripts/hitl-loop.template.sh` so the loop stays structured. Its captured output feeds back to you.
</ways_to_build_a_loop>

<hitl_script>
`scripts/hitl-loop.template.sh` is a human-in-the-loop reproduction loop. Copy it, replace its `step` and `capture` lines and the matching `printf` lines, and run it with `bash`. The agent runs the script, and the user follows the prompts in their terminal. `step "<instruction>"` shows an instruction and waits for Enter. `capture VAR "<question>"` shows a question and reads the answer into VAR. At the end, the script prints the captured values as KEY=VALUE lines for the agent to parse. `capture` prints its value back to the terminal, where the agent reads it. So capture only observations, and leave signing in to the user as a `step`.
</hitl_script>

<tighten_the_loop>
Treat the loop as a product. Once you have a loop, tighten it with these questions.
- Can I make it faster? Cache setup, skip unrelated init, and narrow the test scope.
- Can I make the signal sharper? Assert on the specific symptom, not on "didn't crash".
- Can I make it more deterministic? Pin time, seed the RNG, isolate the filesystem, and freeze the network.

A 30-second flaky loop is barely better than no loop. A 2-second deterministic loop is tight.
</tighten_the_loop>

<non_deterministic_bugs>
For a non-deterministic bug, the goal is a higher reproduction rate, not a clean repro. Loop the trigger 100 times, parallelise, add stress, narrow timing windows, and inject sleeps. A bug that fails 50 percent of the time is debuggable, and a 1 percent bug is not. Keep raising the rate until the bug is debuggable.
</non_deterministic_bugs>

<no_loop_possible>
When you cannot build a loop, stop and say so explicitly. List what you tried. Ask the user for one of these things.
- Access to an environment that reproduces the bug.
- A redacted captured artifact, such as a HAR file, log dump, core dump, or screen recording with timestamps.
- Permission to add temporary production instrumentation.
</no_loop_possible>

<phase_1_done>
Phase 1 is done when the loop is tight and red-capable. You can name one command, such as a script path, a test invocation, or a curl. You have already run it at least once, and you show the invocation and its redacted output. The command meets each condition in this checklist.
- [ ] It is red-capable. It drives the actual bug code path and asserts the user's exact symptom. So it goes red on this bug and green once fixed. "Runs without erroring" is not enough, because the command must catch this specific bug.
- [ ] It is deterministic, with the same verdict every run. For a flaky bug, it has a pinned, high reproduction rate.
- [ ] It is fast, taking seconds and not minutes.
- [ ] It is agent-runnable, so you can run it unattended. A human joins the loop only through `scripts/hitl-loop.template.sh`.

Reading code to build a theory before this command exists is the failure this skill prevents. Without a red-capable command, Phase 2 does not start.
</phase_1_done>
</phase_1_feedback_loop>

<phase_2_reproduce_and_minimise>
Run the loop, and watch it go red as the bug appears. Then confirm each item in this checklist.
- [ ] The loop produces the failure mode the user described, not a different failure nearby. The wrong bug leads to the wrong fix.
- [ ] The failure reproduces across multiple runs. A non-deterministic bug reproduces at a rate high enough to debug against.
- [ ] You captured the exact symptom, such as an error message, wrong output, or slow timing. Later phases use it to verify the fix.

Once the loop is red, shrink the repro to the smallest scenario that still goes red. Cut inputs, callers, config, data, and steps one at a time. Re-run the loop after each cut, and keep only what carries the failure. A minimal repro shrinks the hypothesis space in Phase 3, because fewer moving parts remain to suspect. It also becomes the clean regression test in Phase 5.

Minimising is done when every remaining element carries the failure. Removing any one of them then makes the loop go green. Do not proceed until you have reproduced and minimised the bug.
</phase_2_reproduce_and_minimise>

<phase_3_hypothesise>
Generate 3-5 ranked hypotheses before you test any of them. A single hypothesis anchors on the first plausible idea.

Each hypothesis must be falsifiable, so state the prediction it makes. Write it in the form "If X is the cause, then changing Y will make the bug disappear, or changing Z will make it worse." If you cannot state the prediction, the hypothesis is a vibe, so discard or sharpen it.

Show the ranked list to the user before you test it. The user often has domain knowledge that re-ranks the list at once, as in "we just deployed a change to #3". The user may also know hypotheses they already ruled out. This checkpoint is cheap and saves much time. Do not block on it, and proceed with your ranking if the user is away.
</phase_3_hypothesise>

<phase_4_instrument>
Each probe maps to a specific prediction from Phase 3. Change one variable at a time.

The tools come in this order of preference.
1. Debugger or REPL inspection, if the environment supports it. One breakpoint beats ten logs.
2. Targeted logs at the boundaries that distinguish the hypotheses.
3. Never "log everything and grep".

Tag every debug log with a unique prefix, such as `[DEBUG-a4f2]`. Cleanup at the end then becomes a single grep. Untagged logs survive, and tagged logs get removed.

Performance regressions need a different approach, because logs are usually wrong for them. Establish a baseline measurement first, with a timing harness, `performance.now()`, a profiler, or a query plan. Then bisect. Measure first, and fix second.
</phase_4_instrument>

<phase_5_fix_and_regression_test>
Write the regression test before the fix, but only if a correct seam exists for it.

A correct seam is one where the test exercises the real bug pattern as it occurs at the call site. The only available seam may be too shallow. For example, a single-caller test cannot catch a bug that needs multiple callers. A unit test also cannot replicate the chain that triggered the bug. A regression test at such a seam gives false confidence.

If no correct seam exists, that itself is the finding. The codebase architecture prevents the bug from being locked down, so tell the user in the report.

If a correct seam exists, follow these steps.
1. Turn the minimised repro into a failing test at that seam.
2. Watch it fail. If you forced the red by mutating code or a fixture, `diff` against a pristine copy. This proves the mutation landed before you trust it.
3. Apply the fix.
4. Watch the test pass.
5. Re-run the Phase 1 feedback loop against the original, un-minimised scenario.
</phase_5_fix_and_regression_test>

<phase_6_cleanup>
These items are required before you declare the bug done.
- [ ] The original repro no longer reproduces, after a re-run of the Phase 1 loop.
- [ ] The regression test passes, or the absence of a seam is documented.
- [ ] All `[DEBUG-...]` instrumentation is removed, after a `grep` for the prefix.
- [ ] Throwaway files are removed, as `code_rules` in the coding instructions requires.
- [ ] The report states the hypothesis that turned out correct. When the user asks for a commit or PR, its message states it too, so the next debugger learns it.
</phase_6_cleanup>

<attribution>
Read [credits](references/credits.md) when checking source attribution or redistribution terms.
</attribution>
