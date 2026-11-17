# Patch verified weaknesses

A patch proposal is inert and unapplied. Apply a change to the target only when authorized to fix it. Do not send reports, push or deploy as part of an audit unless separately authorized.

1. Start from a verified finding, its root cause and the affected revision. Inspect the enforcement point and sibling callers before choosing a change. Enforce the invariant at the narrowest boundary that governs those paths. Avoid suppressing errors, changing unrelated policy or relying on one special case.
2. Keep the diff within the requested scope and preserve legitimate use. For a repeated pattern that needs a migration, inventory the callers, define the shared safe replacement and split independent batches only if the project can verify each one.
3. Verify a defensive invariant with ordinary tests on disposable, synthetic fixtures. For example, check that a scoped read rejects a fixture from another tenant and still returns an allowed fixture. Verify existing behavior and the closest layer to the corrected control. Do not create a reproducer for weaponizing a flaw or replay incident traffic.
4. Review the diff against the pre-change source and the affected siblings. Check that it closes the underlying gap, does not weaken a neighboring control and does not narrow legitimate inputs. Use a fresh reviewer where requested or required and permitted.
5. Report the changed invariant, reviewed callers, check results and remaining uncertainty. Static-only review is not execution verification. Include the rollback when the change affects data, access or a live system.

For a requested patch bundle, use `PATCHES/` or the project's existing format. Link each diff to the finding ID, base revision, rationale, caller coverage, review and verification state. Keep rejected and skipped proposals distinct from accepted ones.
