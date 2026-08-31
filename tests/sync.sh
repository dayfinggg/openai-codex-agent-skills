#!/bin/sh
set -eu

repo_root="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"
. "$repo_root/scripts/lib.sh"

test_root="$(mktemp -d "${TMPDIR:-/tmp}/codex-sync-test.XXXXXX")"
trap 'rm -rf "$test_root"' EXIT HUP INT TERM
source_dir="$test_root/source"
destination="$test_root/destination"
work="$test_root/work"
backup="$test_root/backup-1"
mkdir -p "$source_dir/skills/new" "$destination/skills/old" "$destination/skills/.system/builtin" "$work"

printf '%s\n' 'new instructions' >"$source_dir/model-instructions.md"
printf '%s\n' 'new skill' >"$source_dir/skills/new/SKILL.md"
printf '%s\n' \
  'model = "repo"' \
  'approval_policy = "never"' \
  '' \
  '[agents]' \
  'max_concurrent_threads_per_session = 30' \
  '' \
  '[features]' \
  'default_mode_request_user_input = true' >"$source_dir/config.toml"
printf '%s\n' 'old instructions' >"$destination/model-instructions.md"
printf '%s\n' 'old skill' >"$destination/skills/old/SKILL.md"
printf '%s\n' 'system skill' >"$destination/skills/.system/builtin/SKILL.md"
printf '%s\n' 'legacy instructions' >"$destination/AGENTS.md"
printf '%s\n' \
  'model = "local"' \
  'custom = 1' \
  '' \
  '[agents]' \
  'custom_agent_setting = true' \
  '' \
  '[custom]' \
  'value = "keep"' >"$destination/config.toml"

codex_sync_payload "$source_dir" "$destination" "$backup" 1 "$work"
[ "$CODEX_CONFIG_ADDED" -eq 3 ]
grep -q '^model = "local"$' "$destination/config.toml"
grep -q '^approval_policy = "never"$' "$destination/config.toml"
grep -q '^max_concurrent_threads_per_session = 30$' "$destination/config.toml"
grep -q '^\[features\]$' "$destination/config.toml"
grep -q '^value = "keep"$' "$destination/config.toml"
approval_line="$(grep -n '^approval_policy =' "$destination/config.toml" | cut -d: -f1)"
agents_line="$(grep -n '^\[agents\]$' "$destination/config.toml" | cut -d: -f1)"
max_threads_line="$(grep -n '^max_concurrent_threads_per_session =' "$destination/config.toml" | cut -d: -f1)"
custom_line="$(grep -n '^\[custom\]$' "$destination/config.toml" | cut -d: -f1)"
features_line="$(grep -n '^\[features\]$' "$destination/config.toml" | cut -d: -f1)"
[ "$approval_line" -lt "$agents_line" ]
[ "$agents_line" -lt "$max_threads_line" ]
[ "$max_threads_line" -lt "$custom_line" ]
[ "$custom_line" -lt "$features_line" ]
[ ! -e "$destination/skills/old" ]
[ -f "$destination/skills/new/SKILL.md" ]
[ -f "$destination/skills/.system/builtin/SKILL.md" ]
[ "$(cat "$destination/model-instructions.md")" = 'new instructions' ]
[ ! -e "$destination/AGENTS.md" ]
[ -f "$backup/config.toml" ]
[ -f "$backup/skills/old/SKILL.md" ]

before="$(codex_sha256_file "$destination/config.toml")"
mkdir -p "$destination/skills/retired"
printf '%s\n' retired >"$destination/skills/retired/SKILL.md"
printf '%s\n' 'unmanaged in merge mode' >"$destination/AGENTS.md"
codex_sync_payload "$source_dir" "$destination" "$test_root/backup-2" 0 "$work"
after="$(codex_sha256_file "$destination/config.toml")"
[ "$CODEX_CONFIG_ADDED" -eq 0 ]
[ "$before" = "$after" ]
[ ! -e "$destination/skills/retired" ]
[ -f "$destination/AGENTS.md" ]
