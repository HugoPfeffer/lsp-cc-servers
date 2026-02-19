---
title: "MCP-LSP Wrapper Pattern"
tags: [mcp, lsp, plugin-architecture]
created: "2026-02-19"
related: ["./lsp-json-schema.md", "./lsp-protocol.md", "../examples/mcp-lsp-tool-design.md", "../glossary.md"]
domain: "claude-code-lsp-integration"
section: "concepts"
---

# MCP-LSP Wrapper Pattern

## When to Use This

The native `.lsp.json` approach handles standard LSP features automatically. The MCP wrapper pattern is only needed when you want:

- **Conversational tool access**: "Validate this YAML file" as a Claude tool call
- **Custom tool names**: Expose LSP capabilities under domain-specific tool names
- **Aggregation tools**: "Validate all Kubernetes manifests in this directory"
- **Transformation**: Process LSP results before returning to Claude

For standard diagnostics, completion, and hover: use `.lsp.json` instead.

## Architecture

```
Claude Code (MCP Client)
    │
    │  MCP JSON-RPC (tools/call)
    ▼
MCP Server (your code)
    │
    │  LSP JSON-RPC (textDocument/*)
    ▼
LSP Server (yaml-language-server / marksman)
```

The MCP server acts as both:
- An MCP server (responding to Claude's tool calls)
- An LSP client (sending requests to the LSP server)

## Two Implementation Approaches

### Approach A: Process Mode (spawn LSP as child)

Works with ANY LSP server. Spawn the LSP binary, communicate via stdio.

```typescript
import { createMessageConnection, StreamMessageReader, StreamMessageWriter } from 'vscode-jsonrpc/node.js';
import { spawn } from 'node:child_process';

const child = spawn('yaml-language-server', ['--stdio'], {
  stdio: ['pipe', 'pipe', 'pipe']
});

const connection = createMessageConnection(
  new StreamMessageReader(child.stdout!),
  new StreamMessageWriter(child.stdin!)
);
connection.listen();
```

### Approach B: Library Mode (yaml-language-server only)

Import the language service directly. No child process needed.

```typescript
import { getLanguageService } from 'yaml-language-server';

const service = getLanguageService({
  schemaRequestService: async (uri) => fetch(uri).then(r => r.text()),
  workspaceContext: {
    resolveRelativePath: (rel, resource) => new URL(rel, resource).toString()
  }
});

service.configure({
  isKubernetes: true,
  validate: true,
  schemas: [{ uri: 'kubernetes', fileMatch: ['*.yaml'] }]
});
```

**Trade-off**: Library mode is more efficient (no IPC overhead) but only works for yaml-language-server. Process mode works with any LSP binary (including Marksman).

## The Push/Pull Impedance Mismatch

**Problem**: LSP diagnostics are push-based (server sends `publishDiagnostics` unsolicited). MCP is strictly request/response.

**Process mode bridge strategy**:

```typescript
const diagnosticsMap = new Map<string, Diagnostic[]>();

// Listen for push notifications
connection.onNotification('textDocument/publishDiagnostics', (params) => {
  diagnosticsMap.set(params.uri, params.diagnostics);
});

// In the MCP tool handler:
async function validate(filePath: string) {
  const uri = pathToFileURL(filePath).toString();
  const text = readFileSync(filePath, 'utf8');

  // Open document (triggers server-side validation)
  connection.sendNotification('textDocument/didOpen', {
    textDocument: { uri, languageId: 'yaml', version: 1, text }
  });

  // Wait for diagnostics to arrive
  await new Promise(resolve => setTimeout(resolve, 500));
  return diagnosticsMap.get(uri) ?? [];
}
```

**Library mode**: No issue -- `doValidation()` returns a Promise directly.

## MCP SDK Setup

```bash
npm install @modelcontextprotocol/sdk zod
```

Use v1.x (stable). v2 is pre-alpha.

## Reference Implementation

**axivo/mcp-lsp** (https://github.com/axivo/mcp-lsp) is the most complete open-source reference. Key files:
- `src/index.ts` -- MCP server entry point
- `src/server/client.ts` -- Complete LSP client with connection management

## See Also

- [lsp-json-schema.md](./lsp-json-schema.md) -- The simpler native approach
- [lsp-protocol.md](./lsp-protocol.md) -- LSP lifecycle details
- [../examples/mcp-lsp-tool-design.md](../examples/mcp-lsp-tool-design.md) -- MCP tool schema examples
