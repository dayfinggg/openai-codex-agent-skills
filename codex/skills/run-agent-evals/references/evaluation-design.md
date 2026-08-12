# Evaluation Design Reference

Use these templates to make evaluation suites reproducible without exposing the rubric to the executing agent.

## Suite manifest

Record these fields before execution:

| Field | Required content |
| --- | --- |
| Subject | Name, path, revision or hash, and activation mode |
| Environment | Model, host, tools, permissions, configuration, and relevant state |
| Criteria | Stable identifier, observable requirement, evidence source, scale anchors, severity, applicability, and threshold |
| Cases | Identifier, family, separately stored executor prompt and inputs, criteria covered, criterion applicability, controlled environment variation, and repetition count |
| Pass rule | Critical-failure rule, per-criterion thresholds, suite threshold, and incomplete-suite rule |
| Comparison | Baseline and candidate identities, if applicable |

Save and version the manifest before the first execution. Freeze that version for the run; record subsequent changes in a new manifest rather than editing the scoring contract retrospectively.

## Criterion record

Define each criterion with:

| Field | Meaning |
| --- | --- |
| Identifier | Stable name used by cases and reports |
| Observation | Behavior visible in the response, trace, action, or resulting state |
| Evidence | Exact artifact that can prove or disprove the observation |
| Scale | Binary or an anchored ordinal scale with distinct levels |
| Severity | Critical, major, or minor impact on the claimed behavior |
| Applicability | Conditions that make the criterion required or not applicable |

Prefer a binary scale for hard constraints. For quality judgments, define anchors such as `0 = absent or contradictory`, `1 = partial or ambiguous`, and `2 = complete and supported`.

## Case families

Include positive, negative-neighbor, and boundary families in every suite that can receive a `PASS`. Add other applicable families rather than repeating one nominal request:

| Family | Purpose |
| --- | --- |
| Positive explicit | Verify behavior when the subject is named directly |
| Positive implicit | Verify description-based activation from a natural request |
| Negative near-neighbor | Detect unwanted activation on a similar out-of-scope task |
| Boundary | Exercise ambiguity, incomplete input, limits, or competing requirements |
| Failure-path | Exercise missing tools, command failure, unavailable data, or blocked permission |
| Safety boundary | Verify deliberate non-action or escalation around risky effects |
| Regression control | Confirm unrelated behavior remains unchanged |

For each case, store the raw user-style executor prompt verbatim and attach raw inputs. Keep executor prompts separate from the evaluator-only rubric, expected findings, suspected defects, and annotations. Before spawning an executor, compare its prompt and inputs with the evaluator-only record; remove repeated criterion identifiers, rubric wording, scoring terms, expected findings, and intended fixes, then record the leakage-check result. Mark the suite `INCOMPLETE`, not `PASS`, when any required family lacks a valid executed case.

## Artifact record

Preserve one immutable record per run containing:

1. Run identifier and subject revision.
2. Model, host configuration, tool availability, permissions, and relevant environment state.
3. Verbatim prompt and input artifact hashes or copies.
4. Pre-spawn leakage-check result and manifest version.
5. Raw assistant output, tool events, command results, errors, and produced filesystem or external-state diff.
6. Evaluator identity, criterion ratings, evidence pointers, and adjudication notes.
7. Duration, token usage, and cost when available and material.

Redact secrets without altering other evidence. Mark missing telemetry as unavailable rather than estimating it.

## Comparison rules

Use identical cases, inputs, environment, and scoring for baseline and candidate runs. Conceal labels and randomize presentation order when a human or model judge could be biased. Compare critical criteria first, then per-criterion results, then aggregates. Do not describe small repeated samples as statistically conclusive.

Classify failures as activation, instruction interpretation, execution, artifact, environment, or evaluator failures. Treat a capability removal, denied permission, injected command failure, or other environment condition declared in the frozen manifest as a valid scorable input when the harness produces it as specified. Reserve invalidation for unexpected environment drift, harness failure, corrupted artifacts, or missing evidence that makes the rubric inapplicable. Resolve invalid cases and ambiguous criteria before treating them as subject regressions. After a change, rerun the affected cases plus boundary, negative, and regression controls.

Existing product test output may serve as evaluation evidence. Design or implement those product tests with `design-testing-strategy` rather than expanding this suite into a product testing workflow.
