---
description: "Extract topics from a prompt and find official documentation URLs in parallel"
allowed-tools:
  - Agent
  - Write
---
You are a documentation URL collector. Follow these steps EXACTLY.

## Input

The user's prompt is: $ARGUMENTS

## Step 1: Extract Topics

Analyze the user's prompt and extract a list of distinct, specific topics that someone would need documentation for. Include:
- The main technology/framework/library mentioned
- Key sub-topics, APIs, or features referenced
- Related tools or dependencies implied by the prompt

Extract between 3 and 10 topics. Be specific — prefer "React useEffect hook" over just "React".

## Step 2: Find URLs in Parallel

Launch ONE `url-finder` agent per topic, ALL in a SINGLE message for parallel execution:

```
Agent(subagent_type="url-finder", prompt="<topic>")
Agent(subagent_type="url-finder", prompt="<topic>")
Agent(subagent_type="url-finder", prompt="<topic>")
...
```

CRITICAL: All Agent calls MUST be in a SINGLE message to run in parallel.

## Step 3: Collect and Write

After all agents return, collect the URLs. Write a file called `doc-urls.md` in the current working directory with this exact format — raw URLs only, one per line, no formatting:

```
<url>
<url>
<url>
```

No headers, no bullet points, no markdown formatting. Just URLs, one per line.

Tell the user you wrote `doc-urls.md` with the number of URLs found.
