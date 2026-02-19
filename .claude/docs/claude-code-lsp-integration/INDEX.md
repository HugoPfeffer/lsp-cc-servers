# Claude Code LSP Integration - Master Index

**Domain:** claude-code-lsp-integration
**Description:** Claude Code plugin development for LSP integration with Red Hat
yaml-language-server (Kubernetes YAML) and Marksman (Markdown LSP server).
**Last Updated:** 2026-02-19
**Research Status:** Complete

---

## Quick Navigation

| Section | File | Description |
|---|---|---|
| Overview | [overview.md](./overview.md) | Executive summary and quick-start guide |
| Glossary | [glossary.md](./glossary.md) | 14 key terms and definitions |
| Concepts | [concepts/README.md](./concepts/README.md) | Core concepts reading order |
| Patterns | [patterns/README.md](./patterns/README.md) | Architecture and design patterns |
| Examples | [examples/README.md](./examples/README.md) | Code examples with difficulty ratings |
| Guides | [guides/README.md](./guides/README.md) | Step-by-step how-to guides |
| Troubleshooting | [troubleshooting/README.md](./troubleshooting/README.md) | Known issues and solutions |
| References | [references/sources.md](./references/sources.md) | Curated external sources |

---

## Table of Contents

### Root Files
- [overview.md](./overview.md) - Executive summary, architecture at a glance, quick-start
- [glossary.md](./glossary.md) - LSP, plugin system, YAML schema, MCP, and 10+ more terms
- [METADATA.md](./METADATA.md) - Research scope, coverage gaps, source reliability ratings

### Concepts
- [concepts/README.md](./concepts/README.md) - Reading order and concept map
- [concepts/lsp-protocol.md](./concepts/lsp-protocol.md) - Language Server Protocol fundamentals
- [concepts/plugin-architecture.md](./concepts/plugin-architecture.md) - Claude Code plugin system, manifest, CLAUDE_PLUGIN_ROOT
- [concepts/lsp-json-schema.md](./concepts/lsp-json-schema.md) - .lsp.json file format: complete field reference
- [concepts/mcp-lsp-wrapper.md](./concepts/mcp-lsp-wrapper.md) - MCP-LSP bridge pattern (axivo/mcp-lsp)

### Patterns
- [patterns/README.md](./patterns/README.md) - Patterns overview and decision matrix
- [patterns/yaml-language-server.md](./patterns/yaml-language-server.md) - yaml-language-server Kubernetes config, schema priority, CRD support
- [patterns/marksman-integration.md](./patterns/marksman-integration.md) - Marksman Markdown LSP config and workspace requirements
- [patterns/auto-install-hooks.md](./patterns/auto-install-hooks.md) - hooks.json patterns and install script design
- [patterns/distribution-marketplace.md](./patterns/distribution-marketplace.md) - Publishing plugins to Claude marketplace
- [patterns/security.md](./patterns/security.md) - Network access controls, airgapped mode, trust model

### Examples
- [examples/README.md](./examples/README.md) - Examples index with difficulty levels
- [examples/yaml-lsp-config.md](./examples/yaml-lsp-config.md) - Complete yaml-language-server .lsp.json example
- [examples/marksman-config.md](./examples/marksman-config.md) - Complete Marksman .lsp.json example
- [examples/hooks-install-script.md](./examples/hooks-install-script.md) - Annotated hooks.json and shell install scripts
- [examples/mcp-lsp-tool-design.md](./examples/mcp-lsp-tool-design.md) - MCP tool schema wrapping LSP capabilities

### Guides
- [guides/README.md](./guides/README.md) - Guides overview and prerequisites
- [guides/setup-yaml-kubernetes.md](./guides/setup-yaml-kubernetes.md) - End-to-end: yaml-language-server for Kubernetes
- [guides/setup-marksman.md](./guides/setup-marksman.md) - End-to-end: Marksman for Markdown
- [guides/publish-marketplace.md](./guides/publish-marketplace.md) - Submitting to Claude Code marketplace
- [guides/airgapped-install.md](./guides/airgapped-install.md) - Offline / airgapped installation workflow

