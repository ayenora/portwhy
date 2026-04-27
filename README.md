# portwhy

**Explain why a port is busy.**

`portwhy` is a developer CLI tool for diagnosing occupied ports. Instead of dumping raw system output, it tells you what process owns a port, where it came from, what framework it likely is, and what to do next.

> Not just _what_ uses your port — but _why_.

---

## The problem

```
Error: listen EADDRINUSE: address already in use :::3000
```

You run `lsof -i :3000`. You get a PID. You still don't know:

- Is it a Vite server? A Docker container? Something from yesterday?
- Which project folder started it?
- Is it safe to kill?

`portwhy` answers those questions.

---

## Quick start

```bash
portwhy 3000
```

```
Port 3000 is busy

Process
  PID:      12345
  Name:     node
  Command:  npm run dev
  CWD:      /Users/stas/projects/my-app

Likely source
  Vite dev server

Suggested actions
  portwhy kill 3000
  kill 12345
```

---

## Installation

### npm

```bash
npm install -g portwhy
```

Or run without installing:

```bash
npx portwhy 3000
```

### PyPI

```bash
pip install portwhy
```

---

## Usage

```bash
portwhy 3000              # inspect port
portwhy 3000 --json       # machine-readable output
portwhy kill 3000         # kill with confirmation prompt
portwhy kill 3000 --yes   # kill without prompt
```

See [docs/cli.md](docs/cli.md) for the full command reference.

---

## Status

Early development. Package names are reserved on npm and PyPI; current published versions are placeholders. Real functionality is being added incrementally — see [docs/roadmap.md](docs/roadmap.md).

**Supported platforms:** macOS, Linux (Windows planned)

---

## Documentation

- [CLI reference](docs/cli.md)
- [Architecture](docs/architecture.md)
- [Roadmap](docs/roadmap.md)
- [Contributing](docs/contributing.md)

---

## License

MIT
