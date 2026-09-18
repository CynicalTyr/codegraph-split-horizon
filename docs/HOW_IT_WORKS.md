# How this DLC sits on Colby McHenry's CodeGraph

Read this after his engine README (`docs/ENGINE.md` once this overlay sits on a fork; until then: [github.com/colbymchenry/codegraph](https://github.com/colbymchenry/codegraph)).

He built the indexer, the SQLite graph, `codegraph_explore`, and `serve --mcp`. You install **`@colbymchenry/codegraph` ≥ 1.6.0**. This pack does not compile his kernel and does not republish npm.

The ordinary lesson from his repo: index a git checkout, explore symbols, let the watcher keep up.

The extra lesson — why these mods exist — is a **two-consumer** machine:

1. An **operator**: unattended local models and tools. Still has a job when the CLI IDE is closed.
2. An **architect**: you in Cursor (or any MCP client). Skills, rules, notes.

They do not share a brain. They should not share a SQLite file or a writer UID.

## Order (do not skip)

| Step | What Colby already gives you | What the DLC adds |
| --- | --- | --- |
| 0 | `codegraph` binary, `init`, `index`, `explore` | Two roots, two `codegraph.json` ([00](../mods/00-split-horizon-core/PRODUCT.md)) |
| 1 | `serve --mcp --path` (one path, defaults to cwd) | Pin that path to the operator corpus, argv, not `${workspaceFolder}` ([01](../mods/01-pin-the-serve/PRODUCT.md)) |
| 2 | SQLite WAL | Writer UID = SQLite UID; refuse the wrong ROOT; never pkill owner serve ([02](../mods/02-writer-uid-fence/PRODUCT.md)) |
| 3 | `include` / `exclude` / gitignore | On a **non-git home**, include is additive; exclude is the fence; deprioritize is rank ([03](../mods/03-non-git-home-fence/PRODUCT.md)) |
| 4 | Native grammars | Map `.sh`/`.md` → twig, `.html` → xml; never `.env`/`.ini` ([04](../mods/04-extension-shims/PRODUCT.md)) |
| 5 | `explore` ranks symbols | Empty explore on scripts/docs is expected; `horizon-node` ([05](../mods/05-empty-explore-cli/PRODUCT.md)) |
| 6 | Watcher **on the served root** | `projectPath` has no watcher — architect timer ([06](../mods/06-architect-sync-timer/PRODUCT.md)) |
| 7 | — | Remind, do not spawn sync from the IDE ([07](../mods/07-remind-hook/PRODUCT.md)) |
| 8 | Engine `AGENTS.md` (contributors) | Use-path policy cards ([08](../mods/08-agent-protocol/PRODUCT.md)) |
| 9 | — | Index config YAML so agents can **find** it; never print values ([09](../mods/09-findability-not-fear/PRODUCT.md)) |
| 10 | Skip files > 1 MB | Still exclude live `*.db` / wal / sqlite ([10](../mods/10-blob-exclude/PRODUCT.md)) |
| 11 | Multi-`projectPath` | N corpora, still one serve ([11](../mods/11-n-root-unwatched/PRODUCT.md)) |
| 12 | — | Slow-disk first index, unlock only if lock PID dead ([12](../mods/12-slow-disk-first-index/PRODUCT.md)) |
| 13 | — | Refuse another host's CIFS/NFS ([13](../mods/13-foreign-mount-fence/PRODUCT.md)) |
| 14 | Watcher dies when serve dies | Owner-UID timer for the operator tree ([14](../mods/14-operator-own-sync/PRODUCT.md)) |

## Messenger, not oracle

The graph measures **symbols and callers**. Lexical FTS measures literals. ANN measures meaning. Pair them. Empty retrieval is not proof the file is missing. `codegraph files --format flat` is the census.

## Credit

MIT engine: Copyright (c) 2026 Colby Mchenry. Overlay: [NOTICE](../NOTICE). Courtesy note (unposted until public): [COLBY_ISSUE.md](COLBY_ISSUE.md).
