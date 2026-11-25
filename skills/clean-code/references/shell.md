# Bash and POSIX shell

Decide the dialect first and say so in the first line. `#!/usr/bin/env bash` allows arrays, `[[ ]]` and process substitution. `#!/bin/sh` allows none of them. A script that grows past about a hundred lines, or that needs data structures, belongs in a language such as Python.

## Pitfalls

Quote every expansion: `"$var"`, `"$(cmd)"`, `"$@"`. An unquoted value splits on spaces and expands wildcards.

Hold a list of arguments in an array and expand it as `"${args[@]}"`. A list held in a string breaks on the first file name with a space.

`set -euo pipefail` at the top catches many failures and misses others. `set -e` does not fire inside an `if` or `while` test, on the left side of `&&` or `||`, or inside a function called from such a place. Check the commands that matter explicitly, as in `cmd || { echo "cmd failed" >&2; exit 1; }`.

`local name=$(cmd)` hides the exit status of `cmd`, because `local` itself succeeds. Declare first and assign on the next line.

A loop fed by a pipe, as in `cmd | while read -r line`, runs in a subshell, and its variables are gone after the loop. Feed the loop with `done < <(cmd)` or read into an array with `readarray -t`.

Read lines with `while IFS= read -r line`. Without `-r` the shell eats backslashes.

Write `./*` where you would write `*`. A file name that starts with a dash is then not read as an option.

Do not use `eval`. Do not parse the output of `ls`. Use a glob or `find ... -print0` with `read -d ''`.

Create temporary files with `mktemp` and remove them in a `trap cleanup EXIT`.

Print data with `printf '%s\n' "$value"`. `echo` treats some values as options. Send errors to standard error with `>&2`.

Use `$(cmd)` for command substitution and `[[ ]]` for tests in Bash.

## Structure

Put the logic in functions and call `main "$@"` on the last line. Declare function variables with `local`. Name constants in upper case and declare them with `readonly`.

## Tools

Run `shellcheck` on every script and fix what it reports. Format with `shfmt`. Check that a script parses with `bash -n`.
