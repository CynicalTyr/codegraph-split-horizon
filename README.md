# Split-horizon CodeGraph

I did not write CodeGraph. [Colby McHenry](https://github.com/colbymchenry/codegraph) did. `@colbymchenry/codegraph` is the engine I actually run. This repo is my best attempt at DLC — extra maps, fences, and a stubborn little installer — for a setup his README was never going to describe: **two AI consumers on one machine**.

I do not run two versions of CodeGraph. I run **his** binary against **two graphs**. Same CLI, two SQLite files, two Unix writers. That is the whole trick, and it is how I am giving back.

- **Operator** — lives on the box. I close the CLI after a session and it keeps going. 24/7 loop. Maintains my network. Does agentic work. Has its own phone number and email. Spawns on-box subagent models I run locally. Has its own tools. It is supposed to find its own source without me babysitting `Grep` and lighting tokens on fire. For this repo, that process is the *operator*.
- **Architect** — me plus a CLI IDE agent. I use `cursor-cli`. The mods still apply if you glued CodeGraph MCP to something else. That pair is the *architect*.

They do not share a brain. They should not share a SQLite file. I learned that the token-burning way.

If you have one git repo, one Unix user, and one question, take Colby's docs and a single `codegraph_explore`. Steal my mods 04, 05, and 10 if scripts and live databases still bite you. Otherwise pick a card from the [mod store](mods/README.md) like you are installing an addon, not reading a whitepaper.

How it sits on his engine, in order: [docs/HOW_IT_WORKS.md](docs/HOW_IT_WORKS.md). Agents landing here: [HORIZON.md](HORIZON.md), then [mods/AGENT_INDEX.md](mods/AGENT_INDEX.md). His `AGENTS.md` is for people hacking the indexer. Different game. I will not get into it.

## What I actually use this for

Every day I ask the graph two different kinds of question.

The operator wants runtime code: the loop, the workers/subagents, the config it is not allowed to guess. That index is `serve --mcp --path` pointed at the operator tree. I pin it on purpose. Cursor defaulted me to `${workspaceFolder}`. That folder was the architect home. Explore looked healthy and still never saw the process I had changed overnight. I thought CodeGraph was broken. It was indexed on the wrong root.

The architect (me and the IDE) wants skills, rules, hooks, and the notes I leave for the next session. That tree is always `projectPath`. No live watcher. Forget to sync and yesterday's rule is dead. I do **not** run `codegraph sync` from an IDE hook. I tried the clever version. Two writers, one WAL, a "flaky" timer that was not flaky 😆

Then I did it by hand. Typed `codegraph sync` on the operator tree as myself. SQLite said readonly. A leftover `*.db-wal` owned by my UID sat next to a database owned by the operator user. The unattended job looked possessed. Writer UID has to **be** the SQLite UID. Colby's "how to index a repo" pamphlet does not say that. [Mod 02](mods/02-writer-uid-fence/PRODUCT.md) does. Also: do not `pkill` a live owner `serve --mcp`. That is the IDE watcher. Kill it and the architect thinks CodeGraph crashed.

I treated `include` as a whitelist on a home directory. First `--force` started eating a dump of stale agent Python — thousands of files that were not the corpus. `include` adds. `exclude` is the fence. [Mod 03](mods/03-non-git-home-fence/PRODUCT.md).

Agents love scripts and markdown. After the 1.6.0 extension shim those files often have **zero symbols**. `explore` goes quiet. I kept querying `language:bash` like the grammar existed. It does not. The files were in the index the whole time, stored as twig. [Mod 05](mods/05-empty-explore-cli/PRODUCT.md) is `horizon-node` — `files` plus `node --file` when explore shrugs.

I hid the operator identity YAML "for security" (yanked it from the graph, played with ownership). Next session the agent could not **find** the file. Keys belong in CodeGraph. Values do not belong in chat. [Mod 09](mods/09-findability-not-fear/PRODUCT.md). Live `*.db` is not an AST. I almost left chat/memory SQLite in so agents could "find the store." They found a multi-gig blob. [Mod 10](mods/10-blob-exclude/PRODUCT.md).

The thing that finally made me write this down: I almost ran `codegraph init /`. Yes, the root. 😅 His serve still has **one** `--path`. Extra trees are unwatched `projectPath`. [Mod 11](mods/11-n-root-unwatched/PRODUCT.md). First `--force` on a slow old HDD died under the watchdog and left a lock that looked cursed. Unlock only if that PID is dead. A live serve is not a stale lock. [Mod 12](mods/12-slow-disk-first-index/PRODUCT.md). Another dumb one: I pointed CodeGraph at a CIFS share of another computer and called it "the other box's graph." It was a slow copy of someone else's disk. [Mod 13](mods/13-foreign-mount-fence/PRODUCT.md). Close the CLI session and the operator watcher dies with the IDE. The architect timer (06) does not cover that tree. [Mod 14](mods/14-operator-own-sync/PRODUCT.md).

None of this replaces Colby's CodeGraph. I install **his** binary. I run `./horizon.sh`. I pick one mod. `--dry-run` until it looks like my machine. If you or an agent just landed here:

```bash
./horizon.sh list
./horizon.sh info 00-split-horizon-core
./horizon.sh install 00-split-horizon-core --dry-run \
  --operator-root /tmp/horizon-op --architect-home /tmp/horizon-arch
```

Ten minutes, including `codegraph init`: [START_HERE.md](START_HERE.md).

His engine README lives at [docs/ENGINE.md](docs/ENGINE.md) once this overlay sits on a clone. Read that for `codegraph_explore`. Read this page for the split.

## Credit

MIT engine: Copyright (c) 2026 Colby Mchenry. I keep his `LICENSE`. I do not republish `@colbymchenry/codegraph` under another npm name, and neither should you. Do not patch his `src/`. A fence was easier as a shell script.

What he built is phenomenal. I like mods and game DLC that tweak a thing other people already made. Overlay notes: [NOTICE](NOTICE). Optional coffee that does **not** fund his indexer: [SUPPORT.md](SUPPORT.md). Courtesy issue draft stays unposted until this repo is public: [docs/COLBY_ISSUE.md](docs/COLBY_ISSUE.md).
