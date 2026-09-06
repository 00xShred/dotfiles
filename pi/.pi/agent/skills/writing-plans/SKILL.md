---
name: writing-plans
description: Use only for genuinely large or multi-step tasks, before touching code
---

# Writing Plans

Use this skill only when the work is large enough to need coordination across multiple files, components, or implementation stages. Do not use it for small fixes, one-file changes, or straightforward features.

**Announce at start:** "I'm using the writing-plans skill to create the implementation plan."

## Plan format

Write the plan to:
`docs/superpowers/plans/YYYY-MM-DD-<feature-name>.md`

Keep it concise and specific. Start with:

```markdown
# [Feature Name] Implementation Plan

**Goal:** [One sentence]

**Approach:** [Short description of the solution]

**Files:**
- Create: `exact/path`
- Modify: `exact/path`
- Test: `exact/path`

---
```

Then list the implementation steps in dependency order. Each step should state:

- What changes
- Which exact files are involved
- Any important interfaces, behavior, or constraints
- How to verify it

Include actual function names, paths, commands, and expected outcomes when they matter. Avoid vague instructions, speculative work, and unnecessary detail.

## Scope check

If the work contains independent subsystems, recommend separate plans. Keep each plan focused enough to implement and verify on its own.

## Final check

Before presenting the plan, verify that:

- Every requirement is covered by a step.
- Files, names, and dependencies are consistent.
- No placeholders or vague steps remain.
- The plan is no longer than necessary.

After saving, tell the user the file path. Do not commit changes or include commit steps; the user handles commits.
