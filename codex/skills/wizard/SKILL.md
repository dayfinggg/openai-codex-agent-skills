---
name: wizard
description: Generates an interactive bash wizard that walks a human through steps only they can perform. Use when a person must provision infrastructure, create credentials or CI secrets, or click through a third-party dashboard. Use for a one-off migration or cutover with manual steps. Skip it for steps the agent can perform itself.
---

<overview>
A wizard is a bash script that walks a human step by step through a manual procedure. Such a procedure is tedious to do by hand and tedious to re-explain to an AI every time. The wizard opens each URL and says exactly what to click and copy. It captures the values and writes them where they belong, such as `.env` or GitHub secrets. It confirms at every stage and shows how many stages are left. It might configure third-party services, run a one-off migration, or move the project from one state to another.

[template.sh](scripts/template.sh) already solves the user experience. It provides stage-by-stage progress, confirmation gates, and URL opening across platforms, WSL included. It also provides hidden secret entry, idempotent `.env` upserts, `gh secret` and `gh variable` writes, and a closing summary. Your job is only to scope the procedure and author its stages. The library functions above `run_wizard` are identical in every wizard, and that consistency is the point. So edit only the body of `run_wizard`.

A wizard is ephemeral by default. It is built for one run and saved to the session's scratchpad or a temporary directory. Delete it when the job is done. Save it to `scripts/` in the repository only when the user wants a repeatable setup path there.
</overview>

<process>
<scope_the_procedure>
Work out every manual step the human must take and every value captured along the way. Read the repo first instead of asking cold.
- For setup, read variable names from `.env.example`, the README, `docker-compose*`, framework config, and `.github/workflows/*`. Keep secret values out of the conversation. Include only variables needed for the requested setup.
- For a migration or transition, read the current state, the target state, and the irreversible actions between them.

Then show the user the ordered list of stages and the values each one produces, and confirm it. The user may add, drop, or reorder stages.

This step is done when every stage is named in order and you know three facts for each captured value.
1. Where the human gets it.
2. Where it is written, which is `.env`, a GitHub secret, both, or nowhere, since some stages are pure actions.
3. Whether it is secret (hidden entry) or public.
</scope_the_procedure>

<map_each_stage>
For each stage, write the precise path a human follows. Name the URL to open, what to do there, where the value appears, and which variable it fills. An example path is "Dashboard, then Developers, then API keys, then copy the secret key." Where you do not know the current UI or the exact command, check the vendor's docs or ask the user. Never invent steps that may not exist.

This step is done when every stage traces to concrete instructions a stranger could follow.
</map_each_stage>

<author_the_wizard>
Copy `scripts/template.sh` to the target path. Replace the example stage inside `run_wizard` with one `stage` per step, in dependency order. Use the library helpers `stage`, `say`, `step`, `note`, `warn`, `open_url`, `ask`, `ask_secret`, `write_env`, `set_secret`, `set_var`, `pause`, and `confirm`. Start with `banner` and end with `finish`, as the example does. Set `TOTAL_STAGES` to the number of stages you wrote.

Hold the bar the template sets.
- Open the URL before you ask for its value.
- Use the harness's secret input mechanism when available. Otherwise use `ask_secret` for hidden local input, never paste secrets into chat.
- Call `write_env` for every value the scope step sends to `.env`.
- Call `set_secret` only for the values CI actually needs.
- Call `confirm` before any irreversible action.

Each `stage` clears the screen so only the current step is visible. So keep a stage to one focused task, and nothing the human needs scrolls away. Keep every stage inside `run_wizard`, and keep the last line `run_wizard "$@"; exit` as it is. Bash then parses the whole file before the first prompt, so an edit during a run cannot break it. Printed text follows the same plain style as the template's own messages.
</author_the_wizard>

<verify_and_hand_off>
Verify the script statically, because a real run opens browsers and blocks on human input. Say in the reply that the script was checked by reading and not by a run.
1. Run `bash -n` on the script, and run `shellcheck` if it is installed.
2. Run `chmod +x` on the script.
3. Trace it by reading. Every value from the scope step must be captured and land where that step said. Every `set_secret` name must exactly match a `secrets.*` reference in CI.
4. Tell the user the command that runs it. Change a README only when requested, as `code_rules` requires.
</verify_and_hand_off>
</process>
