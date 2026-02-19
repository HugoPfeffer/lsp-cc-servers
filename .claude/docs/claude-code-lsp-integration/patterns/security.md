---
title: "Security Considerations"
tags: [security, airgapped, plugin-architecture]
created: "2026-02-19"
related: ["../guides/airgapped-install.md", "../concepts/plugin-architecture.md", "../patterns/yaml-language-server.md"]
domain: "claude-code-lsp-integration"
section: "patterns"
---

# Security Considerations

## Network Access

yaml-language-server fetches schemas from external URLs by default:

| Source | URL | When |
|---|---|---|
| Schema Store | schemastore.org | `yaml.schemaStore.enable: true` (default) |
| CRD catalog | github.com/datreeio/CRDs-catalog | `yaml.kubernetesCRDStore.enable: true` |
| Custom schemas | Any URL in `yaml.schemas` | When schema URL is an HTTP(S) URL |
| Modeline schemas | Any URL in `# yaml-language-server: $schema=` | When file contains modeline |

Marksman does NOT fetch external resources.

## Disabling Network Access

For airgapped or restricted environments:

```json
"settings": {
  "yaml": {
    "schemaStore": { "enable": false },
    "kubernetesCRDStore": { "enable": false },
    "schemas": {
      "file:///path/to/local/kubernetes.json": ["/*.yaml"]
    }
  }
}
```

See [guides/airgapped-install.md](../guides/airgapped-install.md) for complete offline setup.

## LSP Process Isolation

LSP servers run as child processes of Claude Code. They:

- **Inherit** the Claude Code process environment (env vars, filesystem access)
- **Have no additional sandboxing** beyond OS-level process isolation
- **Can read/write** any file the user can access
- **Can execute** network requests (if not firewalled)

This is the same trust model as running the LSP binary directly in a terminal.

## Plugin Trust Model

- LSP operations are exposed as **built-in tools** (not MCP tools)
- They fall under Claude Code's own permission system
- There is no separate permission model for LSP-specific operations
- Plugin code (hooks, scripts) runs with the user's full permissions

## Schema URL Trust

Be cautious with schema URLs from untrusted sources:

- Modelines (`# yaml-language-server: $schema=<url>`) can point to any URL
- A malicious schema could cause unexpected validation behavior
- The yaml-language-server fetches and executes schema validation, but does not execute arbitrary code from schemas
- JSON Schema `$ref` resolution can cause the server to fetch additional URLs

## Recommendations

1. **Pin schema versions** in URLs rather than using `latest` or `main` branch
2. **Audit modelines** in YAML files from untrusted sources
3. **Use local file:// schemas** in high-security environments
4. **Disable Schema Store and CRD Store** if network access should be restricted
5. **Review hook scripts** before installing third-party plugins

## See Also

- [../guides/airgapped-install.md](../guides/airgapped-install.md) -- Offline installation guide
- [../concepts/plugin-architecture.md](../concepts/plugin-architecture.md) -- Plugin lifecycle and environment
