# Code smells and fixes

A smell is a signal worth checking, not proof of a defect. Fix a smell when it hurts the change at hand or when the user asked for a refactor.

## Contents

- Naming and readability
- Functions
- Data
- Classes and modules
- Change patterns
- Comments and leftovers
- Tests
- Refactoring safely

## Naming and readability

| Smell | Signal | Fix |
|---|---|---|
| Mysterious name | `data`, `tmp`, `x2`, `handle`, `process` with no object | Rename to what the value means or what the function does |
| Inconsistent vocabulary | `fetch_user`, `get_order`, `load_invoice` for the same kind of operation | Pick one verb and use it everywhere |
| Magic value | Literal numbers or strings with business meaning inline | Named constant or enum |
| Negative conditionals | `if not is_not_valid` | Rename to a positive form and invert |
| Boolean blindness | `send(msg, True, False)` | Keyword arguments, an options object, or separate functions |

## Functions

| Smell | Signal | Fix |
|---|---|---|
| Long function | Several blocks each needing a comment, scrolling to see the whole | Extract functions named after each block's intent |
| Mixed abstraction levels | SQL strings next to business rules next to formatting | Extract lower-level details so each function reads at one level |
| Deep nesting | Conditionals three or more levels deep | Guard clauses, early return, extract the inner block |
| Long parameter list | Many parameters, several always passed together | Introduce a parameter object |
| Flag argument | A boolean parameter that switches behavior | Two functions with clear names |
| Hidden side effect | A getter or check that also writes, logs, or mutates | Separate the query from the command |
| Output argument | A function fills in a parameter passed by reference | Return the value |
| Repeated switch | The same `switch` or `if` chain on a type code in several places | Polymorphism or a lookup table |

## Data

| Smell | Signal | Fix |
|---|---|---|
| Primitive obsession | Money as float, phone numbers as raw strings, status as int | Small value types or enums |
| Data clump | The same group of fields travels together | Extract a type |
| Global mutable state | Module-level variables written from many places | Pass state explicitly or encapsulate it |
| Mutable shared data | Several owners mutate one object | Immutable values or a single owner |
| Null returns | Callers check for null before every loop | Return an empty collection, use Optional or Result types |
| Temporary field | A field set only during one operation | Move it into a local variable or a separate object |

## Classes and modules

| Smell | Signal | Fix |
|---|---|---|
| Large class | Many fields, unrelated method groups | Split by responsibility |
| Feature envy | A method uses another object's data more than its own | Move the method to that object |
| Message chain | `a.b().c().d()` | Ask the direct collaborator for what you need |
| Middle man | A class that only delegates | Inline it and call the target directly |
| Inappropriate intimacy | Classes reach into each other's internals | Narrow the interface or merge them |
| Refused bequest | A subclass ignores or overrides most of what it inherits | Replace inheritance with composition |
| Speculative generality | Interfaces, hooks, or parameters with one implementation and no current need | Inline and delete until a second use appears |
| Lazy element | A class or function that adds no meaning | Inline it |
| Leaky third-party API | Library types spread across the codebase | Wrap the library behind your own interface |

## Change patterns

| Smell | Signal | Fix |
|---|---|---|
| Divergent change | One module changes for many unrelated reasons | Split it so each part has one reason to change |
| Shotgun surgery | One logical change needs edits in many files | Move the scattered knowledge into one place |
| Duplicated knowledge | The same rule implemented twice and drifting apart | Extract a single source of truth |
| False duplication | Code merged because it looked alike, now full of flags | Split it back into separate functions |

## Comments and leftovers

| Smell | Signal | Fix |
|---|---|---|
| Deodorant comment | A comment explaining confusing code | Rename and restructure until the comment is unnecessary |
| Redundant comment | `i += 1  # increment i` | Delete |
| Stale comment | A comment that contradicts the code | Fix or delete it |
| Commented-out code | Blocks of disabled code | Delete, version control keeps history |
| Dead code | Unreachable branches, unused functions, imports, or variables | Delete |
| Debug leftovers | `print`, `console.log`, temporary files | Delete or replace with proper logging |
| Silenced warnings | Disabled lint rules or compiler warnings without a reason | Fix the cause, or keep the suppression with a comment explaining why |

## Tests

| Smell | Signal | Fix |
|---|---|---|
| Unclear test name | `test1`, `test_works` | Name the behavior and the expected result |
| Several behaviors per test | Many unrelated asserts after several actions | One behavior per test |
| Logic in tests | Loops and conditionals inside tests | Parametrized tests or separate cases |
| Fragile test | Breaks on refactoring that keeps behavior | Assert on public behavior, not internals |
| Slow or order-dependent tests | Real network, shared state, sleeps | Fakes at boundaries, fresh state per test |
| Tests tuned to pass | Hard-coded expected outputs inside production code | Implement the real logic |

## Refactoring safely

1. Make sure tests cover the behavior you are about to change. If they do not and the change is risky, add characterization tests first.
2. Change structure in small steps that keep the code working, and run the tests after each step.
3. Keep refactoring and behavior changes in separate steps so a regression is easy to trace.
4. Stop when the code is clear enough for the task at hand.
