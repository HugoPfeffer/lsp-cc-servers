---
title: ".lsp.json File Format - Complete Schema Reference"
tags: [lsp-json, plugin-architecture, CLAUDE_PLUGIN_ROOT]
created: "2026-02-19"
related: ["./plugin-architecture.md", "../patterns/yaml-language-server.md", "../patterns/marksman-integration.md", "../examples/yaml-lsp-config.md"]
domain: "claude-code-lsp-integration"
section: "concepts"
---

# .lsp.json File Format - Complete Schema Reference

## Location

Place `.lsp.json` at the **plugin root directory** (not inside `.claude-plugin/`). It is auto-discovered by Claude Code when the plugin loads.

Alternatively, reference it from `plugin.json`:

```json
{ "lspServers": "./.lsp.json" }
```

Or define servers inline in `plugin.json`:

```json
{ "lspServers": { "yaml": { "command": "yaml-language-server", ... } } }
```

## Schema Structure

The file is a JSON object where each key is a **server identifier** and each value is a server configuration:

```json
{
  "<server-id>": {
    "command": "<binary>",
    "extensionToLanguage": { ".<ext>": "<language-id>" },
    ...optional fields...
  }
}
```

Multiple servers can be defined in a single file as additional top-level keys.

## Field Reference

| Field | Required | Type | Description |
|---|---|---|---|
| `command` | **Yes** | string | LSP binary to execute. Must be in `$PATH`. `${CLAUDE_PLUGIN_ROOT}` does NOT work here. |
| `extensionToLanguage` | **Yes** | object | Maps file extensions to LSP language identifiers. E.g., `{".yaml": "yaml"}` |
| `args` | No | string[] | Command-line arguments. E.g., `["--stdio"]` |
| `transport` | No | string | `"stdio"` (default) or `"socket"` |
| `env` | No | object | Environment variables for the server process |
| `initializationOptions` | No | object | Passed during LSP `initialize` request |
| `settings` | No | object | Sent via `workspace/didChangeConfiguration` after initialization |
| `workspaceFolder` | No | string | Workspace folder path |
| `startupTimeout` | No | number | Max milliseconds to wait for startup |
| `shutdownTimeout` | No | number | Max milliseconds for graceful shutdown |
| `restartOnCrash` | No | boolean | Auto-restart on crash |
| `maxRestarts` | No | number | Maximum restart attempts |

## Settings vs initializationOptions

These are distinct LSP concepts:

- **`initializationOptions`**: Sent once during the `initialize` handshake. Used for one-time server setup.
- **`settings`**: Sent via `workspace/didChangeConfiguration` notification after initialization. Can be updated during the session. This is where yaml-language-server reads its `yaml.*` configuration.

For yaml-language-server, use `settings` (not `initializationOptions`) for the `yaml.schemas`, `yaml.schemaStore`, etc. configuration.

## Minimal Example

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

## Full Example (Multiple Servers)

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
        "kubernetesCRDStore": { "enable": true },
        "validate": true,
        "hover": true,
        "completion": true
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

## Key Constraints

1. **`command` must be a binary in `$PATH`**. You cannot use `${CLAUDE_PLUGIN_ROOT}/bin/server` -- the binary must be globally installed. Use a SessionStart hook to auto-install.
2. **`transport` defaults to `"stdio"`**. The `"socket"` option exists but has no known usage examples in public plugins.
3. **Multiple servers in one file**: Define each as a separate top-level key. Each has independent lifecycle.
4. **Claude Code version**: LSP support requires Claude Code 2.0.74+; recommended 2.1.0+.
5. **Native binary installs**: Claude Code installed as a standalone binary does NOT support LSP. Must use npm or bun installation.

## See Also

- [plugin-architecture.md](./plugin-architecture.md) -- Plugin structure and environment variables
- [../patterns/yaml-language-server.md](../patterns/yaml-language-server.md) -- yaml-language-server specific settings
- [../patterns/marksman-integration.md](../patterns/marksman-integration.md) -- Marksman specific settings
- [../examples/yaml-lsp-config.md](../examples/yaml-lsp-config.md) -- Complete ready-to-use config
