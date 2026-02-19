# Claude Code LSP Integration - Research Metadata

---

## Research Domain

**Domain Name:** claude-code-lsp-integration
**Full Title:** Claude Code Plugin Development for LSP Integration
**Domain Path:** `.claude/docs/claude-code-lsp-integration/`

---

## Research Scope

**Primary Objective:** Document how to build Claude Code plugins that integrate
Language Server Protocol (LSP) servers, with specific focus on two target servers:

1. Red Hat `yaml-language-server` for Kubernetes YAML validation and schema
   enforcement.
2. `marksman` for Markdown document authoring support (cross-references,
   completions, diagnostics).

**In Scope:**
- Claude Code plugin system: manifest format, directory layout, environment
  variables, lifecycle hooks
- `.lsp.json` file format: complete field-by-field schema reference
- yaml-language-server: configuration, Kubernetes schema priority ordering,
  CRD validation, programmatic API, settings reference
- Marksman: configuration, workspace requirements, supported LSP features
- Auto-installation hooks: `hooks.json` design and shell install scripts for
  both servers
- Distribution: publishing plugins to the Claude Code marketplace
- MCP-LSP wrapper alternative: the `axivo/mcp-lsp` pattern using the MCP SDK
  to expose LSP capabilities as MCP tools
- Security: network access model, airgapped operation, plugin trust model
- Known issues: Helm template false positives, schema caching, version
  compatibility matrix, Marksman workspace detection

**Out of Scope:**
- General LSP server development (building a new language server from scratch)
- LSP protocol specification details beyond what is needed to configure plugins
- Non-Kubernetes YAML use cases (e.g., Docker Compose, GitHub Actions schemas)
  except where the same yaml-language-server configuration applies
- IDE integrations other than Claude Code (VS Code, Neovim, etc.)
- Paid or enterprise-only Claude Code features not publicly documented

---

## Date and Agents

**Research Date:** 2026-02-19
**Agents Involved:**
- Research agent(s): gathered raw source material from official docs, GitHub
  repositories, and marketplace plugin examples
- Synthesis agent: consolidated and structured the 12 content sections
- Index Architecture agent (this file): designed folder structure, INDEX.md,
  and METADATA.md

**Model:** claude-sonnet-4-6

---

## Coverage Summary

### Fully Covered

| Topic | Depth | Primary File |
|---|---|---|
| Plugin manifest format | Deep | concepts/plugin-architecture.md |
| CLAUDE_PLUGIN_ROOT variable | Deep | concepts/plugin-architecture.md |
| .lsp.json complete schema | Deep | concepts/lsp-json-schema.md |
| yaml-language-server Kubernetes config | Deep | patterns/yaml-language-server.md |
| yaml-language-server settings reference | Deep | patterns/yaml-language-server.md |
| yaml-language-server CRD support | Moderate | patterns/yaml-language-server.md |
| Marksman configuration | Deep | patterns/marksman-integration.md |
| Marksman workspace requirements | Deep | patterns/marksman-integration.md |
| Auto-install hooks.json design | Deep | patterns/auto-install-hooks.md |
| Install scripts (bash) | Deep | examples/hooks-install-script.md |
| Marketplace distribution model | Moderate | patterns/distribution-marketplace.md |
| MCP-LSP wrapper (axivo) pattern | Moderate | concepts/mcp-lsp-wrapper.md |
| Security and network access | Moderate | patterns/security.md |
| Airgapped installation | Moderate | guides/airgapped-install.md |
| Helm template false positives | Deep | troubleshooting/helm-templates.md |
| Schema caching issues | Deep | troubleshooting/schema-caching.md |
| Version compatibility matrix | Moderate | troubleshooting/version-requirements.md |
| Workspace detection failures | Moderate | troubleshooting/workspace-detection.md |
| Existing marketplace plugin examples | Moderate | references/sources.md |
| Glossary (14 terms) | Deep | glossary.md |

