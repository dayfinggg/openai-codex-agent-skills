---
name: securing-code
description: Gives a method for finding, proving and fixing vulnerabilities, with the web and backend flaw classes that scanners and quick reviews miss. Use for a security review, audit or hardening, and when writing or changing code that handles input, auth, sessions, money, files, network calls, queries, templates, caches, queues or dependencies. Load before a security review and before the first edit of code that handles outside input, identity, money, files or dependencies.
---

# Securing code

Assume the obvious checks are done and look for the flaw that needs two facts about the system seen together. Prove findings in a local, development or test environment, test production or systems the user does not own only with their go-ahead, and keep every test free of destruction and denial of service.

## Method

Map every route, handler, job, webhook, consumer, file parser and command that takes outside data, and mark where data crosses between users, tenants, services and privilege levels.

Trace each source to each sink. Sources include headers, cookies, file names, records another user stored and responses from other services. Sinks include queries, commands, templates, file paths, URL fetches, deserialisers, redirects, response headers and logs. Note where validation happens and which representation it saw.

For each handler, find who may call it, which object it touches and where the code proves the caller owns that object.

Look between components, where two parts parse the same input differently or a step is assumed never to run twice, out of order or concurrently. After one finding, search for the same pattern elsewhere.

## Prove, fix, guard

Show the flaw with a test or local request that succeeds against the current code, and label what you cannot demonstrate as a hypothesis. Fix the cause where the wrong assumption is made, preferring a fix that removes the class, such as a parameterised call, an allow-list, a framework primitive or a database constraint, over a filter for bad values. Keep the proof as a regression test and run it after the fix.

Rate each finding by what an attacker gains and needs, and give its file, source-to-sink path, proof, fix and what stayed unchecked.

## References

Read `references/backend.md` for server code, APIs, jobs and services, `references/web.md` for code that serves browsers or handles sessions, tokens, caches or proxies, and `references/supply-chain.md` before changing dependencies, a build or a pipeline, or running scanners.
