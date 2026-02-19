---
description: "Multi-phase research pipeline with parallel agents, firecrawl-powered scraping, skeleton-first scaffolding, and quality gates. Produces indexed documentation under .claude/docs/<domain>/"
allowed-tools:
  - Task
  - Bash
  - Read
  - Glob
  - AskUserQuestion
---

You are orchestrating a multi-phase research pipeline. Follow these phases EXACTLY in order. The user's research topic is: $ARGUMENTS

---

## Phase 1: PLAN (sequential — 1 agent)

Launch a **single** Task agent to create the research plan:

```
Task(subagent_type="planner", model="sonnet", prompt="<user's research topic + any context>")
```

The planner agent will return a structured plan with: `domain_name`, `research_areas`, `proposed_files` (per section), and `estimated_complexity`.

**Parse the plan output** to extract:
- `domain_name` (kebab-case folder name)
- File lists: `concepts`, `patterns`, `examples`, `guides`, `troubleshooting` (comma-separated basenames)

---

## Phase 1.5: DEPTH SELECTION

Use AskUserQuestion to ask the user:

**Question**: "What research depth would you like?"
**Options**:
1. **Quick Summary** — "Rapid survey producing a concise reference guide with key concepts, examples, and references (~5 min)"
2. **Full Research Pipeline** — "Comprehensive multi-agent research with deep analysis, cross-reference verification, firecrawl-powered scraping, and fully indexed artifacts (~15-25 min)"

---

## Phase 2: SCAFFOLD (deterministic shell script — <2s)

Run the scaffold script to create the skeleton file tree:

```bash
bash "${CLAUDE_PLUGIN_ROOT}/scripts/scaffold-docs.sh" "<domain_name>" "<concepts>" "<patterns>" "<examples>" "<guides>" "<troubleshooting>"
```

This creates all directories and skeleton `.md` files with valid YAML frontmatter under `.claude/docs/<domain_name>/`.

---

## Quick Path (if user selected "Quick Summary")

If the user chose Quick Summary, skip Phases 3-4 and run an abbreviated pipeline:

1. Launch a **single** Task agent for abbreviated research:
   ```
   Task(subagent_type="quick-res", model="sonnet", prompt="Research topic: <topic>. Plan: <summarized plan>. Perform a rapid but thorough survey covering the top 5-7 most important aspects. Use firecrawl_search for discovery and firecrawl_scrape for key pages. Include code examples where applicable. Do NOT write any files — return your findings as structured text.")
   ```

2. Launch a **single** Task agent to write all files:
   ```
   Task(subagent_type="quick-writer", model="sonnet", prompt="Write documentation to .claude/docs/<domain_name>/. Research findings: <summarized quick research output>. Populate ALL skeleton files created by scaffold-docs.sh using Edit tool. Every file must have complete YAML frontmatter with title, tags, created, domain, and section fields.")
   ```

3. **Done** — output the file tree and exit.

---

## Phase 3: RESEARCH (parallel — 2-3 agents)

Launch **2 or 3** Task agents in a **SINGLE message** (this is critical for parallelism):

```
# In ONE message, launch all research agents simultaneously:

Task(subagent_type="primary-res", model="sonnet",
     prompt="Research plan:\n<full plan output>")

Task(subagent_type="deep-res", model="sonnet",
     prompt="Research plan:\n<full plan output>")

# Only launch supplemental if estimated_complexity is "complex":
Task(subagent_type="supplemental-res", model="sonnet",  # OPTIONAL
     prompt="Research plan:\n<full plan output>")
```

**IMPORTANT**: All Task calls MUST be in a SINGLE message to execute in parallel.

Collect all results. **Summarize** each agent's output to key findings (do not pass raw output to keep context lean).

---

## Phase 4: VERIFY + SYNTHESIZE (sequential — 2 agents)

### 4a: Verify

Launch a Task agent to cross-reference and verify:

```
Task(subagent_type="verification", model="sonnet",
     prompt="Primary research findings:\n<summarized primary>\n\nDeep research findings:\n<summarized deep>\n\nSupplemental findings:\n<summarized supplemental if available>")
```

### 4b: Synthesize

Launch a Task agent to map verified content to file paths:

```
Task(subagent_type="synthesis", model="sonnet",
     prompt="Domain: <domain_name>\nScaffold directory: .claude/docs/<domain_name>/\n\nVerified research:\n<summarized verification output>")
```

---

## Phase 5: WRITE (parallel — up to 6 agents)

Launch **multiple** section-writer agents in a **SINGLE message**:

```
# In ONE message, launch writers for each section with content:

Task(subagent_type="writer", model="sonnet",
     prompt="Your assigned section: concepts\nTarget directory: .claude/docs/<domain>/concepts/\n\nSynthesized content for this section:\n<concepts content blocks>")

Task(subagent_type="writer", model="sonnet",
     prompt="Your assigned section: patterns\nTarget directory: .claude/docs/<domain>/patterns/\n\nSynthesized content:\n<patterns content blocks>")

Task(subagent_type="writer", model="sonnet",
     prompt="Your assigned section: examples\nTarget directory: .claude/docs/<domain>/examples/\n\nSynthesized content:\n<examples content blocks>")

Task(subagent_type="writer", model="sonnet",
     prompt="Your assigned section: guides\nTarget directory: .claude/docs/<domain>/guides/\n\nSynthesized content:\n<guides content blocks>")

Task(subagent_type="writer", model="sonnet",
     prompt="Your assigned section: troubleshooting\nTarget directory: .claude/docs/<domain>/troubleshooting/\n\nSynthesized content:\n<troubleshooting content blocks>")

Task(subagent_type="writer", model="sonnet",
     prompt="Your assigned section: root\nTarget files: .claude/docs/<domain>/overview.md, glossary.md, INDEX.md, METADATA.md, references/sources.md\n\nSynthesized content:\n<root content blocks>\n\nIMPORTANT: INDEX.md must link to ALL files in the tree.")
```

**IMPORTANT**: All Task calls MUST be in a SINGLE message for parallel execution. Only launch writers for sections that have content.

---

## Phase 6: REVIEW + FIX (sequential — quality gate)

### 6a: Review

Launch the quality reviewer:

```
Task(subagent_type="reviewer", model="sonnet",
     prompt="Domain: <domain_name>\nTarget directory: .claude/docs/<domain_name>/")
```

### 6b: Quality Gate

Parse the reviewer's output. Check if the **first line** starts with `QUALITY: PASS` or `QUALITY: FAIL`.

- **If PASS**: Output the final file tree, summary statistics, and exit.
- **If FAIL**: Proceed to revision (ONE cycle only).

### 6c: Revision (only if FAIL, max 1 cycle)

```
Task(subagent_type="revision", model="sonnet",
     prompt="Domain: <domain_name>\nTarget directory: .claude/docs/<domain_name>/\n\nQuality review report:\n<full review output>")
```

After revision completes, output the final file tree and summary. Do NOT re-run the reviewer — one revision cycle is the cap.

---

## Final Output

After the pipeline completes (either path), output:
1. The complete file tree (`Glob` on `.claude/docs/<domain_name>/**/*.md`)
2. Summary: number of files, sections covered, quality status
3. How to browse: "Read .claude/docs/<domain_name>/INDEX.md for navigation"
