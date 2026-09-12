---
name: triage
description: Classify an issue, alert, or incoming PR by evidence, impact, and likely owner. Produce an actionable brief. Implement fixes only when separately requested.
---

# Triage

Move an ambiguous incoming item to a justified next state.

## Establish the item

Capture the reported behavior, source, affected users or systems, environment, recency, and available evidence. Check for duplicates, known incidents, related changes, and existing ownership where those sources are available.

## Validate

Attempt the smallest safe reproduction or corroborating check. Distinguish confirmed, plausible, unsupported, duplicate, expected behavior, and cannot reproduce. Identify the exact missing information when validation is blocked.

## Classify

Assess severity from impact and urgency rather than tone. Identify likely owning component, scope, dependencies, security or data risk, and whether immediate containment is needed. Do not invent priority labels that the project has not defined.

For a suspected security event, preserve evidence and distinguish indicators from confirmed compromise. Identify a known security owner or an escalation need without inventing an attacker classification. Contacting people, sending evidence, or changing containment requires explicit authorization.

## Prepare the brief

State the problem, evidence, reproduction, expected behavior, acceptance criteria, constraints, likely touch points, and recommended next state. Write labels, comments, or tracker updates only with authorization.

## Output

Return the classification, confidence, rationale, missing information, owner candidate, and agent-ready brief.
