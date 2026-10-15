---
name: applying-design-patterns
description: Chooses, introduces, and removes design patterns such as Strategy, Factory, Adapter, and Observer, starting from a real smell. Use when weighing a pattern, when conditionals or duplicated variation grow, or when reviewing code for over-engineering.
---

# Applying design patterns

A design pattern is a known answer to a recurring problem, and every pattern is paid for in types, indirection, and places to look. This skill starts from the problem in the code and reaches for a pattern only when the problem is real and the price is worth paying. The writing-clean-code skill owns names, functions, code smells, and language idioms. The applying-clean-architecture skill owns layers, ports, adapters at architecture boundaries, and the composition root. Repository and Unit of Work live in the applying-clean-architecture and working-with-databases skills, and Retry, Circuit Breaker, Bulkhead, and other resilience patterns live in the building-resilient-services skill. When the project already solves a kind of problem with a pattern, follow the project over this skill.

## Principles

- **Problem first.** Start from a smell you can point to in the code or a real constraint, such as a second variant that exists today or a requirement the user stated. Never start from the catalog. The Azure Architecture Center puts it as "Choose a pattern based on the problem you need to solve, not the technology you want to use".
- **Not too early.** Fowler warns in Is Design Dead that patterns are often over-used and says to apply them "not too early". Solve the problem that needs solving now, and let a pattern arrive when the second or third real variant does.
- **Know the price.** Before adding a pattern, name its cost in one sentence, meaning the new types, the extra hop for the reader, and what becomes harder to change. Add it only when today's gain is larger.
- **Simplest form first.** Implement the pattern in its simplest form and add complexity later. A function comes before a class, a map before a hierarchy, and a language or framework feature before a hand-written pattern.
- **Prefer the simplest construct the language offers.** In languages with first-class functions, default to a function, a lambda, or a map of functions where the classic form is a Strategy, Command, or Template Method class. Use classes when a variant holds state, groups several operations, or the codebase consistently models variants as classes.
- **Take it out again.** When a pattern "isn't pulling its weight", remove it. Removal is a normal refactoring, not an admission of failure.
- **Move by named refactorings.** Introduce and remove patterns through the refactorings in the refactoring.com catalog, in small steps that keep tests passing, with refactoring and behavior changes kept apart. The writing-clean-code skill has the safe refactoring steps.
- **Singleton is an anti-pattern by default.** The C++ Core Guidelines rule I.3 says "Avoid singletons", because they are global objects in disguise, and the reasoning holds in every language. Create the one instance in the composition root and pass it to the code that needs it.

## From smell to pattern

| Signal in the code | Consider | Simplest form first |
|---|---|---|
| The same switch or if chain on a type code in several places | Strategy, polymorphism | A map from key to function, or one type per variant |
| Behavior depends on lifecycle state and state checks repeat across methods | State | An enum with one transition table |
| Repeated null checks followed by the same default behavior | Null Object | One object with the default behavior |
| The type to create depends on input, or construction steps repeat | Factory | A factory function |
| Many optional constructor parameters or telescoping constructors | Builder | Named arguments with defaults, or a parameter object |
| A foreign or legacy interface does not fit the caller, or its types spread | Adapter | A small wrapper you own with only the operations callers use |
| Optional behavior around an operation in several combinations | Decorator | A wrapping function, or the framework's middleware |
| Several independent reactions to one event, unknown to the source | Observer | A list of callbacks, or the framework's event mechanism |
| Requests must be queued, logged, undone, or replayed as values | Command | A closure, or a data record with a handler when it must be stored |
| Algorithms share fixed steps and differ in one or two | Template Method | One function that takes the varying step as a parameter |
| Callers repeat the same sequence of calls into a subsystem | Facade | One function for the common path |
| A tree of parts and wholes that callers treat the same way | Composite | Recursive data with one recursive function |

## When not to use a pattern

- Only one implementation exists and no second one is required today. That is speculative generality.
- The variants differ only by a value. Put the value in a parameter, a constant, or a table.
- The conditional appears in one place and is short. One switch is easier to read than a hierarchy.
- The language or framework already provides the mechanism, such as iterators, events, decorators, middleware, or a dependency injection container.
- The pattern's name is the only content, as in a factory that only calls a constructor or a manager that only forwards calls.

## Over-engineering and removal

When reviewing code, look for these signals and remove the layer with the matching refactoring.

| Signal | Refactoring |
|---|---|
| An interface with one implementation and no boundary or test need | Inline Class or Inline Function |
| A factory that only calls one constructor | Inline Function |
| A class that only forwards calls | Remove Middle Man |
| Subclasses that barely differ from their parent | Collapse Hierarchy or Remove Subclass |
| A command object created and executed in the same place | Replace Command with Function |
| A global instance reached through a static accessor | Replace Query with Parameter |

A pattern in a published API used outside the repository is part of a contract. Removing it is a breaking change, so mention it to the user instead of removing it.

## Workflow

1. Name the problem. Point to the lines that show the smell, the variants that exist, or the requirement that forces the change. If you cannot, write the plain solution and stop.
2. Check how the project already solves this kind of problem, and reuse that pattern when there is one.
3. Pick the candidate from the table above and read its entry in the catalog file.
4. State the cost in one sentence and decide whether today's gain pays for it. In a review, give the user that cost and gain.
5. Introduce the simplest form with the introducing refactoring, one small step at a time, running the tests after each step.
6. Look at the result again. If the pattern does not make the next change easier, remove it.
7. Review against the checklist.

## Checklist

- [ ] The pattern answers a smell or constraint that exists in the code today
- [ ] At least two real variants use it, or a stated requirement needs it
- [ ] It is in its simplest form, a function or a map where the language allows
- [ ] No Singleton or other global access, and dependencies are passed in
- [ ] No interface with a single implementation unless it is a port at an architecture boundary
- [ ] No factory that only calls a constructor and no class that only forwards calls
- [ ] Names say what each part does in the domain, not only which pattern it implements
- [ ] Each step was a named refactoring that kept the tests passing
- [ ] Patterns that stopped pulling their weight were removed or reported

## Reference files

Read them before the first change, the catalog entry for every pattern you introduce or remove and the examples file.

- [references/catalog.md](references/catalog.md) has one entry per pattern with the problem signal, the simplest form, the cost, the refactorings that introduce and remove it, and when not to use it.
- [examples.md](examples.md) has illustrative before and after pairs in Python, Java, TypeScript, Go, and C#, for adding a pattern where it pays and removing one where it does not.
