---
name: review
description: "Reviews a change with fresh reviewers that did not write it, for bugs and security problems, for breaches of the repo's documented coding standards, and for gaps against what was asked. Use when the user asks for a review, before opening a pull request, and before you report as done a change that is large or hard to undo, such as one that spans several modules or touches data, security, or a production system."
---

<overview>
This skill reviews the diff between `HEAD` and a fixed point along three axes.
- The Correctness axis asks whether the change works, fits the system, and breaks nothing.
- The Standards axis asks whether the code conforms to this repo's documented coding standards.
- The Spec axis asks whether the code faithfully implements the originating issue or spec.

The size of the change sets the number of reviewers. A small change with one concern gets one sub-agent that carries all three briefs. A large or risky change gets one sub-agent for each axis, in parallel, so the axes do not pollute each other's context. Use a sub-agent type that starts with a fresh context, not a fork of this conversation.

When the user asked only for a review, report the findings and change nothing. When you review your own change before reporting it done, fix the confirmed Correctness and Spec findings that the change introduced, and report the rest. Standards judgement calls and pre-existing problems stay the user's decision in both cases.
</overview>

<process>
<step_1_pin_the_fixed_point>
The fixed point is whatever the user named, such as a commit SHA, branch name, tag, `main`, or `HEAD~5`. If the user named none, use the default branch.

Capture the diff command once as `git diff <fixed-point>...HEAD`. The three dots compare against the merge-base. Also note the list of commits from `git log <fixed-point>..HEAD --oneline`. That command leaves out uncommitted changes. To review uncommitted work, use `git diff HEAD`, and list untracked files with `git status --short`.

Before you go further, confirm the fixed point with `git rev-parse <fixed-point>`. Also confirm that the diff is not empty. A bad ref or an empty diff should fail here, not inside parallel sub-agents. When the change lives outside git, such as files installed on another machine, keep the before and after copies and give the sub-agents a diff of those copies, so each axis still reads the whole change.
</step_1_pin_the_fixed_point>

<step_2_identify_the_spec_source>
Look for the originating spec in this order.
1. Issue references in the commit messages, such as `#123`, `Closes #45`, or GitLab `!67`, fetched with the tracker's CLI.
2. A path the user passed as an argument.
3. A spec file under `docs/`, `specs/`, or `.scratch/` that matches the branch name or feature.
4. The user's request in this conversation.
5. If none of these exists, the Spec sub-agent skips and reports "no spec available".

The spec also gives the Correctness axis the stated intent of the change.
</step_2_identify_the_spec_source>

<step_3_identify_the_standards_sources>
Search the repo for every file that documents how code should be written. When `CODING_STANDARDS.md`, `CONTRIBUTING.md`, `CLAUDE.md`, or `AGENTS.md` exists, it must be on the list.

A `REVIEW.md` file sets the review rules for its repo. It can say what failure means there, which paths to skip, and how many nits to report. When it exists, pass it to every sub-agent, and follow it over this skill's defaults.

The Standards axis always carries the smell baseline in [smell-baseline.md](references/smell-baseline.md), on top of whatever the repo documents. The baseline is a fixed set of Fowler code smells from Refactoring, chapter 3. It applies even when a repo documents nothing. Two rules bind it.
- The repo overrides the baseline. A documented repo standard always wins. Where it endorses something the baseline would flag, suppress the smell.
- Each smell is a judgement call. Label it as a heuristic, as in "possible Feature Envy", never as a hard violation. Like any standard here, skip anything tooling already enforces.

The Standards sub-agent reads that file itself, so pass its absolute path and do not paste the list. Read the file whole yourself only when you run the Standards axis without a sub-agent.
</step_3_identify_the_standards_sources>

<step_4_spawn_the_sub_agents>
Issue all sub-agent calls together, in the foreground, and collect the reports they return. Each prompt holds only the items below, the read-only limits of the review, and the length of the report, because the form and language of the report come from the base instructions. For a small change, give one sub-agent the items and briefs of all three axes, and ask it to report each axis apart.

