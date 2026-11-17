The instructions and examples ship in English. Replies follow the language the user writes in unless they request another language.

The working agreement follows the [GPT-6.2 Codex guidance](https://learn.chatgpt.com/guides/prompting-gpt-6-2-astra) for Sol and Astra, with checkable outcomes, proportional tests, and reversible decisions within scope. Codex reads it through [`model_instructions_file`](https://learn.chatgpt.com/docs/config-file/config-reference). The distribution installs no runtime hooks or custom model selectors.

The distribution contains 24 skills and removes 17 retired entrypoints. Seven updated skills keep their existing identifiers. Use `code-review` for independent review, `server-ops` for remote change safety, `agent-docs` for instruction writing, and `orchestration` for delegation. Use `typescript-javascript` for language and runtime work formerly divided among the old JavaScript, TypeScript, and Node.js skills. See [Build skills](https://learn.chatgpt.com/docs/build-skills) for skill discovery and reference loading.

The [Playwright guide](../codex/skills/testing/references/playwright/test-generation.md) keeps a correct test enabled and failing for a confirmed application defect and reports the cause. The security audit workflow is defensive and excludes automated exploitation and attack replay. Adaptation and source notices are in the installed [LICENSE](../codex/LICENSE).

Replace mode removes retired entries from the active installation after backing them up. Merge mode retains unrelated skill folders, including retired names if they were installed earlier. Neither mode changes credentials, sessions, plugins, or system skills. The portable defaults select GPT-6.2 Sol for a fresh setup and keep an existing model selection.
