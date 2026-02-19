---
title: "Guide: Airgapped / Offline Installation"
tags: [airgapped, security]
created: "2026-02-19"
related: ["../patterns/security.md", "../patterns/yaml-language-server.md", "../examples/yaml-lsp-config.md"]
domain: "claude-code-lsp-integration"
section: "guides"
---

# Guide: Airgapped / Offline Installation

## Overview

In airgapped (no internet) or restricted environments, you need to:

1. Pre-install LSP binaries
2. Pre-download JSON schemas
3. Disable network-dependent features in yaml-language-server

## Step 1: Pre-Install Binaries

### yaml-language-server

```bash
# On a machine with internet access:
npm pack yaml-language-server
# Produces yaml-language-server-1.20.0.tgz

# Transfer the tarball to the airgapped machine, then:
npm install -g yaml-language-server-1.20.0.tgz
```

### Marksman

```bash
# On a machine with internet access, download the binary:
curl -L https://github.com/artempyanykh/marksman/releases/latest/download/marksman-linux-x64 -o marksman

# Transfer to airgapped machine and install:
cp marksman /usr/local/bin/marksman
chmod +x /usr/local/bin/marksman
```

## Step 2: Pre-Download Kubernetes Schemas

```bash
# On a machine with internet access:
# Download Kubernetes JSON schemas
git clone https://github.com/yannh/kubernetes-json-schema.git
# Or specific version:
curl -L https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.29.0-standalone-strict/all.json -o kubernetes-v1.29.json

# Transfer to airgapped machine at a known path:
mkdir -p /opt/schemas/kubernetes
cp kubernetes-v1.29.json /opt/schemas/kubernetes/
```

## Step 3: Configure .lsp.json for Offline Mode

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
          "file:///opt/schemas/kubernetes/kubernetes-v1.29.json": ["/*.yaml", "/*.yml"]
        },
        "schemaStore": {
          "enable": false
        },
        "kubernetesCRDStore": {
          "enable": false
        }
      }
    }
  }
}
```

Key changes from the online config:
- **`schemaStore.enable: false`** -- Disables fetching from schemastore.org
- **`kubernetesCRDStore.enable: false`** -- Disables CRD catalog downloads
- **`file://` schema path** -- Points to locally stored schema instead of `"kubernetes"` keyword

## Step 4: Modify Hook Scripts

Update the install hook to skip network operations:

```bash
#!/bin/bash
if command -v yaml-language-server &> /dev/null; then
    exit 0
fi
echo "[yaml-language-server] Not found in PATH."
echo "  In airgapped mode, install manually from pre-packaged tarball:"
echo "  npm install -g /path/to/yaml-language-server-1.20.0.tgz"
exit 0
```

## CRD Schemas in Airgapped Mode

For custom CRDs, pre-download from the datreeio catalog:

```bash
# On internet-connected machine:
curl -L https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/argoproj.io/application_v1alpha1.json \
  -o /opt/schemas/crds/argo-application.json
```

Then reference in `.lsp.json`:

```json
"yaml.schemas": {
  "file:///opt/schemas/kubernetes/kubernetes-v1.29.json": ["/*.yaml"],
  "file:///opt/schemas/crds/argo-application.json": ["**/argo/**/*.yaml"]
}
```

## See Also

- [../patterns/security.md](../patterns/security.md) -- Security model details
- [../patterns/yaml-language-server.md](../patterns/yaml-language-server.md) -- Full settings reference
