---
name: verify
description: Check completed engineering work against requirements using real artifacts, focused tests, and the diff. Report evidence and limits, not unsupported success.
---

# Verify

Completion is an evidence claim. Select checks that directly support that claim.

## Derive the claims

List the observable requirements, preserved invariants, and material failure modes. Map each claim to the strongest practical check. Prefer user-visible execution, integration behavior, or authoritative state over proxies.

## Run the checks

Start with focused checks that isolate the changed behavior. Add broader tests, builds, static analysis, or compatibility checks in proportion to the blast radius. Inspect the final diff for unintended files, stale code paths, debug output, and mismatched tests.

Build or package the real artifact when construction or deployment changed, then run a smoke path through that artifact rather than only through source-level tests. For performance claims, preserve the baseline workload, profile the relevant path, and compare repeated measurements after the change.

For replay, retry, durability, or recovery claims, use isolated test state to exercise relevant interruptions and recovery, then verify duplicate and partial outcomes. Do not interrupt live operations, alter production data, or introduce failure injection without explicit authorization.

For security-sensitive delivery, check the existing artifact provenance and release controls relevant to the change. Exercise restore, failover, revocation, or key rotation only when these behaviors are in scope and an isolated environment or specific authorization is available. Do not turn routine verification into a production resilience exercise.

Do not reuse stale results after relevant files change. Record exact commands and material observations. A check that was not run is not evidence.

## Decide

Mark the work verified only when every required claim has supporting evidence. Otherwise report partial verification, the missing check, and why it could not be completed. Do not weaken the definition of done to match available evidence.

## Output

Return a compact claim-to-evidence account, the final status, and any residual risk.
