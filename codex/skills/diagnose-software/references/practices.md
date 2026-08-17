# Diagnostic Practices

A useful hypothesis predicts an observation that can disprove it. Prefer experiments that distinguish several hypotheses with one controlled check. Preserve a timeline and correlate failures across service boundaries, while treating timestamps, logs, and dashboards as evidence with known gaps.

Root cause explains the mechanism and is supported by reproduction or converging evidence. Contributing conditions explain why safeguards failed or impact expanded. A fix is not verified until the original symptom and a regression check are addressed.

Primary sources:

- [Google SRE troubleshooting](https://sre.google/sre-book/effective-troubleshooting/)
- [Google SRE postmortem culture](https://sre.google/sre-book/postmortem-culture/)
- [Cursor agent debugging guidance](https://cursor.com/blog/agent-best-practices)
