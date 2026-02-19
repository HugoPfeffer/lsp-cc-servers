---
title: "Auto-Installation Hooks Pattern"
tags: [hooks, auto-install, plugin-architecture]
created: "2026-02-19"
related: ["../concepts/plugin-architecture.md", "../examples/hooks-install-script.md", "../guides/setup-yaml-kubernetes.md"]
domain: "claude-code-lsp-integration"
section: "patterns"
---

# Auto-Installation Hooks Pattern

## Why Auto-Install?

LSP binaries must be in `$PATH` for `.lsp.json` to work. Since `${CLAUDE_PLUGIN_ROOT}` is not available in `.lsp.json` command fields, the binary must be globally installed. A `SessionStart` hook ensures the binary is present before the LSP server tries to start.

## hooks.json Structure

Place at `hooks/hooks.json` in your plugin root:

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
          },
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

Note: `${CLAUDE_PLUGIN_ROOT}` IS available in hook commands (unlike `.lsp.json`).

## Design Principles

1. **Idempotent**: Check if binary exists before installing. Exit 0 if already present.
2. **Non-blocking**: Use reasonable timeouts. Don't hang the session on network failure.
3. **Graceful failure**: Print install instructions on failure rather than crashing.
4. **Cross-platform**: Handle Linux and macOS. Detect architecture (x64, arm64).
5. **Silent success**: Only print output on install or failure, not on "already installed".

## npm-based Install (yaml-language-server)

Simple pattern for npm packages:

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
```

## Binary Download (Marksman)

More complex for standalone binaries:

```bash
#!/bin/bash
if command -v marksman &> /dev/null; then
    exit 0
fi

OS=$(uname -s | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m)

case "$ARCH" in
    x86_64) ARCH="x64" ;;
    aarch64|arm64) ARCH="arm64" ;;
    *) echo "[marksman] Unsupported architecture: $ARCH"; exit 0 ;;
esac

# Try Homebrew first
if command -v brew &> /dev/null; then
    echo "[marksman] Installing via Homebrew..."
    brew install marksman
    exit $?
fi

# Fall back to GitHub release download
LATEST=$(curl -sL https://api.github.com/repos/artempyanykh/marksman/releases/latest | grep tag_name | cut -d'"' -f4)
if [ -z "$LATEST" ]; then
    echo "[marksman] Could not determine latest version. Install manually."
    exit 0
fi

case "$OS" in
    linux) BINARY="marksman-linux-${ARCH}" ;;
    darwin) BINARY="marksman-macos" ;;
    *) echo "[marksman] Unsupported OS: $OS"; exit 0 ;;
esac

echo "[marksman] Downloading ${LATEST}..."
curl -sL "https://github.com/artempyanykh/marksman/releases/download/${LATEST}/${BINARY}" -o /usr/local/bin/marksman
chmod +x /usr/local/bin/marksman
echo "[marksman] Installed successfully"
```

## Timeout Considerations

| Server | Install Method | Recommended Timeout |
|---|---|---|
| yaml-language-server | `npm install -g` | 30000 ms |
| Marksman | Binary download or brew | 60000 ms |

Homebrew can be slow due to formula updates. Set a generous timeout for binary distribution.

## See Also

- [../concepts/plugin-architecture.md](../concepts/plugin-architecture.md) -- Plugin structure and lifecycle
- [../examples/hooks-install-script.md](../examples/hooks-install-script.md) -- Full annotated scripts
- [../guides/setup-yaml-kubernetes.md](../guides/setup-yaml-kubernetes.md) -- Complete YAML setup including hooks
