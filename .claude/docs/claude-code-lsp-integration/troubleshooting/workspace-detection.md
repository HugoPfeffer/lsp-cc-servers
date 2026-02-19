---
title: "Issue: Marksman Workspace Root Detection Failures"
tags: [marksman]
created: "2026-02-19"
related: ["../patterns/marksman-integration.md", "../guides/setup-marksman.md"]
domain: "claude-code-lsp-integration"
section: "troubleshooting"
---

# Issue: Marksman Workspace Root Detection Failures

## Symptom

Marksman starts but cross-file features don't work:
- Link completion only shows links within the current file
- Go-to-definition doesn't navigate to other files
- Find references doesn't find cross-file references
- No diagnostics for broken cross-file links

## Root Cause

Marksman requires a workspace root marker to operate in multi-file mode. Without one, it falls back to single-file mode where each file is processed independently.

## Workspace Root Markers

Marksman looks for these markers (in order):

1. **`.git` directory** -- Most common; present in any Git repository
2. **`.marksman.toml` file** -- Explicit Marksman configuration

## Fix

### Option A: Initialize Git (Most Common)

```bash
git init
```

If the project already has `.git`, verify it's at the root that Marksman is being pointed to.

### Option B: Create Empty Config File

```bash
touch .marksman.toml
```

This is useful for non-Git projects or when you want Marksman to treat a subdirectory as its workspace root.

### Option C: Configure .marksman.toml

For more control:

```toml
[core]
wiki_links = true
text_sync = "full"
```

## Multi-Root Workspace Considerations

If Claude Code opens multiple workspace folders, Marksman operates independently in each folder that has a workspace root marker. Cross-references between different root folders are not supported.

## yaml-language-server Workspace Detection

yaml-language-server uses the `workspaceFolders` from the LSP `initialize` request. Claude Code provides this automatically. No manual configuration needed.

For multi-document YAML files (separated by `---`): all documents in the file are parsed independently, but schema association applies to the entire file.

## See Also

- [../patterns/marksman-integration.md](../patterns/marksman-integration.md) -- Marksman features and config
- [../guides/setup-marksman.md](../guides/setup-marksman.md) -- Setup guide
