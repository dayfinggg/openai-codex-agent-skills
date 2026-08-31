---
name: triage
description: Classify an incoming issue, bug report, alert, or external pull request and turn it into an actionable engineering brief. Use when work needs validation, priority, ownership, or missing-information assessment before implementation. Do not solve the issue unless separately requested.
---

# Triage

Move an ambiguous incoming item to a justified next state.

## Establish the item

Capture the reported behavior, source, affected users or systems, environment, recency, and available evidence. Check for duplicates, known incidents, related changes, and existing ownership where those sources are available.

## Validate

Attempt the smallest safe reproduction or corroborating check. Distinguish confirmed, plausible, unsupported, duplicate, expected behavior, and cannot reproduce. Identify the exact missing information when validation is blocked.

## Classify

Assess severity from impact and urgency rather than tone. Identify likely owning component, scope, dependencies, security or data risk, and whether immediate containment is needed. Do not invent priority labels that the project has not defined.

For a suspected security event, distinguish an unsupported or false signal, opportunistic compromise, targeted compromise, and an extreme vulnerability requiring incident response. Route evidence through the approved security owner and preserve it instead of treating the item as an ordinary defect.

## Prepare the brief

State the problem, evidence, reproduction, expected behavior, acceptance criteria, constraints, likely touch points, and recommended next state. Write labels, comments, or tracker updates only with authorization.

## Output

Return the classification, confidence, rationale, missing information, owner candidate, and agent-ready brief.
