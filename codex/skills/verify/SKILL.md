---
name: verify
description: Prove that completed engineering work satisfies its requirements using the real artifact, focused tests, and diff inspection. Use before declaring implementation complete or when the user asks whether a change actually works. Do not replace diagnosis or code review.
---

# Verify

Completion is an evidence claim. Select checks that directly support that claim.

## Derive the claims

List the observable requirements, preserved invariants, and material failure modes. Map each claim to the strongest practical check. Prefer user-visible execution, integration behavior, or authoritative state over proxies.

## Run the checks

Start with focused checks that isolate the changed behavior. Add broader tests, builds, static analysis, or compatibility checks in proportion to the blast radius. Inspect the final diff for unintended files, stale code paths, debug output, and mismatched tests.

Build or package the real artifact when construction or deployment changed, then run a smoke path through that artifact rather than only through source-level tests. For performance claims, preserve the baseline workload, profile the relevant path, and compare repeated measurements after the change.

For replay, retry, durability, or recovery claims, interrupt the operation at a meaningful boundary, execute the real recovery path, and verify the final externally visible state, including duplicate and partial outcomes.

For security-sensitive delivery, verify authentic provenance is bound to the deployed artifact, the policy choke point was enforced, post-deployment state matches intent, and break-glass use alerts correctly. Exercise restore, failover, rollback, revocation, and key rotation against representative state, including stale backups and rejection of retired credentials.

Do not reuse stale results after relevant files change. Record exact commands and material observations. A check that was not run is not evidence.

## Decide

Mark the work verified only when every required claim has supporting evidence. Otherwise report partial verification, the missing check, and why it could not be completed. Do not weaken the definition of done to match available evidence.

## Output

Return a compact claim-to-evidence account, the final status, and any residual risk.
