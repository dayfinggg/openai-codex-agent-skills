#!/bin/sh
set -eu

mode="${1:---merge}"
case "$mode" in
  --merge|--replace) ;;
  *) printf 'Usage: %s [--merge|--replace]\n' "$0" >&2; exit 2 ;;
esac

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
mkdir -p "$dest"

backup_path() {
  path="$1"
  [ -e "$dest/$path" ] || return 0
  mkdir -p "$backup"
  cp -Rp "$dest/$path" "$backup/"
}

if [ "$mode" = "--replace" ]; then
  for path in config.toml AGENTS.md AGENTS.override.md model-instructions.md agents; do
    backup_path "$path"
    rm -rf "$dest/$path"
  done
  backup_path skills
  mkdir -p "$dest/skills"
  find "$dest/skills" -mindepth 1 -maxdepth 1 ! -name .system -exec rm -rf -- {} +
  for path in config.toml model-instructions.md; do
    cp -Rp "$src/$path" "$dest/"
  done
  cp -Rp "$src/skills/." "$dest/skills/"
  install_mode=replace
else
  for path in model-instructions.md skills; do
    backup_path "$path"
    if [ -d "$src/$path" ]; then
      mkdir -p "$dest/$path"
      cp -Rp "$src/$path/." "$dest/$path/"
    else
      cp -p "$src/$path" "$dest/$path"
    fi
  done
  install_mode=merge
fi

printf '%s\n' "$install_mode" >"$dest/.openai-codex-agent-skills.install-mode"
printf 'Codex setup installed in %s mode.\n' "$install_mode"
[ ! -d "$backup" ] || printf 'Previous files were backed up to %s\n' "$backup"
printf 'Restart Codex to load the new instructions and skills.\n'
