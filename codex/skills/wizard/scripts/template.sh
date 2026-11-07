#!/usr/bin/env bash

set -euo pipefail

BOLD=""; DIM=""; RESET=""; BLUE=""; GREEN=""; YELLOW=""

TOTAL_STAGES=0

_STAGE_INDEX=0
ENV_FILE="${ENV_FILE:-.env}"
WRITTEN_ENV=()
WRITTEN_SECRET=()
SKIPPED=()

_clear() {
  [[ -t 1 ]] || return 0
  if command -v tput >/dev/null 2>&1 && tput clear 2>/dev/null; then return 0; fi
  printf '\033[2J\033[3J\033[H'
}

banner() {
  _clear
  printf '\n%s%s  %s%s\n' "$BOLD" "$BLUE" "$1" "$RESET"
  printf '%s  %s stages%s\n\n' "$DIM" "$TOTAL_STAGES" "$RESET"
  printf '%s  You drive the browser. This wizard tells you exactly what to do and\n' "$DIM"
  printf '  captures the values you copy back. Stop any time with Ctrl-C and run it\n'
  printf '  again later, because it remembers the values it already saved.%s\n' "$RESET"
  pause "Ready to start?"
}

stage() {
  _clear
  _STAGE_INDEX=$((_STAGE_INDEX + 1))
  printf '\n%s%sStage %s of %s. %s%s\n' \
    "$BOLD" "$BLUE" "$_STAGE_INDEX" "$TOTAL_STAGES" "$1" "$RESET"
}

say()  { printf '  %s\n' "$1"; }
step() { printf '  %s•%s %s\n' "$BLUE" "$RESET" "$1"; }
note() { printf '  %s%s%s\n' "$DIM" "$1" "$RESET"; }
warn() { printf '  %sWarning. %s%s\n' "$YELLOW" "$1" "$RESET"; }

open_url() {
  local url="$1"
  printf '  %sOpening%s %s\n' "$GREEN" "$RESET" "$url"
  { if   command -v wslview     >/dev/null 2>&1; then wslview "$url"
    elif command -v explorer.exe >/dev/null 2>&1; then explorer.exe "$url"
    elif command -v xdg-open    >/dev/null 2>&1; then xdg-open "$url"
    elif command -v open        >/dev/null 2>&1; then open "$url"
    else false; fi
  } >/dev/null 2>&1 || warn "Could not open a browser. Visit $url by hand."
}

pause() {
  printf '  %s%s%s ' "$DIM" "${1:-Press Enter to continue.}" "$RESET"
  read -r _ || true
}

confirm() {
  local reply=""
  printf '  %s%s [y/N] ' "$YELLOW" "$1"
  read -r reply || true
  [[ "$reply" =~ ^[Yy] ]]
}

