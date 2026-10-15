# OWASP LLM and Agentic risks mapped to code rules

Project conventions and the official pages linked below win over this file. Risk names are as published by the OWASP GenAI Security Project. The Agentic names were checked against the official PDF of the OWASP Top 10 for Agentic Applications 2026, version 2026, December 2025.

## Contents

- How to use this file
- OWASP Top 10 for LLM Applications 2025
- OWASP Top 10 for Agentic Applications 2026
- OWASP cheat sheets
- MCP security rules
- Sources

## How to use this file

Find the risks that match the feature, then apply the code rules in the same row. OWASP repeats some controls across risks, such as least privilege and human approval, so apply every row the feature touches. Organizational measures such as training, red-team programs, and model training pipelines are left out, because they are not decisions made while writing application code.

## OWASP Top 10 for LLM Applications 2025

| Risk | Code rules |
|---|---|
| LLM01 Prompt Injection | Treat the model as an untrusted user. Give the application its own API tokens and handle privileged functions in code rather than giving them to the model. Validate output formats with deterministic code. Require human approval for high-risk actions. Separate and clearly label untrusted external content. Test with adversarial inputs that treat the model as an attacker. |
| LLM02 Sensitive Information Disclosure | Give the model access only to the data the task needs, and restrict its data sources. Redact or tokenize confidential content before it enters a prompt. Keep the system preamble out of user reach. Return errors that do not leak configuration or data. |
| LLM03 Supply Chain | Use models and datasets only from verifiable sources, and check signatures or file hashes. Keep models and their APIs on maintained versions. Keep a signed inventory of components and their licenses. |
| LLM04 Data and Model Poisoning | Record the provenance of data that feeds fine-tuning, embeddings, or retrieval. Version datasets. Limit the model's exposure to unverified data, and keep user-supplied knowledge in a vector store you can correct without retraining. |
| LLM05 Improper Output Handling | Treat the model like any other user and validate its responses before they reach backend functions. Encode output for its context, HTML encoding for web pages and parameterized queries for databases. Never pass output to a shell, `exec`, or `eval`. Sanitize output before it builds file paths or email templates. Use a strict Content Security Policy. Log and monitor outputs. |
| LLM06 Excessive Agency | Minimize the tools exposed, the functions inside each tool, and each tool's permissions. Avoid open-ended tools such as shell execution. Execute tools in the user's context with least-privilege scopes. Require user approval for high-impact actions. Enforce authorization in the downstream system, not in the model. |
| LLM07 System Prompt Leakage | Keep secrets, credentials, and sensitive data out of system prompts and in systems the model cannot reach. Do not rely on the system prompt for strict behavior control. Enforce privilege separation and authorization checks independently of the model, and inspect output with guardrails outside the model. |
| LLM08 Vector and Embedding Weaknesses | Use permission-aware vector stores with fine-grained access control, and partition data so tenants and user groups cannot retrieve each other's content. Accept knowledge sources only from verified providers and audit the index for tampering. Classify combined data by sensitivity. Keep tamper-resistant logs of retrieval. |
| LLM09 Misinformation | Ground answers in retrieved, trusted sources. Validate key outputs automatically in high-stakes flows and route them to human review. Label AI-generated content and state its limits in the interface. Review generated code before it ships, because incorrect suggestions can introduce vulnerabilities. |
| LLM10 Unbounded Consumption | Limit input size. Rate-limit per user or source. Cap queued and total actions, and set timeouts on expensive operations. Restrict the model's access to networks and internal services. Monitor and log resource use and react to anomalies. Degrade gracefully under load. Do not expose logits or log probabilities unless the feature needs them. |

## OWASP Top 10 for Agentic Applications 2026

