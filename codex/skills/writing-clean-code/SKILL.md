---
name: writing-clean-code
description: Applies clean code rules for names, functions, errors, and duplication in any language. Use for every code change, including one-line fixes, scripts, tests, and code reviews.
---

# Writing clean code

Clean code is code another developer can read, understand, and change safely without asking the author. Apply these principles to every line you write or touch, and keep each change as small as the task allows.

## Priorities

When principles pull in different directions, resolve them in this order.

1. **Correctness.** The code works for all valid inputs, not only for the test cases. Never hard-code values or special-case inputs to make a test pass. If a test or requirement looks wrong, say so instead of working around it.
2. **Project conventions.** Match the existing style, naming, structure, linters, formatters, and any AGENTS.md or style guide, because consistency inside a codebase matters more than any general rule in this skill.
3. **Scope.** Change only what the task needs. A bug fix does not need the surrounding code rewritten, and a small feature does not need extra configurability. Mention other problems you notice instead of fixing them uninvited. Keep each change small enough to review, since Google's engineering practices call 100 lines usually reasonable and 1000 lines usually too large, and put refactoring in a separate change from new behavior.
4. **Readability.** Among correct solutions, pick the one a newcomer understands fastest.
5. **Simplicity.** The right amount of complexity is the minimum the current task needs. Do not design for hypothetical future requirements.

## Names

Names carry most of the meaning in code, so spend effort on them.

- A name says why the thing exists and what it does, so the reader never needs a comment to decode it (`elapsed_days`, not `d`).
- Name length grows with scope. A loop index can be `i`, a module-level constant needs a full phrase.
- Functions and methods are verbs (`calculate_total`), classes and data are nouns (`Invoice`), booleans read as yes/no questions (`is_active`, `has_items`).
- Use one word per concept across the codebase. Do not mix `fetch`, `get`, and `retrieve` for the same operation.
- Avoid abbreviations except universal ones (`id`, `url`, `http`), and avoid encoding types in names.

## Functions

- A function does one thing at one level of abstraction. Extract a function when a block needs a comment to say what it does, or when the same logic appears again. Do not split code only to make functions shorter, because a deep function with a simple interface is easier to use than a chain of shallow ones the reader has to chase.
- Prefer few parameters. Group values that always travel together into an object. Replace a boolean flag parameter with two clearly named functions.
- Make parameters precisely and strongly typed. Avoid adjacent parameters of the same type that callers can swap by mistake, and use distinct types or a parameter object instead (C++ Core Guidelines I.4 and I.24, which hold in any language).
- Return early with guard clauses instead of nesting conditionals.
- A function either changes state or answers a question, not both, and it has no hidden side effects.
- Read top-down. Callers come before callees, high-level steps before details.

## Data and state

- Replace magic numbers and strings with named constants.
- Declare variables close to first use, in the smallest possible scope.
- Prefer immutable values and pure functions where the language makes it natural. Avoid global mutable state.
- When state is shared across threads, tasks, or processes, guard every access with the language's synchronization or confine the state to one owner, and check the code for races and deadlocks before it ships.
- Return empty collections instead of null or None.

## Errors

- Report failures with the language's error mechanism (exceptions, `Result`, `error` values), not magic return codes.
- Do not swallow errors. Catch an error only where you can handle it or add useful context, then re-raise or wrap it.
- Error messages state what failed and with which value.
- Validate at system boundaries such as user input, files, network, and external APIs. Inside the system, trust types and internal contracts, and do not add checks for situations that cannot happen.
- Release resources deterministically (`with`, `using`, `defer`, try-with-resources).
- Fail closed. An error inside a permission or validation check denies the operation, work left half done is rolled back, and messages shown to users reveal no internals. The writing-secure-code skill covers this in full.

## Duplication

- Remove duplicated knowledge, meaning the same rule or fact maintained in two places.
- Do not merge code that only looks alike but changes for different reasons. When unsure, wait for a third occurrence before abstracting.

## Classes and modules

- Each class or module has one responsibility and one reason to change.
- Prefer composition over inheritance.
- Talk to direct collaborators only. Avoid chains such as `a.get_b().get_c().do()`.
- Wrap third-party APIs and I/O behind a small interface you own, so the rest of the code does not depend on their details.
- Keep files focused. Split a file when it holds unrelated responsibilities, not when it reaches a line count.

## Comments

- Comments explain why, such as intent, non-obvious constraints, workarounds and their reasons, links to specs, and the idea behind a complex algorithm or regex.
- Do not restate what the code says, leave commented-out code, or write change logs in comments, because version control already keeps history.
- Do not add comments, docstrings, or type annotations to code you did not change. Keep public API docs in the style the project already uses.
- User or project instructions about comments override this section.

## Tests

- Tests follow the same rules as production code.
- One behavior per test, named after that behavior, laid out as arrange, act, assert.
- Tests are fast, independent, repeatable, and contain no branching logic.
- When the project has a test suite and behavior changes, add or update tests.

## Workflow

For every code task, follow these steps.

1. Read the surrounding code and the project configuration (linters, formatters, type checker settings, style guides) before writing.
2. Write the simplest correct solution that fits the existing structure.
3. Run the project's formatter, linter, type checker, and tests when they exist, and fix what they report.
4. Review your own diff against the checklist below, fix every finding, then repeat step 3.
5. Remove temporary files, debug output, and unused imports.

## Self-review checklist

- [ ] Every name is understandable without reading the surrounding code
- [ ] Each function does one thing and nesting is shallow
- [ ] No magic values and no duplicated knowledge
- [ ] Errors are handled at the right level, with informative messages, and nothing is swallowed
- [ ] Failures deny access and roll back partial work
- [ ] Concurrent code guards shared state and has no races or deadlocks
- [ ] No dead code, commented-out code, debug prints, or unused imports
- [ ] Comments explain why and none restate the code
- [ ] The diff contains only changes the task needs, improves the overall code health, and is small enough to review
- [ ] Style matches the surrounding code
- [ ] Changed behavior is covered by tests that pass

## When the rules bend

- **Hot paths.** Measure before restructuring performance-critical code. One clear comment can be better than splitting a tight loop into slower pieces.
- **Generated, vendored, or migration code.** Leave it as it is.
- **Throwaway scripts** the user calls one-off. Keep them correct and readable, skip architecture.

## Reference files

Read them before the first change, the language section of the idioms file and the examples file for every code task, and the code smells catalog when reviewing or refactoring.

- [references/code-smells.md](references/code-smells.md) has a catalog of code smells with their fixes, for reviews and refactoring.
- [references/language-idioms.md](references/language-idioms.md) has idioms for Python, JavaScript and TypeScript, Java, C#, Go, Rust, PHP, SQL, and shell. Read the section for the language at hand.
- [examples.md](examples.md) has illustrative before and after pairs, including one that shows over-engineering.
