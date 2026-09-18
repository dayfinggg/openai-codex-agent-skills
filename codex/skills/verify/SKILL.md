---
name: verify
description: Check completed work against its requirements with real artifacts and the diff. Use when the user asks whether work is done or correct, or an acceptance check is unresolved. Skip it after checks already passed.
---

# Verify

Completion is an evidence claim. Select checks that directly support that claim.

## Derive the claims

List the observable requirements, preserved invariants, and material failure modes. Map each claim to the strongest practical check. Prefer user-visible execution, integration behavior, or authoritative state over proxies.

## Run the checks

Verification finds defects in the requested change. It does not add mechanisms. Report a gap outside the request in one sentence and do not build a fix for it. Keep the number of cases proportional to the change: a fix of a few lines needs a few cases.

Start with focused checks that isolate the changed behavior. Add broader tests, builds, static analysis, or compatibility checks in proportion to how much of the system the change can affect. Inspect the final diff for unintended files, stale code paths, debug output, and mismatched tests.

Build or package the real artifact when construction or deployment changed, then run a smoke path through that artifact rather than only through source-level tests. For performance claims, preserve the baseline workload, profile the relevant path, and compare repeated measurements after the change.

Only when the requested change itself implements replay, retry, durability, or recovery, use isolated test state to exercise relevant interruptions and recovery, then verify duplicate and partial outcomes. Do not interrupt live operations, alter production data, or introduce failure injection without explicit authorization.

For security-sensitive delivery, check the existing artifact provenance and release controls relevant to the change. Exercise restore, failover, revocation, or key rotation only when these behaviors are in scope and an isolated environment or specific authorization is available. Do not turn routine verification into a production resilience exercise.

Do not reuse stale results after relevant files change. Keep the exact commands and observations that support each claim. A check that was not run is not evidence.

## Decide

Mark the work verified only when every required claim has supporting evidence. Otherwise report partial verification, the missing check, and why it could not be completed. Do not weaken the definition of done to match available evidence.

## Output

Return each claim with the evidence that supports it, the final status, and any residual risk.
