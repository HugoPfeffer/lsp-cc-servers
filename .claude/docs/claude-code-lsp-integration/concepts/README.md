---
title: "Concepts - Reading Order and Map"
tags: [lsp, plugin-architecture, mcp]
created: "2026-02-19"
related: ["../overview.md", "./lsp-protocol.md", "./plugin-architecture.md", "./lsp-json-schema.md", "./mcp-lsp-wrapper.md"]
domain: "claude-code-lsp-integration"
section: "concepts"
---

# Concepts

Core concepts and fundamentals for Claude Code LSP integration. Read in this order:

## Reading Order

1. **[lsp-protocol.md](./lsp-protocol.md)** -- LSP protocol fundamentals: JSON-RPC, lifecycle, core capabilities. Foundation for everything else.
2. **[plugin-architecture.md](./plugin-architecture.md)** -- Claude Code plugin system: directory layout, manifest, environment variables, hooks.
3. **[lsp-json-schema.md](./lsp-json-schema.md)** -- The `.lsp.json` file format: complete field-by-field reference. The primary integration surface.
4. **[mcp-lsp-wrapper.md](./mcp-lsp-wrapper.md)** -- Alternative approach: wrapping LSP as MCP tools. Only needed for conversational tool access.

## Concept Map

```
LSP Protocol Fundamentals (lsp-protocol.md)
    │
    ├── JSON-RPC 2.0 message format
    ├── Initialize / Shutdown lifecycle
    ├── Core capabilities (diagnostics, completion, hover)
    └── Push vs pull (diagnostics are server-pushed)
         │
         ▼
Plugin Architecture (plugin-architecture.md)
    │
    ├── Directory layout (.claude-plugin/, hooks/, .lsp.json)
    ├── plugin.json manifest (optional)
    ├── ${CLAUDE_PLUGIN_ROOT} (where it works, where it doesn't)
    └── Testing with --plugin-dir
         │
         ▼
.lsp.json Schema (lsp-json-schema.md)
    │
    ├── Required: command, extensionToLanguage
    ├── Settings propagation (settings → didChangeConfiguration)
    ├── Transport: stdio (default) or socket
    └── Lifecycle: startupTimeout, restartOnCrash, maxRestarts
         │
         ▼
MCP-LSP Wrapper (mcp-lsp-wrapper.md)  [OPTIONAL]
    │
    ├── When native .lsp.json isn't enough
    ├── axivo/mcp-lsp reference implementation
    ├── Push-to-pull diagnostic bridging
    └── MCP tool schema design
```

## See Also

- [../overview.md](../overview.md) -- Start here for a high-level overview
- [../patterns/](../patterns/README.md) -- Applied patterns for specific servers