| Risk | Code rules |
|---|---|
| ASI01 Agent Goal Hijack | Treat all natural-language input, including uploaded documents and retrieved content, as untrusted and route it through the LLM01 controls. Enforce least privilege on tools and human approval for high-impact or goal-changing actions. Keep system prompts under version control and change them only through review. Pause or block when the agent proposes actions outside the original task. Sanitize every connected source, such as RAG input, emails, calendar invites, files, browsing output, and peer-agent messages. Log goal state and tool sequences. |
| ASI02 Tool Misuse and Exploitation | Give each tool a least-privilege profile with scopes, a maximum rate, and an egress allow-list. Require authentication for each tool call and human confirmation for destructive actions, with a dry-run or diff preview where possible. Run tools and code in sandboxes with outbound allow-lists. Validate intent and arguments in a policy check before execution, and enforce schemas and rate limits there. Apply cost, rate, or token budgets. Use fully qualified tool names and version pins to avoid lookalike tools, and fail closed on ambiguous resolution. Log every tool call and parameter change. |
| ASI03 Identity and Privilege Abuse | Issue short-lived, task-scoped credentials per agent. Isolate identity and memory per session and wipe state between tasks. Re-check authorization on each privileged step, not only at the start of a workflow. Require human approval for high-privilege or irreversible actions. Never let a delegated agent inherit its caller's full permissions, and flag privilege gained through delegation chains. |
| ASI04 Agentic Supply Chain Vulnerabilities | Allow-list and pin dependencies, models, prompts, tool definitions, and MCP servers, by content hash or commit where possible. Verify provenance before installing or activating a component, and scan for typosquats. Keep prompts, orchestration scripts, and memory schemas under version control with review. Sign and verify inter-agent messages. Provide a way to disable a compromised tool or connection everywhere at once. |
| ASI05 Unexpected Code Execution (RCE) | Apply LLM05 output handling to generated code. Ban `eval` in production agents. Never run as root, run code in sandboxed containers with network limits, and restrict the filesystem to a dedicated working directory. Separate code generation from execution with a validation step, require human approval for elevated runs, and keep the auto-execution allow-list under version control. Scan generated code statically before running it and log every generation and run. |
| ASI06 Memory and Context Poisoning | Encrypt memory in transit and at rest and give it least-privilege access. Scan memory writes and model outputs for malicious or sensitive content before committing them. Segment memory by user session and domain. Accept memory only from authenticated, curated sources and keep source attribution. Do not re-ingest the agent's own output into trusted memory automatically. Use per-tenant namespaces in shared vector stores, and expire unverified memory. |
| ASI07 Insecure Inter-Agent Communication | Use encrypted channels with per-agent credentials and mutual authentication. Sign messages and validate both payload and context. Protect exchanges with nonces, session identifiers, and timestamps against replay. Pin allowed protocol versions and reject downgrades. Authenticate discovery and registration. Use versioned, typed message schemas and reject messages that fail validation. |
| ASI08 Cascading Failures | Assume any model, agent, or external source can fail or be compromised. Sandbox agents with scoped APIs and mutual authentication. Validate high-impact tool calls against policy before execution. Separate planning from execution. Put checkpoints or human review before outputs propagate downstream. Rate-limit and pause on anomalies, and add quotas, progress caps, and circuit breakers between planner and executor. Keep time-stamped logs of inter-agent messages and decisions. |
| ASI09 Human-Agent Trust Exploitation | Require explicit confirmation before sensitive data access or risky actions. Keep tamper-proof records of user queries and agent actions. Show a plain-language risk summary that the model did not write, and let users report suspicious behavior. Block network and state-changing calls while showing a preview. Mark high-risk recommendations visually and attach their source. |
| ASI10 Rogue Agents | Keep signed, immutable audit logs of agent actions, tool calls, and inter-agent messages. Run agents in restricted environments with least-privilege API scopes and strict rules between trust zones. Provide kill switches and credential revocation. Declare each agent's expected tools and capabilities and block calls outside that declaration. Never expose signing keys to agents directly. |

## OWASP cheat sheets

**LLM Prompt Injection Prevention Cheat Sheet.**

- Distinguish direct injection from indirect injection hidden in content the model reads, such as web pages, code comments, commit messages, and issue descriptions.
- Separate instructions from data with clearly labelled sections. The cheat sheet states that labels do not enforce the boundary and that its filters are illustrative layers, not a complete defense.
- Validate output for leaked system prompts, exposed keys, and other policy violations before returning it.
- Gate consequential tool actions behind human approval decided by the operation, target, arguments, and caller's authority, not by keywords in the prompt, and verify the approval for the exact action at execution.
- Grant minimal permissions, prefer read-only database accounts, and validate tool calls against the user's permissions and session.
- Treat encodings such as Base64, hex, and Unicode smuggling as attack vectors to detect.

**AI Agent Security Cheat Sheet.**

