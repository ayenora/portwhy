# Contributing

Contributions are welcome once the first real implementation lands.

## Good first issues

- Improve output formatting
- Add Linux command support
- Add parser fixtures for `lsof` / `ss` output
- Improve framework detection heuristics
- Write documentation examples

## Development setup

```bash
# Python
pip install -e .
portwhy 3000

# npm
node bin/portwhy.js 3000
```

See the [Makefile](../Makefile) for all available commands (`make help`).

## Before submitting

Run the full check suite:

```bash
make fmt        # auto-format
make lint       # ruff + eslint
make typecheck  # mypy
make test       # pytest
```

All checks must pass before opening a pull request.

## Implementation rules

- Do not silently kill processes — destructive actions require explicit user confirmation.
- Do not require root privileges for normal port inspection.
- Do not add network calls or telemetry.
- Do not hard-code user-specific paths.
- Keep output stable enough to test against (use fixtures, not live processes).
- Implement `--json` before relying on output in scripts.
- Platform detection (macOS / Linux / Windows) is required because system commands differ.

## Testing approach

- Prefer parser tests using **captured command output fixtures** over tests that require a live running process.
- Cover: invalid port input, port not in use, `lsof` output parsing, JSON output shape, kill confirmation gate.
- Avoid tests that depend on the state of the developer's machine.
