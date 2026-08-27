# Document Types

## README

1. Treat the README as the repository's entry point, not its complete manual. State what the project is for, who should use it, current support status, and the shortest verified path to a useful result.
2. Include only applicable prerequisites, installation, a minimal working invocation, development or test commands, essential configuration, common failure recovery, and links to deeper documentation.
3. Preserve project identity without sales copy. Do not add badges, feature lists, architecture sections, contribution steps, or deployment instructions unless they help the README's actual audience.
4. Link to authoritative contribution, security, API, operations, and license material instead of duplicating it.

## Tutorial

1. Define a learner and a concrete result that can be completed in a bounded session. Control the path, remove distracting alternatives, and explain only enough for the next action.
2. Use a safe, self-contained environment and real project behavior. Confirm every step from a clean start and include cleanup when the tutorial creates persistent resources.
3. Give visible milestones and expected results so the learner can detect divergence early. Troubleshoot likely failures without turning the tutorial into reference.
4. Do not use a tutorial for production migration, incident response, or exhaustive configuration where experimentation would be unsafe.

## How-to guide

1. Name the exact outcome and required starting state. Choose one supported, accessible, and maintainable route unless materially different routes serve distinct environments.
2. Keep actions in execution order. Put conditions before the step they govern, name the location where an action occurs, and state expected results when they help the reader continue.
3. Include permissions, side effects, downtime, irreversible boundaries, validation, rollback or cleanup, and known failure recovery when relevant.
4. Link to reference for option detail and explanation for rationale rather than expanding the procedure.

## Reference

1. Derive reference from the authoritative public contract. Organize for lookup with stable names, consistent order, complete types, defaults, constraints, units, environment variables, exit codes, errors, compatibility, and examples.
2. Document what callers can rely on, including absence, nullability, ordering, concurrency, side effects, idempotency, deprecation, and security boundaries where applicable.
3. Keep generated signatures and field inventories generated. Review descriptions, examples, cross-links, and contract semantics manually.
4. Do not document private implementation details as public guarantees. Avoid prose that repeats an identifier without adding meaning.

## Explanation

1. Answer why the system behaves this way, how concepts relate, which forces shaped it, and where its boundaries lie.
2. Use verified examples, diagrams, and comparisons to form a mental model. Separate current facts from historical context, alternatives, and inference.
3. Do not turn preference into architecture law. State tradeoffs in this system and link significant accepted choices to ADRs.

## API documentation and doc comments

1. Start from the actual public API and its version. Document purpose, inputs, outputs, errors, side effects, lifecycle, concurrency, compatibility, and a minimal complete example.
2. Follow the language's official doc-comment format and generator. Describe caller-visible behavior and special cases, not the current algorithm or obvious syntax.
3. Generate navigable API inventory from source, OpenAPI, GraphQL schema, Protocol Buffers, or the project's equivalent. Verify generator output and examples against the same released contract.
4. Keep conceptual guidance and multi-step workflows outside symbol reference, linking between them where useful.

## Changelog and release notes

1. Maintain a curated changelog for notable user and operator impact. Group entries by release and change type, use unambiguous dates, keep the newest release first, and preserve an unreleased section when the project workflow uses one.
2. Describe the effect and affected surface, not the commit implementation. Mark breaking changes prominently and link to verified migration guidance.
3. Do not list formatting, refactoring, dependency churn, or internal work unless it changes behavior, risk, support, licensing, or operation for the intended reader.
4. Release notes may summarize and contextualize one release; derive them from the maintained changelog rather than creating a conflicting history.

## ADR

1. Create an ADR only for a significant decision affecting structure, quality attributes, dependencies, interfaces, data, operations, or long-term constraints.
2. Record title, status, date, context and forces, considered viable options, decision, consequences, confidence, and reconsideration triggers. One record owns one decision.
3. Keep accepted and rejected decisions immutable. Create a new record that links to and supersedes an earlier decision when context changes.
4. Capture why and consequences, not a transcription of the implementation plan.

## Runbook

1. Define the outcome, owner, scope, target environment, prerequisites, permissions, safety checks, exact steps, expected signals, validation, stop conditions, rollback or recovery, cleanup, and escalation.
2. Make commands idempotent or identify the steps that are not. Verify the target before destructive actions and state the point after which rollback is no longer safe.
3. Rehearse the runbook in an isolated or controlled environment and record the last verified version and date. An untested emergency procedure is a hypothesis.
4. Separate routine runbooks from diagnostic playbooks, which organize symptoms, evidence, decisions, containment, and escalation rather than prescribing random fixes.

## Diagrams

1. Add a diagram only when spatial structure, boundaries, sequence, state, data flow, deployment, or responsibility is clearer visually than in prose.
2. Define the question, audience, scope, and abstraction level. Give the diagram a title and legend, name every element, label relationship direction and purpose, and identify protocols or technologies when material.
3. Keep diagram source versioned and close to the described system when the repository supports it. Generate rendered assets in the established workflow and never hand-edit generated images.
4. Provide a text equivalent containing the same decisions and relationships. Do not rely on color alone, unexplained shapes, tiny text, crossing lines, or a generic boxes-and-arrows picture.
