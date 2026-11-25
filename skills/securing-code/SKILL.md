---
name: securing-code
description: Gives a method for finding, proving and fixing vulnerabilities in the code base at hand, with the current classes of web and backend flaws that scanners and quick reviews miss. Use when writing or changing code that handles input, identity, sessions, money, files, network calls, queries, templates, caches, queues or dependencies, when reviewing code or a diff, when the user asks about security, a vulnerability, hardening or an audit, and before reporting such a change as done.
---

# Securing code

The well-known flaws are the starting point and not the goal. Assume that the obvious checks are done, and look for the flaw that needs two facts about the system to be seen together.

## Scope

This work covers the code base at hand and the systems the user runs for it. Prove a finding in the local, development or test environment. Do not send test traffic to production or to a system the user does not own without their go-ahead, and never run a destructive or denial-of-service test.

## Method

Map the entry points first. List every route, handler, job, webhook, message consumer, file parser and command that takes data from outside, and mark where data crosses a trust boundary between users, tenants, services and privilege levels.

Trace data from each source to each sink. A source is anything an outsider controls, including headers, cookies, file names, stored records that another user wrote, and responses from other services. A sink is a query, a command, a template, a file path, a URL fetch, a deserialiser, a redirect, a response header or a log. Follow the value through every transformation, and note where validation happens and what representation it validated.

Check authorisation at every entry point and not only at the front door. For each handler, ask which user may call it, which object it touches, and where the code proves that this user owns that object.

Ask what each component assumes about the others. Most serious flaws sit between two components that parse the same input differently, or in a step that the code assumes cannot run twice, out of order or at the same time.

When you find one flaw, search the code base for its variants. The same author wrote the same pattern elsewhere.

## Prove, fix, guard

Write a test or a local request that shows the flaw, and watch it succeed against the current code. A finding that you cannot demonstrate is a hypothesis, so label it as one. Then fix the cause at the point where the wrong assumption is made, not at the one input that revealed it. Prefer a fix that removes the class, such as a parameterised call, an allow-list, a framework primitive or a database constraint, to a filter for known bad values. Keep the proof as a regression test and run it again after the fix.

Rate each finding by what an attacker gains and what they need. Report the file, the path from source to sink, the proof, the fix and what you did not check. Leave out findings that you could not tie to a concrete path.

## References

Read `references/backend.md` before you review or write server code, an API, a job or a service. Read `references/web.md` before you review or write code that serves browsers or handles sessions, tokens, caches or proxies. Read `references/supply-chain.md` before you add or update a dependency, change a build or a pipeline, or run the scanners.

## Related skills

Load `writing-tests` for the proof and the regression test, `working-with-databases` when the flaw or the fix is in a query, and `verifying-work` before you report.
