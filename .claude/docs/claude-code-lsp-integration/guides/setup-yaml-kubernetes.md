---
title: "Setup Guide: yaml-language-server for Kubernetes"
tags: [yaml-language-server, kubernetes, auto-install, crd]
created: "2026-02-19"
related: ["../patterns/yaml-language-server.md", "../examples/yaml-lsp-config.md", "../examples/hooks-install-script.md", "../patterns/auto-install-hooks.md"]
domain: "claude-code-lsp-integration"
section: "guides"
---

# Setup Guide: yaml-language-server for Kubernetes

## Step 1: Create the Plugin Directory

```bash
mkdir -p yaml-k8s-lsp/.claude-plugin
mkdir -p yaml-k8s-lsp/hooks
mkdir -p yaml-k8s-lsp/scripts
```

## Step 2: Create plugin.json

Create `yaml-k8s-lsp/.claude-plugin/plugin.json`:

```json
{
  "name": "yaml-k8s-lsp",
  "version": "1.0.0",
  "description": "Kubernetes YAML language server using Red Hat yaml-language-server",
  "author": { "name": "Your Name" },
  "lspServers": "./.lsp.json",
  "hooks": "./hooks/hooks.json"
}
```

## Step 3: Create .lsp.json

Create `yaml-k8s-lsp/.lsp.json`:

```json
{
  "yaml": {
    "command": "yaml-language-server",
    "args": ["--stdio"],
    "extensionToLanguage": {
      ".yaml": "yaml",
      ".yml": "yaml"
    },
    "settings": {
      "yaml": {
        "validate": true,
        "hover": true,
        "completion": true,
        "schemas": {
          "kubernetes": ["/*.yaml", "/*.yml"]
        },
        "schemaStore": {
          "enable": true
        },
        "kubernetesCRDStore": {
          "enable": true
        },
        "yamlVersion": "1.2",
        "maxItemsComputed": 5000
      }
    },
    "maxRestarts": 3
  }
}
```

## Step 4: Create Auto-Install Hook

Create `yaml-k8s-lsp/hooks/hooks.json`:

```json
{
  "hooks": {
    "SessionStart": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "bash ${CLAUDE_PLUGIN_ROOT}/scripts/check-yaml-language-server.sh",
            "timeout": 30000
          }
        ]
      }
    ]
  }
}
```

Create `yaml-k8s-lsp/scripts/check-yaml-language-server.sh`:

```bash
#!/bin/bash
if command -v yaml-language-server &> /dev/null; then
    exit 0
fi
echo "[yaml-language-server] Not found. Installing..."
npm install -g yaml-language-server
if [ $? -eq 0 ]; then
    echo "[yaml-language-server] Installed successfully"
else
    echo "[yaml-language-server] Install failed. Run: npm install -g yaml-language-server"
fi
exit 0
```

Make it executable:

```bash
chmod +x yaml-k8s-lsp/scripts/check-yaml-language-server.sh
```

## Step 5: Test Locally

```bash
# Install yaml-language-server first
npm install -g yaml-language-server

# Test the plugin
claude --plugin-dir ./yaml-k8s-lsp
```

Create a test YAML file and verify:
- Schema validation works (try invalid Kubernetes fields)
- Completion triggers (type `apiVersion: ` and check suggestions)
- Hover shows documentation (hover over `kind: Pod`)

## Step 6: Verify with Debug Mode

```bash
claude --plugin-dir ./yaml-k8s-lsp --debug
```

Check for:
- `[LSP] yaml server started` in debug output
- No error messages about missing binary or failed initialization

## Final Plugin Structure

```
yaml-k8s-lsp/
├── .claude-plugin/
│   └── plugin.json
├── .lsp.json
├── hooks/
│   └── hooks.json
└── scripts/
    └── check-yaml-language-server.sh
```

## See Also

- [../patterns/yaml-language-server.md](../patterns/yaml-language-server.md) -- Full settings reference
- [../examples/yaml-lsp-config.md](../examples/yaml-lsp-config.md) -- More config variants
- [../troubleshooting/helm-templates.md](../troubleshooting/helm-templates.md) -- Helm template issues
