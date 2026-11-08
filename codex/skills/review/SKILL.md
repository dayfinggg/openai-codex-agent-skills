---
name: review
description: "Reviews a branch, a PR, or work-in-progress changes since a fixed point (commit, branch, tag, or merge-base) along three axes. Correctness looks for bugs and security problems. Standards checks the repo's documented coding standards. Spec checks what the originating issue or spec asked for. Each axis runs in a fresh sub-agent, and a verifier confirms bug findings before the report. Use when asked to review changes, or before opening a pull request for a multi-file change."
---

<overview>
This skill reviews the diff between `HEAD` and a fixed point along three axes.
- The Correctness axis asks whether the change works, fits the system, and breaks nothing.
- The Standards axis asks whether the code conforms to this repo's documented coding standards.
- The Spec axis asks whether the code faithfully implements the originating issue or spec.

Each axis runs as a parallel sub-agent, so the axes do not pollute each other's context. This skill then verifies and aggregates their findings. Use a sub-agent type that starts with a fresh context, not a fork of this conversation.
</overview>

<process>
<step_1_pin_the_fixed_point>
The fixed point is whatever the user named, such as a commit SHA, branch name, tag, `main`, or `HEAD~5`. If the user named none, use the default branch.

Capture the diff command once as `git diff <fixed-point>...HEAD`. The three dots compare against the merge-base. Also note the list of commits from `git log <fixed-point>..HEAD --oneline`. That command leaves out uncommitted changes. To review uncommitted work, use `git diff HEAD`, and list untracked files with `git status --short`.

Before you go further, confirm the fixed point with `git rev-parse <fixed-point>`. Also confirm that the diff is not empty. A bad ref or an empty diff should fail here, not inside parallel sub-agents.
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

The Standards axis always carries the smell baseline below, on top of whatever the repo documents. The baseline is a fixed set of Fowler code smells from Refactoring, chapter 3. It applies even when a repo documents nothing. Two rules bind it.
- The repo overrides the baseline. A documented repo standard always wins. Where it endorses something the baseline would flag, suppress the smell.
- Each smell is a judgement call. Label it as a heuristic, as in "possible Feature Envy", never as a hard violation. Like any standard here, skip anything tooling already enforces.

Each smell below says what it is and then how to fix it. Match each one against the diff.
- Mysterious Name means a function, variable, or type whose name hides what it does or holds. Rename it, and if no honest name comes, the design is murky.
- Duplicated Code means the same logic shape appears in more than one hunk or file in the change. Extract the shared shape, and call it from both places.
- Feature Envy means a method that reaches into another object's data more than its own. Move the method onto the data it envies.
- Data Clumps means the same few fields or parameters keep travelling together, so a type wants to be born. Bundle them into one type, and pass that.
- Primitive Obsession means a primitive or string stands in for a domain concept that deserves its own type. Give the concept its own small type.
- Repeated Switches means the same `switch` or `if` cascade on the same type recurs across the change. Replace it with polymorphism, or with one map that both sites share.
- Shotgun Surgery means one logical change forces scattered edits across many files in the diff. Gather what changes together into one module.
- Divergent Change means one file or module is edited for several unrelated reasons. Split it, so each module changes for one reason.
- Speculative Generality means abstraction, parameters, or hooks added for needs the spec does not have. Delete it, and inline it back until a real need shows.
- Message Chains means long `a.b().c().d()` navigation that the caller should not depend on. Hide the walk behind one method on the first object.
- Middle Man means a class or function that mostly just delegates onward. Cut it, and call the real target directly.
- Refused Bequest means a subclass or implementer that ignores or overrides most of what it inherits. Drop the inheritance, and use composition.
</step_3_identify_the_standards_sources>

<step_4_spawn_the_sub_agents>
Issue all sub-agent calls together, in the foreground, and collect the reports they return.

The Correctness sub-agent prompt includes these items.
- The full diff command, the commit list, and the stated intent from step 2.
- This brief. "Find bugs and security problems that the diff introduces. Read the changed code against the rest of the repo, including callers, tests, and config. Check that the change solves its stated problem and fits the system. For a bug fix, check that it removes the root cause. Look for injection, exposed secrets, and missing authorization. Give each finding its file and line, the input or scenario that fails, and the consequence. Mark a problem that existed before this diff as pre-existing. Skip style, naming, and cleanup. Report each finding once, in one short entry, with no preamble or recap."

The Standards sub-agent prompt includes these items.
- The full diff command and the commit list.
- The list of standards source files from step 3, plus the smell baseline from step 3 pasted in full. The sub-agent has no other access to it.
- This brief. "Report each place where the diff violates a documented standard, per file or hunk where relevant. Cite the standard by its file and rule. Also report each baseline smell you spot, with its name and the quoted hunk. Separate hard violations from judgement calls. A documented-standard breach can be hard, but a baseline smell is always a judgement call. A documented repo standard overrides the baseline. Skip anything tooling enforces. Report each finding once, in one short entry, with no preamble or recap."

The Spec sub-agent prompt includes these items.
- The diff command and the commit list.
- The path or the fetched contents of the spec.
- This brief. "Report the requirements that the spec asked for and the diff misses or only partly covers. Report the behaviour in the diff that nobody asked for, which is scope creep. Report the requirements that look implemented but where the implementation looks wrong. Quote the spec line for each finding. Report each finding once, in one short entry, with no preamble or recap."

If the spec is missing, skip the Spec sub-agent and note this in the final report.
</step_4_spawn_the_sub_agents>

<step_5_verify_bug_findings>
A false bug report costs the author a fix round, so confirm each Correctness finding before you report it. Give all of them to one more fresh sub-agent, together with the diff command. Its brief asks it to confirm or reject each finding against the code, with a one-sentence reason. Report only the confirmed findings. If the Correctness sub-agent found nothing, skip this step.
</step_5_verify_bug_findings>

<step_6_aggregate>
Open the report with the number of findings per axis. When no axis found anything to fix, say so plainly in that first sentence.

Then present each axis separately, Correctness first, Standards second, and Spec third, in the format the output style sets. Do not merge or rerank findings across axes, because the axes are deliberately separate. Within an axis, tag each finding as important, nit, or pre-existing, and list them in that order. A pre-existing finding was already in the code before this change, so it does not count against the author. Keep nits few, unless `REVIEW.md` asks for more.

Name the worst issue within each axis, if any. Do not pick a single winner across axes, because that is the reranking the separation exists to prevent.
</step_6_aggregate>
</process>

<repeat_reviews>
A review that follows fixes to an earlier review follows four rules.
- Review only the diff since the last review, with that review's `HEAD` as the fixed point.
- Do not repeat a finding that an earlier round already reported.
- When a finding is a class of bug, ask for a fix at every instance, not only at the cited line.
- After three rounds on the same change, stop. Report that the approach itself may need rethinking, instead of starting a fourth round.
</repeat_reviews>

<why_separate_axes>
A change can pass one axis and fail another.
- Code that runs correctly and follows every standard can still implement the wrong thing, so it fails Spec.
- Code that does exactly what the issue asked can still break the project's conventions, so it fails Standards.
- Code that meets the spec and the standards can still crash on an input nobody tested, so it fails Correctness.

Separate reports stop one axis from masking another.
</why_separate_axes>
