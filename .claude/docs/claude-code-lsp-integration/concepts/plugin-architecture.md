---
title: "Claude Code Plugin Architecture"
tags: [plugin-architecture, hooks, CLAUDE_PLUGIN_ROOT, security]
created: "2026-02-19"
related: ["./lsp-json-schema.md", "../patterns/auto-install-hooks.md", "../patterns/distribution-marketplace.md", "../glossary.md"]
domain: "claude-code-lsp-integration"
section: "concepts"
---

# Claude Code Plugin Architecture

## Directory Layout

```
my-plugin/
├── .claude-plugin/
│   └── plugin.json           # Optional manifest (metadata, component refs)
├── .lsp.json                 # LSP server configuration (auto-discovered at root)
├── .mcp.json                 # MCP server configuration (optional)
├── hooks/
│   └── hooks.json            # Hook definitions (e.g., SessionStart)
├── commands/                 # Slash commands (Markdown files)
├── agents/                   # Agent definitions
├── skills/                   # Agent skills (SKILL.md subdirs)
└── scripts/                  # Utility scripts (install, etc.)
```

**Critical**: `commands/`, `agents/`, `skills/`, `hooks/` must be at the plugin **root**, NOT inside `.claude-plugin/`. Only `plugin.json` goes inside `.claude-plugin/`.

## plugin.json (Optional Manifest)

```json
{
  "name": "yaml-k8s-lsp",
  "version": "1.0.0",
  "description": "Kubernetes YAML LSP via Red Hat yaml-language-server",
  "author": { "name": "Your Name" },
  "lspServers": "./.lsp.json",
  "hooks": "./hooks/hooks.json"
}
```

The `version` field controls caching. Plugins are copied to `~/.claude/plugins/cache/`. **You must bump the version for updates to propagate to existing users.**

Inline MCP servers are also supported:

```json
{
  "name": "my-plugin",
  "mcpServers": {
    "my-server": {
      "command": "${CLAUDE_PLUGIN_ROOT}/servers/my-server",
      "args": ["--port", "8080"]
    }
  }
}
```

## Environment Variables

| Variable | Available In | Description |
|---|---|---|
| `${CLAUDE_PLUGIN_ROOT}` | Hooks, MCP configs | Absolute path to installed plugin directory |
| `${WORKSPACE_ROOT}` | MCP configs | Current workspace root (supports fallback: `${WORKSPACE_ROOT:-/tmp}`) |

**Important**: `${CLAUDE_PLUGIN_ROOT}` is **NOT available** in `.lsp.json` `command` fields. LSP binaries must be in `$PATH`. This is why auto-install hooks are necessary.

## .mcp.json Format

```json
{
  "mcpServers": {
    "my-server": {
      "command": "${CLAUDE_PLUGIN_ROOT}/bin/server",
      "args": ["--stdio"],
      "env": { "WORKSPACE": "${WORKSPACE_ROOT:-/tmp}" }
    }
  }
}
```

Environment variable expansion (`${VAR}` and `${VAR:-default}`) is supported in `command`, `args`, `env`, `url`, and `headers`.

## Plugin Lifecycle

1. **Installation**: Plugin directory copied to `~/.claude/plugins/cache/<name>/`
2. **Loading**: On Claude Code startup, enabled plugins are loaded from cache
3. **LSP startup**: LSP servers from `.lsp.json` start automatically
4. **MCP startup**: MCP servers from `.mcp.json` start automatically
5. **Hook execution**: Hooks fire on registered events (SessionStart, PreToolUse, etc.)

## Testing Locally

```bash
# Load a single plugin
claude --plugin-dir ./my-plugin

# Load multiple plugins
claude --plugin-dir ./plugin-one --plugin-dir ./plugin-two

# Debug mode (verbose output)
claude --debug

# Check MCP server status within Claude
/mcp
```

## Plugin Caching

- Installed plugins are copied to `~/.claude/plugins/cache/`
- The `version` in `plugin.json` determines whether to update
- If you change code but don't bump version, existing users won't see changes
- Path traversal (`../`) doesn't work after installation -- external files are not copied

## See Also

- [lsp-json-schema.md](./lsp-json-schema.md) -- The `.lsp.json` file format reference
- [../patterns/auto-install-hooks.md](../patterns/auto-install-hooks.md) -- Hook patterns for auto-installing LSP binaries
- [../patterns/distribution-marketplace.md](../patterns/distribution-marketplace.md) -- Publishing to marketplace
