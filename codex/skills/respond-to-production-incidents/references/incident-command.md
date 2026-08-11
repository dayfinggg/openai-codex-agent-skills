# Incident command and communication

**Reviewed:** 2026-08-11
**Scope:** Active incident roles, decision logs, internal updates, and authorized external status communication.

## Command structure

- Assign one incident commander responsible for priorities and coordination, not every technical action.
- Assign operational investigators or mitigators by service boundary. Keep one owner per action and a reviewer for consequential changes where policy requires it.
- Assign a communications owner and a scribe or timeline owner. Rotate roles when fatigue or duration requires it.
- Use a single authoritative incident identifier, coordination channel, state summary, decision log, and time zone.

## Update content

Each update should state verified impact, current severity, what changed since the prior update, actions in progress, current health, material uncertainty, owner, and next update or decision time. Separate fact, inference, decision, and planned action.

Do not expose credentials, personal data, security-sensitive exploit details, internal hostnames, or unverified cause. Customer, regulator, law-enforcement, vendor, and public communication require the organization's designated authority.

## Decision records

Record the actor, time, observed evidence, decision, intended effect, exact target, command or action, result, and rollback status. An automated tool success message is evidence of execution, not recovery.

## Official sources

- [NIST SP 800-61 Rev. 3](https://csrc.nist.gov/pubs/sp/800/61/r3/final)
- [Google SRE incident response](https://sre.google/workbook/incident-response/)
- [Google SRE managing incidents](https://sre.google/sre-book/managing-incidents/)
