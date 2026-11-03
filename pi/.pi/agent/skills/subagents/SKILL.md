---
name: subagents
description: invoke this skill when the user asks you to use subagents
---

# Subagents

Each subagent is headless, has its own context window, cannot see the parent conversation, cannot ask the user, and cannot spawn subagents or workflows. Give every child a self-contained prompt with paths, constraints, and the expected report.

## Harness & Model Selection Strategy

**Default Policy:** Omit model and harness to inherit the exact active chat model and provider through `pi`. Explicit tier changes must stay in the same model family and provider and use the latest available generation. This includes GLM and all other families, not just Claude/GPT. Never guess model IDs or use hardcoded version fallbacks. Unverified tier availability → inherit; adjust reasoning effort instead. The `subagent-model-policy` extension enforces this at tool execution.
- **Claude / Anthropic sessions:** Harness `claude` (or `pi`), using current generation.
- **OpenAI / Codex sessions:** Harness `codex` (or `pi`), using current generation.
- **Other sessions (DeepSeek, Kimi, Antigravity):** Harness `pi` (inherits directly).

### Task-Aware Model Tiers

| Task Gravity | Claude Family (`claude`) | Codex Family (`codex`) | Other Pi Providers (`pi`) |
|---|---|---|---|
| **Critical / Heavy** (complex architecture, tough refactors) | Current-generation flagship (effort: `high`/`max`) | Current-generation flagship (effort: `high`/`max`) | Inherit exact parent model (effort: `high`/`max`) |
| **Standard / Default** | Current-generation model (effort: `medium`/`high`) | Current-generation model (effort: `medium`) | Inherit exact parent model & thinking |
| **Light / Recon** (code search, file exploration, triage) | Current-generation fast model (effort: `low`/`minimal`) | Current-generation fast model (effort: `minimal`) | Inherit exact parent model (effort: `low`/`minimal`) |

**Thinking budgets:** `off`, `minimal`, `low`, `medium`, `high`, `xhigh`, `max`. The extension maps these to Claude thinking-token budgets: 0, 1,024, 4,096, 10,000, 16,000, 32,000, and 63,999 tokens respectively.

Requires Claude Code to be installed and authenticated.

## Pi Harness

**Harness:** `pi`
**Prompt nicknames:** “pi”, “pi agent”, “pi subagent”
**Usage:** Use when the user requests the pi harness or when in-process pi tool inheritance is needed. Inherits the parent model and thinking level when `model` or `reasoning_effort` is omitted.

**Thinking budgets:** `off`, `minimal`, `low`, `medium`, `high`, `xhigh`, `max`. The extension maps these to Claude thinking-token budgets: 0, 1,024, 4,096, 10,000, 16,000, 32,000, and 63,999 tokens respectively.

Requires Claude Code to be installed and authenticated.

## Codex Harness

**Harness:** `codex`
**Prompt nicknames:** “codex”, “Codex CLI”, “codex agent”, “codex subagent”
**Best default:** Current-generation Codex model, matching parent generation. Prefer `pi` with model omitted when model generation cannot be reliably determined. Never pin a specific older model ID.

**Thinking budgets accepted by the extension:** `off`, `minimal`, `low`, `medium`, `high`, `xhigh`, `max`. Codex maps these to the nearest effort supported by the selected model; `off`/`minimal` become `minimal`, while `max` becomes the highest extension-supported Codex effort.

Requires the Codex CLI to be installed and authenticated.

## Spawn and Manage

Call `subagent_spawn` with a complete `prompt`, short `name`, chosen `harness`, and optional `working_dir`, `model`, and `reasoning_effort`. At most four subagents run concurrently.

- `subagent_check({ id })`: peek without blocking.
- `subagent_list()`: list all runs.
- `subagent_wait({ ids })`: block only when results are required to proceed.
- `subagent_cancel({ ids })`: stop runs while preserving partial transcripts.
- `/subagents`: inspect or take over a run interactively.

Results return automatically. After spawning, continue useful parent work instead of immediately waiting.
