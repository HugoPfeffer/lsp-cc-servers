---
title: "Overview - Claude Code LSP Integration"
tags: [lsp, plugin-architecture, yaml-language-server, marksman, overview]
created: "2026-02-19"
related: ["./glossary.md", "./concepts/plugin-architecture.md", "./concepts/lsp-json-schema.md"]
domain: "claude-code-lsp-integration"
section: "root"
---

# Overview - Claude Code LSP Integration

## Executive Summary

Claude Code supports **native Language Server Protocol (LSP) integration** through `.lsp.json` configuration files in plugins. This means you can add intelligent code assistance (diagnostics, completions, hover, go-to-definition) for any language by simply declaring an LSP server in a plugin -- no MCP wrapping required.

This research covers building two Claude Code plugins:

1. **Kubernetes YAML** -- Using Red Hat's `yaml-language-server` (mandatory) for schema validation, completion, and hover on Kubernetes manifests
2. **Markdown** -- Using `marksman` for link completion, cross-references, and diagnostics in Markdown files

## Architecture at a Glance

```
Claude Code Plugin (.lsp.json)
│
├── yaml-language-server --stdio    (npm package, Red Hat)
│   ├── Kubernetes schema validation
│   ├── CRD support via datreeio catalog
│   ├── Completion for K8s resources
│   └── Hover documentation
│
└── marksman server                 (standalone binary)
    ├── Link completion (inline, wiki-style)
    ├── Go-to-definition
    ├── Find references
    └── Broken link diagnostics
```

## Two Integration Approaches

| Approach | When to Use | Complexity |
|---|---|---|
| **Native `.lsp.json`** (recommended) | Standard LSP features (diagnostics, completion, hover) | Minimal -- one JSON file |
| **MCP wrapper** | Need conversational tool access ("validate this YAML") | Significant -- full Node.js project |

For standard use cases, the native `.lsp.json` approach is clearly superior. See [concepts/mcp-lsp-wrapper.md](./concepts/mcp-lsp-wrapper.md) for the alternative.

## Quick Start

### 1. Install the LSP servers

```bash
# yaml-language-server (npm)
npm install -g yaml-language-server

# Marksman (binary)
brew install marksman
# or download from https://github.com/artempyanykh/marksman/releases
```

### 2. Create the plugin

```
my-lsp-plugin/
├── .claude-plugin/
│   └── plugin.json
├── .lsp.json
├── hooks/
│   └── hooks.json
└── scripts/
    ├── check-yaml-language-server.sh
    └── check-marksman.sh
```

### 3. Configure `.lsp.json`

```json
{
  "yaml": {
    "command": "yaml-language-server",
    "args": ["--stdio"],
    "extensionToLanguage": { ".yaml": "yaml", ".yml": "yaml" },
    "settings": {
      "yaml": {
        "schemas": { "kubernetes": ["/*.yaml", "/*.yml"] },
        "schemaStore": { "enable": true },
        "kubernetesCRDStore": { "enable": true }
      }
    }
  },
  "markdown": {
    "command": "marksman",
    "args": ["server"],
    "extensionToLanguage": { ".md": "markdown" }
  }
}
```

### 4. Test locally

```bash
claude --plugin-dir ./my-lsp-plugin
```

## Key Findings

- **Claude Code 2.0.74+** required for LSP support; **2.1.0+** recommended
- **Native binary installs** of Claude Code do not support LSP (must use npm/bun)
- **`${CLAUDE_PLUGIN_ROOT}`** is available in hooks and MCP configs but NOT in `.lsp.json` command fields -- binaries must be in `$PATH`
- **`"kubernetes"` is a special keyword** in yaml-language-server schema config (not a URL)
- **Marksman requires `.git` or `.marksman.toml`** at project root for cross-file features
- **Helm templates** produce false positives in yaml-language-server (Go template syntax is invalid YAML)

## See Also

- [concepts/lsp-json-schema.md](./concepts/lsp-json-schema.md) -- Complete `.lsp.json` field reference
- [guides/setup-yaml-kubernetes.md](./guides/setup-yaml-kubernetes.md) -- End-to-end YAML setup
- [guides/setup-marksman.md](./guides/setup-marksman.md) -- End-to-end Marksman setup
- [glossary.md](./glossary.md) -- Key terms and definitions
