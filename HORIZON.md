# HORIZON

Complementary pack on Colby McHenry's CodeGraph (`@colbymchenry/codegraph` ≥ 1.6.0). His `AGENTS.md` is for contributing to the engine. This file is for **using** two (or N) indexes on one box. Curriculum: [docs/HOW_IT_WORKS.md](docs/HOW_IT_WORKS.md).

The **architect** is you in a CLI IDE (Cursor or anything that speaks MCP). The **operator** is the unattended local loop — on-box models, tools, the process that still has a job when the IDE is closed. They must not share a SQLite file. They must not share a writer UID.

`serve --mcp --path` has one root. Pin it to the operator corpus. Every other tree is `projectPath` / `--path`. `projectPath` has no live watcher.

`include` adds. `exclude` fences. `deprioritize` ranks. On a non-git home, a fat `include` still walks dump trees.

Explore ranks symbols. Mapped `.md`/`.sh`/`.html` often have zero. Use `horizon-node`. Never `language:bash`.

The graph is a **messenger**, not an oracle. Symbols and callers live here. Literals belong to FTS. Meaning belongs to ANN. Pair them. Empty retrieval is not proof of absence. `codegraph files --format flat` is the census.

YAML in the graph is how agents **find** config. Do not print values.

Do not edit `src/` or `codegraph-kernel/` to "fix" split-horizon. Install a mod.

```bash
./horizon.sh list
./horizon.sh info 00-split-horizon-core
./horizon.sh install 00-split-horizon-core --dry-run \
  --operator-root /tmp/horizon-op --architect-home /tmp/horizon-arch
./horizon.sh uninstall 00-split-horizon-core
```

## Broke it

| Symptom | Look at |
| --- | --- |
| readonly database | mod 02 — architect wrote the operator WAL (or `files --path` as the wrong UID) |
| explore misses runtime | mod 01 — serve pinned to architect home |
| first index never ends | mod 03 — you indexed a home with include-as-whitelist |
| `.md` invisible | 04 then 05 |
| skills stale | 06 / 07 |
| cannot find the identity YAML | 09 |
| index ate a live `*.db` | 10 |
| first `--force` on USB died | 12 — `CODEGRAPH_NO_WATCHDOG`; unlock only if lock PID is dead |
| you indexed another computer | 13 |
| operator graph stale after laptop-lid | 14 (06 is architect-only) |

Human ten minutes: [START_HERE.md](START_HERE.md). Agent protocol: [mods/AGENT_INDEX.md](mods/AGENT_INDEX.md).
