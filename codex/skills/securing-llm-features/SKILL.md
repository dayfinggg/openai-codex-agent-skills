---
name: securing-llm-features
description: Secures code that uses large language models against prompt injection, excessive agency, unsafe output handling, data leaks, and runaway cost. Use when code calls an LLM API, defines tools, builds an agent, MCP server, or RAG pipeline, or stores model memory.
---

# Securing LLM features

A model reads instructions and data through one channel and cannot reliably tell them apart, so anything that reaches its context can steer it. Make LLM features safe through what the code allows, not through what the prompt asks. This skill covers making any provider's LLM feature secure. The writing-secure-code skill owns injection, authentication, secrets, and resource limits in general, the working-with-databases skill owns SQL built from any input, the designing-http-apis skill owns endpoint authorization, and the adding-observability skill owns what never to log. When the project already has security conventions for its AI features, follow them over this skill.

## Treat the model as an untrusted user

- **Untrusted input.** User messages, retrieved web pages, documents, emails, code comments, commit messages, issues, tool results, and messages from other agents can all carry instructions. Assume any of them will try, and give the model no power you would not give the author of that content.
- **Prompts are not controls.** A system prompt that says "never do X" is guidance. Enforce every rule that must hold, such as who may see what or which action is allowed, in code outside the model.
- **Privileged operations run in code.** The application holds its own scoped credentials and performs privileged calls itself. The model never sees API keys, tokens, passwords, or connection strings.

## Tools and agency

- **Least functionality.** Expose only the tools the feature needs. Prefer a narrow tool such as `get_service_status(service)` over an open-ended one such as a shell, raw SQL, or arbitrary HTTP fetch.
- **Least privilege.** Each tool's credentials allow only its own operation, for example a read-only database account for a lookup tool and no send or delete rights for an email summarizer. Enforce the limit in the downstream system, not in the tool description.
- **The user's identity, not the model's word.** Take the user, tenant, and session from the authenticated request and pass them to the tool handler in code. Never accept an owner, role, or user ID as a model argument, and check authorization on every object a tool touches.
- **Strict arguments.** Give every tool a JSON Schema with types, enums, length limits, and `additionalProperties: false`, and validate again in the handler. Reject unknown tool names and invalid arguments with an error, never with a best guess.
- **Least autonomy.** Destructive, irreversible, financial, outbound, or permission-changing actions wait for a human. Show the exact action and arguments, bind the approval to them, give it an expiry, consume it once, and execute in code after confirmation. Any change to the target or arguments needs a new approval, and a tool without a risk rating needs approval by default.
- **Short-lived credentials.** When a tool needs delegated access, issue a token scoped to that task and session and let it expire, instead of reusing a long-lived key.

## Model output

- **Encode for the sink.** Model output is untrusted input to whatever reads it next (LLM05). Render it as text, or as Markdown through a renderer that escapes raw HTML and filters URL schemes, under a Content Security Policy. Build SQL with bound parameters, run processes with an argument array from an allow-list and never through a shell, resolve file paths and check them against a base directory, and fetch URLs only from allow-listed hosts.
- **Parse, then validate.** When code consumes structured output, parse it with a schema validator such as Pydantic or Zod and reject anything that does not conform. Never pass output to `eval` or `exec`, and never use it as template source.
- **Generated code runs only in a sandbox.** Run model-written code in an isolated container or VM, as a non-root user, with no credentials, no network unless an egress allow-list requires it, a dedicated working directory, and time and memory limits. Never run it directly against production.

## Retrieved content and RAG

- **Label external content as data.** Put retrieved text in the user turn inside delimiters that name the source, escape anything inside it that could close the delimiter, and state in the system prompt that delimited content is data. This lowers the success rate of indirect injection but does not stop it, so the tool and privilege rules above still carry the weight.
- **Filter by tenant in the query.** Pass the tenant or user from the session into the vector store query itself, or keep one namespace or collection per tenant. Never retrieve across tenants and rely on the model to ignore the rest.
- **Control ingestion.** Index content only from authenticated, curated sources, and store its source, owner, and ingestion time with each chunk so poisoned entries can be traced and removed.

## Memory and context

- **Isolate memory.** Key stored conversation history, summaries, and long-term memory by the authenticated user and session, and never share them across users.
- **Validate before storing.** Check memory writes for secrets and injected instructions, and do not feed the agent's own output back into trusted memory automatically.
- **Expire it.** Give memory a size limit and an expiry, and let unverified entries expire first.
- **Minimize context.** Send the model only the fields the task needs, and keep personal and sensitive data out of prompts unless the feature requires it.

