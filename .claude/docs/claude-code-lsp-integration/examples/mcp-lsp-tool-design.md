---
title: "MCP Tool Schema Design for LSP Capabilities"
tags: [mcp, lsp]
created: "2026-02-19"
related: ["../concepts/mcp-lsp-wrapper.md", "../concepts/lsp-protocol.md"]
domain: "claude-code-lsp-integration"
section: "examples"
---

# MCP Tool Schema Design for LSP Capabilities

This example shows how to design MCP tools that wrap LSP features. Only needed if the native `.lsp.json` approach doesn't meet your requirements.

## Tool Mapping

| MCP Tool | LSP Method | Description |
|---|---|---|
| `yaml_validate` | `publishDiagnostics` / `doValidation` | Validate YAML against schemas |
| `yaml_complete` | `textDocument/completion` | Get completions at position |
| `yaml_hover` | `textDocument/hover` | Get hover info at position |
| `yaml_format` | `textDocument/formatting` | Format YAML document |

## MCP Server Skeleton

```typescript
import { McpServer } from '@modelcontextprotocol/sdk/server/mcp.js';
import { StdioServerTransport } from '@modelcontextprotocol/sdk/server/stdio.js';
import { z } from 'zod';

const server = new McpServer({
  name: 'yaml-lsp-mcp',
  version: '1.0.0'
});

// Validate tool
server.tool(
  'yaml_validate',
  {
    file_path: z.string().describe('Absolute path to YAML file'),
    content: z.string().optional().describe('YAML content (reads file if omitted)')
  },
  async ({ file_path, content }) => {
    const diagnostics = await validateYaml(file_path, content);
    return {
      content: [{
        type: 'text',
        text: diagnostics.length === 0
          ? 'No issues found.'
          : diagnostics.map(d =>
              `${d.severity}: Line ${d.range.start.line}: ${d.message}`
            ).join('\n')
      }]
    };
  }
);

// Completion tool
server.tool(
  'yaml_complete',
  {
    file_path: z.string().describe('Absolute path to YAML file'),
    line: z.number().describe('0-indexed line number'),
    character: z.number().describe('0-indexed character offset')
  },
  async ({ file_path, line, character }) => {
    const completions = await getCompletions(file_path, { line, character });
    return {
      content: [{
        type: 'text',
        text: completions.items.map(c => `${c.label}: ${c.detail || ''}`).join('\n')
      }]
    };
  }
);

// Hover tool
server.tool(
  'yaml_hover',
  {
    file_path: z.string().describe('Absolute path to YAML file'),
    line: z.number().describe('0-indexed line number'),
    character: z.number().describe('0-indexed character offset')
  },
  async ({ file_path, line, character }) => {
    const hover = await getHover(file_path, { line, character });
    return {
      content: [{
        type: 'text',
        text: hover?.contents?.value || 'No hover information available.'
      }]
    };
  }
);

// Start server
const transport = new StdioServerTransport();
await server.connect(transport);
```

## Library Mode Implementation (yaml-language-server)

```typescript
import { getLanguageService } from 'yaml-language-server';
import { TextDocument } from 'vscode-languageserver-textdocument';
import { readFileSync } from 'fs';

const service = getLanguageService({
  schemaRequestService: async (uri) => {
    const response = await fetch(uri);
    return response.text();
  },
  workspaceContext: {
    resolveRelativePath: (rel, resource) => new URL(rel, resource).toString()
  }
});

service.configure({
  isKubernetes: true,
  validate: true,
  hover: true,
  completion: true,
  schemas: [{ uri: 'kubernetes', fileMatch: ['*.yaml', '*.yml'] }]
});

async function validateYaml(filePath: string, content?: string) {
  const text = content ?? readFileSync(filePath, 'utf8');
  const doc = TextDocument.create(`file://${filePath}`, 'yaml', 1, text);
  return service.doValidation(doc, true);
}

async function getCompletions(filePath: string, position: { line: number; character: number }) {
  const text = readFileSync(filePath, 'utf8');
  const doc = TextDocument.create(`file://${filePath}`, 'yaml', 1, text);
  return service.doComplete(doc, position, true);
}

async function getHover(filePath: string, position: { line: number; character: number }) {
  const text = readFileSync(filePath, 'utf8');
  const doc = TextDocument.create(`file://${filePath}`, 'yaml', 1, text);
  return service.doHover(doc, position);
}
```

## .mcp.json Registration

```json
{
  "mcpServers": {
    "yaml-lsp-mcp": {
      "command": "node",
      "args": ["${CLAUDE_PLUGIN_ROOT}/dist/index.js"],
      "env": {}
    }
  }
}
```

Note: Unlike `.lsp.json`, MCP server configs DO support `${CLAUDE_PLUGIN_ROOT}`.

## See Also

- [../concepts/mcp-lsp-wrapper.md](../concepts/mcp-lsp-wrapper.md) -- Architecture and design decisions
- [../concepts/lsp-protocol.md](../concepts/lsp-protocol.md) -- LSP protocol details
