---
name: planning
description: Breaks work into ordered, verifiable tasks before implementation. Use it whenever the user asks for a plan, a roadmap, or an estimate, when requirements or a spec must become tasks, when the work spans several modules, sessions, or agents, or when a task feels too large or vague to start. Skip it for a change whose scope and order are already obvious.
---

<overview>
Break work into small, verifiable tasks with explicit acceptance criteria. Make each task small enough to implement, test, and verify in one focused session. A plan holds the requested work and what that work requires, and nothing more.
</overview>

<planning_process>
<read_only_first>
Before you write any code, work in read-only mode.
- Read the spec and the relevant parts of the codebase.
- Identify existing patterns and conventions.
- Map the dependencies between components.
- Note risks and unknowns.

Write no code during planning. The output is a plan document and a task list in the task list target, not implementation. The `output_files` block describes both. When the user asked for the work itself and not only for a plan, start the first task as soon as the plan is written, because the plan is a step of that work and needs no approval of its own.
</read_only_first>

<vertical_slices>
Build one complete feature path at a time. Do not build the whole database, then the whole API, then the whole UI. That horizontal slicing gives a plan like this bad one.

```
Task 1. Build entire database schema
Task 2. Build all API endpoints
Task 3. Build all UI components
Task 4. Connect everything
```

Vertical slicing builds every layer for one feature in each task, as in this good plan.

```
Task 1. User can create an account (schema + API + UI for registration)
Task 2. User can log in (auth schema + API + UI for login)
Task 3. User can create a task (task schema + API + UI for creation)
Task 4. User can view task list (query + API + UI for list view)
```

Each vertical slice delivers working, testable functionality.
</vertical_slices>

<task_template>
Each task follows this structure in the markdown task list. An item in an external tracker carries the same parts.

```markdown
- [ ] Task [N]. [Short descriptive title]

[One paragraph that explains what this task accomplishes.]

It is done when [specific, testable condition] and [specific, testable condition].

This check verifies it.
- [ ] [The check that would fail if this task were wrong, such as the repository's focused-test command, its build, or a manual check of the behavior.]

It depends on [task numbers, or no other task].

It likely touches `src/path/to/file.ts` and `tests/path/to/test.ts`.

Its size is [XS, S, M, or L], from the file counts in the `task_sizing` table.
```
</task_template>

<order_and_checkpoints>
Four rules set the task order.
1. Dependencies are satisfied, so the foundation comes first.
2. Each task leaves the system in a working state.
3. A checkpoint follows a group of tasks where an integration point, a risk, or a decision of the user sits.
4. High-risk tasks come early, so they fail fast.

Add explicit checkpoints to the task list target. This checkpoint follows tasks 1-3.

```markdown
Checkpoint after tasks 1-3.
- [ ] The tests that cover tasks 1-3 pass.
- [ ] The core user flow works end to end.
```
</order_and_checkpoints>
</planning_process>

<task_sizing>
Task size follows the number of files and the scope.

| Size | Files | Scope | Example |
|------|-------|-------|---------|
| XS | 1 | Single function or config change | Add a validation rule |
| S | 1-2 | One component or endpoint | Add a new API endpoint |
| M | 3-5 | One feature slice | User registration flow |
| L | 6-8 | Multi-component feature | Search with filtering and pagination |
| XL | 9+ | Too large, so break it down further | None |

Break an L or larger task into smaller tasks, because S and M tasks are easier to verify and review.

Four signs show that a task needs a further split.
- It would take more than one focused session.
- You cannot describe its acceptance criteria in 3 or fewer points.
- It touches two or more independent subsystems, such as auth and billing.
- Its title contains "and", which signals two tasks.
</task_sizing>

<output_files>
The planning output has two parts.
- The plan document is `plan.md` in the plan directory. It is always a markdown file, because design decisions, risks, and open questions do not fit tracker issues.
- The task list goes into the task list target, which the `task_list_target` block defines.

