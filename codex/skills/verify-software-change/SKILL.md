---
name: verify-software-change
description: Verify whether a software change is correct and complete. Use before completion claims, during reviews, or when asked to test, validate, audit, or assess readiness across code, configuration, data, interfaces, and user behavior.
---

# Verify Software Change

## Workflow

1. Derive acceptance criteria and risks from the request, contracts, instructions, and changed files.
2. Inspect the final diff for scope, accidental edits, secrets, generated artifacts, compatibility, migrations, and missing consumers.
3. Select the smallest risk-based set of fresh checks covering behavior, regression, error paths, boundaries, security, performance, and operability as relevant.
4. Run exact repository commands in the correct environment. Confirm tests can detect the defect when practical.
5. Investigate failures. Do not rerun until green without explaining the cause or weaken tests to obtain a pass.
6. Report commands and results, what they establish, remaining unverified areas, and whether every acceptance criterion is met.

Compilation alone is not proof of behavior. Never claim a check, environment, or result that was not actually observed.

Read [verification practices](references/practices.md) for review and test selection guidance.
