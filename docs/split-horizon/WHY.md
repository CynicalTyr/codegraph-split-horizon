# Why these mods exist

Short backstory. Install paths live in `mods/*/INSTALL.md`. Teaching order: [../HOW_IT_WORKS.md](../HOW_IT_WORKS.md).

We ran CodeGraph in anger on a box with two personalities: an unattended local autonomous/ML operator, and a Cursor architect. Colby's product is excellent at "index this git repo and explore." It does not know you pinned MCP at `${workspaceFolder}` while the runtime lives one tree over. It does not know the architect's `codegraph sync` stole the operator WAL. It does not know `include` on a home directory is how you ingest 23k stale Python files. It does not know a CIFS share of another computer is not a local graph.

Each mod is one of those scars, filed into something you can install.

- 00–02: two consumers, one serve path, writer UID = SQLite UID
- 03–05: non-git fence, extension shims, empty-explore is a measurement
- 06–08: unwatched `projectPath`, remind-not-spawn, agent protocol
- 09–10: findability of config YAML; live `*.db` is not an AST
- 11–14: N roots, slow-disk first index, foreign-mount refuse, operator-own timer

The graph is a messenger (symbols + callers), not an oracle. Pair it with FTS and ANN.

Do not send a 20-file docs PR at Colby unless he asks. Credit him. Use his binary.
