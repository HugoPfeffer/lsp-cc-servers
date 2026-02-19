---
title: "Issue: Server Version Compatibility"
tags: [version-compatibility]
created: "2026-02-19"
related: ["../concepts/plugin-architecture.md", "../references/sources.md"]
domain: "claude-code-lsp-integration"
section: "troubleshooting"
---

# Issue: Server Version Compatibility

## Claude Code Version Requirements

| Version | LSP Support | Notes |
|---|---|---|
| < 2.0.74 | No | LSP not implemented |
| 2.0.74 - 2.0.x | Partial | First LSP support; known race condition where LSP Manager initializes before plugins load |
| 2.1.0+ | Full | Race condition fixed; recommended minimum |

**Critical**: Claude Code installed as a **native/standalone binary** does NOT support LSP. You must install via **npm** or **bun**:

```bash
# npm (recommended)
npm install -g @anthropic-ai/claude-code

# bun
bun install -g @anthropic-ai/claude-code
```

## yaml-language-server Version Notes

| Version | Notable Changes |
|---|---|
| 1.0.0+ | Switched to eemeli/yaml parser; strict YAML 1.2 by default |
| 1.20.0 | Current stable; CRD auto-detection for custom resources |

**Recommended**: Latest stable (currently 1.20.0)

```bash
# Check version
yaml-language-server --version

# Update
npm update -g yaml-language-server
```

## Marksman Version Notes

Marksman uses date-based releases. Latest release: 2026-02-08.

```bash
# Check version
marksman --version

# Update via brew
brew upgrade marksman
```

## Troubleshooting "No LSP Server Available"

1. Check Claude Code version: `claude --version`
2. Verify not using native binary: `which claude` should point to an npm-installed binary
3. Verify plugin is loaded: check `claude --plugin-dir ./my-plugin --debug` output
4. Verify LSP binary is in PATH: `which yaml-language-server` or `which marksman`

## See Also

- [../concepts/plugin-architecture.md](../concepts/plugin-architecture.md) -- Plugin loading lifecycle
- [../references/sources.md](../references/sources.md) -- Official documentation links
