---
title: "Guides - Overview and Prerequisites"
tags: [guides]
created: "2026-02-19"
related: ["../patterns/README.md", "../examples/README.md"]
domain: "claude-code-lsp-integration"
section: "guides"
---

# Guides

Step-by-step how-to guides for building and deploying LSP plugins.

## Prerequisites

- **Node.js >= 18** (for npm and yaml-language-server)
- **Claude Code >= 2.1.0** installed via npm or bun (NOT native binary)
- **Basic shell scripting** knowledge (for hook scripts)
- **Git** (for plugin distribution and Marksman workspace detection)

## Guide Index

| Guide | Time | Description |
|---|---|---|
| [setup-yaml-kubernetes.md](./setup-yaml-kubernetes.md) | 15 min | Build a yaml-language-server plugin with Kubernetes support |
| [setup-marksman.md](./setup-marksman.md) | 10 min | Build a Marksman plugin for Markdown |
| [publish-marketplace.md](./publish-marketplace.md) | 20 min | Publish plugins to a Claude Code marketplace |
| [airgapped-install.md](./airgapped-install.md) | 15 min | Set up LSP plugins in offline/restricted environments |

## Suggested Order

1. Start with [setup-yaml-kubernetes.md](./setup-yaml-kubernetes.md) to build the primary plugin
2. Add Markdown support with [setup-marksman.md](./setup-marksman.md)
3. Combine into a marketplace with [publish-marketplace.md](./publish-marketplace.md)
4. Review [airgapped-install.md](./airgapped-install.md) if deploying in restricted environments

## See Also

- [../patterns/README.md](../patterns/README.md) -- Design patterns behind these guides
- [../examples/README.md](../examples/README.md) -- Ready-to-copy code examples
