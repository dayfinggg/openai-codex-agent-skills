#!/bin/sh

codex_backup_path() {
  cb_dest="$1"
  cb_backup="$2"
  cb_rel="$3"
  [ -e "$cb_dest/$cb_rel" ] || return 0
  mkdir -p "$cb_backup/$(dirname "$cb_rel")"
  cp -Rp "$cb_dest/$cb_rel" "$cb_backup/$cb_rel"
}

codex_sha256_file() {
  if command -v sha256sum >/dev/null 2>&1; then
    sha256sum "$1" | awk '{print $1}'
  elif command -v shasum >/dev/null 2>&1; then
    shasum -a 256 "$1" | awk '{print $1}'
  else
    openssl dgst -sha256 "$1" | awk '{print $NF}'
  fi
}

codex_merge_config() {
  cm_source="$1"
  cm_destination="$2"
  cm_destination_root="$3"
  cm_backup="$4"
  cm_work="$5"
  cm_output="$cm_work/config-merge.out"
  cm_count="$cm_work/config-merge.count"

  if [ ! -f "$cm_destination" ]; then
    mkdir -p "$(dirname "$cm_destination")"
    cp -p "$cm_source" "$cm_destination"
    awk '/^[[:space:]]*[A-Za-z0-9_.-]+[[:space:]]*=/ { count++ } END { print count + 0 }' "$cm_source"
    return 0
  fi

  awk -v count_file="$cm_count" '
    function is_section(line) {
      return line ~ /^[[:space:]]*\[[^]]+\][[:space:]]*(#.*)?$/
    }
    function section_name(line, value) {
      value = line
      sub(/^[[:space:]]*\[/, "", value)
      sub(/\][[:space:]]*(#.*)?$/, "", value)
      sub(/^[[:space:]]+/, "", value)
      sub(/[[:space:]]+$/, "", value)
      return value
    }
    function is_key(line) {
      return line ~ /^[[:space:]]*[A-Za-z0-9_.-]+[[:space:]]*=/
    }
    function key_name(line, value) {
      value = line
      sub(/^[[:space:]]*/, "", value)
      sub(/[[:space:]]*=.*/, "", value)
      return value
    }
    function emit_missing(section, before_section, i) {
      if (emitted[section] || missing_count[section] == 0) {
        return
      }
      for (i = 1; i <= missing_count[section]; i++) {
        print missing_line[section SUBSEP i]
      }
      if (before_section) {
        print ""
      }
      emitted[section] = 1
    }
    FNR == NR {
      if (is_section($0)) {
        source_section = section_name($0)
        if (!source_section_seen[source_section]) {
          source_section_seen[source_section] = 1
          source_section_order[++source_section_count] = source_section
          source_section_header[source_section] = $0
        }
      } else if (is_key($0)) {
        source_entry_section[++source_entry_count] = source_section
        source_entry_key[source_entry_count] = key_name($0)
        source_entry_line[source_entry_count] = $0
      }
      next
    }
    {
      destination_line[++destination_line_count] = $0
      if (is_section($0)) {
        destination_section = section_name($0)
        destination_section_seen[destination_section] = 1
      } else if (is_key($0)) {
        destination_key[destination_section SUBSEP key_name($0)] = 1
      }
    }
    END {
      for (i = 1; i <= source_entry_count; i++) {
        section = source_entry_section[i]
        key = source_entry_key[i]
        if (section == "" && key == "model_instructions_file") {
          instruction_line = source_entry_line[i]
        }
        if (!destination_key[section SUBSEP key]) {
          missing_line[section SUBSEP ++missing_count[section]] = source_entry_line[i]
          added++
        }
      }

      current_section = ""
      top_emitted = 0
      for (i = 1; i <= destination_line_count; i++) {
        line = destination_line[i]
        if (is_section(line)) {
          if (!top_emitted) {
            emit_missing("", 1)
            top_emitted = 1
          }
          if (current_section != "") {
            emit_missing(current_section, 1)
          }
          print line
          current_section = section_name(line)
        } else {
          if ((current_section == "" || current_section ~ /^profiles[.]/) && instruction_line != "" && line ~ /^[[:space:]]*model_instructions_file[[:space:]]*=[[:space:]]*[\042\047]([^\042\047]*[/\\])?model-instructions[.]md[\042\047][[:space:]]*(#.*)?$/) {
            line = instruction_line
            added++
          }
          print line
        }
      }
      if (!top_emitted) {
        emit_missing("", 0)
      }
      if (current_section != "") {
        emit_missing(current_section, 0)
      }

      for (i = 1; i <= source_section_count; i++) {
        section = source_section_order[i]
        if (destination_section_seen[section] || missing_count[section] == 0) {
          continue
        }
        print ""
        print source_section_header[section]
        emit_missing(section, 0)
      }
      print added + 0 > count_file
    }
  ' "$cm_source" "$cm_destination" >"$cm_output"

  cm_added="$(cat "$cm_count")"
  if [ "$cm_added" -gt 0 ]; then
    cm_relative="${cm_destination#"$cm_destination_root"/}"
    codex_backup_path "$cm_destination_root" "$cm_backup" "$cm_relative"
    cp "$cm_output" "$cm_destination"
  fi
  printf '%s\n' "$cm_added"
}

codex_write_manifest() {
  cwm_source="$1"
  cwm_destination="$2"
  cwm_work="$3"
  cwm_files="$cwm_work/manifest-files"
  cwm_manifest="$cwm_destination/.openai-codex-agent-skills.manifest"

  {
    printf '%s\n' "$cwm_source/base_instructions.md"
    find "$cwm_source/skills" -type f
  } | LC_ALL=C sort >"$cwm_files"

  : >"$cwm_manifest"
  while IFS= read -r cwm_file; do
    cwm_relative="${cwm_file#"$cwm_source"/}"
    cwm_hash="$(codex_sha256_file "$cwm_file")"
    printf '%s\t%s\n' "$cwm_hash" "$cwm_relative" >>"$cwm_manifest"
  done <"$cwm_files"
}

codex_sync_payload() {
  csp_source="$1"
  csp_destination="$2"
  csp_backup="$3"
  csp_remove_legacy="$4"
  csp_work="$5"

  for csp_required in config.toml base_instructions.md skills; do
    [ -e "$csp_source/$csp_required" ] || {
      printf 'Downloaded payload is missing codex/%s.\n' "$csp_required" >&2
      return 1
    }
  done

  mkdir -p "$csp_destination"
  CODEX_SYNC_REMOVED=0
  codex_backup_path "$csp_destination" "$csp_backup" base_instructions.md
  codex_backup_path "$csp_destination" "$csp_backup" model-instructions.md
  codex_backup_path "$csp_destination" "$csp_backup" skills

  for csp_instruction in base_instructions.md model-instructions.md; do
    if [ -e "$csp_destination/$csp_instruction" ]; then
      rm -rf "$csp_destination/$csp_instruction"
      CODEX_SYNC_REMOVED=$((CODEX_SYNC_REMOVED + 1))
    fi
  done

  mkdir -p "$csp_destination/skills"
  csp_retired_count="$(find "$csp_destination/skills" -mindepth 1 ! -path "$csp_destination/skills/.system" ! -path "$csp_destination/skills/.system/*" -type f | wc -l | tr -d ' ')"
  CODEX_SYNC_REMOVED=$((CODEX_SYNC_REMOVED + csp_retired_count))
  find "$csp_destination/skills" -mindepth 1 -maxdepth 1 ! -name .system -exec rm -rf -- {} +

  if [ "$csp_remove_legacy" = 1 ]; then
    for csp_legacy in AGENTS.md AGENTS.override.md agents; do
      if [ -e "$csp_destination/$csp_legacy" ]; then
        codex_backup_path "$csp_destination" "$csp_backup" "$csp_legacy"
        rm -rf "$csp_destination/$csp_legacy"
        CODEX_SYNC_REMOVED=$((CODEX_SYNC_REMOVED + 1))
      fi
    done
  fi

  cp -p "$csp_source/base_instructions.md" "$csp_destination/base_instructions.md"
  cp -Rp "$csp_source/skills/." "$csp_destination/skills/"
  CODEX_SYNC_UPDATED=$((1 + $(find "$csp_source/skills" -type f | wc -l | tr -d ' ')))
  CODEX_CONFIG_ADDED="$(codex_merge_config "$csp_source/config.toml" "$csp_destination/config.toml" "$csp_destination" "$csp_backup" "$csp_work")"
  codex_write_manifest "$csp_source" "$csp_destination" "$csp_work"
}
