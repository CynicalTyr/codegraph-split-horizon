# If you are an agent

You landed in a **complementary fork**. The indexer is Colby McHenry's CodeGraph (`@colbymchenry/codegraph` ≥ 1.6.0). This overlay is split-horizon DLC. Do not treat `AGENTS.md` in the repo root as your playbook — that file is for people contributing to the engine.

Curriculum (why each mod exists, in order): `../docs/HOW_IT_WORKS.md`. Two-screen map: `../HORIZON.md`.

## Do this, in order

1. Read `../HORIZON.md` (two screens). Then this file.
2. Parse `catalog.json`. Or run `./horizon.sh list` if you can execute.
3. Map the user's pain to **one** `id`. Do not install the whole pack.
4. `./horizon.sh info <id>` then `./horizon.sh install <id> --dry-run` with roots **the user named**. Never invent a home directory, LAN address, hostname, or UID.
5. After the user accepts `--apply`, run `./horizon.sh verify <id>`. Verify failure is the task. Do not Grep `src/` to "confirm."
6. Empty `codegraph_explore` on `.md` / `.sh` / `.html` is expected (zero symbols). Use mod `05-empty-explore-cli`. Never query `language:bash` or `language:html`.
7. Never edit `src/` or `codegraph-kernel/` for a split-horizon install. That is Colby's game.
8. YAML hits are keys. Do not print secret values from explore output.
9. MCP not connected: same CLI on that root (`explore`, `files`, `node --file`). Not a Glob survey.
10. Budget about three `explore` calls **per index**. Callers and blast radius are already in the response. A fourth is not banned by the engine; it is usually nodding.
11. After `codegraph.json` edits: `index --force`. `sync` loads file changes, not a new config. After file edits on an unwatched root: `sync` as the **owner UID of that DB**.
12. Do not spawn the indexer from an IDE hook (mod 07 reminds; it does not exec). Do not `pkill` a live owner `serve --mcp`.

## Pick table

| User says | Mod |
| --- | --- |
| two processes, IDE vs unattended operator | `00-split-horizon-core` |
| MCP answers from the wrong tree | `01-pin-the-serve` |
| readonly database / flaky timer after the architect synced | `02-writer-uid-fence` |
| first index ate a home directory | `03-non-git-home-fence` |
| scripts/docs missing from explore | `04-extension-shims` then `05-empty-explore-cli` |
| architect skills go stale | `06-architect-sync-timer` and/or `07-remind-hook` |
| agents keep Glob/Grep first | `08-agent-protocol` |
| cannot find identities/config through the graph | `09-findability-not-fear` |
| index ballooned on `*.db` | `10-blob-exclude` |
| third corpus / many trees / almost `init /` | `11-n-root-unwatched` |
| first `--force` on USB/SD/NFS died | `12-slow-disk-first-index` |
| almost indexed a CIFS/NFS share | `13-foreign-mount-fence` |
| operator graph stale after laptop-lid | `14-operator-own-sync` (needs 02) |

Each mod's `manifest.json` has `agent_summary`. Use that before PRODUCT.md unless the user asked why.

Budget: one mod per turn unless the user named a sequence. Generator stays off the evaluator — do not grade your own unread diff of their `codegraph.json`.