The Correctness sub-agent prompt includes these items.
- The full diff command, the commit list, and the stated intent from step 2.
- This brief. "Find bugs and security problems that the diff introduces. Read the changed code against the rest of the repo, including callers, tests, and config. Check that the change solves its stated problem and fits the system. For a bug fix, check that it removes the root cause. Look for injection, exposed secrets, and missing authorization. Give each finding its file and line, the input or scenario that fails, and the consequence. Mark a problem that existed before this diff as pre-existing. Skip style, naming, and cleanup. Report each finding once, in one short entry, with no preamble or recap."

The Standards sub-agent prompt includes these items.
- The full diff command and the commit list.
- The list of standards source files from step 3, plus the absolute path of the smell baseline file from step 3, with the instruction to read it whole before judging the diff.
- This brief. "Report each place where the diff violates a documented standard, per file or hunk where relevant. Cite the standard by its file and rule. Also report each baseline smell you spot, with its name and the quoted hunk. Separate hard violations from judgement calls. A documented-standard breach can be hard, but a baseline smell is always a judgement call. A documented repo standard overrides the baseline. Skip anything tooling enforces. Report each finding once, in one short entry, with no preamble or recap."

The Spec sub-agent prompt includes these items.
- The diff command and the commit list.
- The path of the spec, or its fetched contents once in their original wording, without a translation.
- This brief. "Report the requirements that the spec asked for and the diff misses or only partly covers. Report the behaviour in the diff that nobody asked for, which is scope creep. Report the requirements that look implemented but where the implementation looks wrong. Quote the spec line for each finding. Report each finding once, in one short entry, with no preamble or recap."

If the spec is missing, skip the Spec sub-agent and note this in the final report.

When no tool for starting a sub-agent is available, run the axes yourself, one after another. Reread the diff once for each axis against that axis's brief and items above, confirm or reject each Correctness finding against the code a second time in place of step 5, and say in the report that no fresh reviewer ran, because a self-review misses what a fresh reader would catch.
</step_4_spawn_the_sub_agents>

<step_5_verify_bug_findings>
A false bug report costs the author a fix round, so confirm each Correctness finding before you report it. Open the cited lines and confirm or reject each finding against the code, with a one-sentence reason. Give a finding to one more fresh sub-agent only when you cannot settle it yourself. Report only the confirmed findings. If the Correctness axis found nothing, skip this step.
</step_5_verify_bug_findings>

<step_6_aggregate>
The reply to the user follows the `writing_style` rules, and its length limit holds unless the user asked for the full review. Open with the number of confirmed findings per axis, or say plainly that no axis found anything to fix.

Then give the findings that need a fix, Correctness first, Standards second, and Spec third, each with its file and line. Keep the axes apart and do not rerank findings across them, because the axes are deliberately separate. A pre-existing finding was already in the code before this change, so it does not count against the author. Pre-existing findings and nits get one sentence in total, unless `REVIEW.md` or the user asks for more.
</step_6_aggregate>
</process>

<repeat_reviews>
A review that follows fixes to an earlier review follows four rules.
- Review only the diff since the last review, with that review's `HEAD` as the fixed point.
- Do not repeat a finding that an earlier round already reported.
- When a finding is a class of bug, ask for a fix at every instance the change introduced or touches, not only at the cited line.
- After three rounds on the same change, stop. Report that the approach itself may need rethinking, instead of starting a fourth round.
</repeat_reviews>

<why_separate_axes>
A change can pass one axis and fail another.
- Code that runs correctly and follows every standard can still implement the wrong thing, so it fails Spec.
- Code that does exactly what the issue asked can still break the project's conventions, so it fails Standards.
- Code that meets the spec and the standards can still crash on an input nobody tested, so it fails Correctness.

Separate reports stop one axis from masking another.
</why_separate_axes>
