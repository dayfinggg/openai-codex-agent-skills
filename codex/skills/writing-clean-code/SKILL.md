---
name: writing-clean-code
description: Applies clean code rules for names, functions, errors, and duplication in any language. Use for every code change, including one-line fixes, scripts, tests, and code reviews.
---

# Writing clean code

## Priorities

When rules pull in different directions, this order decides.

1. Correctness for all valid inputs, without hard-coded values or special cases that only make a test pass. When a test or requirement looks wrong, say so.
2. Project conventions, linters, formatters, AGENTS.md, and style guides, which win over every rule here.
3. Scope. Change only what the task needs and mention other problems instead of fixing them. Google's engineering practices call 100 lines usually reasonable and 1000 lines usually too large. Refactoring goes in a separate change from new behavior.
4. Readability for a newcomer.
5. Simplicity. Build for the current task. Add an abstraction such as a strategy or a factory once a second real variant exists.

## Rules

- Use one word per concept across the codebase, not `fetch`, `get`, and `retrieve` for one operation.
- Extract a function when a block needs a comment to say what it does or the logic repeats. Length alone is no reason, because one deep function with a simple interface is easier to use than a chain of shallow ones.
- Replace a boolean flag parameter with two named functions. Adjacent parameters of the same type that callers can swap get distinct types or a parameter object (C++ Core Guidelines I.4 and I.24).
- Validate at system boundaries such as user input, files, network, and external APIs. Inside the system, trust types and contracts and skip checks for cases that cannot happen.
- Fail closed. An error inside a permission or validation check denies the operation, work left half done is rolled back, and messages to users reveal no internals, as the writing-secure-code skill describes.
- Shared state across threads, tasks, or processes is synchronized or confined to one owner, and checked for races and deadlocks.
- Merge only duplicated knowledge, meaning one rule kept in two places. Code that only looks alike stays separate until a third occurrence shows the shared rule.
- Wrap third-party APIs and I/O behind a small interface you own. Return empty collections instead of null. Split files by responsibility, not by line count.
- Comments explain only why, such as intent, constraints, workarounds, and spec links. Code you did not change gets no new comments, docstrings, or type annotations. User or project rules about comments override this.
- Fix a code smell only when it hurts the change at hand or the user asked for a refactor. Before a risky refactor of untested code, add characterization tests, then change structure in small steps.

## Exceptions

Leave generated, vendored, and migration code as it is. In hot paths, measure before restructuring. One-off scripts stay correct and readable and skip architecture.

## Before finishing

Run the project's formatter, linter, type checker, and tests, fix what they report, and review the diff. It holds only what the task needs, with no dead code, commented-out code, debug output, temporary files, or unused imports.

## Reference files

- [reference/language-idioms.md](reference/language-idioms.md) has the idioms chosen per language. Read the section for the language at hand.
- [examples.md](examples.md) has an over-engineered and a right-sized solution to one task. Read it when a change adds an abstraction.
