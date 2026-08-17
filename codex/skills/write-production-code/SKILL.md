---
name: write-production-code
description: Implement, fix, or refactor production software in any language. Use whenever code must be changed and correctness, clarity, maintainability, security, compatibility, and measured efficiency matter, including work in poor legacy code.
---

# Write Production Code

## Workflow

1. Read repository instructions, neighboring code, contracts, tests, formatter, linter, type checker, and language or framework conventions.
2. Clarify observable behavior and constraints. Make the smallest complete change and preserve unrelated behavior.
3. Use domain-meaningful names and cohesive functions with explicit inputs, outputs, ownership, and side effects. Prefer shallow control flow and established local patterns.
4. Apply KISS and YAGNI. Remove semantic duplication that must change together, but do not abstract coincidental similarity or add speculative layers, configuration, factories, or extension points.
5. Handle errors where a decision can be made, preserve causes, add safe context, release resources, bound concurrency, and honor cancellation and timeouts.
6. Validate untrusted input at trust boundaries, parameterize commands and queries, enforce authorization server-side, use least privilege, and keep secrets out of code and logs.
7. Optimize only against a requirement or measurement. Prefer a clear correct solution, then profile or benchmark representative workloads.
8. Add or update behavior-focused tests. Run the repository's real formatter, static checks, tests, and build, then inspect the final diff.

Follow repository formatting rather than imposing a universal line or function length. If legacy code is poor, do not copy defects or redesign unrelated areas. Characterize current behavior, improve the touched seam safely, and separate broader cleanup.

Treat generated code and recalled APIs as untrusted until verified. Read [production coding practices](references/practices.md) for detailed decision rules and sources.
