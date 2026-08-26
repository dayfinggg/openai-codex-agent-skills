---
name: review-code
description: Review a code change or audit a requested code scope for concrete defects, regressions, and unmet requirements.
---

Use this skill when the user asks for a code review, change review, merge-readiness review, or code audit. For a change review, pin the comparison point and confirm the intended diff. For an audit, define the requested scope even when no diff exists.

Inspect every relevant changed line plus enough surrounding code, tests, configuration, generated artifacts, and call paths to judge behavior. Evaluate repository conformance and fulfillment of the originating request as separate questions. Trace security-sensitive, concurrent, stateful, compatibility-sensitive, or resource-sensitive behavior far enough to establish the relevant invariant.

Report only concrete, actionable findings supported by evidence. For a change review, distinguish defects introduced or exposed by the change from unrelated pre-existing issues; for an audit, include pre-existing issues inside the requested scope. Order findings by severity, cite the smallest useful location, and identify a material test or evidence gap only when it changes confidence. Do not turn personal style preferences into defects.
