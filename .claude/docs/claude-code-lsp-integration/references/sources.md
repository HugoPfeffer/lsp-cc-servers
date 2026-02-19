---
title: "References - Curated Source List"
tags: [marketplace, version-compatibility]
created: "2026-02-19"
related: ["../METADATA.md", "../overview.md"]
domain: "claude-code-lsp-integration"
section: "references"
---

# References - Curated Source List

## Official Documentation

| Source | URL | Reliability | Notes |
|---|---|---|---|
| Claude Code Plugins | https://docs.anthropic.com/en/docs/claude-code/plugins | High | Plugin system overview |
| Claude Code Plugins Reference | https://code.claude.com/docs/en/plugins-reference | High | .lsp.json schema, hooks, manifest |
| Claude Code MCP | https://docs.anthropic.com/en/docs/claude-code/mcp | High | MCP server configuration |
| Claude Code Marketplaces | https://code.claude.com/docs/en/plugin-marketplaces | High | Marketplace format and distribution |
| LSP Specification 3.17 | https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/ | High | Protocol reference |
| MCP Specification | https://modelcontextprotocol.io/ | High | MCP protocol and SDK docs |

## Language Servers

| Source | URL | Reliability | Notes |
|---|---|---|---|
| yaml-language-server | https://github.com/redhat-developer/yaml-language-server | High | Red Hat YAML LSP (MANDATORY) |
| yaml-language-server npm | https://www.npmjs.com/package/yaml-language-server | High | v1.20.0 current |
| Marksman | https://github.com/artempyanykh/marksman | High | Markdown LSP binary |
| helm-ls | https://github.com/mrjosh/helm-ls | Medium | Helm template language server |
| remark-language-server | https://github.com/remarkjs/remark-language-server | Medium | Alternative Markdown LSP (lint/format) |

## Reference Implementations

| Source | URL | Reliability | Notes |
|---|---|---|---|
| axivo/mcp-lsp | https://github.com/axivo/mcp-lsp | Medium | MCP-LSP wrapper reference implementation |
| MCP TypeScript SDK | https://github.com/modelcontextprotocol/typescript-sdk | High | @modelcontextprotocol/sdk |

## Existing Marketplace Plugins

| Source | URL | Reliability | Notes |
|---|---|---|---|
| boostvolt/claude-code-lsps | https://github.com/boostvolt/claude-code-lsps | Medium | Community LSP marketplace; yaml-language-server plugin (no Kubernetes settings) |
| Ven0m0/claude-config | https://github.com/Ven0m0/claude-config | Medium | 28 language servers in one .lsp.json |
| anthropics/claude-plugins-official | Marketplace | High | Official Anthropic LSP plugins (pyright, typescript, jdtls) |

## Schema Sources

| Source | URL | Reliability | Notes |
|---|---|---|---|
| Schema Store | https://www.schemastore.org/json/ | High | Community JSON schema catalog |
| datreeio CRDs-catalog | https://github.com/datreeio/CRDs-catalog | Medium | Kubernetes CRD schemas |
| Kubernetes JSON Schema | https://github.com/yannh/kubernetes-json-schema | Medium | Versioned K8s schemas for offline use |

## See Also

- [../METADATA.md](../METADATA.md) -- Research metadata and coverage summary
- [../overview.md](../overview.md) -- Executive summary
