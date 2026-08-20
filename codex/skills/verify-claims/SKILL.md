---
name: verify-claims
description: Verify whether behavior works, is fixed, stable, compliant, faster, or reproducible.
---

Use this skill when the user asks whether something works, is fixed, stable, compliant, faster, or reproducible.

State one falsifiable claim. For comparative claims, capture a baseline and a treatment under the same conditions. For non-comparative claims, define controlled observations and negative controls. Preserve raw logs, outputs, or measurements needed to audit the result. Use an independent expected result or a separate checker when the implementation and its tests were produced by the same agent. Compare the evidence against a predeclared success threshold or coverage matrix and return exactly one verdict. Use `VERIFIED`, `NOT VERIFIED`, or `INCONCLUSIVE`. Do not infer certainty from one passing run, a plausible explanation, model-authored tests, or missing evidence.

Read [references/examples.md](references/examples.md) when selecting an independent check for a performance, security, or completeness claim.
