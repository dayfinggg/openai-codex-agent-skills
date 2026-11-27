---
name: clean-code
description: Gives design heuristics for functions and modules, plus per-language pitfalls and the tools that catch them, for Python, PHP, TypeScript, JavaScript, Bash or POSIX shell and PowerShell. Use when writing, changing or reviewing code or a script in these languages, or when asked for clean, readable or maintainable code. Use before the first edit of code or a script in one of these languages.
---

# Clean code

These heuristics apply to the code you write for the task, and surrounding code stays as it is unless the task is to change it.

Before the first edit, read the reference for the language, which lists its pitfalls and checking tools. The files are `references/python.md`, `references/php.md`, `references/typescript.md`, `references/javascript.md`, `references/shell.md` for Bash and POSIX shell, and `references/powershell.md`.

## Principles

- Choose the plainest design that meets the requirement, and build only what the task needs now (KISS, YAGNI).
- Keep one authoritative source for each piece of knowledge (DRY). Prefer duplication to the wrong abstraction. Consider extraction at the third similar use.
- Before writing a function, search the repository for one that already does the job and reuse it, and follow the naming, error handling and structure of the neighbouring code.
- Give each function and module one reason to change, and keep business logic apart from input, output and the interface.
- Prefer names that make a comment unnecessary, and comment only a reason the code cannot show.
- Fail fast. Validate input at trust boundaries and after transformations that can invalidate checks. Surface errors where they occur.
- Pass dependencies explicitly rather than through global state, and prefer the language core, the standard library and the project's existing dependencies before a new one.

## Functions

- A function either changes state or returns a value. Split one that does both, except where the two cannot be separated, as in `pop`.
- A boolean parameter that switches behaviour is two functions, each named after what it does.
- An orchestrating function calls named steps and leaves slicing and arithmetic to them. Place callers above the functions they call.
- Past three parameters, group the ones that travel together into an object or record. Return a new value instead of changing the arguments.
- Handle special cases first and return early.

## Modules

- A module earns its place when its interface is much smaller than what it does.
- A chain such as `a.b().c().d()` ties the caller to three inner structures. Ask the first object for what you need, and keep the chain when the only alternative is wrapper methods written to avoid it.
- At the third copy of the same branching on a type, replace it with one function or method per type.
- Before changing a signature, a name, a data shape or a shared constant, find every use with a search or the language server and update them in the same change.

## When heuristics conflict

Keep a function of thirty lines whole when its pieces would only be read together, because tiny functions read in sequence are harder to follow. Otherwise choose the version a newcomer to the file understands faster.

## Check

Run the formatter, linter and type checker that the manifest or the CI configuration defines, or the tools the reference names when the project defines none.
