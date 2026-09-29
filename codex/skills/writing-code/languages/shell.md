# Shell scripts

## When to use the shell

Use Bash for glue: running a few commands in order, deploy and setup steps, small wrappers. Once a script passes about 100 lines, needs data structures beyond an array, or parses structured data, write it in the project's main language instead. Match the shell the project already uses, and write POSIX `sh` only when the script must run where Bash is absent.

## Defaults for every script

- Start with `#!/usr/bin/env bash` and `set -Eeuo pipefail`. Treat that line as a safety net, not as error handling: it does not fire inside `if` conditions, `&&` and `||` chains, functions called from a condition, or `local name=$(command)`, so check the commands whose failure matters explicitly.
- Quote every expansion: `"${file}"`, `"$@"`, `"$(command)"`. Keep argument lists in arrays and expand them as `"${args[@]}"`.
- Use `[[ ... ]]` for tests and `$(...)` for command substitution.
- Declare function variables with `local`, and split declaration from assignment when the value comes from a command: `local output` on one line, `output="$(command)"` on the next.
- Put constants in `readonly` uppercase names. Pass everything else as arguments.
- Scripts with several functions end with `main "$@"`.
- Send errors to stderr with `>&2` and exit with a non-zero status.
- Create temporary files with `mktemp` and remove them with `trap 'rm -rf -- "${tmp_dir}"' EXIT`.
- Put `--` before paths that come from input, so a name starting with a dash is not read as an option.

## Safe to run twice

Deploy and setup scripts are run again after a failure. Make each step idempotent: `mkdir -p`, `ln -sfn`, check before creating a user, a database or a line in a config file, and write files to a temporary name then `mv` them into place.

## Network and external commands

Give every `curl` call `--fail --silent --show-error --max-time <seconds>` and limited retries with `--retry`. Check that required commands exist with `command -v` before using them.

## Outdated or risky patterns

Do not write backticks, unquoted variables, `eval`, parsing the output of `ls`, `for f in $(find ...)`, piping into `while read` when the loop must change variables, `echo` for arbitrary data where `printf '%s\n'` is safe, or `cd` without checking that it succeeded.

## Fallback commands

- Lint: `shellcheck script.sh`, with `-x` to follow sourced files. Fix every warning. When one is wrong for a specific command, put `# shellcheck disable=SC<code>` on the line before it.
- Format: `shfmt -w script.sh` when the project uses it.
