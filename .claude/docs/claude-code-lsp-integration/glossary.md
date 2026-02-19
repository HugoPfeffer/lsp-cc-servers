---
title: "Glossary"
tags: [lsp, mcp, schema, glossary, lsp-json, markdown, CLAUDE_PLUGIN_ROOT]
created: "2026-02-19"
related: ["./overview.md", "./concepts/lsp-protocol.md", "./concepts/plugin-architecture.md"]
domain: "claude-code-lsp-integration"
section: "root"
---

# Glossary

## LSP (Language Server Protocol)

An open protocol standardized by Microsoft for communication between code editors and language servers. Uses JSON-RPC 2.0 over stdio or sockets. Provides features like diagnostics, completion, hover, go-to-definition, and find-references. Current version: 3.17.

## MCP (Model Context Protocol)

Anthropic's protocol for extending AI assistants with external tools, resources, and prompts. Also uses JSON-RPC 2.0. MCP servers expose capabilities that Claude can invoke during conversations. Distinct from LSP but can wrap LSP servers.

## .lsp.json

The configuration file that declares LSP server integrations in a Claude Code plugin. Placed at the plugin root directory. Contains server-id-keyed entries with `command`, `extensionToLanguage`, `settings`, and other fields. See [concepts/lsp-json-schema.md](./concepts/lsp-json-schema.md).

## yaml-language-server

Red Hat's open-source YAML language server. NPM package: `yaml-language-server` (v1.20.0). Provides schema-based validation, completion, and hover for YAML files. Supports Kubernetes schemas via the special `"kubernetes"` keyword. Repository: [redhat-developer/yaml-language-server](https://github.com/redhat-developer/yaml-language-server).

## Marksman

An open-source Markdown language server written in F#. Distributed as a standalone binary (not npm). Provides link completion, go-to-definition, find-references, rename, and broken-link diagnostics. Supports wiki-style `[[links]]`. Repository: [artempyanykh/marksman](https://github.com/artempyanykh/marksman).

## Schema Store

A community-maintained catalog of JSON schemas at [schemastore.org](https://www.schemastore.org/json/). yaml-language-server can automatically pull schemas from this store when `yaml.schemaStore.enable` is true.

## CRD (Custom Resource Definition)

A Kubernetes extension mechanism that defines custom resource types. yaml-language-server supports CRD schema validation through the datreeio CRDs-catalog or manual schema URL configuration.

## Modeline

A comment directive at the top of a YAML file that specifies which schema to use: `# yaml-language-server: $schema=<url>`. Has the highest priority in yaml-language-server's schema resolution chain.

## ${CLAUDE_PLUGIN_ROOT}

An environment variable set by Claude Code that resolves to the absolute path of the installed plugin directory. Available in hook commands and MCP server configurations. **Not available** in `.lsp.json` `command` fields.

## Plugin Manifest (plugin.json)

An optional JSON file at `.claude-plugin/plugin.json` that declares plugin metadata (name, version, description, author) and references to component files (lspServers, hooks, mcpServers).

## Marketplace

A Claude Code distribution mechanism for sharing plugins. Defined by a `marketplace.json` file in a GitHub repository. Plugins are installed via `claude plugin install <name>@<marketplace>`.

## SessionStart Hook

A hook event triggered when a Claude Code session begins. Used for auto-installing LSP server binaries. Defined in `hooks/hooks.json` with `"SessionStart"` as the event key.

## vscode-jsonrpc

A Node.js library that implements the JSON-RPC 2.0 protocol with the LSP framing format (`Content-Length` headers). Used by yaml-language-server internally and by MCP-LSP wrapper implementations.

## initializationOptions

A field in `.lsp.json` that passes data to the LSP server during the `initialize` handshake. Distinct from `settings`, which is sent via `workspace/didChangeConfiguration` after initialization.

## See Also

- [overview.md](./overview.md) -- Executive summary
- [concepts/lsp-protocol.md](./concepts/lsp-protocol.md) -- LSP protocol fundamentals
- [concepts/plugin-architecture.md](./concepts/plugin-architecture.md) -- Plugin system details
