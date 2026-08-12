# Coordination Patterns

## Assignment Contract

Define an assignment with these fields when coordination is nontrivial:

1. Outcome: one inspectable artifact, answer, decision, or patch.
2. Ownership: exact files, modules, questions, or data partitions the agent owns.
3. Inputs: authoritative paths, snapshots, constraints, versions, and relevant prior findings.
4. Boundaries: forbidden changes, excluded systems, and decisions retained by the coordinator.
5. Acceptance: observable conditions that distinguish completion from an attempt.
6. Evidence: required tests, commands, citations, logs, or comparisons.
7. Return: changed paths, conclusions, validation output, risks, and unresolved questions.

Keep dependencies explicit. Do not start a downstream assignment until its required upstream artifact is stable, unless the downstream agent can work against a clearly identified snapshot.

## Author and Reviewer

Assign one agent to create the artifact and a different agent to review it. Give the reviewer the artifact, requirements, and raw validation evidence. Do not provide the author's rationale, confidence, suspected defects, or expected verdict unless a targeted review requires that context.

Keep the reviewer read-only by default. Ask for findings with precise locations, impact, supporting evidence, and a reproducible check. Let the coordinator decide whether the author, reviewer, or coordinator applies a correction. Re-run the relevant checks after every accepted correction.

## Parallel Research

Partition research by source class, technical question, product area, jurisdiction, time period, or competing hypothesis. Require each researcher to identify unsupported claims and source limitations.

Give one synthesizer the raw results only after collection. Require it to distinguish agreement, contradiction, and missing evidence. Verify decisive claims against the cited primary material before reporting them.

## Large Fan-Out

Use a shallow hierarchy when many independent units exist:

1. Keep the root coordinator responsible for shared constraints and the final result.
2. Assign domain coordinators only for coherent groups with distinct ownership.
3. Give leaf agents atomic units that can complete without editing the same files.
4. Return compact structured evidence upward instead of full conversation histories.
5. Limit aggregation layers to those needed for reliable review.

Scale fan-out to meaningful units, not the available agent limit. If fewer independent units exist than requested agents, explain the practical boundary in the final result rather than creating redundant writers.

## Shared-Filesystem Conflict Recovery

When two agents touch overlapping files or assumptions:

1. Stop further writes to the affected area.
2. Capture the current paths, diffs, and validation state without reverting anything.
3. Identify the intended owner and compare both changes against the same acceptance criteria.
4. Select one integrator to preserve compatible work and resolve incompatible edits.
5. Recheck nearby files for dependent changes and stale assumptions.
6. Run the narrow affected validation, then the broader integration checks warranted by risk.

Do not use destructive cleanup, broad formatting, or history rewriting to resolve coordination mistakes.

## Completion Gate

Before accepting delegated work, confirm that every required assignment has a terminal result, returned evidence is inspectable, shared-file conflicts are resolved, integrated behavior is verified, and unsupported claims or residual risks are disclosed.
