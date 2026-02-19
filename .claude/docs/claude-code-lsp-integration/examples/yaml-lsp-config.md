---
title: "Complete yaml-language-server .lsp.json Example"
tags: [yaml-language-server, lsp-json, kubernetes, schema]
created: "2026-02-19"
related: ["../patterns/yaml-language-server.md", "../concepts/lsp-json-schema.md", "../guides/setup-yaml-kubernetes.md"]
domain: "claude-code-lsp-integration"
section: "examples"
---

# Complete yaml-language-server .lsp.json Example

## Minimal (No Kubernetes)

```json
{
  "yaml": {
    "command": "yaml-language-server",
    "args": ["--stdio"],
    "extensionToLanguage": {
      ".yaml": "yaml",
      ".yml": "yaml"
    }
  }
}
```

## Full Kubernetes Configuration

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

### Field-by-field explanation:

- **`"yaml"`** -- Server identifier. Arbitrary string used as a key.
- **`command`** -- `yaml-language-server` binary. Must be in `$PATH` (install via `npm install -g yaml-language-server`).
- **`args: ["--stdio"]`** -- Use stdio transport (required for Claude Code).
- **`extensionToLanguage`** -- Map `.yaml` and `.yml` files to the `"yaml"` language ID.
- **`settings.yaml.schemas`** -- `"kubernetes"` is a special keyword (NOT a URL) that activates built-in Kubernetes schemas.
- **`settings.yaml.schemaStore.enable`** -- Pull additional schemas from schemastore.org.
- **`settings.yaml.kubernetesCRDStore.enable`** -- Auto-download CRD schemas from datreeio catalog.
- **`settings.yaml.maxItemsComputed`** -- Increase for large multi-resource files.
- **`maxRestarts: 3`** -- Auto-restart on crash, up to 3 times.

## With Helm Template Exclusion

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
        "schemas": {
          "kubernetes": [
            "/*.yaml",
            "/*.yml",
            "!**/templates/**"
          ]
        },
        "schemaStore": { "enable": true },
        "kubernetesCRDStore": { "enable": true }
      }
    }
  }
}
```

The `!**/templates/**` glob excludes Helm chart template directories from Kubernetes schema validation, preventing false positives from Go template syntax.

## Airgapped (No Network)

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
        "schemas": {
          "file:///opt/schemas/kubernetes/v1.29.json": ["/*.yaml"]
        },
        "schemaStore": { "enable": false },
        "kubernetesCRDStore": { "enable": false }
      }
    }
  }
}
```

## See Also

- [../patterns/yaml-language-server.md](../patterns/yaml-language-server.md) -- Full settings reference
- [../concepts/lsp-json-schema.md](../concepts/lsp-json-schema.md) -- Field reference
- [../guides/setup-yaml-kubernetes.md](../guides/setup-yaml-kubernetes.md) -- End-to-end setup
