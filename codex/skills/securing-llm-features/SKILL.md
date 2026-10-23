---
name: securing-llm-features
description: Secures LLM features against prompt injection, excessive agency, unsafe output, leaks, and runaway cost. Use when code calls an LLM API or builds tools, agents, MCP servers, RAG, or model memory.
---

# Securing LLM features

Anything in the model's context can steer it, including retrieved pages, tool results, code comments, and other agents' messages. Enforce every rule that must hold in code outside the model. A project's own AI security conventions win over this skill.

## Tools

- Expose only narrow tools the feature needs, such as `get_service_status(service)` instead of a shell, raw SQL, or arbitrary fetch. Each tool's credentials allow only its operation, enforced downstream, and the model never sees keys or tokens.
- User, tenant, and session come from the authenticated request into the handler, never from model arguments, and every object a tool touches gets an authorization check.
- Each tool has a JSON Schema with enums, length limits, and `additionalProperties: false`, validated again in the handler. Unknown tools and invalid arguments get an error.
- Destructive, irreversible, financial, outbound, or permission-changing actions wait for a human approval that shows and binds the exact action and arguments, expires, and is consumed once. Changed arguments need a new approval, and a tool without a risk rating needs approval by default.
- Delegated access uses a short-lived token scoped to the task and session.

## Output, retrieval, and memory

- Output is untrusted input to its sink (LLM05). Markdown goes through a renderer that drops raw HTML and filters URL schemes, under a CSP. SQL uses bound parameters, processes get argument arrays without a shell, paths are checked against a base directory, and fetches go only to allow-listed hosts. Structured output passes a schema validator such as Pydantic or Zod and never reaches `eval`, `exec`, or a template source.
- Generated code runs only in an isolated container or VM, as non-root, without credentials or open network, in its own directory, with time and memory limits.
- Retrieved text sits in the user turn inside source-named delimiters, with closing sequences escaped, and the system prompt calls delimited content data. This lowers indirect injection without stopping it.
- The session's tenant filters the vector query itself, or each tenant has its own namespace. Ingested chunks come from curated sources and carry source, owner, and ingestion time.
- Memory is keyed by user and session, checked for secrets and injected instructions before writes, size-capped, and expires, unverified entries first. The agent's own output does not flow into trusted memory automatically.
- System prompts hold no credentials, internal URLs, discount codes, or rules whose secrecy matters (LLM07), and prompts carry only the fields the task needs.

## Limits

Each agent run has a step limit, token and cost budgets, a deadline, and a delegation depth, each model call an output limit, and each tool call a timeout (LLM10). Limits come from configuration and stop the run with an error naming the limit. Rate-limit per user and cap input size.

## Agents and MCP

- Agent-to-agent and MCP connections use authenticated, encrypted transport with per-agent credentials. A valid signature grants nothing by itself, so the receiver checks permission and rejects replays.
- MCP servers validate inputs, enforce access control, rate-limit, and sanitize outputs. They accept only tokens issued for themselves, pass no client token downstream, and bind state handles to the authenticated user. Local servers use `stdio` or require a token on HTTP.
- MCP clients treat descriptions, annotations, results, and URLs from foreign servers as untrusted, pin servers, prefix tool names by server, and confirm sensitive calls.
- Models, prompts, tool definitions, and MCP servers come from verified sources at pinned versions.

## Logging and tests

Log each tool call with user, session, tool, argument summary, authorization decision, approval ID, and result, with secrets and personal data redacted. Track tokens and cost per user and session, and alert on unusual sequences or spend. Adversarial tests cover an injected instruction in a retrieved document, an argument outside its enum, a cross-tenant query, an expired or reused approval, and an exceeded budget.

## Reference files

- [reference/owasp-llm-and-agentic.md](reference/owasp-llm-and-agentic.md) when designing or reviewing a feature, for the OWASP LLM and Agentic risks, cheat sheets, and MCP rules mapped to code.
- [examples.md](examples.md) for safe HTML rendering of output, a delete tool behind approval, tenant-scoped labelled retrieval, and an agent budget.
