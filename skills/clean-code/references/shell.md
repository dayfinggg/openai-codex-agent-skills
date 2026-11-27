# Bash and POSIX shell

Choose the dialect and name it in the first line. `#!/usr/bin/env bash` allows arrays, `[[ ]]` and process substitution, and `#!/bin/sh` allows none of them. Move a script that grows past about a hundred lines, or that needs data structures, to a language such as Python.

## Pitfalls

- Quote every expansion, as in `"$var"`, `"$(cmd)"` and `"$@"`, because an unquoted value splits on spaces and expands wildcards.
- Hold a list of arguments in an array and expand it as `"${args[@]}"`. A list held in a string breaks on the first file name with a space.
- `set -euo pipefail` misses failures inside an `if` or `while` test, on the left side of `&&` or `||`, and in functions called from such a place. Check the commands that matter explicitly, as in `cmd || { echo "cmd failed" >&2; exit 1; }`.
- `local name=$(cmd)` hides the exit status of `cmd`, because `local` itself succeeds. Declare on one line and assign on the next.
- `cmd | while read -r line` runs the loop in a subshell, so its variables are gone after the loop. Feed it with `done < <(cmd)` or read into an array with `readarray -t`.
- Read lines with `while IFS= read -r line`, because without `-r` the shell eats backslashes.
- Write `./*` in place of `*`, so a file name that starts with a dash is not read as an option.
- Iterate files with a glob or with `find ... -print0` and `read -d ''` in place of parsing `ls`, and build commands as arrays in place of `eval`.
- Create temporary files with `mktemp` and remove them in a `trap cleanup EXIT`.
- Print data with `printf '%s\n' "$value"`, because `echo` treats some values as options, and send errors to standard error with `>&2`.

## Structure

Put the logic in functions and call `main "$@"` on the last line. Declare function variables with `local`, and name constants in upper case with `readonly`.

## Tools

Run `shellcheck` on every script and fix what it reports, format with `shfmt`, and check that a script parses with `bash -n`.
