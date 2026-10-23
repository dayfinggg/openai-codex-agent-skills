# Security logging

From the OWASP Logging Cheat Sheet and the OpenTelemetry page on sensitive data. The project's logging policy and legal requirements win. Log only the events this application can detect and someone will act on, because OWASP warns that a blind checklist drowns real alerts.

## Events to log

- Input validation failures, such as protocol violations, bad encodings, and invalid parameter names and values.
- Output validation failures, such as a record set mismatch or invalid data encoding.
- Authentication successes and failures, and authorization failures.
- Session management failures, such as a modified session cookie or a suspicious JWT validation failure.
- Application errors and system events, such as runtime errors, connectivity and performance problems, third-party error messages, file system errors, virus detection in uploads, and configuration changes.
- Start-up and shut-down of the application and of logging itself.
- User administration, such as adding or deleting users, changing privileges, and assigning or removing tokens.
- Every use of administrator rights, and of default, shared, or break-glass accounts.
- Access to sensitive data such as cardholder data.
- Use and rotation of cryptographic keys.
- Creation and deletion of system-level objects.
- Data import and export, including screen-based reports.
- User-generated content, especially file uploads.
- Deserialization failures.
- Network failures, backend TLS and certificate validation failures, and requests with an unexpected HTTP method.
- Legal opt-ins, such as consent to use personal data, acceptance of terms, and marketing permission.
- Suspicious business logic activity.

When the project has no event naming scheme, use the OWASP Application Logging Vocabulary, such as `authn_login_fail` and `authz_fail`.

## Event fields

| Question | Fields |
|---|---|
| When | Event time in ISO 8601 UTC, the log time if it differs, and the correlation ID |
| Where | Application name and version, host, service, URL and method or code location |
| Who | Source address and the user or machine identity |
| What | Event type, severity, a security flag, a description, and optionally action, object, result, and reason |

Keep server clocks synchronized so events from several services line up.

## Data beyond the SKILL.md list

- Commercially sensitive information, data above the classification the log system may hold, and data the user opted out of also stay out.
- File paths and internal network names need special handling, because they reveal the system to anyone who reads the logs.
- When the code cannot be fixed at once, the Collector can delete or hash attributes with the attributes processor, drop spans or metrics with the filter processor, keep an allowlist with the redaction processor, and rewrite values with the transform processor.

## Logging failures

- A failure to log or export never stops the application and never leaks information to the caller.
- Logging cannot exhaust disk or database transaction log space.
- Actions driven by log data, such as account lockouts, cannot be abused to deny service to other users.

## Tests

- A logged value with CR and LF produces exactly one record holding the neutralized value.
- A request carrying a password, token, or session cookie produces output with none of them.
- Each new security event is emitted with its when, where, who, and what fields.
- The application keeps serving when the log destination or exporter fails.
- Logging stays on during security, fuzz, and performance tests.
