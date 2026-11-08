---
name: tdd
description: Write behavior tests or use a requested test-first development loop.
---

Test observable behavior through the interface used by callers.
Derive expected results from the requirement or independently worked cases, not from the implementation.
Use one failing behavior test, a minimal implementation, and a passing check per cycle.
Keep each cycle focused on the current requirement. Refactor only when needed and while preserving behavior.
Read [tests.md](references/tests.md) for test examples and [mocking.md](references/mocking.md) when choosing test doubles.
Use real internal collaborators. Isolate external dependencies, time, randomness, or filesystem effects when needed.
Choose the test boundary without a permission checkpoint unless the choice changes scope or required access.