### Troubleshooting
- [troubleshooting/README.md](./troubleshooting/README.md) - Issue index by symptom
- [troubleshooting/helm-templates.md](./troubleshooting/helm-templates.md) - Helm template files not validating
- [troubleshooting/schema-caching.md](./troubleshooting/schema-caching.md) - Schema cache stale or missing
- [troubleshooting/version-requirements.md](./troubleshooting/version-requirements.md) - Server version compatibility matrix
- [troubleshooting/workspace-detection.md](./troubleshooting/workspace-detection.md) - Marksman workspace root detection failures

### References
- [references/sources.md](./references/sources.md) - All sources with reliability ratings and annotations

---

## Tag Index

Each tag below maps to files that cover that topic.

### #lsp
- [concepts/lsp-protocol.md](./concepts/lsp-protocol.md)
- [concepts/lsp-json-schema.md](./concepts/lsp-json-schema.md)
- [concepts/mcp-lsp-wrapper.md](./concepts/mcp-lsp-wrapper.md)
- [overview.md](./overview.md)
- [glossary.md](./glossary.md)

### #plugin-architecture
- [concepts/plugin-architecture.md](./concepts/plugin-architecture.md)
- [concepts/lsp-json-schema.md](./concepts/lsp-json-schema.md)
- [patterns/auto-install-hooks.md](./patterns/auto-install-hooks.md)
- [patterns/distribution-marketplace.md](./patterns/distribution-marketplace.md)
- [overview.md](./overview.md)

### #yaml-language-server
- [patterns/yaml-language-server.md](./patterns/yaml-language-server.md)
- [examples/yaml-lsp-config.md](./examples/yaml-lsp-config.md)
- [guides/setup-yaml-kubernetes.md](./guides/setup-yaml-kubernetes.md)
- [troubleshooting/helm-templates.md](./troubleshooting/helm-templates.md)
- [troubleshooting/schema-caching.md](./troubleshooting/schema-caching.md)

### #kubernetes
- [patterns/yaml-language-server.md](./patterns/yaml-language-server.md)
- [examples/yaml-lsp-config.md](./examples/yaml-lsp-config.md)
- [guides/setup-yaml-kubernetes.md](./guides/setup-yaml-kubernetes.md)
- [troubleshooting/helm-templates.md](./troubleshooting/helm-templates.md)

### #marksman
- [patterns/marksman-integration.md](./patterns/marksman-integration.md)
- [examples/marksman-config.md](./examples/marksman-config.md)
- [guides/setup-marksman.md](./guides/setup-marksman.md)
- [troubleshooting/workspace-detection.md](./troubleshooting/workspace-detection.md)

### #markdown
- [patterns/marksman-integration.md](./patterns/marksman-integration.md)
- [examples/marksman-config.md](./examples/marksman-config.md)
- [guides/setup-marksman.md](./guides/setup-marksman.md)
- [glossary.md](./glossary.md)

### #lsp-json
- [concepts/lsp-json-schema.md](./concepts/lsp-json-schema.md)
- [examples/yaml-lsp-config.md](./examples/yaml-lsp-config.md)
- [examples/marksman-config.md](./examples/marksman-config.md)
- [glossary.md](./glossary.md)

### #hooks
- [patterns/auto-install-hooks.md](./patterns/auto-install-hooks.md)
- [examples/hooks-install-script.md](./examples/hooks-install-script.md)
- [concepts/plugin-architecture.md](./concepts/plugin-architecture.md)

### #auto-install
- [patterns/auto-install-hooks.md](./patterns/auto-install-hooks.md)
- [examples/hooks-install-script.md](./examples/hooks-install-script.md)
- [guides/setup-yaml-kubernetes.md](./guides/setup-yaml-kubernetes.md)
- [guides/setup-marksman.md](./guides/setup-marksman.md)

