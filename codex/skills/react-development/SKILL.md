---
name: react-development
description: "Write or refactor React and Next.js components, improve data fetching, rendering, bundles, or component composition, and apply the relevant engineering rules."
---

Establish the React and framework versions, runtime boundary, changed components, and requested behavior. Preserve the existing component and application contracts.

Read [host integration](../.shared/host-integration.md) once for the imported rule bundles.

| Task | Read |
|---|---|
| Implement React or Next.js behavior, fetch data, investigate rendering, or optimize a bundle | [Performance and implementation rules](references/performance/guide.md) |
| Design component composition, compound components, state placement, or public props | [Composition patterns](references/composition/guide.md) |

Each procedure retains its individual rules and full compiled guide. Load the specific rules that govern the changed behavior rather than reading both complete guides for every edit.

Use both procedures when a component API redesign also changes rendering or data flow. Use web-design-guidelines separately when the task requires framework-independent accessibility or interface review. Do not introduce optimization machinery without a relevant performance or correctness reason.