- Give agents only the tools their task needs, scope each tool to read or write and to specific resources, and never use wildcard permissions.
- Enforce authorization in the execution component outside the model's context, and fail closed for unknown tools or missing approval requirements.
- Check and consume approvals atomically, bind them to the exact tool call, and reissue them when the target or parameters change. Bind approvals to an expiry, protect them against replay, and require step-up authentication for critical actions.
- Validate and sanitize data before storing it in agent memory. Isolate memory per user and session, set expiry and size limits, and check the integrity of long-term memory.
- Validate tool calls with schema-checked structured output, filter sensitive data from output, and apply rate and scope limits.
- Enforce token, cost, retry, and tool-chain limits, and never allow unlimited recursion, retries, or tool chaining.
- Log all agent decisions, tool calls, and outcomes, and for high-risk actions also the risk classification, authorization outcome, approval ID, result, and policy version. Track token use and cost per session or user. Redact sensitive fields first.
- In multi-agent systems, a valid message signature does not grant permission for the requested action. The receiver enforces the sender's permissions, and messages carry a unique ID and a bounded validity window.
- Run adversarial tests before release and after any change to prompts, tools, memory, retrieval, policies, or model provider.

## MCP security rules

From the Model Context Protocol specification pages on tools and on security best practices.

- Servers must validate all tool inputs, implement access controls, rate-limit tool invocations, and sanitize tool outputs.
- Clients should prompt for confirmation on sensitive operations, show tool inputs to the user before calling the server, validate tool results before passing them to the model, set timeouts for tool calls, and log tool usage.
- Clients must treat tool annotations as untrusted unless they come from trusted servers.
- Servers must not accept tokens that were not issued for the server, so token passthrough to downstream APIs is forbidden.
- Servers must not treat possession of a state handle as authentication. Bind handles server-side to the user taken from the verified token, and generate them with a secure random generator.
- Servers meant to run locally should use the `stdio` transport, or require an authorization token or a restricted IPC channel when they use HTTP.
- Clients that fetch URLs from servers should require HTTPS, block private and link-local address ranges, and validate redirect targets. Clients must reject dangerous schemes such as `javascript:` and `file:` in authorization URLs and must not open URLs through a shell.
- Use a progressive, least-privilege scope model and avoid wildcard or omnibus scopes.
- Clients that combine tools from several servers should disambiguate names, for example by prefixing them with a server identifier.

## Sources

- OWASP Top 10 for LLM Applications 2025, https://genai.owasp.org/llm-top-10/
- LLM01 Prompt Injection, https://genai.owasp.org/llmrisk/llm01-prompt-injection/
- LLM02 Sensitive Information Disclosure, https://genai.owasp.org/llmrisk/llm022025-sensitive-information-disclosure/
- LLM03 Supply Chain, https://genai.owasp.org/llmrisk/llm032025-supply-chain/
- LLM04 Data and Model Poisoning, https://genai.owasp.org/llmrisk/llm042025-data-and-model-poisoning/
- LLM05 Improper Output Handling, https://genai.owasp.org/llmrisk/llm052025-improper-output-handling/
- LLM06 Excessive Agency, https://genai.owasp.org/llmrisk/llm062025-excessive-agency/
- LLM07 System Prompt Leakage, https://genai.owasp.org/llmrisk/llm072025-system-prompt-leakage/
- LLM08 Vector and Embedding Weaknesses, https://genai.owasp.org/llmrisk/llm082025-vector-and-embedding-weaknesses/
- LLM09 Misinformation, https://genai.owasp.org/llmrisk/llm092025-misinformation/
- LLM10 Unbounded Consumption, https://genai.owasp.org/llmrisk/llm102025-unbounded-consumption/
- OWASP Top 10 for Agentic Applications 2026, https://genai.owasp.org/resource/owasp-top-10-for-agentic-applications-for-2026/
- LLM Prompt Injection Prevention Cheat Sheet, https://cheatsheetseries.owasp.org/cheatsheets/LLM_Prompt_Injection_Prevention_Cheat_Sheet.html
- AI Agent Security Cheat Sheet, https://cheatsheetseries.owasp.org/cheatsheets/AI_Agent_Security_Cheat_Sheet.html
- MCP tools, https://modelcontextprotocol.io/specification/latest/server/tools
- MCP security best practices, https://modelcontextprotocol.io/specification/latest/basic/security_best_practices
