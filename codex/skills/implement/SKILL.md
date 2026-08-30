---
name: implement
description: Make an authorized code or configuration change from a settled request, specification, or task. Use when the user asks to build, fix, add, or change something and the implementation scope is clear. Do not use for diagnosis-only, review-only, or planning-only requests.
---

# Implement

Deliver the requested behavior with the smallest coherent change and evidence that it works.

## Prepare

Read the governing instructions, target files, relevant tests, and one local precedent. Restate the required outcome internally and identify the narrowest verification that can prove it. Ask only if a missing decision would materially change behavior or risk.

## Change

Preserve user work and repository conventions. Prefer existing abstractions and dependencies. Keep the patch focused, update all affected callers, and avoid compatibility layers that the request does not require. Do not refactor adjacent code unless it is necessary for correctness.

Run safe independent reads and checks efficiently. Stop before an external write, destructive action, purchase, or material scope expansion unless separately authorized.

## Verify

Run the most relevant focused tests first, followed by broader checks in proportion to risk. Inspect the actual diff and exercise the real behavior when feasible. Treat a passing build as insufficient when the feature can be observed directly.

## Finish

Report the behavior delivered, material files changed, verification performed, and any limitation or skipped check. Never claim completion when required evidence is missing.
