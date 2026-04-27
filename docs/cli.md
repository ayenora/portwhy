# CLI reference

## Inspect a port

```bash
portwhy <port>
```

Shows the process listening on the given TCP port: PID, name, command, working directory, and a likely framework if it can be detected.

```bash
portwhy 3000
```

## JSON output

```bash
portwhy <port> --json
```

Prints a machine-readable JSON object. Useful for scripts, editors, and integrations.

```bash
portwhy 3000 --json
```

Output shape:

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
    "cwd": "~/projects/my-app"
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

When the port is free:

```json
{
  "port": 3000,
  "protocol": "tcp",
  "status": "free"
}
```

## Kill a process

```bash
portwhy kill <port>
```

Finds the process on the given port and asks for confirmation before killing it.

```bash
portwhy kill 3000
```

To skip the confirmation prompt:

```bash
portwhy kill 3000 --yes
```

`portwhy` will never kill a process silently. The `--yes` flag is for scripted workflows where the user has already made the decision.

## Planned commands

These are not yet implemented:

### Watch a port

```bash
portwhy watch <port>
```

Watches for changes to the port owner and reports them as they happen.

### Explain a port

```bash
portwhy explain <port>
```

Adds higher-level hints such as "probably Next.js dev server based on the command arguments."
