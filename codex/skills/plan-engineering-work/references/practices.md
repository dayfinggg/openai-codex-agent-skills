# Planning Practices

Use a full plan when work crosses modules or services, changes architecture or data, has meaningful ambiguity, or needs rollout and rollback. For a small reversible edit, state the intended change and validation without manufacturing phases.

Plans should remain read-only, describe the current state before the target state, expose assumptions, name affected code when verified, and make each phase independently checkable. Prefer small vertical changes that leave the system working. Separate preparatory refactors from behavior changes.

Primary sources:

- [Cursor agent best practices](https://cursor.com/blog/agent-best-practices)
- [Cursor Plan Mode](https://cursor.com/blog/plan-mode)
- [Claude Code permission and plan modes](https://code.claude.com/docs/en/permission-modes)
- [Google small change guidance](https://google.github.io/eng-practices/review/developer/small-cls.html)
- [Google SRE What, Why, How](https://sre.google/resources/practices-and-processes/what-why-how/)
