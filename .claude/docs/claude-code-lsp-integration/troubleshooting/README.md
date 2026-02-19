---
title: "Troubleshooting - Issue Index by Symptom"
tags: [troubleshooting, yaml-language-server, marksman]
created: "2026-02-19"
related: ["./helm-templates.md", "./schema-caching.md", "./version-requirements.md", "./workspace-detection.md"]
domain: "claude-code-lsp-integration"
section: "troubleshooting"
---

# Troubleshooting

## Issue Index by Symptom

| Symptom | Likely Cause | Fix |
|---|---|---|
| Helm template files show hundreds of YAML errors | yaml-language-server can't parse Go template syntax | [helm-templates.md](./helm-templates.md) |
| Kubernetes schemas not loading / validation not working | Schema cache stale or network issue | [schema-caching.md](./schema-caching.md) |
| "No LSP server available" error | Wrong Claude Code version or install method | [version-requirements.md](./version-requirements.md) |
| LSP server fails to start | Binary not in $PATH | Check auto-install hook ran successfully |
| Marksman: no cross-file link completion | Missing .git or .marksman.toml | [workspace-detection.md](./workspace-detection.md) |
| Plugin changes not visible after update | Version not bumped in plugin.json | [schema-caching.md](./schema-caching.md) |
| LSP features work but are slow | Large schema set or many files | Increase `yaml.maxItemsComputed` |
| Completion shows no Kubernetes resources | `"kubernetes"` schema key not configured | Check `.lsp.json` settings |

## Quick Diagnostic Steps

1. **Check Claude Code version**: `claude --version` (need 2.0.74+, recommend 2.1.0+)
2. **Check binary is installed**: `which yaml-language-server` or `which marksman`
3. **Check debug output**: `claude --plugin-dir ./my-plugin --debug`
4. **Check MCP/LSP status**: Run `/mcp` inside Claude Code

## See Also

- [../patterns/yaml-language-server.md](../patterns/yaml-language-server.md) -- Settings reference
- [../patterns/marksman-integration.md](../patterns/marksman-integration.md) -- Marksman requirements
