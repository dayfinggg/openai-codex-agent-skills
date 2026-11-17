# Codex skills

The facts below follow the [Codex skills documentation](https://developers.openai.com/codex/skills) and the [Agent Skills specification](https://agentskills.io/specification), checked on 2026-11-17. Recheck current documentation before relying on a setting or path that may have changed.

A skill directory contains `SKILL.md` with YAML frontmatter for `name` and `description`. The name must match the directory and use lowercase letters, digits, and single hyphens, up to 64 characters. Keep the description under 1,024 characters and phrase it as a precise discovery pointer. A selected skill loads its full entrypoint; linked references and scripts load only when needed. Keep references one level below the entrypoint and explain their trigger before each link.

Codex supports implicit skill selection by description and explicit selection with `$skill-name`. Keep implicit selection enabled unless the user requests otherwise. An optional `agents/openai.yaml` can set UI metadata, invocation policy, and tool dependencies. Do not copy Claude-specific skill frontmatter such as `when_to_use`, `context: fork`, `hooks`, `model`, or `allowed-tools` into a Codex skill. Use only metadata supported by Codex and the Agent Skills specification.

The current Codex documentation lists project `.agents/skills` and user `$HOME/.agents/skills` locations, while installed distributions and the bundled installer can expose a `$CODEX_HOME/skills` directory. Verify the active locations in the installed runtime and use the user's chosen destination. Do not move or overwrite a same-named skill before checking its contents and callers. The official [skill guide](https://developers.openai.com/codex/skills) documents discovery, installation, and distribution.

When a skill does not trigger, test its description against both realistic requests and close misses. Inspect the actual loaded skill listing and relevant `agents/openai.yaml` file before changing policy. A valid YAML file does not prove the skill's routing is useful.
