# vesper-sieve

What is not needed sleeps until it is called.

A Codex plugin with ten skills that the model opens on its own, and a base instruction file for GPT models. The instructions are the official Codex base text with rules for short plain answers, grounded facts, research and finished work.

## Install

```
codex plugin marketplace add dayfinggg/openai-codex-agent-skills
codex plugin add vesper-sieve@vesper-sieve
```

Then point Codex at the instruction file in `~/.codex/config.toml`, as the first line of the file:

```
model_instructions_file = ".tmp/marketplaces/vesper-sieve/base_instructions.md"
```
