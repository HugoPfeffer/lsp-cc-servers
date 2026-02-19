---
title: "Complete Marksman .lsp.json Example"
tags: [marksman, lsp-json, markdown]
created: "2026-02-19"
related: ["../patterns/marksman-integration.md", "../concepts/lsp-json-schema.md", "../guides/setup-marksman.md"]
domain: "claude-code-lsp-integration"
section: "examples"
---

# Complete Marksman .lsp.json Example

## Standard Configuration

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

### Field-by-field explanation:

- **`"markdown"`** -- Server identifier. Arbitrary string used as a key.
- **`command: "marksman"`** -- Marksman binary. Must be in `$PATH` (install via `brew install marksman` or binary download).
- **`args: ["server"]`** -- Start in LSP server mode via stdio.
- **`extensionToLanguage`** -- Map `.md` files to the `"markdown"` language ID.

No additional settings are required. Marksman reads configuration from `.marksman.toml` in the workspace root (if present).

## Combined with yaml-language-server

Both servers in a single `.lsp.json`:

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
        "schemas": { "kubernetes": ["/*.yaml", "/*.yml"] },
        "schemaStore": { "enable": true },
        "kubernetesCRDStore": { "enable": true }
      }
    },
    "maxRestarts": 3
  },
  "markdown": {
    "command": "marksman",
    "args": ["server"],
    "extensionToLanguage": {
      ".md": "markdown"
    }
  }
}
```

## Workspace Requirement

For cross-file features (link completion across files, find references), ensure your project has:

```bash
# Option A: Git repository (most common)
git init

# Option B: Empty config file
touch .marksman.toml
```

Without either, Marksman operates in single-file mode only.

## See Also

- [../patterns/marksman-integration.md](../patterns/marksman-integration.md) -- Feature details and alternatives
- [../concepts/lsp-json-schema.md](../concepts/lsp-json-schema.md) -- Field reference
- [../guides/setup-marksman.md](../guides/setup-marksman.md) -- End-to-end setup
