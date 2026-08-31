# Resource abuse, URLs, and SSRF

- Bound request bodies, file sizes, decompression ratios, collection sizes, nesting, recursion, concurrency, retries, queue depth, execution time, and response size according to resource cost.
- Parse URLs with a maintained URL library and allow only intended schemes, hosts, ports, and redirect behavior.
- For server-side fetches, resolve and validate every destination according to the threat model, including redirects and DNS changes. Block loopback, link-local, private, metadata, file, and internal service targets unless explicitly required.
- Do not use a regular expression as the sole validator for a complex URL or IP address. Prefer parser and address libraries plus a clear allowlist policy.
- Apply rate limits and quotas at the identity or resource boundary that represents cost. A global limit alone may let one tenant exhaust everyone else's capacity.
- Make expensive work cancellable and propagate deadlines. Reject overload early rather than accepting unbounded work that will fail later.
- Prevent retry storms with bounded attempts, exponential backoff, jitter, idempotency, and a shared retry budget.
