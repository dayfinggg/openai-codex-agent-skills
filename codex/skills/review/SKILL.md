---
name: review
description: "Reviews a branch, a PR, or work-in-progress changes since a fixed point (commit, branch, tag, or merge-base) along two axes. The Standards axis checks the repo's documented coding standards. The Spec axis checks what the originating issue or spec asked for. Both run in parallel sub-agents. Use when asked to review changes, or before opening a pull request for a multi-file change."
---

<overview>
This skill reviews the diff between `HEAD` and a fixed point along two axes.
- The Standards axis asks whether the code conforms to this repo's documented coding standards.
- The Spec axis asks whether the code faithfully implements the originating issue or spec.

Both axes run as parallel sub-agents, so they do not pollute each other's context. This skill then aggregates their findings. Use a sub-agent type that starts with a fresh context, not a fork of this conversation.
</overview>

<process>
<step_1_pin_the_fixed_point>
The fixed point is whatever the user named, such as a commit SHA, branch name, tag, `main`, or `HEAD~5`. If the user named none, use the default branch.

Capture the diff command once as `git diff <fixed-point>...HEAD`. The three dots compare against the merge-base. Also note the list of commits from `git log <fixed-point>..HEAD --oneline`. That command leaves out uncommitted changes. To review uncommitted work, use `git diff HEAD`, and list untracked files with `git status --short`.

Before you go further, confirm the fixed point with `git rev-parse <fixed-point>`. Also confirm that the diff is not empty. A bad ref or an empty diff should fail here, not inside two parallel sub-agents.
</step_1_pin_the_fixed_point>

<step_2_identify_the_spec_source>
Look for the originating spec in this order.
1. Issue references in the commit messages, such as `#123`, `Closes #45`, or GitLab `!67`, fetched with the tracker's CLI.
2. A path the user passed as an argument.
3. A spec file under `docs/`, `specs/`, or `.scratch/` that matches the branch name or feature.
4. The user's request in this conversation.
5. If none of these exists, the Spec sub-agent skips and reports "no spec available".
</step_2_identify_the_spec_source>

<step_3_identify_the_standards_sources>
Search the repo for every file that documents how code should be written. When `CODING_STANDARDS.md`, `CONTRIBUTING.md`, `CLAUDE.md`, or `AGENTS.md` exists, it must be on the list.

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

<step_4_spawn_both_sub_agents>
Issue both sub-agent calls together, in the foreground, and aggregate the reports they return.

The Standards sub-agent prompt includes these items.
- The full diff command and the commit list.
- The list of standards source files from step 3, plus the smell baseline from step 3 pasted in full. The sub-agent has no other access to it.
- This brief. "Report each place where the diff violates a documented standard, per file or hunk where relevant. Cite the standard by its file and rule. Also report each baseline smell you spot, with its name and the quoted hunk. Separate hard violations from judgement calls. A documented-standard breach can be hard, but a baseline smell is always a judgement call. A documented repo standard overrides the baseline. Skip anything tooling enforces. Stay under 400 words."

The Spec sub-agent prompt includes these items.
- The diff command and the commit list.
- The path or the fetched contents of the spec.
- This brief. "Report the requirements that the spec asked for and the diff misses or only partly covers. Report the behaviour in the diff that nobody asked for, which is scope creep. Report the requirements that look implemented but where the implementation looks wrong. Quote the spec line for each finding. Stay under 400 words."

If the spec is missing, skip the Spec sub-agent and note this in the final report.
</step_4_spawn_both_sub_agents>

<step_5_aggregate>
Present the two reports separately, Standards first and Spec second, in the format the output style sets. Do not merge or rerank the findings, because the two axes are deliberately separate.

End with a one-line summary of the total findings per axis and the worst issue within each axis, if any. Do not pick a single winner across axes, because that is the reranking the separation exists to prevent.
</step_5_aggregate>
</process>

<why_two_axes>
A change can pass one axis and fail the other.
- Code that follows every standard but implements the wrong thing passes Standards and fails Spec.
- Code that does exactly what the issue asked but breaks the project's conventions passes Spec and fails Standards.

Separate reports stop one axis from masking the other.
</why_two_axes>

<attribution>
Read [credits](references/credits.md) when checking source attribution or redistribution terms.
</attribution>