_existing() {
  [[ -f "$ENV_FILE" ]] || return 1
  local line value sq="'\\''"; line=$(grep -E "^${1}=" "$ENV_FILE" | tail -n1) || return 1
  value="${line#*=}"
  if [[ "$value" == \'*\' ]]; then value="${value:1:${#value}-2}"; value="${value//"$sq"/\'}"
  elif [[ "$value" == \"*\" ]]; then
    value="${value:1:${#value}-2}"
    [[ "$value" == *[\\\$\"]* ]] && return 1
  fi
  printf '%s' "$value"
}

ask() {
  local key="$1" prompt="$2" current input s=$'\001' e=$'\002' p rc=0
  current=$(_existing "$key" || true)
  p="  $s$BOLD$e$prompt$s$RESET$e "
  [[ -n "$current" ]] && p+="$s$DIM$e(Enter keeps the current value)$s$RESET$e "
  read -e -r -p "$p" input || rc=1
  if (( rc )) && [[ -z "$input" ]]; then return 1; fi
  [[ -z "$input" && -n "$current" ]] && input="$current"
  printf -v "$key" '%s' "$input"
}

ask_secret() {
  local key="$1" prompt="$2" current input rc=0
  current=$(_existing "$key" || true)
  if [[ -n "$current" ]]; then
    printf '  %s%s%s %s(Enter keeps the current value)%s ' "$BOLD" "$prompt" "$RESET" "$DIM" "$RESET"
  else
    printf '  %s%s%s ' "$BOLD" "$prompt" "$RESET"
  fi
  read -rs input || rc=1
  printf '\n'
  if (( rc )) && [[ -z "$input" ]]; then return 1; fi
  [[ -z "$input" && -n "$current" ]] && input="$current"
  printf -v "$key" '%s' "$input"
}

write_env() {
  local key="$1" value="$2" tmp sq="'\\''"
  if [[ -L "$ENV_FILE" ]]; then
    warn "The environment file is a symbolic link. Choose a regular private file."
    return 1
  fi
  if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    if git ls-files --error-unmatch -- "$ENV_FILE" >/dev/null 2>&1 || ! git check-ignore -q -- "$ENV_FILE"; then
      warn "The environment file must be untracked and ignored before values can be saved."
      return 1
    fi
  fi
  [[ -e "$ENV_FILE" ]] || (umask 077 && : > "$ENV_FILE")
  chmod 600 "$ENV_FILE"
  tmp=$(mktemp)
  grep -vE "^${key}=" "$ENV_FILE" > "$tmp" || true
  printf "%s='%s'\n" "$key" "${value//\'/$sq}" >> "$tmp"
  cat "$tmp" > "$ENV_FILE"
  rm -f "$tmp"
  printf -v "$key" '%s' "$value"
  WRITTEN_ENV+=("$key")
  printf '  %sWrote%s %s to %s.\n' "$GREEN" "$RESET" "$key" "$ENV_FILE"
}

set_secret() {
  local name="$1" value="$2" repository
  if command -v gh >/dev/null 2>&1 && gh auth status >/dev/null 2>&1; then
    repository=$(gh repo view --json nameWithOwner --jq .nameWithOwner) || return 1
    if ! confirm "Set secret $name in $repository?"; then
      SKIPPED+=("GitHub secret $name in $repository")
      return 0
    fi
    if printf '%s' "$value" | gh secret set "$name" --repo "$repository" >/dev/null 2>&1; then
      WRITTEN_SECRET+=("$name")
      printf '  %sSet%s GitHub secret %s.\n' "$GREEN" "$RESET" "$name"
      return
    fi
  fi
  SKIPPED+=("GitHub secret $name (set it by hand with gh secret set $name)")
  warn "Skipped GitHub secret $name, because gh is not ready. Set it later."
}

set_var() {
  local name="$1" value="$2" repository
  if command -v gh >/dev/null 2>&1 && gh auth status >/dev/null 2>&1; then
    repository=$(gh repo view --json nameWithOwner --jq .nameWithOwner) || return 1
    if ! confirm "Set variable $name in $repository?"; then
      SKIPPED+=("GitHub variable $name in $repository")
      return 0
    fi
    if gh variable set "$name" --body "$value" --repo "$repository" >/dev/null 2>&1; then
      printf '  %sSet%s GitHub variable %s.\n' "$GREEN" "$RESET" "$name"
      return
    fi
  fi
  SKIPPED+=("GitHub variable $name")
  warn "Skipped GitHub variable $name, because gh is not ready. Set it later."
}

finish() {
  _clear
  printf '\n%s%s  Setup complete.%s\n' "$BOLD" "$GREEN" "$RESET"
  (( ${#WRITTEN_ENV[@]} ))    && note "Wrote ${#WRITTEN_ENV[@]} values to $ENV_FILE (${WRITTEN_ENV[*]})."
  (( ${#WRITTEN_SECRET[@]} )) && note "Set ${#WRITTEN_SECRET[@]} GitHub secrets (${WRITTEN_SECRET[*]})."
  if (( ${#SKIPPED[@]} )); then
    printf '\n'; warn "These items are still to do by hand."
    for s in "${SKIPPED[@]}"; do note "  - $s"; done
  fi
  printf '\n'
}

run_wizard() {

TOTAL_STAGES=1

banner "Stripe setup"

stage "Stripe API keys"
say "This stage stores your Stripe sandbox keys for local development and CI."
open_url "https://dashboard.stripe.com/apikeys"
step "Select your sandbox, then copy the publishable key (it starts with pk_test_)."
ask STRIPE_PUBLISHABLE_KEY "Paste the publishable key."
step "In the Standard keys list, copy the secret key (it starts with sk_test_)."
ask_secret STRIPE_SECRET_KEY "Paste the secret key."
write_env STRIPE_PUBLISHABLE_KEY "$STRIPE_PUBLISHABLE_KEY"
write_env STRIPE_SECRET_KEY "$STRIPE_SECRET_KEY"
set_secret STRIPE_SECRET_KEY "$STRIPE_SECRET_KEY"

finish
}

run_wizard "$@"; exit
