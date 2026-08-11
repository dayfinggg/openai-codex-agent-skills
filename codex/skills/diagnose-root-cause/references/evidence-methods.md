# Diagnostic Evidence Methods

Reviewed: 2026-08-11.

Use the repository's runbook, incident policy, configured tools, and observed system contract before these general sources.

## Live incidents

[NIST SP 800-61 Rev. 3](https://csrc.nist.gov/pubs/sp/800/61/r3/final) is the current final NIST incident-response publication reviewed for this skill. Use it to separate response, evidence preservation, recovery, and later improvement. It does not authorize a production action or replace the system owner's runbook.

## Troubleshooting

[Google SRE, Effective Troubleshooting](https://sre.google/sre-book/effective-troubleshooting/) supports triage, baseline comparison, observation before hypothesis expansion, controlled experiments, and separating correlation from causation. Apply only the parts that distinguish the current plausible causes. Do not reproduce its full process when the cause is already evidenced.

## Regression bisection

[Git `bisect` documentation](https://git-scm.com/docs/git-bisect) defines the good and bad revision workflow and automated run behavior. Use it only after verifying repository state, build reproducibility, test discrimination, and isolation from unrelated work. An inconclusive revision must not be labeled good or bad merely to continue the search.

These sources shape method, not confidence. The observed reproducer, trace, controlled experiment, and compatibility checks determine the claim that can be made in a specific task.