### #mcp
- [concepts/mcp-lsp-wrapper.md](./concepts/mcp-lsp-wrapper.md)
- [examples/mcp-lsp-tool-design.md](./examples/mcp-lsp-tool-design.md)
- [glossary.md](./glossary.md)

### #marketplace
- [patterns/distribution-marketplace.md](./patterns/distribution-marketplace.md)
- [guides/publish-marketplace.md](./guides/publish-marketplace.md)
- [references/sources.md](./references/sources.md)

### #security
- [patterns/security.md](./patterns/security.md)
- [guides/airgapped-install.md](./guides/airgapped-install.md)
- [concepts/plugin-architecture.md](./concepts/plugin-architecture.md)

### #airgapped
- [patterns/security.md](./patterns/security.md)
- [guides/airgapped-install.md](./guides/airgapped-install.md)

### #crd
- [patterns/yaml-language-server.md](./patterns/yaml-language-server.md)
- [guides/setup-yaml-kubernetes.md](./guides/setup-yaml-kubernetes.md)
- [troubleshooting/schema-caching.md](./troubleshooting/schema-caching.md)

### #schema
- [patterns/yaml-language-server.md](./patterns/yaml-language-server.md)
- [concepts/lsp-json-schema.md](./concepts/lsp-json-schema.md)
- [troubleshooting/schema-caching.md](./troubleshooting/schema-caching.md)
- [glossary.md](./glossary.md)

### #helm
- [troubleshooting/helm-templates.md](./troubleshooting/helm-templates.md)
- [patterns/yaml-language-server.md](./patterns/yaml-language-server.md)

### #version-compatibility
- [troubleshooting/version-requirements.md](./troubleshooting/version-requirements.md)
- [references/sources.md](./references/sources.md)

### #CLAUDE_PLUGIN_ROOT
- [concepts/plugin-architecture.md](./concepts/plugin-architecture.md)
- [concepts/lsp-json-schema.md](./concepts/lsp-json-schema.md)
- [glossary.md](./glossary.md)

---

## Topic Map

```
claude-code-lsp-integration
├── Plugin System
│   ├── Plugin manifest format              -> concepts/plugin-architecture.md
│   ├── CLAUDE_PLUGIN_ROOT env variable     -> concepts/plugin-architecture.md
│   ├── hooks.json auto-install             -> patterns/auto-install-hooks.md
│   └── Marketplace distribution            -> patterns/distribution-marketplace.md
│
├── LSP Protocol
│   ├── Protocol fundamentals               -> concepts/lsp-protocol.md
│   ├── .lsp.json schema reference          -> concepts/lsp-json-schema.md
│   └── MCP-LSP bridge alternative          -> concepts/mcp-lsp-wrapper.md
│
├── yaml-language-server (Kubernetes)
│   ├── Configuration and settings          -> patterns/yaml-language-server.md
│   ├── Schema priority ordering            -> patterns/yaml-language-server.md
│   ├── CRD validation support              -> patterns/yaml-language-server.md
│   ├── Programmatic API                    -> patterns/yaml-language-server.md
│   └── Complete config example             -> examples/yaml-lsp-config.md
│
├── Marksman (Markdown)
│   ├── Configuration                       -> patterns/marksman-integration.md
│   ├── Workspace requirements              -> patterns/marksman-integration.md
│   ├── Feature set                         -> patterns/marksman-integration.md
│   └── Complete config example             -> examples/marksman-config.md
│
├── Installation and Distribution
│   ├── Auto-install hook patterns          -> patterns/auto-install-hooks.md
│   ├── Shell script examples               -> examples/hooks-install-script.md
│   ├── Marketplace submission              -> guides/publish-marketplace.md
│   └── Airgapped offline install           -> guides/airgapped-install.md
│
├── Security
│   ├── Network access model                -> patterns/security.md
│   ├── Airgapped mode                      -> patterns/security.md
│   └── Plugin trust model                  -> patterns/security.md
│
├── Alternative Approaches
│   ├── MCP-LSP wrapper (axivo pattern)     -> concepts/mcp-lsp-wrapper.md
│   └── MCP tool design for LSP             -> examples/mcp-lsp-tool-design.md
│
└── Known Issues
    ├── Helm template validation            -> troubleshooting/helm-templates.md
    ├── Schema caching problems             -> troubleshooting/schema-caching.md
    ├── Version compatibility               -> troubleshooting/version-requirements.md
    └── Workspace detection failures        -> troubleshooting/workspace-detection.md
```

