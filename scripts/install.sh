#!/bin/sh
set -eu

mode="${1:---merge}"
case "$mode" in
  --merge|--replace) ;;
  *) printf 'Usage: %s [--merge|--replace]\n' "$0" >&2; exit 2 ;;
esac

script_dir="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
. "$script_dir/lib.sh"

repo="${CODEX_SKILLS_REPO:-dayfinggg/openai-codex-agent-skills}"
branch="${CODEX_SKILLS_BRANCH:-main}"
dest="$HOME/.codex"
stamp="$(date -u +%Y%m%dT%H%M%SZ)"
backup="$HOME/.codex-backups/$stamp"
tmp="$(mktemp -d "${TMPDIR:-/tmp}/openai-codex-agent-skills-install.XXXXXX")"
trap 'rm -rf "$tmp"' EXIT HUP INT TERM

command -v curl >/dev/null 2>&1 || { printf 'curl is required.\n' >&2; exit 1; }
command -v tar >/dev/null 2>&1 || { printf 'tar is required.\n' >&2; exit 1; }

curl -fsSL "https://codeload.github.com/$repo/tar.gz/$branch" | tar -xz -C "$tmp"
source_root="$(find "$tmp" -mindepth 1 -maxdepth 1 -type d | head -n 1)"
[ -n "$source_root" ] || { printf 'Downloaded archive is empty.\n' >&2; exit 1; }
src="$source_root/codex"

remove_legacy=0
install_mode=merge
if [ "$mode" = --replace ]; then
  remove_legacy=1
  install_mode=replace
fi

codex_sync_payload "$src" "$dest" "$backup" "$remove_legacy" "$tmp"
printf '%s\n' "$install_mode" >"$dest/.openai-codex-agent-skills.install-mode"
printf 'Codex setup installed in %s mode: updated=%s removed=%s config_added=%s.\n' \
  "$install_mode" "$CODEX_SYNC_UPDATED" "$CODEX_SYNC_REMOVED" "$CODEX_CONFIG_ADDED"
[ ! -d "$backup" ] || printf 'Previous files were backed up to %s\n' "$backup"
printf 'Restart Codex to load the new instructions, skills, and configuration.\n'
