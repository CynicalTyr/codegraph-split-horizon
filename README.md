# Split-horizon CodeGraph

I did not write CodeGraph. [Colby McHenry](https://github.com/colbymchenry/codegraph) did. `@colbymchenry/codegraph` is the engine I actually run. This repo is my best attempt at DLC, extra maps, enhancement, and an extra little installer, for a setup the default `@colbymchenry/codegraph` README was never going to describe: **two AI consumers (an IDE and locally running AI agents/models) on one machine**.

I do not run two versions of CodeGraph. I instead run the standard [CodeGraph](https://github.com/colbymchenry/codegraph) binary against **two graphs**. Same CLI, two SQLite files, and two Unix admins/writers. That is why I made this [CynicalTyr/codegraph-split-horizon](https://github.com/CynicalTyr/codegraph-split-horizon).

- **Operator** — lives autonomously on the machine. I close the CLI after a session and it keeps going. 24/7 loop. Maintains my network. Does agentic work. Has its own phone number and email. Spawns on-box subagent models that run locally. It has its own tools, MCP's, and is supposed to find its own source information without me babysitting `Grep` and burning tokens for no reason. For this repo, that process is the *operator*.
- **Architect** — me plus a CLI IDE agent. I use `cursor-cli` personally. The mods I have here still apply if you glued CodeGraph to Claude, Gemini, or something else. This I call the *architect*.

The *operator* and *architect* do not share a brain. They should not share a SQLite file. I learned that the hard way when setting input/output tokens on 🔥*Fire*.

If you only have one git repo, Unix user that manages everything, and one system AI or just you to explore, take Colby's docs and a single `codegraph_explore`. But feel free to steal my mods 04, 05, and 10 if the default [CodeGraph](https://github.com/colbymchenry/codegraph) scripts and live databases still give issue when searching for things. Otherwise pick your adventure from my [mod store](mods/README.md) like you are installing an addon or a DLC to enhance what [Colby McHenry](https://github.com/colbymchenry/codegraph) built.

How it works, in order: [docs/HOW_IT_WORKS.md](docs/HOW_IT_WORKS.md). 
Agents landing here: [HORIZON.md](HORIZON.md), then [mods/AGENT_INDEX.md](mods/AGENT_INDEX.md). Colby's `AGENTS.md` is for people hacking the indexer. Different game. I will not get into it or provide that here.

## What I actually use this for

Every day I ask the graph two different kinds of questions.

The operator wants runtime code: the loop, the workers/subagents, the config it is not allowed to guess. That index is `serve --mcp --path` pointed at the operator tree. I pin it on purpose. My CLI IDE (architect) defaulted me to `${workspaceFolder}` home when I'd work with my IDE to build and enhance my local operator agent and/or subagents that I run. Codegraph Explore overall looked healthy and still never saw the process I had changed or modified. I thought CodeGraph was broken. It was instead being indexed on the wrong root Unix admin.

The architect (me and the IDE) wants your typical custom skills, rules, hooks, and the admin notes I leave for the next IDE session. That tree is always `projectPath`. No live watcher. Forget to sync this and yesterday's rule is dead. I do **not** run `codegraph sync` from an IDE hook. I tried to be clever with it. Two writers, one WAL and a "flaky" timer that was not flaky 😆

Then I did it by hand. Typed `codegraph sync` on the operator tree as myself. SQLite said readonly. A leftover `*.db-wal` owned by my UID sat next to a database owned by the operator user. The unattended job looked possessed. Writer UID has to **be** the SQLite UID. Colby's "how to index a repo" pamphlet does not say that. [Mod 02](mods/02-writer-uid-fence/PRODUCT.md) does and is intended to help. Also: do not `pkill` a live owner `serve --mcp`. That is the IDE watcher. Kill it and the architect thinks CodeGraph crashed and you're back to the beginning.

I treated `include` as a whitelist on a home directory. First `--force` started eating a dump of stale agent Python configs ("No papa") and thousands of files that were not the corpus. `include` adds. `exclude` is the fence. [Mod 03](mods/03-non-git-home-fence/PRODUCT.md) aims to clean this up.

Agents (Local models or your flavor of Cursor/Claude/Gemini) love scripts and markdown. After the 1.6.0 extension shim those files often have **zero symbols**. `explore` turns into a funeral. I kept querying `language:bash` like the grammar existed. It does not 🫠. The files were in the index the whole time, I stored them as twig and explain in [Mod 05](mods/05-empty-explore-cli/PRODUCT.md). This is `horizon-node` + `files` + `node --file` so when explore flakes on you as much as a millennial older than 30 at 9PM you have the receipts where they are now.

I hid the operator identity YAML "for security" from my IDE architect (yanked it from the graph, played with ownership). Next session the agent could not **find** the file. Keys belong in CodeGraph. Values do not belong in chat. [Mod 09](mods/09-findability-not-fear/PRODUCT.md). Live `*.db` is not an AST. I almost left chat/memory SQLite in so agents could "find the identity store." Instead they found a multi-gig blob. How to address that is [Mod 10](mods/10-blob-exclude/PRODUCT.md).

The thing that finally made me write this down: I almost ran `codegraph init /`. Yes, the root. 😅 serve still has **one** `--path`. Extra trees are unwatched `projectPath`. [Mod 11](mods/11-n-root-unwatched/PRODUCT.md). First `--force` on a slow old HDD died under the watchdog and left a lock that looked cursed. Unlock only if that PID is dead. A live serve is not a stale lock. [Mod 12](mods/12-slow-disk-first-index/PRODUCT.md). Another dumb one: I pointed CodeGraph at a CIFS share of another computer and called it "the other box's graph." It was a slow copy of trash from another disk. [Mod 13](mods/13-foreign-mount-fence/PRODUCT.md) addresses this for you if you choose this path. Close the CLI session and the operator watcher dies with the IDE. The architect timer (06) does not cover that tree. [Mod 14](mods/14-operator-own-sync/PRODUCT.md) does and here to help.

None of this replaces Colby's CodeGraph. I install **his** binary. I run `./horizon.sh`. I pick one mod. `--dry-run` until it looks like how I want my machine, system, operator and IDE to run and build onto it. If you or your own AI agent just found this repo and pull it here ya go:

```bash
./horizon.sh list
./horizon.sh info 00-split-horizon-core
./horizon.sh install 00-split-horizon-core --dry-run \
  --operator-root /tmp/horizon-op --architect-home /tmp/horizon-arch
```

Ten minutes, including `codegraph init`: [START_HERE.md](START_HERE.md).

Colby's engine README lives at [docs/ENGINE.md](docs/ENGINE.md) and [CodeGraph](https://github.com/colbymchenry/codegraph) once this overlay sits on your box. Learn that for `codegraph_explore`. Read and learn these mods for the split and DLC to help make it easier if you run into challenges with multi Unix and multi IDE claw-type or Frontier cursor-claude type and your own autonomous agents in your stack.

## Credit

MIT engine: Copyright (c) 2026 Colby Mchenry. I keep his `LICENSE`. I do not republish `@colbymchenry/codegraph` under another npm name, and neither should you. Do not patch his `src/`. What [Colby McHenry](https://github.com/colbymchenry/codegraph) built is phenomenal. I like mods and game DLC's that tweak a thing other people already made. 

Overlay notes: [NOTICE](NOTICE). Optional coffee that does **not** fund his indexer: [SUPPORT.md](SUPPORT.md). 