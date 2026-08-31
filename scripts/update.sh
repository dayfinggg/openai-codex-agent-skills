#!/bin/sh
set -eu

script_dir="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
. "$script_dir/lib.sh"

repo="${CODEX_SKILLS_REPO:-dayfinggg/openai-codex-agent-skills}"
branch="${CODEX_SKILLS_BRANCH:-main}"

command -v curl >/dev/null 2>&1 || {
  printf 'curl is required.\n' >&2
  exit 1
}
command -v tar >/dev/null 2>&1 || {
  printf 'tar is required.\n' >&2
  exit 1
}

tmp="$(mktemp -d "${TMPDIR:-/tmp}/openai-codex-agent-skills.XXXXXX")"
trap 'rm -rf "$tmp"' EXIT HUP INT TERM
nonce="$(date +%s)"

commit="$(
  curl -fsSL -H 'Accept: application/vnd.github+json' \
    -H 'Cache-Control: no-cache' \
    -H 'User-Agent: openai-codex-agent-skills-updater' \
    "https://api.github.com/repos/$repo/commits/$branch?update=$nonce" 2>/dev/null |
    tr '{,' '\n\n' |
    sed -n 's/^[[:space:]]*"sha"[[:space:]]*:[[:space:]]*"\([0-9a-f]\{40\}\)".*$/\1/p' |
    head -n 1
)" || true
[ -n "$commit" ] || commit="$branch"

curl -fsSL "https://codeload.github.com/$repo/tar.gz/$commit" | tar -xz -C "$tmp"
source_root="$(find "$tmp" -mindepth 1 -maxdepth 1 -type d | head -n 1)"
[ -n "$source_root" ] || {
  printf 'Downloaded archive is empty.\n' >&2
  exit 1
}

src="$source_root/codex"
dest="$HOME/.codex"
install_mode="$(cat "$dest/.openai-codex-agent-skills.install-mode" 2>/dev/null || printf replace)"
remove_legacy=1
if [ "$install_mode" = merge ]; then
  remove_legacy=0
fi
stamp="$(date -u +%Y%m%dT%H%M%SZ)"
backup="$dest/.openai-codex-agent-skills-backups/$stamp"

codex_sync_payload "$src" "$dest" "$backup" "$remove_legacy" "$tmp"
printf '%s\n' "$commit" >"$dest/.openai-codex-agent-skills.version"
printf 'Codex: updated=%s removed=%s config_added=%s commit=%s\n' \
  "$CODEX_SYNC_UPDATED" "$CODEX_SYNC_REMOVED" "$CODEX_CONFIG_ADDED" "$commit"
[ ! -d "$backup" ] || printf 'Previous files were backed up to %s\n' "$backup"
printf 'Restart Codex to load the new instructions, skills, and configuration.\n'
