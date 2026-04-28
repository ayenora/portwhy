# Agent Executor Playbook

## Core Rules

- Ambiguous requirements → **stop and list conflicts before coding**
- Same input → same output (determinism required)
- One source of truth — no parallel logic for the same rule
- No silent failures, no magic values
- No changes outside defined Scope

---

## Task Structure (expected input)

```
Task <ID> — <Title>
Goal / Dependencies / Scope (in) / Out of scope
Invariants / Data contracts / Implementation requirements
Error handling / Testing / Acceptance criteria
```

---

## Implementation Checklist

- [ ] Source of truth identified and used
- [ ] No logic duplicated across modules
- [ ] Layer boundaries respected (adapter / pipeline / CLI / config)
- [ ] All errors surface explicitly — no silent failures
- [ ] Logging in place for orchestrator actions
- [ ] JSON output contracts match spec exactly
- [ ] No GitHub mutations in read-only contexts
- [ ] Output JSON contract strictly followed (block present, schema valid)
- [ ] Operation is idempotent (safe to re-run without duplicate side effects)

---

## Testing Policy

**Cover:** pipeline state logic · JSON parsing · config validation · label classification · edge cases (no label, multiple labels, empty repo)

**Do NOT autotest:** actual subprocess calls to `gh`/`codex`/`claude` — mock at the adapter boundary

---

## Output Contract Rule

- Every agent invocation MUST end stdout with a machine-readable JSON block.
- The orchestrator uses ONLY this JSON — no free-text parsing.
- Missing or invalid JSON → orchestrator sets `blocked` and posts comment.
- See [OUTPUT_CONTRACTS.md](../../OUTPUT_CONTRACTS.md) for exact schemas per agent.

## Idempotency Requirement

- Every operation must be safe to re-run without additional side effects.
- Running an operation twice must produce the same result as running it once.
- No duplicate GitHub comments, label changes, or worktree creations on repeated invocation.

## Communication Model

- Agents (Codex, Claude Code) never communicate with each other directly.
- The orchestrator is the sole mediator: it passes the output of one agent as the input to the next.
- Direct agent-to-agent communication is a contract violation.

## Side Effect Policy

- Side effects (label changes, GitHub comments, worktree creation, branch push) must be explicitly listed in the task's Implementation Requirements.
- Default posture: **no mutation**.
- Forbidden for all agents: `git push`, `rm -rf`, any operation not in `allowedTools`.

## Failure Handling Policy

- One automatic retry is allowed on agent `ERROR` (Claude Code only — see [OUTPUT_CONTRACTS.md](../../OUTPUT_CONTRACTS.md)).
- If the retry also fails → escalate to `blocked`, post comment, stop.
- No infinite loops. Every failure path must terminate or escalate.

---

## Required Report (one message)

```md
## Summary

## Files Changed
- path/to/file — what changed

## Contract Mapping
- Requirement A → how fulfilled
- Requirement B → how fulfilled

## Acceptance Mapping
- Criterion 1 → ✅/❌
- Criterion 2 → ✅/❌

## Test Results
- ruff / mypy
- pytest

## Residual Risks / Follow-ups
- risks, tech debt, deferred items
```
