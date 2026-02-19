---
title: "Setup Guide: Marksman for Markdown"
tags: [marksman, markdown, auto-install]
created: "2026-02-19"
related: ["../patterns/marksman-integration.md", "../examples/marksman-config.md", "../examples/hooks-install-script.md"]
domain: "claude-code-lsp-integration"
section: "guides"
---

# Setup Guide: Marksman for Markdown

## Step 1: Create the Plugin Directory

```bash
mkdir -p marksman-lsp/.claude-plugin
mkdir -p marksman-lsp/hooks
mkdir -p marksman-lsp/scripts
```

## Step 2: Create plugin.json

Create `marksman-lsp/.claude-plugin/plugin.json`:

```json
{
  "name": "marksman-lsp",
  "version": "1.0.0",
  "description": "Markdown language server using Marksman",
  "author": { "name": "Your Name" },
  "lspServers": "./.lsp.json",
  "hooks": "./hooks/hooks.json"
}
```

## Step 3: Create .lsp.json

Create `marksman-lsp/.lsp.json`:

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

## Step 4: Create Auto-Install Hook

Create `marksman-lsp/hooks/hooks.json`:

```json
{
  "hooks": {
    "SessionStart": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "bash ${CLAUDE_PLUGIN_ROOT}/scripts/check-marksman.sh",
            "timeout": 60000
          }
        ]
      }
    ]
  }
}
```

Create `marksman-lsp/scripts/check-marksman.sh` (see [examples/hooks-install-script.md](../examples/hooks-install-script.md) for the full annotated script).

Abbreviated version:

```bash
#!/bin/bash
if command -v marksman &> /dev/null; then exit 0; fi

if command -v brew &> /dev/null; then
    brew install marksman && exit 0
fi

OS=$(uname -s | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m)
case "$ARCH" in x86_64) ARCH="x64" ;; aarch64|arm64) ARCH="arm64" ;; esac

LATEST=$(curl -sL https://api.github.com/repos/artempyanykh/marksman/releases/latest | grep tag_name | cut -d'"' -f4)
case "$OS" in linux) BIN="marksman-linux-${ARCH}" ;; darwin) BIN="marksman-macos" ;; esac

curl -sL "https://github.com/artempyanykh/marksman/releases/download/${LATEST}/${BIN}" -o /usr/local/bin/marksman
chmod +x /usr/local/bin/marksman
exit 0
```

Make it executable:

```bash
chmod +x marksman-lsp/scripts/check-marksman.sh
```

## Step 5: Ensure Workspace Detection

Marksman needs one of these at the project root for cross-file features:

```bash
# Option A: Already have git (most common)
git init

# Option B: Empty config file
touch .marksman.toml
```

## Step 6: Test Locally

```bash
# Install marksman first
brew install marksman  # or download binary

# Test the plugin
claude --plugin-dir ./marksman-lsp
```

Verify:
- Link completion works (type `[text](./` in a Markdown file)
- Go-to-definition works on links
- Broken link diagnostics appear

## Final Plugin Structure

```
marksman-lsp/
├── .claude-plugin/
│   └── plugin.json
├── .lsp.json
├── hooks/
│   └── hooks.json
└── scripts/
    └── check-marksman.sh
```

## See Also

- [../patterns/marksman-integration.md](../patterns/marksman-integration.md) -- Feature details
- [../examples/marksman-config.md](../examples/marksman-config.md) -- Config variants
- [../troubleshooting/workspace-detection.md](../troubleshooting/workspace-detection.md) -- Workspace issues
