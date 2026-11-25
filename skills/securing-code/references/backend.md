# Backend and API flaws

## Authorisation

Broken object-level authorisation is the most common serious API flaw. Look for a handler that loads a record by an identifier from the request and does not compare its owner or tenant with the caller. Check the same for nested resources, bulk endpoints, exports, search filters and background jobs that take an identifier. Prove it with two test users. The fix scopes every query by the caller, in one shared place.

Function-level authorisation fails where an admin or internal route relies on being unlisted, or where a check exists for `GET` and not for `PUT` or `DELETE`. Mass assignment hides where a request body is bound to a model whole. Send fields such as a role, an owner, a price or a verified flag, and fix it with an explicit list of accepted fields.

Multi-tenant code leaks through caches, queues, file paths and search indexes whose keys leave out the tenant.

## Races and state

A check followed by an update is a race when two requests can pass the check before either writes. Look at coupons, balances, quotas, single-use tokens, invitations and file writes. Prove it with twenty or more parallel requests in a test. Fix it with one atomic statement, a unique constraint, a row lock or an idempotency key, never with a delay.

Look for steps that can be skipped, repeated or reordered in a multi-step flow such as checkout, password reset or verification.

## Server-side requests

A fetch of a URL from the user reaches internal services and cloud metadata. A filter on the host string fails against redirects, alternate IP notations, IPv6-mapped addresses and DNS that changes between the check and the fetch. Resolve the name once, check the resolved address against an allow-list, connect to that address, and refuse redirects or check each hop.

## Injection beyond SQL

Look for raw fragments in an ORM, column names and sort orders built from input, NoSQL operators that arrive as objects in JSON such as `{"$ne": null}`, arguments passed to a program where a value that starts with `-` becomes an option, header values with line breaks, LDAP and XPath filters, and stored values that reach a sink later in another request. Template engines execute input that is used as the template and not as its data. Parsers for XML resolve external entities unless that is switched off.

## Parsers and paths

Two components that parse the same bytes differently disagree about what was validated. Look for JSON with duplicate keys, differences in URL parsing between a validator and a client, Unicode that changes after validation through case mapping or normalisation, and multipart bodies. Validate after the last transformation, with the parser that the sink uses.

Path traversal survives a check when the path is normalised after it. Archive extraction writes outside the target through entry names and symbolic links. Resolve the final path and require that it stays under the base directory.

Deserialisers that build arbitrary types run code. This covers `pickle`, PHP `unserialize`, Java native serialisation and YAML loaders with full tags. Use a data-only format.

## Cryptography and secrets

Hash passwords with Argon2id at 19 MiB of memory, 2 iterations and 1 degree of parallelism or stronger, or with scrypt, or with bcrypt at a work factor of 10 or more, which reads only the first 72 bytes. Compare secrets in constant time. Take tokens from a cryptographic random source. Do not reuse a nonce, do not use ECB, and verify the algorithm and the audience of a signed token before you trust its claims.

Look for secrets in logs, error pages, URLs, client bundles and version history. Verify the signature and the timestamp of every incoming webhook.

## Availability

One request should not be able to consume unbounded memory, time or rows. Look for regular expressions with nested repetition applied to input, pagination without a ceiling, uploads and decompression without limits, and queries whose cost the caller controls.

## Applications that call language models

Text from a document, a web page or a tool is able to steer the model. Treat model output as untrusted input to any query, command, template or browser, and give the model's tools the rights of the user it acts for and no more.
