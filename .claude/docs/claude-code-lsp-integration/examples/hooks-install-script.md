---
title: "Annotated hooks.json and Shell Install Scripts"
tags: [hooks, auto-install]
created: "2026-02-19"
related: ["../patterns/auto-install-hooks.md", "../concepts/plugin-architecture.md"]
domain: "claude-code-lsp-integration"
section: "examples"
---

# Annotated hooks.json and Shell Install Scripts

## hooks.json

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

**Annotations:**
- `"SessionStart"` -- Fires when Claude Code session begins, before LSP servers start
- `${CLAUDE_PLUGIN_ROOT}` -- Resolves to the plugin's installed directory
- `"timeout": 30000` -- 30 seconds for npm install; 60 seconds for binary download (Homebrew can be slow)
- Both scripts run sequentially within the same hook group

## check-yaml-language-server.sh

```bash
#!/bin/bash
# check-yaml-language-server.sh
# Ensures yaml-language-server is globally installed.
# Called by hooks.json on SessionStart.

# 1. Check if already installed (idempotent)
if command -v yaml-language-server &> /dev/null; then
    exit 0  # Silent success -- don't clutter output
fi

# 2. Attempt npm global install
echo "[yaml-language-server] Not found in PATH. Installing via npm..."
npm install -g yaml-language-server 2>&1

# 3. Verify installation
if command -v yaml-language-server &> /dev/null; then
    echo "[yaml-language-server] Installed successfully ($(yaml-language-server --version))"
else
    echo "[yaml-language-server] Installation failed."
    echo "  Manual install: npm install -g yaml-language-server"
    echo "  Then restart Claude Code."
fi

# Always exit 0 to avoid blocking the session
exit 0
```

## check-marksman.sh

```bash
#!/bin/bash
# check-marksman.sh
# Ensures marksman binary is available in PATH.
# Tries Homebrew first, falls back to GitHub release download.

# 1. Check if already installed
if command -v marksman &> /dev/null; then
    exit 0
fi

# 2. Detect platform
OS=$(uname -s | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m)

case "$ARCH" in
    x86_64)         ARCH="x64" ;;
    aarch64|arm64)  ARCH="arm64" ;;
    *)
        echo "[marksman] Unsupported architecture: $ARCH"
        echo "  Download manually: https://github.com/artempyanykh/marksman/releases"
        exit 0
        ;;
esac

# 3. Try Homebrew (macOS and Linux)
if command -v brew &> /dev/null; then
    echo "[marksman] Installing via Homebrew..."
    brew install marksman 2>&1
    if command -v marksman &> /dev/null; then
        echo "[marksman] Installed successfully"
        exit 0
    fi
fi

# 4. Fall back to GitHub release download
echo "[marksman] Downloading latest release from GitHub..."

LATEST=$(curl -sL https://api.github.com/repos/artempyanykh/marksman/releases/latest \
    | grep '"tag_name"' | cut -d'"' -f4)

if [ -z "$LATEST" ]; then
    echo "[marksman] Could not determine latest version."
    echo "  Install manually: brew install marksman"
    exit 0
fi

case "$OS" in
    linux)  BINARY="marksman-linux-${ARCH}" ;;
    darwin) BINARY="marksman-macos" ;;
    *)
        echo "[marksman] Unsupported OS: $OS"
        exit 0
        ;;
esac

DOWNLOAD_URL="https://github.com/artempyanykh/marksman/releases/download/${LATEST}/${BINARY}"
INSTALL_PATH="/usr/local/bin/marksman"

curl -sL "$DOWNLOAD_URL" -o "$INSTALL_PATH" 2>&1
chmod +x "$INSTALL_PATH"

if command -v marksman &> /dev/null; then
    echo "[marksman] Installed ${LATEST} to ${INSTALL_PATH}"
else
    echo "[marksman] Download may have failed."
    echo "  Try: curl -L ${DOWNLOAD_URL} -o /usr/local/bin/marksman && chmod +x /usr/local/bin/marksman"
fi

exit 0
```

## See Also

- [../patterns/auto-install-hooks.md](../patterns/auto-install-hooks.md) -- Design patterns
- [../concepts/plugin-architecture.md](../concepts/plugin-architecture.md) -- Plugin structure
