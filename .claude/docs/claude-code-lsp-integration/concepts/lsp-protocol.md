---
title: "LSP Protocol Fundamentals"
tags: [lsp]
created: "2026-02-19"
related: ["./lsp-json-schema.md", "./mcp-lsp-wrapper.md", "../glossary.md"]
domain: "claude-code-lsp-integration"
section: "concepts"
---

# LSP Protocol Fundamentals

## What is LSP?

The Language Server Protocol (LSP) defines a standard for communication between an editor (client) and a language intelligence server. It uses JSON-RPC 2.0 messages transmitted over stdio with `Content-Length` framing:

```text
Content-Length: 52\r\n
\r\n
{"jsonrpc":"2.0","id":1,"method":"initialize",...}
```

## Lifecycle

### Phase 1: Initialize

The client sends an `initialize` request with capabilities and workspace info:

```json
{
  "jsonrpc": "2.0",
  "id": 1,
  "method": "initialize",
  "params": {
    "processId": 12345,
    "rootUri": "file:///path/to/workspace",
    "workspaceFolders": [{ "uri": "file:///path", "name": "project" }],
    "capabilities": {
      "textDocument": {
        "completion": { "completionItem": { "snippetSupport": true } },
        "hover": {},
        "publishDiagnostics": { "relatedInformation": true }
      },
      "workspace": { "workspaceFolders": true, "configuration": true }
    }
  }
}
```

Server responds with its capabilities, then client sends `initialized` notification.

### Phase 2: Document Synchronization

Client notifies server when files are opened, changed, or closed:

```json
{
  "jsonrpc": "2.0",
  "method": "textDocument/didOpen",
  "params": {
    "textDocument": {
      "uri": "file:///path/to/file.yaml",
      "languageId": "yaml",
      "version": 1,
      "text": "apiVersion: v1\nkind: Pod\n..."
    }
  }
}
```

### Phase 3: Language Features

| Method | Direction | Description |
|---|---|---|
| `textDocument/completion` | Client → Server → Client | Get completion items at position |
| `textDocument/hover` | Client → Server → Client | Get hover info at position |
| `textDocument/definition` | Client → Server → Client | Go to definition |
| `textDocument/references` | Client → Server → Client | Find all references |
| `textDocument/publishDiagnostics` | **Server → Client** | Push diagnostics (errors, warnings) |
| `textDocument/codeAction` | Client → Server → Client | Get available code actions |
| `textDocument/formatting` | Client → Server → Client | Format document |

**Critical distinction**: Diagnostics are PUSH-based. The server sends `publishDiagnostics` notifications to the client unsolicited after `didOpen` or `didChange`. This is the opposite of the request/response pattern used by MCP.

### Phase 4: Shutdown

```json
{"jsonrpc": "2.0", "id": 99, "method": "shutdown"}
// Server responds with null, then:
{"jsonrpc": "2.0", "method": "exit"}
```

## Capability Negotiation

The client advertises what it supports in the `initialize` request. The server only uses features the client supports. For Claude Code's native `.lsp.json` integration, Claude Code acts as the LSP client and handles capability negotiation automatically.

For an MCP wrapper acting as an LSP client, minimum required capabilities are:
- `textDocument.publishDiagnostics` -- receive diagnostic notifications
- `textDocument.synchronization` -- `TextDocumentSyncKind.Full` or `Incremental`
- `workspace.workspaceFolders` -- for multi-root workspace

## Key Libraries

| Library | Purpose |
|---|---|
| `vscode-languageserver` | Server-side LSP implementation (used by yaml-language-server) |
| `vscode-languageserver-protocol` | Type definitions for LSP messages |
| `vscode-jsonrpc` | JSON-RPC 2.0 with Content-Length framing |
| `vscode-languageserver-textdocument` | `TextDocument` class for document modeling |

## See Also

- [lsp-json-schema.md](./lsp-json-schema.md) -- How Claude Code configures LSP clients
- [mcp-lsp-wrapper.md](./mcp-lsp-wrapper.md) -- Bridging LSP's push model to MCP's pull model
- [../glossary.md](../glossary.md) -- Term definitions
