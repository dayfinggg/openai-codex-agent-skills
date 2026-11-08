---
name: typescript
description: Change TypeScript types or compiler configuration, or diagnose type errors.
---

Read the relevant tsconfig and its extends chain, then establish the installed compiler version.
Prefer the simplest precise type that preserves the caller's contract.
Select references by the type problem.
- Types derived from values use [as-const-typeof.md](references/as-const-typeof.md).
- Array or tuple element types use [array-index-access.md](references/array-index-access.md).
- Derived function and object types use [utility-types.md](references/utility-types.md).
- Constraints and generic inference use [generics-basics.md](references/generics-basics.md).
- Fluent builders use [builder-pattern.md](references/builder-pattern.md).
- Nested literal inference uses [deep-inference.md](references/deep-inference.md).
- Conditional types use [conditional-types.md](references/conditional-types.md).
- Type extraction uses [infer-keyword.md](references/infer-keyword.md).
- Typed strings use [template-literal-types.md](references/template-literal-types.md).
- Property transformations use [mapped-types.md](references/mapped-types.md).
- Distinct semantic IDs use [opaque-types.md](references/opaque-types.md).
- Unknown values and unions use [type-narrowing.md](references/type-narrowing.md).
- Argument-dependent return types use [function-overloads.md](references/function-overloads.md).
- Long diagnostics use [error-diagnosis.md](references/error-diagnosis.md).
- Compiler migration uses [typescript-6-7.md](references/typescript-6-7.md), checked against installed versions and current official release notes.

Do not copy illustrative type guards without checking actual property types. Runtime execution in Node belongs to node.
