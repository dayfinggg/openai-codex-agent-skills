---
name: review-code
description: Review code changes for introduced correctness and maintainability defects.
---

Use this skill when the user asks for a review, audit, diff check, or merge-readiness assessment.

Resolve the actual comparison point and inspect the complete diff, including untracked and generated files, with enough surrounding code to establish each finding. For changes to public, shared, security-sensitive, or stateful code, trace the likely blast radius beyond the diff and prove the key safety fact with a focused run when practical. Review repository standards and fulfillment of the originating request as separate questions. Report only concrete, introduced, actionable issues supported by a reachable scenario. Order findings by severity, keep cited ranges minimal, and mention material test gaps or residual risks only when relevant. Do not invent findings or turn style preferences into defects.
