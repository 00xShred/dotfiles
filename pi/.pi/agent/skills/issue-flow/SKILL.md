---
name: issue-flow
description: Sequential issue resolution loop from priority.md (analyze, confirm, implement, verify, CI, PR, cleanup, repeat). Use when user asks to work through priority issues or invokes /issue-flow.
---

# Issue Resolution Protocol

When resolving issues from `priority.md` or an issue tracker, execute this sequential loop:

1. **Pick next issue**: Read `priority.md` and any linked plan under `docs/plans/`.
2. **Analyze & Confirm**:
   - Inspect issue details (`gh issue view <id>` if available).
   - Summarize root problem, API/DB contract, and scope in ultra-terse caveman style.
   - Pause for user confirmation before proceeding.
3. **Suggested Implementation**:
   - Propose targeted changes across domain, DB, API/GraphQL, and tests.
   - Wait for user acknowledgment.
4. **Implementation Step**:
   - Ponytail mode: simplest working solution, minimal diff, reuse existing helpers, standard library first, zero speculative abstractions.
   - Preserve error handling, auth checks, and tenant isolation.
5. **Review & Verification**:
   - Format: `cargo fmt --all` (and check with `--check`).
   - Clippy: `cargo clippy --workspace --all-targets -- -D warnings`.
   - Run targeted unit and integration tests.
6. **Local CI**:
   - Run `./scripts/ci-local.sh` and ensure all checks, migrations, security audits, and tests pass.
7. **Cleanup**:
   - Delete the issue plan in `docs/plans/` (e.g. `rm docs/plans/<plan-file>.md`).
   - Remove the issue entry from `priority.md`.
8. **Git / PR Hand-off**:
   - Provide a single copy-pasteable terminal bash snippet with branch creation, commit, push, and PR creation — stop there.
   - The user merges PRs manually in the GitHub UI after watching CI pass. NEVER merge, squash, or close PRs from the CLI (`gh pr merge` is forbidden), and never delete branches or auto-close issues in the snippet. Let the PR body's `Closes #<id>` handle issue closing.
   - Never mention or invoke a `scripts/release-local.sh` — it does not exist. Releases are automated by the `release-please` GitHub Action (`.github/workflows/release.yml`) on push to `main`.
   - Never run release-please manually and never hand-edit `Cargo.lock` version entries — the workflow owns them.
9. **Release & Advance**:
   - No local release step. After the user merges to `main` in the UI, the release-please Action bumps the version, updates the changelog, and tags the GitHub release automatically.
   - Optionally offer `gh pr checks <num> --watch` so the user can watch CI from the terminal while still merging in the UI.
   - After the user confirms the merge: sync local main (`git pull origin main --tags`), verify the issue closed, and advance to the next issue in `priority.md`.
