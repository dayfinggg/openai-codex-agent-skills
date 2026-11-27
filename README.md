# vesper-sieve

Short working rules on top of the official Codex instructions, and ten skills that load when their work comes up.

`base_instructions.md` holds the official Codex instructions for GPT-6.2 Sol, taken unchanged from the model catalog of Codex 0.172.0 on 2026-11-27, followed by one section, "Working with this user", with the user's own rules. When Codex ships new instructions for its models, refresh the official part and keep the last section.

## Install

```
codex plugin marketplace add dayfinggg/openai-codex-agent-skills
codex plugin add vesper-sieve@vesper-sieve
```

Then point Codex at the instruction file in `~/.codex/config.toml`, as the first line of the file:

```
model_instructions_file = ".tmp/marketplaces/vesper-sieve/base_instructions.md"
```
