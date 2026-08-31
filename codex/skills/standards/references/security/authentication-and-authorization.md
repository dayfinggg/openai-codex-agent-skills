# Authentication and authorization

- Separate authentication, which establishes identity, from authorization, which permits an action on a resource.
- Authorize every sensitive operation at the trusted server boundary using current identity, resource ownership, tenant, state, and requested action.
- Apply complete mediation: do not reuse a stale authorization decision when identity, policy, resource state, or requested operation may have changed.
- Treat an authenticated remote component as identified, not automatically trustworthy. Validate its authorization and message content for each protected operation.
- Deny by default and grant the smallest capability or role required. Avoid broad administrator checks when a narrow policy expresses the real rule.
- Avoid ambient authority. Prefer small administrative operations with explicit target, action, duration, and business justification; require independent approval for exceptionally dangerous actions when the risk warrants it.
- Define authorization-controller failure per operation. Use fail-static behavior when retaining the last safe state is safer than granting new access or shutting down all existing access.
- Protect against horizontal and vertical privilege escalation by testing access to another user's or tenant's identifiers.
- Bind sessions and tokens to the intended audience, issuer, lifetime, scopes, and transport. Rotate or revoke them when privilege or compromise state changes.
- Make emergency or break-glass access narrow, audited, time-bounded, regularly exercised, and independent enough to work during the failure it is meant to recover.
- Return safe authentication and authorization failures without revealing account existence, secrets, internal policy, or stack details beyond what the user needs to recover.
- Separate the safe external failure from a correlation token and protected diagnostic record that an authorized support workflow can use.
