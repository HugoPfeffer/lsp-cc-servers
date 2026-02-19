#!/bin/bash
# Auto-install marksman if not found in PATH
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

# Try Homebrew first (macOS / Linux)
if command -v brew &> /dev/null; then
    echo "[marksman] Installing via Homebrew..."
    brew install marksman
    exit $?
fi

# Fall back to GitHub release download
LATEST=$(curl -sL https://api.github.com/repos/artempyanykh/marksman/releases/latest | grep tag_name | cut -d'"' -f4)
if [ -z "$LATEST" ]; then
    echo "[marksman] Could not determine latest version. Install manually: https://github.com/artempyanykh/marksman/releases"
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

if command -v marksman &> /dev/null; then
    echo "[marksman] Installed successfully"
else
    echo "[marksman] Install failed. Download manually: https://github.com/artempyanykh/marksman/releases"
fi
exit 0
