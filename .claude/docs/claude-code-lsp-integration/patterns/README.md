---
title: "Patterns - Overview and Decision Matrix"
tags: [lsp, yaml-language-server, marksman, mcp]
created: "2026-02-19"
related: ["../concepts/README.md", "./yaml-language-server.md", "./marksman-integration.md", "./auto-install-hooks.md"]
domain: "claude-code-lsp-integration"
section: "patterns"
---

# Patterns

Applied architecture and configuration patterns for Claude Code LSP plugins.

## Decision Matrix

| Decision | Option A | Option B | Recommendation |
|---|---|---|---|
| Integration approach | Native `.lsp.json` | MCP wrapper | `.lsp.json` for standard LSP features |
| YAML server | yaml-language-server (Red Hat) | N/A (mandatory) | yaml-language-server |
| Markdown server | Marksman | remark-language-server | Marksman (navigation > linting) |
| Kubernetes schemas | `"kubernetes"` keyword | Explicit schema URLs | `"kubernetes"` keyword for core resources |
| CRD validation | kubernetesCRDStore auto-download | Manual schema URLs | Auto-download for general use |
| Binary install | SessionStart hook | Manual prerequisite | SessionStart hook |
| Helm templates | Exclude from schema matching | Use helm-ls proxy | Exclude for simplicity |
| Distribution | Marketplace repo | Direct plugin-dir | Marketplace for multi-project use |

## Patterns in This Section

1. **[yaml-language-server.md](./yaml-language-server.md)** -- Full configuration reference for Red Hat yaml-language-server with Kubernetes mode
2. **[marksman-integration.md](./marksman-integration.md)** -- Marksman configuration and workspace requirements
3. **[auto-install-hooks.md](./auto-install-hooks.md)** -- Hook patterns for automatic binary installation
4. **[distribution-marketplace.md](./distribution-marketplace.md)** -- Publishing plugins via Claude Code marketplace
5. **[security.md](./security.md)** -- Network access controls and airgapped operation

## See Also

- [../concepts/README.md](../concepts/README.md) -- Foundation concepts
- [../examples/README.md](../examples/README.md) -- Ready-to-use code examples
