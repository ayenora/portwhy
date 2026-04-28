# TODO

First implementation tasks for portwhy. Scope is **v0.1.0** from [roadmap.md](roadmap.md):
`portwhy <port>` on macOS with friendly formatted output and clear messages.

Each task lists a concrete verification check so it can be closed without ambiguity.

---

## 1. Set up Python test infrastructure

Add `pytest` to dev dependencies and create `tests/` with a `fixtures/` subfolder for
captured command output. No production code yet — just the scaffold.

- Add `[project.optional-dependencies] dev = ["pytest"]` to [pyproject.toml](../pyproject.toml).
- Create `tests/__init__.py` and `tests/fixtures/`.
- Add a trivial `tests/test_smoke.py` that imports `portwhy` and asserts it loads.
- Wire `make test` to run `pytest`.

**Verify:** `make test` passes from a clean checkout.

---

## 2. Capture real `lsof` output as a fixture

Before writing a parser, record real input. Run `lsof -i :<port> -sTCP:LISTEN -n -P`
against a known listener (e.g. `python -m http.server`) and save the verbatim output.

- Save to `tests/fixtures/lsof_listen_node.txt` (and one or two more variants:
  empty result, multi-line result).
- Document the exact command used to generate each fixture in a header comment.

**Verify:** fixtures exist, are plain text, contain no machine-specific paths
beyond what the parser will normalize.

---

## 3. Implement `lsof` listener parser

Pure function: `parse_lsof_listen(stdout: str) -> ListenerInfo | None`. No subprocess
calls inside the parser — it takes a string in, returns a dataclass out.

- Define a small dataclass matching the `process` block of the data model in
  [architecture.md](architecture.md#data-model): `pid`, `ppid`, `name`, `command`, `cwd`.
- Parse only the fields available from `lsof -i` output; leave `command` and `cwd`
  as `None` for now (they come from `ps` and a second `lsof` call — task 5).
- Tests drive off the fixtures from task 2.

**Verify:** parser tests pass; parser does not call `subprocess` (grep the source).

---

## 4. Validate port input

`portwhy <port>` must reject anything that is not an integer in `1..=65535` with
a clear message and a non-zero exit code.

- Implement validation in [src/portwhy/\_\_main\_\_.py](../src/portwhy/__main__.py).
- Errors go to stderr; exit code is `2` (matches Unix convention for usage error).
- Tests: invalid string, `0`, `65536`, negative number, missing argument.

**Verify:** all invalid-input tests pass; valid integers proceed to the next stage.

---

## 5. Wire up the macOS inspect path end-to-end

Glue the pieces together: argv → validate → run `lsof` → parse → enrich with `ps`
and `lsof -d cwd` → format → print.

- Platform check: bail with a clear message on non-Darwin/Linux for now.
- Subprocess calls live in a dedicated module so they can be mocked in tests.
- The formatter takes the dataclass and produces the human output shown in
  [README.md](../README.md#quick-start).

**Verify:** `portwhy <busy-port>` on macOS prints PID, name, command, CWD;
`portwhy <free-port>` prints a clear "no process is listening on port N" message
and exits `0`.

---

## 6. Handle "no process found" cleanly

This is its own task because the empty-result path is easy to mishandle (parser
returning `None` vs. raising; exit code; wording).

- Empty `lsof` output → print `Port <N> is free` to stdout, exit `0`.
- Decide and document: free port is **not** an error.
- Add a fixture for empty `lsof` output and a test asserting the exit code.

**Verify:** test for empty fixture asserts both stdout text and exit code `0`.

---

## 7. Decide the npm wrapper strategy

[bin/portwhy.js](../bin/portwhy.js) is currently a placeholder. Before any real
output is written from the JS side, pick one path and write it down in
[architecture.md](architecture.md):

- **Option A:** JS shells out to the installed `portwhy` Python binary.
- **Option B:** JS reimplements the same logic natively.
- **Option C:** Keep JS as a placeholder until the primary runtime is decided
  (this is what CLAUDE.md currently implies).

No code change is required — this task is to record the decision so future
tasks for the npm package have a clear target.

**Verify:** a short "npm package strategy" section exists in `architecture.md`
naming the chosen option and the reason.

---

## 8. Update CHANGELOG on first real release

When tasks 1–6 land, move the matching items from `[Unreleased] / Planned` into
a real `[0.1.0]` section in [CHANGELOG.md](../CHANGELOG.md) and tag the release.

**Verify:** `git tag` shows `v0.1.0`; CHANGELOG has a dated `[0.1.0]` entry.

<!-- dev-factory:intake processed 2026-04-28 -->
