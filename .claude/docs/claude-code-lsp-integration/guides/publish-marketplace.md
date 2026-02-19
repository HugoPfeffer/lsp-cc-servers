---
title: "Guide: Publishing to Claude Code Marketplace"
tags: [marketplace]
created: "2026-02-19"
related: ["../patterns/distribution-marketplace.md", "../concepts/plugin-architecture.md"]
domain: "claude-code-lsp-integration"
section: "guides"
---

# Guide: Publishing to Claude Code Marketplace

## Step 1: Create the Marketplace Repository

```bash
mkdir my-lsp-marketplace
cd my-lsp-marketplace
git init
mkdir .claude-plugin
```

## Step 2: Create marketplace.json

Create `.claude-plugin/marketplace.json`:

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

## Step 3: Add Plugin Directories

Copy or move your plugin directories into the marketplace repo:

```
my-lsp-marketplace/
├── .claude-plugin/
│   └── marketplace.json
├── yaml-k8s-lsp/
│   ├── .claude-plugin/
│   │   └── plugin.json
│   ├── .lsp.json
│   ├── hooks/
│   │   └── hooks.json
│   └── scripts/
│       └── check-yaml-language-server.sh
└── marksman-lsp/
    ├── .claude-plugin/
    │   └── plugin.json
    ├── .lsp.json
    ├── hooks/
    │   └── hooks.json
    └── scripts/
        └── check-marksman.sh
```

## Step 4: Push to GitHub

```bash
git add .
git commit -m "Initial marketplace with YAML and Markdown LSP plugins"
git remote add origin https://github.com/your-org/my-lsp-marketplace.git
git push -u origin main
```

## Step 5: Register the Marketplace

Add to `.claude/settings.json` in target projects:

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

## Step 6: Install Plugins

```bash
claude plugin marketplace add your-org/my-lsp-marketplace
claude plugin install yaml-k8s-lsp@my-lsp-marketplace --scope project
claude plugin install marksman-lsp@my-lsp-marketplace --scope project
```

## Updating Plugins

1. Make changes to plugin files
2. Bump `version` in the plugin's `plugin.json`
3. Update the `version` in `marketplace.json` to match
4. Commit and push
5. Users run `claude plugin update` to get new versions

## See Also

- [../patterns/distribution-marketplace.md](../patterns/distribution-marketplace.md) -- Distribution patterns
- [../concepts/plugin-architecture.md](../concepts/plugin-architecture.md) -- Plugin structure
