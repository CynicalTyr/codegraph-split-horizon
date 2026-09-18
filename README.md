# Split-horizon CodeGraph

I did not write CodeGraph. [Colby McHenry](https://github.com/colbymchenry/codegraph) did. `@colbymchenry/codegraph` is the engine I actually run. This repo is DLC — extra maps, fences, and a stubborn little installer — for a setup his README was never going to describe: **two consumers on one machine**.

One consumer is the thing that lives here when I close the laptop lid. A local autonomous loop. It talks to on-box ML models, it has tools, it is supposed to find its own source without me babysitting Grep. Call it the operator. The other consumer is me in a CLI IDE (Cursor, or whoever you glued MCP to). Call that the architect. They do not share a brain. They should not share a SQLite file either. I learned that the expensive way.

If you only have one git repo, one Unix user, and one question, you probably want Colby's docs and a single `codegraph_explore`. Steal mods 04, 05, and 10 if scripts and databases still bite you. Otherwise pick a card from the [mod store](mods/README.md) like you are installing an addon, not reading a whitepaper.

How it complements his engine, in order: [docs/HOW_IT_WORKS.md](docs/HOW_IT_WORKS.md). Agents landing here: [HORIZON.md](HORIZON.md), then [mods/AGENT_INDEX.md](mods/AGENT_INDEX.md). His `AGENTS.md` is for people hacking the indexer. Different game.

## What I actually use this for

Every day I ask the graph two different kinds of question.

The operator wants runtime code — the loop, the workers, the config it is not allowed to guess. That index is the default `serve --mcp --path`. I pin it there on purpose. `${workspaceFolder}` is a trap when the IDE opened the architect home. Explore looks healthy and still never saw the process that runs overnight. I thought CodeGraph was broken. It was indexed on the wrong root.

The architect wants skills, rules, hooks, the notes I leave for the next session. That tree is always `projectPath`. No live watcher. If I forget to sync, yesterday's rule is a ghost. I do not run `codegraph sync` from an IDE hook. Two writers, one WAL, a "flaky" timer that was not flaky.

When the architect typed `codegraph sync` on the operator tree, SQLite said readonly. A leftover `*.db-wal` owned by the wrong user made the unattended job look possessed. Writer UID equals SQLite UID. That is not in the "how to index a repo" pamphlet. It is in [mod 02](mods/02-writer-uid-fence/PRODUCT.md).

I also tried `include` as a whitelist on a home directory. First `--force` started eating a dump of stale agent Python. `include` adds. `exclude` fences. [Mod 03](mods/03-non-git-home-fence/PRODUCT.md).

Scripts and markdown often have zero symbols after the 1.6.0 extension shim. Explore goes quiet. The files are in the index. [Mod 05](mods/05-empty-explore-cli/PRODUCT.md) is `horizon-node`. I stopped querying `language:bash` like a rube.

I hid the identity YAML "for safety." The next agent could not **find** the file. Keys belong in the graph. Values do not belong in chat. [Mod 09](mods/09-findability-not-fear/PRODUCT.md). Live `*.db` is not an AST. [Mod 10](mods/10-blob-exclude/PRODUCT.md).

A third corpus showed up. I almost ran `codegraph init /`. His serve still has one `--path`. The extras are unwatched `projectPath`. [Mod 11](mods/11-n-root-unwatched/PRODUCT.md). First `--force` on a slow disk died under the watchdog and left a lock that looked cursed. Unlock only if that PID is dead. [Mod 12](mods/12-slow-disk-first-index/PRODUCT.md). A CIFS share of another computer is not a local graph. [Mod 13](mods/13-foreign-mount-fence/PRODUCT.md). Close the lid and the operator watcher dies with the IDE. The architect timer (06) does not cover that tree. [Mod 14](mods/14-operator-own-sync/PRODUCT.md).

None of this replaces Colby. I install **his** binary. I run `./horizon.sh`. I pick one mod. `--dry-run` until I mean it.

```bash
./horizon.sh list
./horizon.sh info 00-split-horizon-core
./horizon.sh install 00-split-horizon-core --dry-run \
  --operator-root /tmp/horizon-op --architect-home /tmp/horizon-arch
```

Ten minutes, including `codegraph init`: [START_HERE.md](START_HERE.md).

Colby's full engine README (after this overlay sits on a fork) lives at [docs/ENGINE.md](docs/ENGINE.md). Read that for `codegraph_explore` itself. Read this page for the split.

## Credit

MIT engine: Copyright (c) 2026 Colby Mchenry. I keep his `LICENSE`. I do not republish `@colbymchenry/codegraph` under another npm name. I do not patch `src/` because a fence was easier as a shell script.

When this pack is public I will open a courtesy issue on his repo — field notes, engine unchanged, link back. Not a twenty-file docs PR. Draft: [docs/COLBY_ISSUE.md](docs/COLBY_ISSUE.md). Not posted yet.

Overlay scripts and these notes: [NOTICE](NOTICE). Optional coffee that does not fund his indexer: [SUPPORT.md](SUPPORT.md).
