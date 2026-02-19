---
title: "Issue: Schema Cache Stale or Missing"
tags: [schema, crd, yaml-language-server]
created: "2026-02-19"
related: ["../patterns/yaml-language-server.md", "../concepts/plugin-architecture.md"]
domain: "claude-code-lsp-integration"
section: "troubleshooting"
---

# Issue: Schema Cache Stale or Missing

## Symptom 1: Schemas Not Loading

Kubernetes validation doesn't work. No completions for `apiVersion`, `kind`, etc.

### Possible Causes

1. **Network issue**: yaml-language-server fetches schemas from schemastore.org on first use. If network is blocked, schemas won't load.
2. **schemaStore.enable is false**: Check `.lsp.json` settings.
3. **No `"kubernetes"` schema key**: The `yaml.schemas` object must include `"kubernetes"` with a glob pattern.

### Fix

Verify settings in `.lsp.json`:

```json
"settings": {
  "yaml": {
    "schemas": { "kubernetes": ["/*.yaml"] },
    "schemaStore": { "enable": true }
  }
}
```

If behind a proxy, yaml-language-server respects `http_proxy` / `https_proxy` environment variables. Set them in the `.lsp.json` `env` field:

```json
"env": {
  "https_proxy": "http://proxy.corp:8080"
}
```

## Symptom 2: Schema Changes Not Taking Effect

You changed `.lsp.json` settings but validation behavior hasn't changed.

### Possible Causes

1. **yaml-language-server caches schemas in memory** for the session duration. Changing `.lsp.json` requires a restart.
2. **Plugin cache**: Installed plugins are copied to `~/.claude/plugins/cache/`. If you changed the plugin but didn't bump the version in `plugin.json`, the old cached version is still used.

### Fix

1. **Restart Claude Code** to reload LSP servers with new settings
2. **Bump version** in `plugin.json` if distributing via marketplace
3. **Clear plugin cache** (if needed): `rm -rf ~/.claude/plugins/cache/<plugin-name>/`

## Symptom 3: CRD Schemas Not Available

Custom Resource Definitions (CRDs) aren't being validated.

### Fix

Enable CRD store:

```json
"yaml": {
  "kubernetesCRDStore": {
    "enable": true
  }
}
```

Or add specific CRD schema URLs:

```json
"yaml.schemas": {
  "https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/argoproj.io/application_v1alpha1.json": ["**/argo/*.yaml"]
}
```

## See Also

- [../patterns/yaml-language-server.md](../patterns/yaml-language-server.md) -- Schema priority and settings
- [../guides/airgapped-install.md](../guides/airgapped-install.md) -- Offline schema setup
