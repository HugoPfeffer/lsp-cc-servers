#!/usr/bin/env bash
# scaffold-docs.sh — Deterministic skeleton creator for research documentation
#
# Usage:
#   scaffold-docs.sh <domain-name> <concepts> <patterns> <examples> <guides> <troubleshooting>
#
# Each section argument is a comma-separated list of file basenames (without .md).
# Use "" for empty sections.
#
# Example:
#   scaffold-docs.sh react-hooks "use-state,use-effect,use-ref" "custom-hooks,composition" "counter,todo-app" "" "stale-closures"

set -euo pipefail

DOMAIN="${1:?Usage: scaffold-docs.sh <domain-name> <concepts> <patterns> <examples> <guides> <troubleshooting>}"
CONCEPTS="${2:-}"
PATTERNS="${3:-}"
EXAMPLES="${4:-}"
GUIDES="${5:-}"
TROUBLESHOOTING="${6:-}"

TODAY=$(date +%Y-%m-%d)
BASE=".claude/docs/${DOMAIN}"

# Subdirectories to create
SECTIONS=("concepts" "patterns" "examples" "guides" "troubleshooting" "references")

# Create directory tree
mkdir -p "${BASE}"
for section in "${SECTIONS[@]}"; do
  mkdir -p "${BASE}/${section}"
done

file_count=0

# Helper: write a skeleton markdown file if it doesn't already exist
write_skeleton() {
  local filepath="$1"
  local title="$2"
  local section="$3"

  if [[ -f "${filepath}" ]]; then
    return
  fi

  cat > "${filepath}" << SKEL
---
title: "${title}"
tags: []
created: "${TODAY}"
domain: "${DOMAIN}"
section: "${section}"
---

# ${title}

<!-- Content will be populated by research agents -->
SKEL
  file_count=$((file_count + 1))
}

# Write root-level skeleton files
write_skeleton "${BASE}/overview.md" "Overview" "root"
write_skeleton "${BASE}/glossary.md" "Glossary" "root"

# Write INDEX.md skeleton
if [[ ! -f "${BASE}/INDEX.md" ]]; then
  cat > "${BASE}/INDEX.md" << IDX
---
title: "Index — ${DOMAIN}"
tags: [index, navigation]
created: "${TODAY}"
domain: "${DOMAIN}"
section: "root"
---

# ${DOMAIN} Documentation Index

## Quick Navigation

| Section | Description |
|---------|-------------|
| [Overview](./overview.md) | Executive summary and quick-start guide |
| [Glossary](./glossary.md) | Key terms and definitions |
| [Concepts](./concepts/) | Core concepts and fundamentals |
| [Patterns](./patterns/) | Patterns, best practices, architectures |
| [Examples](./examples/) | Code examples and implementations |
| [Guides](./guides/) | How-to guides and tutorials |
| [Troubleshooting](./troubleshooting/) | Common issues, pitfalls, solutions |
| [References](./references/) | External sources and further reading |

## Tag Index

<!-- Populated by research agents -->

## Topic Map

<!-- Populated by research agents -->

## Reading Order

<!-- Populated by research agents -->
IDX
  file_count=$((file_count + 1))
fi

# Write METADATA.md skeleton
if [[ ! -f "${BASE}/METADATA.md" ]]; then
  cat > "${BASE}/METADATA.md" << META
---
title: "Metadata — ${DOMAIN}"
tags: [metadata]
created: "${TODAY}"
domain: "${DOMAIN}"
section: "root"
---

# Research Metadata

| Field | Value |
|-------|-------|
| Domain | ${DOMAIN} |
| Created | ${TODAY} |
| Pipeline | research-pipeline v1.0.0 |
| Status | In Progress |

## Coverage Summary

<!-- Populated by research agents -->

## Source References

| Source | Reliability | URL |
|--------|------------|-----|
<!-- Populated by research agents -->

## Revision History

| Date | Agent | Changes |
|------|-------|---------|
| ${TODAY} | scaffold-docs.sh | Initial skeleton created |
META
  file_count=$((file_count + 1))
fi

# Write README.md for each subdirectory
for section in "${SECTIONS[@]}"; do
  readme="${BASE}/${section}/README.md"
  if [[ ! -f "${readme}" ]]; then
    pretty_name="${section^}"
    cat > "${readme}" << README
---
title: "${pretty_name} — ${DOMAIN}"
tags: [${section}, navigation]
created: "${TODAY}"
domain: "${DOMAIN}"
section: "${section}"
---

# ${pretty_name}

<!-- Section overview populated by research agents -->

## Files

<!-- File listing populated by research agents -->
README
    file_count=$((file_count + 1))
  fi
done

# Write references/sources.md
write_skeleton "${BASE}/references/sources.md" "Sources" "references"

# Write section-specific files from comma-separated lists
write_section_files() {
  local section="$1"
  local file_list="$2"

  if [[ -z "${file_list}" ]]; then
    return
  fi

  IFS=',' read -ra files <<< "${file_list}"
  for name in "${files[@]}"; do
    name="$(echo "${name}" | xargs)"  # trim whitespace
    if [[ -n "${name}" ]]; then
      local title
      local words="${name//-/ }"
      title="${words^}"
      write_skeleton "${BASE}/${section}/${name}.md" "${title}" "${section}"
    fi
  done
}

write_section_files "concepts" "${CONCEPTS}"
write_section_files "patterns" "${PATTERNS}"
write_section_files "examples" "${EXAMPLES}"
write_section_files "guides" "${GUIDES}"
write_section_files "troubleshooting" "${TROUBLESHOOTING}"

# Output summary
echo "=== Scaffold Complete ==="
echo "Domain: ${DOMAIN}"
echo "Base:   ${BASE}"
echo "Files created: ${file_count}"
echo ""
echo "Directory tree:"
if command -v tree &>/dev/null; then
  tree "${BASE}"
else
  find "${BASE}" -type f | sort
fi