## System prompts

- **No secrets in system prompts** (LLM07). Assume the system prompt will leak, so it holds no credentials, internal URLs, connection strings, discount codes, or rules whose secrecy matters.
- **Security rules live in code.** Authorization, privilege separation, and bounds checks never depend on the model following its prompt.

## Limits

- **Bound every loop** (LLM10). Each agent run has a maximum number of steps, a token budget, a cost budget, a wall-clock deadline, and a maximum delegation or recursion depth. Each model call has an output token limit, and each tool call has a timeout.
- **Limit per user.** Rate-limit requests per user and cap input size before it reaches the model.
- **Values come from configuration.** Read limits from the project's configuration, stop the run with a clear error when one is exceeded, and never let an agent retry or recurse without a bound. The building-resilient-services skill covers retries and timeouts in general.

## Agents and MCP

- **Authenticate every connection.** Agent-to-agent and MCP connections use authenticated, encrypted transport with per-agent credentials. A valid signature identifies the sender but does not grant the action, so the receiver checks the sender's permission and rejects replayed messages.
- **MCP servers.** Validate all tool inputs, enforce access control, rate-limit tool calls, and sanitize tool outputs. Accept only tokens issued for this server and never pass a client's token through to a downstream API. Never treat a state handle as authentication, and bind it to the authenticated user. A local server uses the `stdio` transport or requires an authorization token on HTTP. Request the smallest scopes that work.
- **MCP clients.** Treat tool descriptions, annotations, and results from servers you do not control as untrusted. Pin the servers you connect to, prefix tool names by server when combining several, show tool inputs and confirm sensitive calls, and validate URLs a server hands you before opening or fetching them.
- **Supply chain.** Load models, prompts, tool definitions, and MCP servers only from verified sources and pin their versions. The managing-dependencies-and-ci skill covers packages.

## Logging

Log every tool call with the user, session, tool name, a summary of the arguments, the authorization decision, the approval ID when there was one, and the result status. Track token use and cost per user and session, and alert on unusual tool sequences or spending. Redact secrets and personal data before logging, and follow the adding-observability skill for what never to log.

## Workflow

1. Map the feature. List every source that reaches the model's context, every tool, every sink its output reaches, every store it reads or writes, and every credential involved.
2. For each tool, define the narrowest operation, the identity it runs as, its argument schema, and whether it needs human approval.
3. Add output encoding or validation at every sink, and a sandbox for any code execution.
4. Scope retrieval and memory to the authenticated user or tenant, and label retrieved content.
5. Add step, token, cost, time, and depth limits from configuration, and tool call logging.
6. Write adversarial tests, such as an injected instruction in a retrieved document, a tool argument outside its enum, a cross-tenant query, an expired or reused approval, and an exceeded budget. The writing-tests skill covers test style.
7. Review against the checklist.

## Checklist

- [ ] No credential, secret, or authorization rule depends on the model or appears in a prompt
- [ ] Each tool is narrow, uses least-privilege credentials, and runs as the authenticated user
- [ ] Tool arguments are validated by schema and in the handler, and unknown tools are rejected
- [ ] Destructive and high-risk actions need a bound, expiring, single-use human approval
- [ ] Model output is encoded or validated before HTML, SQL, a shell, a file path, a URL, or code
- [ ] Generated code runs only in a sandbox without credentials or open network access
- [ ] Retrieved content is labelled as data, and retrieval is filtered by tenant in the query
- [ ] Memory is isolated per user and session, validated before writes, and expires
- [ ] Agent loops have step, token, cost, time, and depth limits from configuration
- [ ] Agent-to-agent and MCP connections are authenticated, and MCP servers reject foreign tokens
- [ ] Tool calls are logged without secrets or personal data
- [ ] Adversarial tests cover injection, invalid tool arguments, cross-tenant access, approvals, and budgets

## Reference files

Read them before the first change, the examples file for every task and the OWASP mapping when designing a feature or reviewing one.

- [references/owasp-llm-and-agentic.md](references/owasp-llm-and-agentic.md) maps each OWASP LLM and Agentic risk, the two OWASP cheat sheets, and the MCP security rules to concrete code rules, with source links.
- [examples.md](examples.md) has illustrative before and after pairs in Python and TypeScript for model output in HTML, a shell tool, a delete tool behind approval, labelled retrieval, an agent budget, and a system prompt with secrets.