### Partially Covered (Gaps Noted)

| Topic | Gap Description |
|---|---|
| yaml-language-server programmatic API | Public API surface documented; internal
implementation not verified against latest release |
| MCP SDK tool design | Pattern documented from axivo example; official MCP SDK
version compatibility not confirmed as of 2026-02 |
| Marketplace submission process | General process documented; exact form fields
and review timeline are subject to change |
| CRD schema generation tooling | Referenced tools noted but not comprehensively
benchmarked |

### Not Covered

| Topic | Reason |
|---|---|
| Building a new LSP server from scratch | Out of scope |
| Non-YAML / non-Markdown LSP integrations | Out of scope for this research run |
| Windows-specific installation paths | Research focused on Linux/macOS |
| Claude Code enterprise / Teams tier differences | Not publicly documented |

---

## Source References

Sources are rated on a three-point reliability scale:

- **High** - Official documentation, maintained by the project owner
- **Medium** - Community documentation, well-maintained third-party resources
- **Low** - Forum posts, issues, indirect references; verify before relying on

| Source | URL | Reliability | Notes |
|---|---|---|---|
| Claude Code official docs | https://docs.anthropic.com/claude-code | High | Primary plugin system reference |
| yaml-language-server GitHub | https://github.com/redhat-developer/yaml-language-server | High | Config schema, settings, release notes |
| Marksman GitHub | https://github.com/artempyanykh/marksman | High | Features, workspace requirements |
| LSP specification | https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/ | High | Protocol fundamentals |
| axivo/mcp-lsp | https://github.com/axivo/mcp-lsp | Medium | MCP-LSP wrapper reference implementation |
| boostvolt marketplace plugin | https://marketplace.claudecode.dev (search: boostvolt) | Medium | Existing yaml-language-server plugin example |
| Ven0m0 marketplace plugin | https://marketplace.claudecode.dev (search: Ven0m0) | Medium | Existing Markdown LSP plugin example |
| Anthropic official plugins | https://marketplace.claudecode.dev (search: Anthropic) | High | Official plugin distribution patterns |
| MCP SDK documentation | https://modelcontextprotocol.io/docs | High | MCP tool schema and SDK reference |
| Kubernetes JSON Schema store | https://github.com/SchemaStore/schemastore | Medium | Schema source for Kubernetes resource validation |
| Helm template documentation | https://helm.sh/docs/chart_template_guide/ | High | Helm templating behavior that causes YAML parse errors |

---

## Related Domains

These domains are related and may be useful for cross-domain navigation:

| Domain | Relationship | Notes |
|---|---|---|
| `claude-code-plugins` | Parent domain | General plugin development outside of LSP specifics |
| `model-context-protocol` | Sibling domain | MCP SDK used in the MCP-LSP wrapper alternative |
| `kubernetes-yaml` | Consumer domain | End-user workflows that this plugin supports |
| `lsp-protocol` | Foundation domain | Protocol fundamentals referenced in concepts/ |

---

## File Naming Conventions

All files in this documentation set follow these conventions:

- **Format:** kebab-case
- **Maximum length:** 40 characters (excluding `.md` extension)
- **Pattern:** `<noun>-<qualifier>.md` or `<verb>-<noun>.md` for guides
- **No version numbers in filenames** (versions are tracked in METADATA.md and
  within file content)
- **No generic names** (`config.md`, `notes.md`) - all names are descriptive

### Examples
- `yaml-language-server.md` (not `yaml.md` or `yaml-config.md`)
- `setup-yaml-kubernetes.md` (not `kubernetes-setup.md`)
- `auto-install-hooks.md` (not `hooks.md`)
- `mcp-lsp-wrapper.md` (not `alternative.md`)

---

## Revision History

| Date | Agent | Change Description |
|---|---|---|
| 2026-02-19 | Index Architecture agent | Initial structure created from synthesis output |

<!-- Future revisions: add rows above this comment -->
