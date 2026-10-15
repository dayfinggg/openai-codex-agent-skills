#!/bin/sh
set -eu

mode="${1:---replace}"
case "$mode" in
  --merge|--replace) ;;
  *) printf 'Usage: %s [--merge|--replace]\n' "$0" >&2; exit 2 ;;
esac
[ "$#" -le 1 ] || { printf 'Too many arguments.\n' >&2; exit 2; }

script_dir="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
. "$script_dir/lib.sh"
src="${CODEX_SKILLS_SOURCE:-$script_dir/../codex}"
dest="${CODEX_HOME:-$HOME/.codex}"
tmp="$(mktemp -d "${TMPDIR:-/tmp}/openai-codex-agent-skills-install.XXXXXX")"
trap 'rm -rf "$tmp"' EXIT HUP INT TERM
backup="$dest/.openai-codex-agent-skills-backups/$(date -u +%Y%m%dT%H%M%SZ)-$(basename "$tmp")"

remove_legacy=1
install_mode=replace
if [ "$mode" = --merge ]; then
  remove_legacy=0
  install_mode=merge
fi

codex_sync_payload "$src" "$dest" "$backup" "$remove_legacy" "$tmp"
printf '%s\n' "$install_mode" >"$dest/.openai-codex-agent-skills.install-mode"
printf 'Codex setup installed in %s mode: updated=%s removed=%s config_added=%s.\n' \
  "$install_mode" "$CODEX_SYNC_UPDATED" "$CODEX_SYNC_REMOVED" "$CODEX_CONFIG_ADDED"
[ ! -d "$backup" ] || printf 'Previous files were backed up to %s\n' "$backup"
printf 'Restart Codex to load the new instructions, skills, and configuration.\n'
