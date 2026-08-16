---
name: research-technical-decisions
description: Research current technical options, versions, standards, and support with traceable evidence. Use for comparisons and engineering decisions. Exclude implementation, code changes, and unsolicited recommendations.
---

# Research Technical Decisions

## Establish the question

1. Define the decision or factual question, intended environment, time horizon, and required output.
2. Extract material constraints and decision criteria from the request and available project evidence.
3. Ask for missing input only when different answers would materially change the research or conclusion. Otherwise, state a narrow assumption.

## Decide whether to browse

1. Inspect supplied material, repository configuration, lockfiles, and local documentation first.
2. Do not browse when that evidence is sufficient and the relevant facts are stable.
3. Browse when a material claim may have changed, the evidence is incomplete or disputed, exact version or support status matters, or the user requests current sources.
4. Search to resolve specific unknowns, not to accumulate background or citations.

## Gather evidence

1. Prefer primary authoritative sources for each claim. Read [source-quality.md](references/source-quality.md) when selecting, ranking, or reconciling external sources.
2. Verify the exact product, artifact, edition, version, publication or update date, support window, and applicable scope. Read the source context rather than relying on snippets.
3. Corroborate material claims when no controlling primary source settles them, especially for security, performance, compatibility, or disputed behavior.
4. Preserve the source URL and the specific fact it supports while researching. Discard sources that do not directly support a material claim. A topical citation, search snippet, URL, fluent explanation, or model confidence is not proof.
5. For long source sets, prefer relevant, deduplicated, provenance-labeled evidence over maximum context length. Preserve available source, date, scope, and confirmation metadata for remembered or summarized material, and mark missing metadata unknown.

## Analyze the decision

1. Keep only viable alternatives that differ materially under the stated criteria. Do not pad the comparison with nominal options.
2. Compare alternatives on the same scope, versions, workloads, units, and constraints. Do not convert vendor claims or incompatible benchmarks into false equivalence.
3. Separate verified facts, evidence-based inferences, assumptions, and unknowns. Label inferences and explain the evidence connecting them to the conclusion.
4. Resolve apparent conflicts by checking dates, versions, definitions, and source authority. Preserve unresolved disagreement instead of inventing certainty.
5. Avoid arbitrary scores, fabricated precision, and unstated weighting. If a recommendation is requested, derive it from the user's criteria and identify the conditions that would change it.
6. Treat same-model self-critique as an error-finding heuristic, not independent evidence. Prefer primary sources, reproducible calculations, executable checks, compilers, databases, or separately grounded verification when the consequence of error is material.
7. Do not report a numerical probability merely because a model sounds confident. Use numerical confidence only when a relevant calibration evaluation supports it. Otherwise describe the evidence, scope, and uncertainty in words.

## Report the result

1. Answer the requested question directly and neutrally. Do not add a recommendation unless requested.
2. Cite each material external claim near the supporting evidence. Include exact versions and dates only where they affect currency or applicability.
3. State consequential uncertainty, missing evidence, and the limits of the comparison. Say when the available evidence cannot support a conclusion.
4. Omit irrelevant history, exhaustive option catalogs, research narration, and unsolicited next steps.
5. Stop at research and analysis. Do not implement a choice, edit project files, or perform operational changes under this skill.
