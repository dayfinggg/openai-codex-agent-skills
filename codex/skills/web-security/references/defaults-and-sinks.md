# Fail-open behavior and credentials in sinks

Confirm the deployment configuration and actual code path before reporting a finding.

## Fail-open behavior

Judge what executes, not the name of a flag. Missing secrets that fall back to known values, optional authentication that defaults to off, permissive origins, and verification failures that continue the request can expose protected behavior. Check whether a development-only bypass can run when a deployment variable is missing or misspelled.

Inspect exception paths in authentication and authorization. A timeout, missing policy result, or caught exception that is treated as allowed is a security control failure when an untrusted caller can reach it. Distinguish a rollback-safe failure from a multi-step operation left partly committed. Error responses can also expose stack traces, SQL, hostnames, or account data.

Check that any default credential, seeded admin account, or insecure debug mode is actually enabled in the shipped environment before reporting it. Do not infer production exposure from test fixtures alone.

## Credential holders and sinks

A credential leak needs a holder and a sink. Trace credential-bearing objects into logs, traces, errors, caches, queue messages, and API responses. Search the entire code path because generated serialization may happen far from where the credential is stored.

In Python, `repr=False` does not prevent `asdict`, `vars`, or custom serializers from exposing a field. Pydantic representation and dump exclusion settings are separate. In JavaScript and TypeScript, a TypeScript `private` property is still a normal runtime property; a JavaScript `#private` field behaves differently. A custom JSON serializer may not affect console or tracing output.

Prefer not storing credentials on broadly serialized objects. Otherwise use the appropriate redacting type or explicitly serialize an allowlist. Test the actual sink serializer and assert that the secret value does not appear. Keep test credentials synthetic.
