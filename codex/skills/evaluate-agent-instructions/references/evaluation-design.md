# Evaluation design

## Case contract

For each case record an identifier, task segment, input and starting state, applicable instruction scope, required result, acceptable variants, forbidden behavior, required evidence, grader, repetitions, and must-pass status. Preserve real tasks when lawful and anonymize sensitive content; otherwise create faithful cases that exercise the same decision.

## Comparison controls

Keep model, reasoning effort, verbosity, tools, permissions, context, repository revision, environment, timeouts, and budgets fixed between baseline and candidate. Randomize presentation to human reviewers and hide the variant label. Store raw outputs and tool traces rather than only aggregate scores.

## SCC-Guard candidate simplicity control

Inspect the effective instruction stack, artifact schema, current routing metadata, referenced files, and observed failures before authoring a rule. Define one smallest complete candidate. A candidate is complete when it covers the current case and necessary failure boundary without adding unrelated policy or a future mode.

Track instruction complexity as a vector:

`I = {instruction tokens, repeated rules, branches or modes, examples, tools or permissions, touched artifacts, dependencies}`

The default budget is zero for a new tool, permission, dependency, artifact, routing branch, exception, duplicated policy, future workflow, or unrelated style rule. Exceed a coordinate only when a saved current case or authoritative contract requires it and a deterministic or behavioral check covers it. Do not add speculative generality for hypothetical tasks.

When at least two materially different candidates are viable, compare leave-as-is, the smallest local instruction, and at most one alternative against the same cases. Prefer the simpler candidate that clears every gate. Do not generate an option matrix for an obvious typo, broken link, or schema correction.

For coding-agent evaluations, also measure the generated change vector:

`C = {production LOC, touched owners, public surface, abstractions, dependencies, configuration, state or concurrency, branch complexity, duplication}`

Use each coordinate separately. A low line count cannot compensate for a new contract regression, invented dependency, or weakened test.

## Metrics

Use task success and required-behavior completion as primary metrics. Add unsupported claims, nonexistent APIs or dependencies, tool and postcondition success, unsafe effects, unnecessary actions, questions, concepts, or changed hunks, trigger precision and recall, exact-format preservation, contract compatibility, test sensitivity, style preference, tokens, latency, and cost when the changed instruction can affect them.

Automatic graders need a defined rubric and spot checks. Use deterministic checks for schemas, files, commands, tests, and forbidden actions. Use blind human comparison for natural writing, proportional detail, and ambiguous usefulness. Resolve reviewer disagreement with a predefined adjudication rule.

## Decision

Set practical thresholds and non-inferiority margins before the run. A candidate must pass every safety, permission, data-integrity, required-contract, and irreversible-effect case. For coding behavior, make invented APIs or dependencies, unjustified public surface, weakened tests, and hidden composed regressions must-pass failures. The candidate must not materially regress any required task segment or neighboring route.

Compare performance and efficiency only on the same correct workload and environment. Predefine repetitions and aggregation, retain variation, and treat a noisy apparent improvement as inconclusive. Lower tokens, latency, cost, or code size count only when correctness and every required contract are preserved.

After the run, inspect the complete candidate diff and remove untested rules, repeated constraints, speculative examples, unused dependencies, and unrelated wording churn. Re-run affected cases after deletion. Preserve baseline hashes, files, configuration, raw outcomes, and the exact restore operation. Verify rollback when the artifact or deployment mechanism makes that practical. Report uncertainty when the sample or repetitions cannot support a stable conclusion.