---

## Search Hints

Use these keywords and aliases when searching within this documentation set.

| Query / Alias | Canonical Term | Primary File |
|---|---|---|
| yaml lsp, yaml server, redhat yaml | yaml-language-server | patterns/yaml-language-server.md |
| k8s linting, kube validation | Kubernetes YAML validation | guides/setup-yaml-kubernetes.md |
| markdown lsp, md lsp | Marksman | patterns/marksman-integration.md |
| lsp config, lsp json, .lsp.json | lsp-json schema | concepts/lsp-json-schema.md |
| plugin root, plugin env, CLAUDE_PLUGIN_ROOT | plugin environment variable | concepts/plugin-architecture.md |
| auto install, install hook, hooks json | auto-installation hooks | patterns/auto-install-hooks.md |
| publish plugin, submit plugin | marketplace distribution | patterns/distribution-marketplace.md |
| mcp bridge, mcp wrapper, mcp-lsp | MCP-LSP wrapper | concepts/mcp-lsp-wrapper.md |
| offline install, no internet, disconnected | airgapped installation | guides/airgapped-install.md |
| helm error, helm validation | Helm template issue | troubleshooting/helm-templates.md |
| stale schema, schema not updating | schema cache | troubleshooting/schema-caching.md |
| server version, node version, compatibility | version requirements | troubleshooting/version-requirements.md |
| workspace not found, root detection | workspace detection | troubleshooting/workspace-detection.md |
| boostvolt, Ven0m0, official marketplace | existing marketplace plugins | references/sources.md |
| crd validation, custom resource | CRD support | patterns/yaml-language-server.md |
| trust, network, sandboxing | security | patterns/security.md |

---

## Reading Order

### For New Readers: Start Here

Follow this sequence if you are new to the domain:

1. [overview.md](./overview.md) - Understand the goal and architecture at a glance (5 min)
2. [glossary.md](./glossary.md) - Learn key terms before diving in (5 min)
3. [concepts/lsp-protocol.md](./concepts/lsp-protocol.md) - LSP protocol fundamentals (10 min)
4. [concepts/plugin-architecture.md](./concepts/plugin-architecture.md) - How Claude Code plugins work (10 min)
5. [concepts/lsp-json-schema.md](./concepts/lsp-json-schema.md) - The .lsp.json file reference (15 min)

### For Hands-On Implementers

After completing the foundation reading:

6. [guides/setup-yaml-kubernetes.md](./guides/setup-yaml-kubernetes.md) - Build yaml-language-server plugin
7. [guides/setup-marksman.md](./guides/setup-marksman.md) - Build Marksman plugin
8. [examples/hooks-install-script.md](./examples/hooks-install-script.md) - Wire up auto-installation
9. [patterns/security.md](./patterns/security.md) - Apply security constraints

### For Plugin Publishers

10. [patterns/distribution-marketplace.md](./patterns/distribution-marketplace.md) - Distribution model
11. [guides/publish-marketplace.md](./guides/publish-marketplace.md) - Submission walkthrough
12. [references/sources.md](./references/sources.md) - Review existing marketplace plugins

### For Troubleshooters

- [troubleshooting/README.md](./troubleshooting/README.md) - Start here for issue triage
- Jump directly to the specific issue file matching your symptom

### For Alternative Architecture Explorers

- [concepts/mcp-lsp-wrapper.md](./concepts/mcp-lsp-wrapper.md) - MCP-as-LSP bridge pattern
- [examples/mcp-lsp-tool-design.md](./examples/mcp-lsp-tool-design.md) - MCP tool schema examples
