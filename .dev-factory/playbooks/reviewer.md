# Agent Reviewer Playbook

## Severity Levels

| Level | Condition |
|-------|-----------|
| **Blocker** | Output contract violated · wrong state transition · crash · incorrect label handling |
| **Major** | Incomplete requirements · logic duplicated · missing coverage for critical path |
| **Minor** | Structural issues without contract breakage |
| **Nit** | Naming, style, readability |

---

## Review Checklist

### Code & Architecture
- [ ] No logic duplication
- [ ] Layer boundaries respected (adapter / pipeline / CLI / config)
- [ ] Single source of truth enforced
- [ ] No hidden logic outside scope
- [ ] No magic values

### Contract & Behavior
- [ ] All invariants hold
- [ ] Behavior is deterministic
- [ ] Fallback defined for unparseable agent output
- [ ] No regressions in state machine transitions
- [ ] Machine-readable JSON status block present at end of stdout
- [ ] Idempotency preserved — re-running produces no duplicate side effects
- [ ] No direct agent-to-agent communication

### Data & Compatibility
- [ ] JSON output schemas match [OUTPUT_CONTRACTS.md](../../OUTPUT_CONTRACTS.md)
- [ ] Config fields validated on load
- [ ] State label changes are backward-compatible

### Error Handling
- [ ] All errors surface explicitly — no silent failures
- [ ] Orchestrator errors set `blocked` and post comment
- [ ] CLI errors print to stderr and exit non-zero
- [ ] Logging present for all subprocess calls
- [ ] Failure behavior follows retry/escalation rules (retry once → blocked)

### Tests
- [ ] Critical pipeline logic covered
- [ ] Edge cases covered (no label, multiple labels, blocked state)
- [ ] No false-green tests (assertions are meaningful)

---

## Acceptance Statuses

- **Accepted** — all criteria met
- **Accepted with follow-up** — mergeable, deferred items logged
- **Changes requested** — Blocker or Major found

---

## Review Output Template

```md
Status: <Accepted | Accepted with follow-up | Changes requested>

Findings:
1. [Severity] description — file:line
2. ...

Next iteration:
1. ...
```
