# Extra CodeGraph roots (unwatched)

Primary serve (`codegraph serve --mcp --path`) is the operator corpus. Do not add a second serve.

List every other tree you actually ask questions about. Query them with `projectPath` / `--path`. After edits: `codegraph sync` as **that** DB's owner.

| Kind | Local path (you fill) | Query |
| --- | --- | --- |
| Architect home | | `projectPath` |
| Extra corpus 1 | | `--path` / `projectPath` |
| Extra corpus 2 | | `--path` / `projectPath` |

Never:

- `codegraph init /`
- one giant index of `$HOME`
- a network mount of another host (mod 13)
- MEDIA, model weights, `node_modules`, `.venv`

After any extra `codegraph.json` edit: `index --force` on **that** root.
