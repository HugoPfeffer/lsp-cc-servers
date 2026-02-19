#!/bin/bash
# Auto-install yaml-language-server (Red Hat) if not found in PATH
if command -v yaml-language-server &> /dev/null; then
    exit 0
fi

echo "[yaml-language-server] Not found. Installing..."

if command -v npm &> /dev/null; then
    npm install -g yaml-language-server
elif command -v bun &> /dev/null; then
    bun install -g yaml-language-server
else
    echo "[yaml-language-server] Neither npm nor bun found. Install Node.js first, then run: npm install -g yaml-language-server"
    exit 0
fi

if [ $? -eq 0 ]; then
    echo "[yaml-language-server] Installed successfully"
else
    echo "[yaml-language-server] Install failed. Run manually: npm install -g yaml-language-server"
fi
exit 0
