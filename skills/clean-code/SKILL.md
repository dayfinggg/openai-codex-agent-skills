---
name: clean-code
description: Gives design heuristics from Clean Code and Refactoring and per-language pitfalls with the tools that catch them, for Python, PHP, TypeScript, JavaScript, Bash and POSIX shell, and PowerShell. Use when writing, changing or reviewing code or a script in one of these languages, when the user asks for clean, readable or maintainable code, and when choosing how to shape a function, a module or an interface.
---

# Clean code

This skill adds to your code instructions. It applies to the code you write for the task. Leave the surrounding code as it is unless the task is to change it.

## Read the reference for the language

Before you write code, read the file for the language you work in. Each file lists the pitfalls that are specific to that language and the commands that check for them.

Python is in `references/python.md`. PHP is in `references/php.md`. TypeScript is in `references/typescript.md`. JavaScript is in `references/javascript.md`. Bash and POSIX shell are in `references/shell.md`. PowerShell is in `references/powershell.md`.

## Shape of functions

A function either changes state or returns a value. A function that does both surprises its caller, and the usual fix is to split it. A well-known exception is an operation such as `pop`, where the two cannot be separated.

A boolean parameter that switches between two behaviours is two functions. Write both and name each one after what it does.

Keep one level of abstraction inside a function. A function that orchestrates steps calls named steps and does not also do string slicing or arithmetic. Order a file so that a caller stands above the functions it calls, and a reader can go from the overview down to the detail.

Past three parameters, group the ones that travel together into one object or record. Do not change the arguments you were given. Return a new value.

Handle the special cases first and return early. The main path then runs without nesting.

## Shape of modules

Hide what can change behind an interface that does not. A module is worth having when its interface is much smaller than what it does.

A chain such as `a.b().c().d()` ties the caller to the inner structure of three objects. Treat it as a hint to ask the first object for what you need. It is a hint, and wrapper methods written only to avoid the chain make things worse.

A `switch` or an `if` chain on a type is fine the first time. When the same branching appears in a third place, replace it with one function or method per type.

## Limits

Do not split a function only to make it shorter. Several tiny functions that are read only together are harder to follow than one function of thirty lines.

When two of these heuristics pull apart, pick the version that a newcomer to the file would understand faster.

## Check

Run the project's own formatter, linter and type checker, as its manifest or its CI configuration defines them. The reference file names the usual tools for a project that defines none.

## Related skills

Load `writing-tests` when the change needs a test, `designing-interfaces` when the change is visible in an interface, `working-with-databases` when it touches a query, a migration or a cache, and `verifying-work` before you report the change as done.
