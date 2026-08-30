---
name: swarm
description: Fan out several independent investigations or candidate solutions and synthesize them into one judged result. Use when broad coverage, competing designs, or separable evidence lanes justify parallel agents and delegation is authorized. Do not use for dependent steps or shared mutable state.
---

# Swarm

Use parallel agents to increase coverage or diversity, not to duplicate the same unbounded request.

## Partition

Define the shared question, success criteria, evidence standard, and final decision owner. Divide work into non-overlapping lanes by component, hypothesis, source class, risk category, or candidate approach. Resolve shared contracts before fan-out.

## Dispatch

Give each worker a bounded brief with its lane, exclusions, output schema, and stopping condition. Use the smallest number of workers that covers the independent lanes. Do not let multiple workers edit the same files or state.

## Drain

Collect all results before synthesis unless one result proves that the remaining work is unnecessary. Track missing or failed lanes. Do not hide disagreement between workers.

## Judge

Compare evidence, reconcile duplicates, explain conflicts, and select a conclusion or base candidate. The primary agent remains responsible for integration and final verification.

## Boundaries

Use this skill only when multi-agent work is available and authorized. Otherwise execute the lanes sequentially without pretending they were independently reviewed.
