# Pi session archive

This private repository synchronizes Pi session JSONL files between devices.

Each device writes only to its own directory under `sessions/`; this avoids concurrent writes to the same JSONL file.

Current device: `desktop`

To sync this device's sessions:

```bash
./bin/sync-desktop
```

To open a session created on another device without copying it:

```bash
pi --session "$HOME/pi-sessions/sessions/<device>/<path-to-session>.jsonl"
```

Sessions may contain source code, terminal output, or secrets. Keep this repository private.
