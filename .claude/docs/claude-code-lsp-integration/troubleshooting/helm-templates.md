---
title: "Issue: Helm Template Files Not Validating"
tags: [helm, yaml-language-server]
created: "2026-02-19"
related: ["../patterns/yaml-language-server.md", "../examples/yaml-lsp-config.md"]
domain: "claude-code-lsp-integration"
section: "troubleshooting"
---

# Issue: Helm Template Files Not Validating

## Symptom

Helm chart template files (in `templates/` directory) show hundreds of YAML parse errors. Every Go template directive (`{{ .Values.foo }}`, `{{- if }}`, `{{ range }}`) is flagged as invalid YAML.

## Root Cause

yaml-language-server parses files as standard YAML. Go template syntax (`{{ }}`) is NOT valid YAML. The parser cannot distinguish between YAML content and template directives, producing false positives on every template expression.

## Solutions

### Solution 1: Exclude templates from Kubernetes schema (Recommended)

Add a negation glob to exclude template directories:

```json
"yaml.schemas": {
  "kubernetes": [
    "/*.yaml",
    "/*.yml",
    "!**/templates/**"
  ]
}
```

This validates `values.yaml`, `Chart.yaml`, and non-template YAML files while skipping templates entirely.

### Solution 2: Use per-file modeline override

Add an empty schema modeline to template files to suppress validation:

```yaml
# yaml-language-server: $schema=
{{- if .Values.enabled }}
apiVersion: v1
kind: ConfigMap
...
```

This is per-file and harder to maintain across many templates.

### Solution 3: Use helm-ls as a proxy (Experimental)

[helm-ls](https://github.com/mrjosh/helm-ls) pre-renders Go templates, then forwards the resulting YAML to yaml-language-server:

```json
{
  "helm": {
    "command": "helm_ls",
    "args": ["serve"],
    "extensionToLanguage": {
      ".tpl": "helm",
      ".yaml": "helm"
    },
    "settings": {
      "helm-ls": {
        "yamlls": {
          "path": "yaml-language-server",
          "config": {
            "schemas": { "kubernetes": ["**/*.yaml"] },
            "validate": true
          }
        }
      }
    }
  }
}
```

**Caveat**: helm-ls is experimental and can still produce errors when templates are partially edited.

## Recommendation

Start with Solution 1 (exclude templates). It's the simplest and most reliable. Add helm-ls as a separate plugin later if Helm template support becomes critical.

## See Also

- [../patterns/yaml-language-server.md](../patterns/yaml-language-server.md) -- Schema configuration
- [../examples/yaml-lsp-config.md](../examples/yaml-lsp-config.md) -- Config with Helm exclusion
