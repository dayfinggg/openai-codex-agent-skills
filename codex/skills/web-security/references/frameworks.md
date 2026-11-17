# Framework behavior relevant to web security

These are review leads, not a substitute for documentation matching the installed framework version.

## Django and Django REST Framework

- Model forms and serializers using all model fields can expose ownership or privilege fields. Prefer explicit fields and read-only treatment for server-owned properties.
- DRF object permissions do not automatically filter list results or protect custom object lookups. Check the view's actual lookup and permission flow.
- A per-view permission setting may replace the configured default rather than extend it. Verify effective settings for the installed release.

## FastAPI, Flask, Jinja, and Go templates

- Declare separate request and response schemas where a database model contains fields clients must not see.
- Verify Jinja autoescaping for the actual environment and template extension. Markup helpers and safe filters can bypass escaping.
- Go `text/template` does not provide HTML contextual escaping; use the correct HTML template engine for HTML output.

## Express and Next.js

- Trust proxy settings affect forwarded host and client IP interpretation. Trust only the real proxy chain configured for the deployment.
- A Next.js Server Action or Server Function is a callable server endpoint. Authenticate and authorize inside each action; a check in its page, layout, or client interface does not protect a direct request.

## Rails, Laravel, Symfony, and Spring

- Rails strong-parameter bypasses and Laravel unguarded models or `forceFill()` can permit request-controlled privileged fields.
- Symfony role checks are not necessarily object checks. Inspect the voter, subject, and entity query scope.
- Spring method security must be enabled and can be bypassed by self-invocation that avoids the proxy. Check all request-bound model fields and allowed binding rules.

## Keep the review bounded

Use these patterns only when the installed framework is in scope. Confirm the exact API, default, and mitigations in its official versioned documentation before assigning severity or recommending a framework-specific change.
