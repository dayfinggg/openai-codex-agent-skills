# GNU and BSD tools, macOS bash

Linux and Git Bash ship GNU tools. macOS ships BSD tools and bash 3.2.57 as `/bin/bash`. `sed --version` succeeds only on GNU.

## Commands that differ

| Task | GNU (Linux, Git Bash) | BSD (macOS) | Works on both |
|---|---|---|---|
| Edit in place | `sed -i 's/a/b/' f` | `sed -i '' 's/a/b/' f` | `sed -i.bak 's/a/b/' f && rm f.bak` |
| Perl regex | `grep -P` | none | `grep -E`, `rg`, `perl -ne` |
| Date arithmetic | `date -d '1 day ago'` | `date -v-1d` | none, use `python3` or `perl` |
| File size | `stat -c %s f` | `stat -f %z f` | `wc -c < f` (BSD pads with spaces) |
| NUL after file names | `grep -lZ` | `-Z` means decompress | `grep -l --null` |
| Empty input | `xargs` runs the command once | runs nothing | `xargs -r` |

## macOS /bin/bash 3.2

- It lacks `readarray` and `mapfile`, associative arrays and `${v,,}` (all bash 4.0) and `inherit_errexit` (4.4).
- Before 4.4, `"${arr[@]}"` of an empty array fails as unbound under `set -u`. Guard with `${arr[@]+"${arr[@]}"}`.
- Use `#!/usr/bin/env bash` so a Homebrew bash on PATH runs the script, and keep scripts meant for stock macOS within 3.2.
