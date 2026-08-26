---
name: verify-claims
description: Verify a claim that behavior works, is fixed, stable, compliant, faster, safer, or reproducible using controlled evidence.
---

Use this skill when the user explicitly asks to verify a behavioral, performance, security, compliance, stability, or reproducibility claim.

State the falsifiable claim and success criterion before interpreting results. For a comparison, capture baseline and treatment under the same relevant conditions. For a non-comparative claim, choose observations and negative or boundary controls that could falsify it. Preserve the raw evidence needed to audit the verdict.

Use an independent expected result or checker when the implementation and its tests were produced by the same agent. Match the strength of the verdict to the coverage: a narrow passing check does not prove a broader property. Return exactly one verdict, `VERIFIED`, `NOT VERIFIED`, or `INCONCLUSIVE`, and state the evidence boundary that determines it.

Read [references/examples.md](references/examples.md) when selecting an independent check or a controlled baseline.
