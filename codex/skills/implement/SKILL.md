---
name: implement
description: Implement an authorized feature, fix, or configuration change with settled scope. Skip diagnosis-only, review-only, and planning-only requests.
---

# Implement

Deliver the requested behavior with the smallest coherent change and evidence that it works.

## Prepare

Establish the outcome and a focused verification path from governing instructions, target files, relevant tests, and available local precedents. Inspect a blocking subsystem's code and documentation before asking for essential missing information.

## Change

Preserve user work and repository conventions. Before writing custom code, check whether the behavior already exists in the codebase, the standard library or platform, or an installed dependency, and use the first option that completely satisfies the requirement. Add a new dependency only when its current benefit outweighs its ownership, update, compatibility, and security costs. Update all affected callers and avoid compatibility layers the request does not require.

Integrate in small working increments when the change spans several units. Treat strict compiler, linter, analyzer, and warning diagnostics as feedback to resolve or narrowly justify, not output to suppress broadly. Do not optimize without a relevant baseline and profile, and remeasure after any performance-motivated change.

For release or deployment changes, use existing validation, provenance, rollout, and recovery mechanisms proportionate to risk. Do not invent a delivery system for a small configuration edit.

## Verify

Inspect the additions for helpers, options, layers, or dependencies that can be removed without losing required behavior or clarity, and remove them. Run the most relevant focused checks first, then broader ones in proportion to risk. Exercise the real behavior when it can be observed directly. A passing build alone does not prove it. The change is done when the requested behavior works, failures it caused are fixed, and the affected checks pass.
