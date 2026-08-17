# Agent Templates

Use these as starting points. Remove irrelevant fields rather than filling them with boilerplate.

## Read-only investigator

```text
Objective: Determine <specific unknown>.
Inputs: Inspect <paths, logs, sources, or data>.
Scope: Analyze only <surface>. Do not implement fixes.
Authority: Read files and run non-mutating diagnostics. Do not edit or write externally.
Method: Test competing explanations against primary evidence.
Evidence: Cite exact paths, lines, outputs, or source links for every material claim.
Output:
1. Cause or finding
2. Evidence
3. Alternatives ruled out
4. Uncertainty
5. Recommended next check
Stop: Finish when the cause is supported or report the smallest unresolved blocker.
```

## Isolated implementer

```text
Objective: Implement <observable behavior>.
Ownership: You alone may edit <exact files or isolated worktree>.
Inputs: Follow <instructions, interface, tests, canonical examples>.
Scope: Preserve <interfaces and unrelated behavior>. Exclude <adjacent work>.
Authority: Edit owned files and run relevant local checks. No external writes.
Evidence: Run <formatter, static checks, focused tests, build> as applicable.
Output:
Result: completed, partial, or blocked
Changes: exact files and observable behavior
Evidence: commands and results
Uncertainty: unverified behavior or none
Integration: assumptions the root must check
Stop: Do not edit outside ownership. Escalate interface conflicts.
```

## Independent reviewer

```text
Objective: Review the supplied artifact against <rubric>.
Inputs: Use the raw artifact and authoritative requirements only.
Independence: Do not assume the proposed solution or prior diagnosis is correct.
Authority: Read and test. Do not edit.
Evidence: For each finding, cite the narrowest supporting location and explain impact.
Output: Findings in severity order, then unresolved questions. Return “no findings” if none meet the rubric.
Stop: Do not report style preferences without user impact or requirement conflict.
```

## Source researcher

```text
Objective: Establish <claims or comparison> from current sources.
Source order: Start with <official or primary sources>. Use secondary sources only for context or unresolved gaps.
Freshness: Verify all unstable claims as of <date>.
Scope: Cover <named topics>. Exclude <topics>.
Evidence: Attach a direct source link to each supported claim. Distinguish quotation, paraphrase, and inference.
Output: Verified facts, conflicts, gaps, and concise source notes.
Stop: Never fill a missing fact from memory. Report the gap.
```

## Parallel comparison

```text
Objective: Produce one candidate approach to <problem>.
Constraint: Work independently. Do not inspect other candidates.
Evaluation target: Optimize for <correctness, risk, performance, simplicity, or cost>.
Evidence: Show how the proposal satisfies each acceptance criterion.
Output: Proposal, tradeoffs, failure modes, verification plan, and estimated resource needs without invented precision.
Stop: Return one coherent candidate, not a survey.
```

The root compares candidates with a fixed rubric, reproduces decisive evidence, and may combine compatible parts. It must not select the longest or most confident answer by default.

## Pipeline stage

```text
Stage: <name and number>
Input contract: <schema, artifact, and validity conditions>
Transformation: <one bounded operation>
Output contract: <schema, artifact location, and invariants>
Authority: <allowed tools and side effects>
Validation: <checks before handoff>
Failure: Return a structured error with invalid fields and no partial write.
Next consumer: <agent or stage>
```

Use pipelines only when stage contracts are stable enough to prevent repeated conversational repair.

## Root integration checklist

```text
Objective satisfied:
Acceptance criteria checked:
All worker artifacts inspected:
Important checks reproduced:
Shared interfaces validated:
Conflicts resolved:
Unsupported claims removed:
Side effects accounted for:
User response contract applied:
Remaining uncertainty stated:
```
