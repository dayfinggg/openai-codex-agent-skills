---
name: applying-design-patterns
description: Introduces and removes design patterns such as Strategy, Factory, and Observer only for a real smell. Use when weighing a pattern, when conditionals or variants multiply, or when reviewing for over-engineering.
---

# Applying design patterns

The project's existing pattern for a kind of problem wins. Resilience patterns belong to building-resilient-services.

## Rules

- Start from a smell you can point to or a stated requirement, such as a second variant that exists today. Otherwise write the plain solution. A pattern arrives with the second or third real variant.
- Name the cost in one sentence, meaning new types, the extra hop, and what gets harder to change. Add the pattern only when today's gain is larger, and in a review give the user both.
- Use the simplest form. With first-class functions, a function or a map of functions replaces a Strategy, Command, or Template Method class. Use classes when a variant holds state, groups several operations, or the codebase already models variants as classes. A language or framework mechanism beats a hand-written pattern.
- Singleton is an anti-pattern by default, per C++ Core Guidelines rule I.3. Create the one instance in the composition root and pass it in, or use the DI container's singleton lifetime.
- Introduce and remove patterns through named refactorings from refactoring.com, in small steps that keep the tests passing, separate from behavior changes.
- Remove a pattern that does not make the next change easier. A pattern in a published API used outside the repository is a contract, so report it to the user instead of removing it.

## Smell to pattern

| Signal in the code | Pattern | Simplest form |
|---|---|---|
| The same switch on a type code in several places | Strategy | Map from key to function, or one type per variant |
| State checks repeat across methods | State | Enum with one transition table |
| Repeated null checks with the same default | Null Object | One object with the default behavior |
| Type to create depends on input, or construction repeats | Factory | Factory function |
| Many optional constructor parameters | Builder | Named arguments with defaults, or a parameter object |
| A foreign interface does not fit, or its types spread | Adapter | Small wrapper you own with only the operations callers use |
| Optional behavior around an operation in combinations | Decorator | Wrapping function, or the framework's middleware |
| Independent reactions to one event | Observer | List of callbacks, or the framework's events |
| Requests are queued, logged, undone, or replayed | Command | Closure, or a data record with a handler when stored |
| Algorithms differ in one or two fixed steps | Template Method | Function taking the varying step as a parameter |
| Callers repeat one call sequence into a subsystem | Facade | One function for the common path |
| A tree of parts and wholes treated alike | Composite | Recursive data with one recursive function |

Use no pattern when the variants differ only by a value, which belongs in a parameter or table, or when one short conditional appears in one place.

## Over-engineering

In a review, remove with the catalog's refactoring an interface with one implementation and no boundary or test need, a factory that only calls a constructor, a class that only forwards, subclasses that barely differ, a command executed where it is created, and a global behind a static accessor.

## Reference files

- [reference/catalog.md](reference/catalog.md) has the cost and the introducing and removing refactorings for each pattern. Read the row of every pattern you add or remove.
