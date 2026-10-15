# Security logging

Summarized from the OWASP Logging Cheat Sheet and the OpenTelemetry page on handling sensitive data. The project's logging policy, data classification, and legal requirements win over this file. OWASP warns that a blind checklist approach produces so many events that real alerts drown, so log the events this application can actually detect and someone will act on.

## Contents

- Events to log
- Event attributes
- Data that never enters telemetry
- Generalization instead of hashing
- Log injection
- Logging failures
- Tests

## Events to log

- Input validation failures, such as protocol violations, unacceptable encodings, and invalid parameter names and values.
- Output validation failures, such as a database record set mismatch or invalid data encoding.
- Authentication successes and failures.
- Authorization failures.
- Session management failures, such as a modified session cookie or a suspicious JWT validation failure.
- Application errors and system events, meaning syntax and runtime errors, connectivity problems, performance issues, error messages from third-party services, file system errors, virus detection in uploads, and configuration changes.
- Start-up and shut-down of the application and related systems, and starting, stopping, or pausing of logging itself.
- User administration, meaning adding or deleting users, changing privileges, and assigning or removing tokens.
- Any use of system or application administrator rights, and every action taken with them.
- Any use of default, shared, or break-glass accounts.
- Access to sensitive data such as payment cardholder data.
- Use and rotation of cryptographic keys.
- Creation and deletion of system-level objects.
- Data import and export, including screen-based reports.
- Submission and processing of user-generated content, especially file uploads.
- Deserialization failures.
- Network failures, backend TLS failures including certificate validation failures, and requests with an unexpected HTTP method.
- Legal and other opt-ins, such as consent to use personal data, acceptance of terms, permission for marketing, and permissions for mobile device capabilities.
- Suspicious business logic activity.

The OWASP Application Logging Vocabulary Cheat Sheet proposes a standard vocabulary for security events, such as `authn_login_fail` and `authz_fail`. Use it when the project has no event naming scheme of its own.

## Event attributes

Every security event answers four questions.

| Question | Fields |
|---|---|
| When | Event time in an international format such as ISO 8601 in UTC, the log time if it differs, and the interaction or correlation ID that links all events of one request |
| Where | Application name and version, host or address, service, URL and method or code location |
| Who | Source address and the identity of the user or machine client |
| What | Event type, severity, a security flag that separates security events from other logs, a description, and optionally the action, object, result, and reason |

Keep server clocks synchronized so events from several services line up.

## Data that never enters telemetry

Never put the following in log messages, log fields, span attributes, span events, baggage, metric attributes, or exception messages. Remove, mask, or encrypt it, and hash only where the hash cannot be reversed and tracking is truly needed.

- Passwords and other authentication credentials.
- Access tokens, refresh tokens, API keys, and authorization headers.
- Session identifiers and session cookies. Hash a session ID only when sessions must be tracked.
- Database connection strings.
- Encryption keys and other primary secrets.
- Payment card data and other financial account data.
- Source code.
- Sensitive personal data and personal data in general, such as names, email addresses, phone numbers, government identifiers, and health data.
- Commercially sensitive information.
- Data above the classification the log system may hold.
- Data the user opted out of or did not consent to.

File paths and internal network names need special handling, because they reveal the system to anyone who reads the logs. OWASP opens the topic with the rule to never log data unless it is legally sanctioned.

OpenTelemetry adds the principle of data minimization. Collect only data that serves an observability purpose, avoid personal information unless absolutely necessary, consider whether aggregated or anonymized data serves the same purpose, and review collected attributes regularly. It names `user.email`, `user.full_name`, `user.id`, and `client.address` as attributes to delete, hash, or generalize. Its baggage page adds that baggage and trace context travel in HTTP headers, visible to anyone inspecting the traffic and shared with downstream services such as third-party APIs.

## Generalization instead of hashing

Hashing a user ID or name may not anonymize it, because hashes of small and predictable input spaces, such as numeric user IDs, are reversible in practice. Prefer truncation or generalization.

- Dates. Keep the year, or the year and month, and drop the day.
- Email addresses. Drop the local part and keep only the domain.
- IPv4 addresses. Drop the last octet.
- IPv6 addresses. Drop the last 80 bits.

When the code cannot be fixed at once, the OpenTelemetry Collector can delete or hash attributes with the attributes processor, drop whole spans or metrics with the filter processor, keep an allowlist with the redaction processor, and rewrite values with the transform processor. Treat this as a safety net behind code that does not emit the data.

## Log injection

- Treat data from every other trust zone as untrusted, including headers, user names, file names, and responses from other services.
- Prefer a structured encoder such as JSON, which escapes control characters and quotes for the output format.
- In plain text output, replace CR, LF, and the format's delimiter characters in untrusted values before they reach the logger, and encode values for the format the logs are written in.
- Keep the message template constant, so an untrusted value can only ever fill a field.
- When logs are written to a database, use parameterized statements as the working-with-databases skill describes.

## Logging failures

- A failure in logging or exporting never stops the application from otherwise running and never leaks information to the caller.
- Logging cannot exhaust disk space or database transaction log space. Write to stdout or the OpenTelemetry pipeline and leave storage to the platform.
- Actions driven by log data, such as account lockouts, cannot be abused to deny service to other users.

## Tests

- A logged value containing CR and LF produces exactly one record whose field holds the neutralized value.
- A request carrying a password, token, or session cookie produces output that contains none of them.
- Each security event the change adds is emitted with its when, where, who, and what fields.
- The application keeps serving requests when the log destination or exporter fails.
- Logging stays on during security, fuzz, and performance tests, so those runs show what production would record.