The plan directory is `tasks/` in the repository when the user or the project's agent rules ask for plans there. Otherwise it is the session's scratchpad or temporary directory. The repository then gets no files the user did not ask for. Create the directory if it does not exist. Below, `tasks/plan.md` and `tasks/todo.md` mean these files in the plan directory.

<no_overwrite>
Never overwrite an incomplete plan. Before you write `tasks/plan.md` or `tasks/todo.md`, check whether they exist and still hold unchecked tasks.
- If the user asked to revise or extend this same plan, update the existing files in place.
- If the files hold different work, stop and ask. Their unchecked tasks may be mid-build in another session. Do not delete, overwrite, or rename the files yourself. Present the conflict and let the user decide. The user can finish the old plan first, discard it, or name a place for the new plan.

The same rule holds for an external task list target. Never bulk-close or delete the open tracker items of another plan to make room for new ones.
</no_overwrite>

<task_list_target>
The task list target is where you record tasks and checkpoints. This block defines it once, and every other block in this skill defers to it.

By default it is a checklist-style markdown file named `todo.md` in the plan directory defined by `output_files`. Mirror the current tasks in the session's task tool when one exists.

The user or the project's agent rules, such as `CLAUDE.md` or `AGENTS.md`, may name an issue tracker. Examples are GitHub Issues, Jira, Linear, and `bd` (beads). Then create one tracker item per task instead of writing `tasks/todo.md`. Map the task template onto the tracker fields. Acceptance criteria and verification steps go in the item body. Dependencies use the tracker's links, such as `bd dep add` or "blocked by".

Record the checkpoints as tracker items too. If the tracker has no natural equivalent, keep them as a checklist in the plan document. Note the tracker in `tasks/plan.md`, as in "Tasks tracked in Linear project FOO." Later steps and future sessions then know where to look. The task list in the plan document then holds an ordered index of tracker items. It is not a duplicate checklist.
</task_list_target>
</output_files>

<plan_document_template>
The plan document follows this template.

```markdown
This plan covers [feature or project name]. [One paragraph that sums up what we are building.]

These decisions shape the architecture.
- [Key decision 1], chosen because [rationale].
- [Key decision 2], chosen because [rationale].

Phase 1 builds the foundation.
- [ ] Task 1. ...
- [ ] Task 2. ...
- [ ] The foundation checkpoint passes when tests pass and the build is clean.

Phase 2 builds the core features.
- [ ] Task 3. ...
- [ ] Task 4. ...
- [ ] The core checkpoint passes when the end-to-end flow works.

Phase 3 finishes the remaining requested work.
- [ ] Task 5. ...
- [ ] Task 6. ...
- [ ] The final checkpoint passes when all acceptance criteria are met.

| Risk | Impact | Mitigation |
|------|--------|------------|
| [Risk] | [High, medium, or low] | [Strategy] |

These questions need the user's input.
- [Question]?
```
</plan_document_template>

<parallel_work>
With several agents or sessions available, the work falls into three groups.
- Independent feature slices, tests for features already built, and documentation are safe to run in parallel.
- Database migrations, shared state changes, and dependency chains must run in sequence.
- Features that share an API contract need coordination. Define the contract first, then split the work.
</parallel_work>

<plan_check>
Confirm these points before you start implementation.
- [ ] Every task has acceptance criteria.
- [ ] Every task has a verification step.
- [ ] Task dependencies are identified and ordered correctly.
- [ ] Tasks are in the task list target, by default `tasks/todo.md`.
- [ ] No existing incomplete plan was overwritten without the user's explicit confirmation.
- [ ] No task touches more than about 5 files.
- [ ] Checkpoints sit at the integration points and risks.
- [ ] The plan's open questions and assumptions are stated for the user.

Acceptance criteria belong to each task and answer whether we built the right thing. They sit on top of the `verification` block of the coding instructions. That block is the standing bar every task clears before it counts as done.
</plan_check>
