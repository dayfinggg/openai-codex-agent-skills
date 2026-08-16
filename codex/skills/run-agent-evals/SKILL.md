---
name: run-agent-evals
description: Design and run leakage-resistant evaluations for agent instructions and Codex skills. Use to verify behavior across positive, negative-neighbor, and boundary cases; not for static checks, product tests, or delegation.
---

# Run Agent Evals

Evaluate the behavior produced by agent instructions or skills. Treat static validation as a prerequisite, not evidence that the behavior works.

## Define the contract

1. Identify the exact instruction or skill version under evaluation. Record its path and a stable revision or content hash.
2. Translate each requirement into an observable criterion with a stable identifier, evidence source, rating scale, severity, and applicability.
3. Before executing any case, save a versioned pre-run manifest containing the subject revision, criterion identifiers, scale anchors, severities, critical-failure rules, per-criterion thresholds, suite threshold, and planned cases. Freeze it for that run; record later rubric changes as a new version.
4. Record the model, host instructions, available tools, permissions, and relevant environment state. Attribute behavior imposed by higher-priority constraints separately from subject defects.

## Build the suite

1. Derive cases from realistic user requests and raw task artifacts.
2. Include positive, negative-neighbor, and boundary case families. Do not report `PASS` unless every family has at least one valid executed case; report `INCOMPLETE` when a required family is absent or invalid.
3. Exercise every material criterion with more than one case when practical. Add repetitions when nondeterminism could change the result.
4. Keep executor prompts natural and user-styled. Store them verbatim with their inputs, separately from evaluator rubrics, expected findings, and annotations.
5. Map every planned case to the criteria it exercises and record criterion applicability before execution. A case without this mapping cannot support a scored verdict.
6. Read [evaluation-design.md](references/evaluation-design.md) when defining a reusable suite, rubric, artifact record, or baseline comparison.
7. Translate important output requirements into atomic observable conditions such as required fields, counts, schema, language, ordering, and forbidden extras.
8. For material changes to prompts, model behavior, context handling, memory, or orchestration, select fresh, held-out, paraphrased, adversarial, long-context, and multilingual cases according to risk and availability. Do not require every family when it is irrelevant, but record omitted material risks.
9. Do not treat a declared context window as proof that all included material will be used reliably. For long-context or memory cases, preserve available provenance, time, scope, and confirmation metadata, and mark unavailable metadata unknown.
10. Apply instruction priority, safety checks, and output validation consistently across Russian, English, mixed-language input, transliteration, and relevant low-resource languages.

## Run without leakage

1. Before spawning an executor, check its prompt and inputs against the evaluator-only record. Reject or rewrite any prompt that repeats criterion identifiers, rubric wording, scoring language, expected findings, suspected defects, or the intended fix; record the check result.
2. Use a fresh task, thread, or agent for each independent run. Provide only the subject under test, the raw user-style request, and task-local inputs needed to perform it.
3. Do not tell the executing agent the expected answer, evaluation criteria, previous results, candidate change, or reason for the test.
4. Isolate writable state between runs. Use disposable fixtures or separate work areas and prevent prior outputs from becoming discoverable inputs.
5. Hold the model, tools, permissions, inputs, and host configuration constant when comparing a baseline with a candidate. Randomize or conceal candidate labels from evaluators when feasible.
6. Obtain approval before a run that could modify a live system, incur material cost, require new permissions, or take substantial time.

## Preserve and score evidence

1. Preserve the prompt, inputs, raw response, tool events, command output, produced files or diffs, errors, and environment metadata without rewriting them. Store evaluator annotations separately.
2. Apply the frozen manifest and rubric consistently. Tie every rating to an observable artifact and justify exclusions or unavailable evidence. Do not issue a scored verdict if the pre-run manifest was not saved before execution.
3. Separate activation failures, instruction-following failures, task-quality failures, environment failures, and evaluator ambiguity. A manifest-declared capability removal, denied permission, command fault, or other controlled failure-path condition is valid and scorable when the observed environment matches the case. Mark a case invalid only for unexpected drift, harness failure, corruption, or unavailable evidence that prevents applying the frozen rubric. Do not average away a critical regression.
4. Compare results criterion by criterion before calculating aggregate measures. Report the tested scope, run count, pass rule, failures, and uncertainty.
5. Report correctness, groundedness, completeness, instruction following, safety, latency, and cost as separate dimensions when they materially affect the decision. Preserve the model, version, date, test scope, and unresolved limitations.

## Diagnose and rerun

1. Cluster failures by observable symptom and likely cause. Confirm that the case and rubric are valid before changing the subject.
2. Change one causal element at a time when possible. Preserve the original artifacts and record the new subject revision.
3. Rerun every affected case, relevant boundary and negative cases, and unchanged controls. Use the same scoring procedure.
4. Treat a single successful sample as exploratory evidence only. Claim compliance or reliability only for the covered criteria and conditions after representative reruns show no critical regression.

## Keep boundaries clear

- Run structural validators separately and report their results separately from behavioral evaluation.
- Use `design-testing-strategy` to design tests for product code, services, or user-facing behavior.
- Use `delegate-agent-work` to decompose work, assign ownership, or coordinate agents.
