# Architecture

## Repository layout

```
portwhy/
├── bin/
│   └── portwhy.js          # npm entry point
├── src/
│   └── portwhy/
│       ├── __init__.py
│       └── __main__.py     # Python entry point (main())
├── docs/
├── package.json
├── pyproject.toml
└── README.md
```

Both npm and PyPI packages live in the same repository. The long-term primary runtime is intentionally undecided — both wrappers stay minimal until that decision is made.

## Platform detection

Port and process inspection differs by OS. Platform detection is required before any system call.

### macOS / Linux

Find the listening process:

```bash
lsof -i :<port> -sTCP:LISTEN -n -P
```

Get process details:

```bash
ps -p <PID> -o pid,ppid,comm,args
```

Get working directory:

```bash
lsof -a -p <PID> -d cwd -Fn
```

### Linux alternatives

```bash
ss -ltnp 'sport = :<port>'
netstat -tulpn
```

### Windows (planned)

```powershell
netstat -ano | findstr :<port>
Get-Process -Id <PID>
```

## Data model

The normalized output shape used for `--json` and internal processing:

```json
{
  "port": 3000,
  "protocol": "tcp",
  "status": "busy",
  "process": {
    "pid": 12345,
    "ppid": 11111,
    "name": "node",
    "command": "npm run dev",
    "cwd": "/Users/stas/projects/my-app"
  },
  "detection": {
    "kind": "dev-server",
    "framework": "vite",
    "confidence": "medium"
  },
  "suggestions": [
    {
      "label": "Kill process",
      "command": "kill 12345",
      "destructive": true
    }
  ]
}
```

## Framework detection

Detection is best-effort. Confidence is always reported. `portwhy` never claims certainty when data is incomplete.

| Process | Command contains | Detected as |
|---|---|---|
| `node` | `vite` | Vite dev server |
| `node` | `next` | Next.js dev server |
| `node` | `react-scripts` | Create React App |
| `python` | `uvicorn` | Uvicorn / FastAPI |
| `python` | `flask` | Flask dev server |
| `ruby` | `rails` | Rails server |
| `docker-proxy` | — | Docker port mapping |

## Design principles

1. **Explain, do not dump.** Raw `lsof` output is a fallback, not the interface.
2. **Be safe by default.** Never kill a process without a clear user action.
3. **Zero config.** `portwhy 3000` must work immediately, no setup required.
4. **Stay small.** Lightweight CLI with minimal dependencies.
5. **Show confidence.** Uncertain detections are labeled as such.
6. **Script-friendly.** Machine-readable output via `--json`.
