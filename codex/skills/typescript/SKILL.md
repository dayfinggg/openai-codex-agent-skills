---
name: typescript
description: Fixes TypeScript type errors and compiler settings with current facts for TypeScript 6 and 7. Use it whenever tsc reports a type error, when a task adds or changes generics, type guards, or other non-trivial types, or replaces `any` with a strict type. Use it when editing tsconfig.json, choosing module, target, or resolution settings, or upgrading to TypeScript 6 or 7 with the Go-based native compiler.
---

<project_first>
Follow the project before this skill, as `code_rules` requires. Read the `tsconfig.json` files the code uses, including every file in the `extends` chain. Find the installed TypeScript version in the lockfile or in `node_modules/typescript/package.json`. Read how nearby code already writes types, such as brands, guards, schema libraries, and helper types. Reuse those patterns.

Apply a version fact only to the version the project uses. Upgrade TypeScript only when the user asks.
</project_first>

<references>
One reference file holds the version facts that this file does not repeat. Before you edit a `tsconfig.json`, upgrade TypeScript, or fix errors that appeared after an upgrade, read [typescript-6-7.md](references/typescript-6-7.md) whole. It lists the changed defaults, the removed options, the module settings, the standard library changes, the flags of the native compiler, the compiler API, and the stricter JavaScript checking of TypeScript 5.9 to 7.1 beta.
</references>

<boundary>
This skill covers types, type errors, and compiler configuration. Running TypeScript inside Node.js, with type stripping or a loader, belongs to the `node` skill. JavaScript language features, browser code, and React belong to the `javascript` skill.
</boundary>

<workflow>
A type problem takes four steps.

1. Capture the full compiler output before you change code. Use the project's type-check script, or `npx tsc --noEmit` when it has none.
2. Find the root cause as the `debugging` block requires. Typical causes are unsound inference, a missing constraint, an implicit `any`, or a widened literal.
3. Fix the cause with the simplest precise type. Replace each `any` with a real type, and check that every call site still compiles.
4. Run the type check again and read the output, as the `verification` block requires.

Prefer a plain type, a union, or an overload over a type-level construct when both express the same contract. Type data from outside the program as `unknown` and narrow it with a guard at the system boundary, where `code_rules` asks for validation. Keep the type changes inside the scope of the task.
</workflow>

<upgrade_facts>
TypeScript 7.0 is the Go-based native compiler, released in July 2026. It ships in the standard `typescript` package and keeps the `tsc` command. In November 2026 the latest stable release is 7.0.2, and 7.1 is in beta.

These five facts matter most when a project is on TypeScript 6 or 7, or moves to one of them.

- TypeScript 6.0 changed the defaults. Now `strict` is `true`, `module` is `esnext`, `types` is `[]`, and `rootDir` is the directory of `tsconfig.json`.
- Every option that TypeScript 6.0 deprecates is a hard error in 7.0. Examples are `baseUrl`, `moduleResolution` `node`, `target` `es5`, and `downlevelIteration`.
- Move to 6.0 first and fix each deprecation error. The `ignoreDeprecations` setting only hides them in 6.0.
- TypeScript 7.0 has no programmatic API. Tools that import `typescript`, such as typescript-eslint, still need the `@typescript/typescript6` package.
- An omitted `types` list no longer loads every `@types` package. List global packages such as `node` explicitly.
</upgrade_facts>
