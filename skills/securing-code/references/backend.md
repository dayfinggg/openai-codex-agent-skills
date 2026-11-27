# Backend and API flaws

## Authorisation

Broken object-level authorisation is the most common serious API flaw. Look for a handler that loads a record by an identifier from the request without comparing its owner or tenant with the caller, also in nested resources, bulk endpoints, exports, search filters and jobs. Prove it with two test users, and fix it by scoping every query by the caller in one shared place.

Check that admin and internal routes have a real check rather than an unlisted path, and that `PUT` and `DELETE` are checked like `GET`. For mass assignment, send fields such as a role, an owner, a price or a verified flag, and bind only an explicit list of accepted fields. In multi-tenant code, check that cache keys, queues, file paths and search indexes include the tenant.

## Races and state

A check followed by an update races when two requests pass the check before either writes, typically in coupons, balances, quotas, single-use tokens, invitations and file writes. Prove it with twenty or more parallel requests, and fix it with one atomic statement, a unique constraint, a row lock or an idempotency key. In multi-step flows such as checkout or password reset, try skipping, repeating and reordering steps.

## Server-side requests

A host string filter fails against redirects, alternate IP notations, IPv6-mapped addresses and DNS that changes between check and fetch. Resolve the name once, check the address against an allow-list, connect to that address, and refuse redirects or check each hop.

## Injection beyond SQL

Look for raw ORM fragments, column names and sort orders from input, NoSQL operators arriving as JSON objects such as `{"$ne": null}`, program arguments where a leading `-` becomes an option, header values with line breaks, LDAP and XPath filters, input used as a template rather than its data, XML parsers with external entities on, and stored values that reach a sink in a later request.

## Parsers and paths

Validate after the last transformation, with the parser the sink uses. Mismatches hide in duplicate JSON keys, URL parsing that differs between validator and client, Unicode case mapping or normalisation after validation, and multipart bodies. Resolve the final path, including archive entry names and symbolic links, and require that it stays under the base directory. Replace `pickle`, PHP `unserialize`, Java native serialisation and full-tag YAML loaders with a data-only format.

## Cryptography and secrets

Hash passwords with Argon2id at 19 MiB, 2 iterations and parallelism 1 or stronger, with scrypt, or with bcrypt at work factor 10 or more, which reads only the first 72 bytes. Compare secrets in constant time and take tokens from a cryptographic random source. Use a fresh nonce every time and an authenticated mode instead of ECB, and verify the algorithm and audience of a signed token before trusting its claims. Verify the signature and timestamp of every incoming webhook, and look for secrets in logs, error pages, URLs, client bundles and history.

## Availability

Bound the memory, time and rows one request can use. Look for nested repetition in regular expressions on input, pagination without a ceiling, uploads and decompression without limits, and queries whose cost the caller controls.

## Applications that call language models

Text from a document, a page or a tool can steer the model. Treat model output as untrusted input to queries, commands, templates and browsers, and give the model's tools only the rights of the user it acts for.
