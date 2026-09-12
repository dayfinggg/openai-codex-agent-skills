# Data and serialization

- Preserve explicit contracts for missing, null, empty, and false values. Validate decoded JSON shape before using it, including depth and size limits. `JSON_THROW_ON_ERROR` requires PHP 7.3+; on earlier supported versions check `json_last_error()` instead of accepting ambiguous null.
- Keep identifiers that exceed the runtime integer range as strings across JSON and storage. Distinguish JSON lists from objects; non-contiguous PHP array keys can change encoded shape. Do not reindex meaningful keys without a contract.
- Do not use binary floats for exact money. Use integer minor units with explicit currency/scale and overflow bounds, or the project's compatible decimal implementation. Define rounding at business boundaries.
- Use explicit time zones and immutable date values where supported. Distinguish an instant from a local calendar date or recurring local time. Preserve precision and test daylight-saving transitions for scheduling behavior. Use a monotonic clock for elapsed durations when the runtime provides one.
- Normalize external encoding deliberately. Byte length and character length differ; require the relevant extension before relying on multibyte operations. Never silently truncate identifiers or signed data during normalization.
- Do not pass untrusted content to `unserialize()`, even with `allowed_classes`. Prefer validated JSON/data formats at trust boundaries. For existing trusted serialized storage, check compatibility before changing class names, visibility, types, or serialization hooks.
- Version durable queue, cache, and API payloads when schema evolution requires it. During rolling releases, keep old/new readers compatible or provide an explicit conversion path. Do not serialize service containers or active database connections.

Sources: [PHP JSON decoding](https://www.php.net/manual/en/function.json-decode.php), [PHP floating-point precision](https://www.php.net/manual/en/language.types.float.php), [DateTimeImmutable](https://www.php.net/manual/en/class.datetimeimmutable.php), and [unserialize](https://www.php.net/manual/en/function.unserialize.php).
