#!/usr/bin/env bash
# validate-frontmatter.sh — PostToolUse hook for Write/Edit tool calls
#
# Reads tool input JSON from stdin, extracts the file path.
# Only validates .md files under .claude/docs/.
# Checks for valid YAML frontmatter with required fields.
#
# Exit codes:
#   0 = valid (or not applicable)
#   2 = invalid frontmatter (blocks the write)

set -euo pipefail

# Read tool input from stdin
INPUT=$(cat)

# Extract file path from the JSON input
# Handles both Write (file_path) and Edit (file_path) tool schemas
FILE_PATH=$(echo "${INPUT}" | grep -oP '"file_path"\s*:\s*"([^"]*)"' | head -1 | sed 's/.*"\([^"]*\)"$/\1/')

# If we couldn't extract a file path, pass through
if [[ -z "${FILE_PATH}" ]]; then
  exit 0
fi

# Only validate .md files under .claude/docs/
if [[ "${FILE_PATH}" != *".claude/docs/"* ]] || [[ "${FILE_PATH}" != *.md ]]; then
  exit 0
fi

# Check if the file exists (it should after Write/Edit)
if [[ ! -f "${FILE_PATH}" ]]; then
  exit 0
fi

# Read the file content
CONTENT=$(cat "${FILE_PATH}")

# Check for opening --- delimiter (must be first line)
FIRST_LINE=$(echo "${CONTENT}" | head -1)
if [[ "${FIRST_LINE}" != "---" ]]; then
  echo "[validate-frontmatter] BLOCKED: ${FILE_PATH} — missing opening '---' delimiter"
  exit 2
fi

# Find closing --- delimiter (second occurrence)
CLOSING_LINE=$(echo "${CONTENT}" | tail -n +2 | grep -n "^---$" | head -1 | cut -d: -f1)
if [[ -z "${CLOSING_LINE}" ]]; then
  echo "[validate-frontmatter] BLOCKED: ${FILE_PATH} — missing closing '---' delimiter"
  exit 2
fi

# Extract frontmatter between delimiters
FRONTMATTER=$(echo "${CONTENT}" | head -n "$((CLOSING_LINE + 1))" | tail -n +2)

# Check required fields
REQUIRED_FIELDS=("title" "tags" "created" "domain" "section")
MISSING=()

for field in "${REQUIRED_FIELDS[@]}"; do
  if ! echo "${FRONTMATTER}" | grep -qE "^${field}:"; then
    MISSING+=("${field}")
  fi
done

if [[ ${#MISSING[@]} -gt 0 ]]; then
  echo "[validate-frontmatter] BLOCKED: ${FILE_PATH} — missing required fields: ${MISSING[*]}"
  exit 2
fi

# All checks passed
exit 0
