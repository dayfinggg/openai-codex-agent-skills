#!/bin/sh
set -eu

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

curl -fsSL "https://codeload.github.com/$repo/tar.gz/$commit" -o "$tmp/source.tar.gz"
tar -xzf "$tmp/source.tar.gz" -C "$tmp"
source_root="$(find "$tmp" -mindepth 1 -maxdepth 1 -type d | head -n 1)"
[ -n "$source_root" ] || {
  printf 'Downloaded archive is empty.\n' >&2
  exit 1
}

src="$source_root/codex"
dest="${CODEX_HOME:-$HOME/.codex}"
install_mode="$(cat "$dest/.openai-codex-agent-skills.install-mode" 2>/dev/null || printf replace)"
mode=--replace
if [ "$install_mode" = merge ]; then
  mode=--merge
fi

CODEX_SKILLS_SOURCE="$src" sh "$source_root/scripts/install.sh" "$mode"
printf '%s\n' "$commit" >"$dest/.openai-codex-agent-skills.version"
printf 'Codex source revision: %s\n' "$commit"
