---
title: "Marksman Integration Pattern"
tags: [marksman, markdown]
created: "2026-02-19"
related: ["../concepts/lsp-json-schema.md", "../examples/marksman-config.md", "../guides/setup-marksman.md", "../troubleshooting/workspace-detection.md"]
domain: "claude-code-lsp-integration"
section: "patterns"
---

# Marksman Integration Pattern

## Server Details

| Property | Value |
|---|---|
| Repository | https://github.com/artempyanykh/marksman |
| Type | Self-contained binary (F#) |
| Distribution | Binary only (NOT npm) |
| Command | `marksman server` |
| Transport | stdio |
| Latest release | 2026-02-08 |

## Installation

Marksman is a standalone binary, not an npm package:

```bash
# Homebrew (macOS / Linux)
brew install marksman

# GitHub releases (manual download)
# Platforms: linux-x64, linux-arm64, linux-musl-x64, linux-musl-arm64, macos, windows
curl -sL https://github.com/artempyanykh/marksman/releases/latest/download/marksman-linux-x64 -o /usr/local/bin/marksman
chmod +x /usr/local/bin/marksman

# Nix
nix-env -i marksman
```

## .lsp.json Configuration

```json
{
  "markdown": {
    "command": "marksman",
    "args": ["server"],
    "extensionToLanguage": {
      ".md": "markdown"
    }
  }
}
```

No additional settings are required. Marksman discovers its configuration from the workspace.

## Features

| Feature | Supported | Notes |
|---|---|---|
| Link completion (inline) | Yes | `[text](./` triggers completion |
| Link completion (wiki) | Yes | `[[` triggers wiki-link completion |
| Go to definition | Yes | Navigate to linked files/headings |
| Find references | Yes | All links pointing to a file/heading |
| Rename | Yes | Rename headings and update all references |
| Diagnostics | Yes | Broken links, duplicate headings |
| Document symbols | Yes | Heading outline |
| Workspace symbols | Yes | Cross-file heading search |

## Workspace Requirement

Marksman requires one of these at the project root to activate cross-file features:

1. A `.git` directory (most common)
2. An empty `.marksman.toml` file

Without either, Marksman operates in single-file mode and cross-file link completion/diagnostics won't work. See [troubleshooting/workspace-detection.md](../troubleshooting/workspace-detection.md).

## Configuration File (.marksman.toml)

Create an empty file for basic workspace detection, or configure:

```toml
[core]
# Enable/disable wiki links
wiki_links = true
# Markdown extensions to process
text_sync = "full"
```

## Comparison with Alternatives

| Feature | Marksman | remark-language-server | markdown-oxide |
|---|---|---|---|
| Link completion | Yes | No | Yes |
| Go to definition | Yes | No | Yes |
| Find references | Yes | No | Yes |
| Rename | Yes | No | No |
| Diagnostics | Broken links | Lint rules (configurable) | Broken links |
| Formatting | No | Yes (remark) | No |
| Wiki links | Yes | No | Yes (Obsidian-style) |
| Language | F# (binary) | Node.js (npm) | Rust (binary) |

**Recommendation**: Use Marksman for code intelligence (navigation, references). Add remark-language-server alongside if lint/format enforcement is needed.

## See Also

- [../concepts/lsp-json-schema.md](../concepts/lsp-json-schema.md) -- `.lsp.json` field reference
- [../examples/marksman-config.md](../examples/marksman-config.md) -- Ready-to-use config
- [../guides/setup-marksman.md](../guides/setup-marksman.md) -- Step-by-step setup
- [../troubleshooting/workspace-detection.md](../troubleshooting/workspace-detection.md) -- Workspace detection issues
