---
name: testing-code
description: Write or maintain tests and verify changed behavior, including real browser checks. Use the project's existing tools and size verification to the affected surface.
---

# Testing code

Tests establish behavior, not a target to game. Do not weaken, skip or delete meaningful assertions, patch the runner, hardcode test inputs, mock the code under test or swallow failures to manufacture success. Update expected behavior only when the requested contract changes, and explain that change. Investigate a contradictory test and report a real specification conflict.

Use the public interface and expected values from the requirement, not values computed by the implementation under test. Prefer real implementations, using test doubles at unavailable external boundaries. Add the cases and reachable boundaries that matter to the changed behavior rather than an exhaustive universal checklist.

Use test-first development when requested or when a cheap, decisive regression test is available. Use [property-based.md](property-based.md) when an input-space invariant benefits from generated cases and the tooling is justified. It is optional for a plain example or small UI edit.

For changed page behavior or visual layout, read [browser-checks.md](browser-checks.md) and exercise the relevant path in a real browser when available. Locate controls by role, label or text where possible. Use test IDs or other selectors when the actual surface lacks an accessible locator, rather than blocking the task over a selector preference.

Run relevant checks after the final change. Expand to the full suite for shared impact or project requirements. Read exit codes and diagnostic output and report only results actually observed. A passing build, a mocked service and a real browser check establish different things.

Do not introduce new test dependencies, lasting visual snapshots or elaborate harnesses for a low-impact change without a concrete benefit. If a check is unavailable, name what remains unverified instead of claiming completion from static reasoning alone.
