---
title: "Distribution and Marketplace Pattern"
tags: [marketplace, plugin-architecture]
created: "2026-02-19"
related: ["../concepts/plugin-architecture.md", "../guides/publish-marketplace.md", "../references/sources.md"]
domain: "claude-code-lsp-integration"
section: "patterns"
---

# Distribution and Marketplace Pattern

## Marketplace Repository Structure

A marketplace is a GitHub repository containing multiple plugins:

```
my-lsp-marketplace/
├── .claude-plugin/
│   └── marketplace.json         # Marketplace manifest
├── yaml-k8s-lsp/               # Plugin 1
│   ├── .claude-plugin/
│   │   └── plugin.json
│   ├── .lsp.json
│   ├── hooks/
│   │   └── hooks.json
│   └── scripts/
│       └── check-yaml-language-server.sh
└── marksman-lsp/               # Plugin 2
    ├── .claude-plugin/
    │   └── plugin.json
    ├── .lsp.json
    ├── hooks/
    │   └── hooks.json
    └── scripts/
        └── check-marksman.sh
```

## marketplace.json

```json
{
  "name": "my-lsp-marketplace",
  "owner": { "name": "Your Name" },
  "plugins": [
    {
      "name": "yaml-k8s-lsp",
      "source": "./yaml-k8s-lsp",
      "description": "Kubernetes-focused YAML language server (Red Hat)",
      "version": "1.0.0"
    },
    {
      "name": "marksman-lsp",
      "source": "./marksman-lsp",
      "description": "Markdown language server (Marksman)",
      "version": "1.0.0"
    }
  ]
}
```

## strict: true vs strict: false

| Mode | Behavior |
|---|---|
| `strict: true` (default) | Plugin directory must contain its own `plugin.json`, `.lsp.json`, etc. Marketplace entry only points to the source directory. |
| `strict: false` | Component definitions (lspServers, hooks) can be defined inline in the marketplace entry. Plugin directory only needs to exist. |

Anthropic's official plugins use `strict: false` with inline `lspServers`. For custom plugins, `strict: true` with standalone files is more maintainable.

## Adding a Marketplace to Claude Code

In `.claude/settings.json` or user settings:

```json
{
  "extraKnownMarketplaces": {
    "my-lsp-marketplace": {
      "source": {
        "source": "github",
        "repo": "your-org/my-lsp-marketplace"
      }
    }
  }
}
```

## Installing Plugins

```bash
# Add marketplace
claude plugin marketplace add your-org/my-lsp-marketplace

# Install specific plugin
claude plugin install yaml-k8s-lsp@my-lsp-marketplace --scope project

# Scopes:
#   --scope local    (default, current project only)
#   --scope project  (shared via .claude/settings.json)
#   --scope user     (available across all projects)
```

## Existing Marketplace Examples

| Marketplace | Plugins | Notes |
|---|---|---|
| `boostvolt/claude-code-lsps` | yaml-language-server, marksman, others | Community marketplace; yaml plugin lacks Kubernetes settings |
| `anthropics/claude-plugins-official` | pyright-lsp, typescript-lsp, jdtls-lsp | Official Anthropic LSP plugins |
| `Ven0m0/claude-config` | 28 language servers | Not a marketplace, but a comprehensive multi-LSP `.lsp.json` example |

## Version Management

- Bump `version` in `plugin.json` for every change
- Installed plugins are cached at `~/.claude/plugins/cache/`
- Users won't see updates without a version bump
- The marketplace `plugins[].version` field should match the plugin's own `plugin.json` version

## See Also

- [../concepts/plugin-architecture.md](../concepts/plugin-architecture.md) -- Plugin structure details
- [../guides/publish-marketplace.md](../guides/publish-marketplace.md) -- Step-by-step publishing guide
- [../references/sources.md](../references/sources.md) -- Links to existing marketplaces
