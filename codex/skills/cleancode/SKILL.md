---
name: cleancode
description: Routes code quality work to compressed rules from Code Complete, Refactoring, Working Effectively with Legacy Code, and Release It. Use it when you write a new module or a sizeable piece of logic, when the task is a refactor or cleanup, when you change code that lacks trustworthy tests, and when you add outbound calls, retries, queues, background jobs, migrations, or deploy steps. A small edit inside existing code needs only the coding instructions.
---

<overview>
This skill routes code quality work to four book rule sets. Each reference file holds one book's rules in compressed form. A file has decision rules, trigger rules, and a final checklist. Read the files that fit the task first. Check the work against the checklist items that bear on the change before you report.
</overview>

<books>
Each reference file covers one book.
- [code-complete.mini.md](references/code-complete.mini.md) holds the construction rules of Code Complete by Steve McConnell. Read it when you write new code or change behavior. It covers names, data types, control flow, error handling, and performance tuning.
- [refactoring.mini.md](references/refactoring.mini.md) holds the rules of Refactoring by Martin Fowler. Read it when the task is a refactor or cleanup. Also read it when the requested change needs a preparatory refactor.
- [working-effectively-with-legacy-code.mini.md](references/working-effectively-with-legacy-code.mini.md) holds the rules of Working Effectively with Legacy Code by Michael Feathers. Read it when you change code without trustworthy tests, or when a hidden dependency blocks a test.
- [release-it.mini.md](references/release-it.mini.md) holds the rules of Release It by Michael T. Nygard. Read it when code makes outbound calls or touches queues, pools, caches, or jobs. Startup, health checks, migrations, and deployment also qualify.
</books>

<precedence>
The coding instructions win where a book disagrees with them. The `code_rules` block already sets KISS, YAGNI, DRY, the least code, comments only where the repository keeps them, and the project's style. The reference files leave those rules out. Three book habits still meet `code_rules`, and `code_rules` decides each one.
- The books invite cleanup of nearby code. Refactor only what the request names or needs, and mention other smells in the report.
- Characterization tests and new edge-case tests stay only where `code_rules` allows new tests. Otherwise use them as temporary checks and delete them.
- Release It defenses, such as timeouts and circuit breakers, go into code that the task adds or changes. For other code, propose them in the report.

The `design` skill owns module interfaces, depth, and seam placement.
</precedence>
