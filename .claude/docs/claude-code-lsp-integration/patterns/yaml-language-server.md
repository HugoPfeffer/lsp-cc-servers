---
title: "yaml-language-server Integration Pattern"
tags: [yaml-language-server, kubernetes, schema, crd, helm]
created: "2026-02-19"
related: ["../concepts/lsp-json-schema.md", "../examples/yaml-lsp-config.md", "../guides/setup-yaml-kubernetes.md", "../troubleshooting/helm-templates.md", "../troubleshooting/schema-caching.md"]
domain: "claude-code-lsp-integration"
section: "patterns"
---

# yaml-language-server Integration Pattern

## Server Details

| Property | Value |
|---|---|
| Repository | https://github.com/redhat-developer/yaml-language-server |
| NPM package | `yaml-language-server` |
| Current version | 1.20.0 |
| Install | `npm install -g yaml-language-server` |
| Binary | `yaml-language-server --stdio` |
| LSP version | 3.16 (via vscode-languageserver@^9.0.0) |
| YAML parser | eemeli/yaml 2.7.1 |

## Kubernetes Mode

The special keyword `"kubernetes"` in `yaml.schemas` activates built-in Kubernetes schema support. This is NOT a URL:

```json
"yaml.schemas": {
  "kubernetes": ["/*.yaml", "/*.yml"]
}
```

When this keyword is used, yaml-language-server fetches Kubernetes JSON schemas from the Schema Store automatically. The `isKubernetes` flag is set per-document when the file URI matches the glob pattern.

## Schema Priority

The schema resolution chain (highest to lowest priority):

1. **Modeline** -- `# yaml-language-server: $schema=<url>` in the YAML file
2. **CustomSchemaProvider API** -- Dynamic per-file resolution callback
3. **`yaml.settings`** -- The `yaml.schemas` mappings from `.lsp.json` `settings` field
4. **Schema association notification** -- From external clients
5. **Schema Store** -- Auto-fetched from schemastore.org

Users can always override at the file level using a modeline:

```yaml
# yaml-language-server: $schema=https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/kustomize.toolkit.fluxcd.io/kustomization_v1.json
apiVersion: kustomize.toolkit.fluxcd.io/v1
kind: Kustomization
```

## Complete Settings Reference

All settings go under `"yaml"` in the `.lsp.json` `settings` field:

| Setting | Type | Default | Description |
|---|---|---|---|
| `yaml.validate` | bool | true | Enable/disable validation |
| `yaml.hover` | bool | true | Enable/disable hover information |
| `yaml.completion` | bool | true | Enable/disable auto-completion |
| `yaml.schemas` | object | {} | Schema-to-glob mappings |
| `yaml.schemaStore.enable` | bool | true | Pull schemas from schemastore.org |
| `yaml.kubernetesCRDStore.enable` | bool | false | Auto-download CRD schemas |
| `yaml.kubernetesCRDStore.url` | string | datreeio URL | CRD catalog URL |
| `yaml.customTags` | string[] | [] | Custom YAML tags |
| `yaml.yamlVersion` | string | "1.2" | YAML spec version ("1.2" or "1.1") |
| `yaml.maxItemsComputed` | int | 5000 | Max items in document outline |
| `yaml.disableAdditionalProperties` | bool | false | Strict schema validation |
| `yaml.disableDefaultProperties` | bool | false | Don't insert defaults on completion |

## CRD Support

### Auto-download from CRD catalog

```json
"yaml": {
  "kubernetesCRDStore": {
    "enable": true,
    "url": "https://raw.githubusercontent.com/datreeio/CRDs-catalog/main"
  }
}
```

### Manual CRD schema URLs

```json
"yaml.schemas": {
  "kubernetes": ["**/k8s/**/*.yaml"],
  "https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/apps/deployment_v1.json": "deployment.yaml"
}
```

### Local file schemas (for airgapped environments)

```json
"yaml.schemas": {
  "file:///path/to/schemas/deployment.json": ["**/k8s/*.yaml"]
}
```

## Programmatic API (Library Mode)

yaml-language-server exports a library API for embedding without running a process:

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
  hover: true,
  completion: true,
  schemas: [{ uri: 'kubernetes', fileMatch: ['*.yaml', '*.yml'] }]
});

// Available methods:
// service.doValidation(document, isKubernetes) -> Diagnostic[]
// service.doComplete(document, position, isKubernetes) -> CompletionList
// service.doHover(document, position) -> Hover
// service.getCodeAction(document, params) -> CodeAction[]
// service.doFormat(document, options) -> TextEdit[]
// service.doDefinition(document, params) -> LocationLink[]
// service.addSchema(schemaID, schema) -> void
```

Key source files:
- `src/server.ts` -- Entry point
- `src/languageservice/yamlLanguageService.ts` -- `getLanguageService()` factory
- `src/yamlSettings.ts` -- All settings with defaults
- `src/index.ts` -- Library re-exports

## Known Limitations

- **Helm templates**: Go template syntax (`{{ }}`) is invalid YAML. See [troubleshooting/helm-templates.md](../troubleshooting/helm-templates.md).
- **Multi-document YAML** (`---`): Supported. Schema applies to the whole file; each document validated independently.
- **YAML anchors/aliases**: Supported via eemeli/yaml. Schema validation applies to resolved values.
- **Large files**: Increase `yaml.maxItemsComputed` for files with many resources (default 5000).

## See Also

- [../concepts/lsp-json-schema.md](../concepts/lsp-json-schema.md) -- `.lsp.json` field reference
- [../examples/yaml-lsp-config.md](../examples/yaml-lsp-config.md) -- Ready-to-use config
- [../guides/setup-yaml-kubernetes.md](../guides/setup-yaml-kubernetes.md) -- Step-by-step setup
- [../troubleshooting/helm-templates.md](../troubleshooting/helm-templates.md) -- Helm workarounds
