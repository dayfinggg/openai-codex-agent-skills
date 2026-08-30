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

Do not reuse stale results after relevant files change. Record exact commands and material observations. A check that was not run is not evidence.

## Decide

Mark the work verified only when every required claim has supporting evidence. Otherwise report partial verification, the missing check, and why it could not be completed. Do not weaken the definition of done to match available evidence.

## Output

Return a compact claim-to-evidence account, the final status, and any residual risk.
