---
name: impact
description: Determine what a proposed or completed change could break outside its immediate diff. Use for blast-radius analysis, shared contracts, migrations, risky refactors, and changes to public interfaces or persistent data. Do not use for a general code review with no cross-boundary risk.
---

# Impact

Trace changed assumptions to every meaningful consumer and identify the evidence needed to call the change safe.

## Establish the changed contract

Identify the type, interface, schema, behavior, configuration, timing, or state assumption that changes. State both the old and new contract.

## Trace consumers

Search direct callers, re-exports, generated clients, tests, jobs, integrations, stored data, deployment configuration, and operational tooling as applicable. Follow semantic consumers, not only textual matches. Consider rollback and mixed-version operation when releases can overlap.

## Rank risk

For each plausible break, describe the consumer, failure mode, likelihood, impact, and current protection. Separate verified consumers from uncertain external dependencies.

## Prove the critical fact

Run or identify the smallest check that demonstrates the most important compatibility claim. Do not rely only on a written inventory.

## Output

Return the changed contract, affected surfaces, ranked risks, evidence, unresolved consumers, and a focused verification plan. Do not implement the change unless separately requested.
