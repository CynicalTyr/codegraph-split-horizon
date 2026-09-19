# Split-horizon CodeGraph

I did not write CodeGraph. [ColbyMcHenry](https://github.com/colbymchenry/codegraph) did. `@colbymchenry/codegraph` is the engine I actually run. This repo is mu best attempt at a DLC; extra maps, fences, and a stubborn little installer for a setup. his README was never going to describe how I wanted to implement on my system; **two AI _consumers_ on one machine**.

I run 2 versions of Codegraph on my system and this is my way of giving back.
- Consumer 1 (The Operator) is the thing that lives directly on my system, when I close the CLI session after doing work my agent maintains codegraph processes. It's A local autonomous and 24/7 loop that maintains my network, performs agentic tasks and has its own phone number and email address for communication. It talks to and spawns on-box subagent AI/ML models I run locally on my system, it runs its own tools and it is supposed to find its own source without me babysitting `Grep` commands and token burn. For this publication repo lets call it the _"operator"_. 
- Consumer 2 (The Architect) is me and a CLI IDE agent (I use `cursor-cli` personally, but what I built will help with whatever IDE agent you have glued your codegraph MCP or skills to). We'll call that the _architect_. 
They do not share a brain. They should not share a SQLite file either. I learned that the expensive (token burning) way.

If you only have one git repo, one Unix user, and one way to task out and research your database, you probably just want Colby's docs and a single `codegraph_explore`. Steal my mods 04, 05, and 10 if scripts and databases still bite you. Otherwise pick a card from the [mod store](mods/README.md) like you are installing an addon, not reading a whitepaper.

How it complements [ColbyMcHenry](https://github.com/colbymchenry/codegraph) engine, in order: 
[docs/HOW_IT_WORKS.md](docs/HOW_IT_WORKS.md). 
Agents landing here: [HORIZON.md](HORIZON.md), then [mods/AGENT_INDEX.md](mods/AGENT_INDEX.md). 
[ColbyMcHenry](https://github.com/colbymchenry/codegraph) `AGENTS.md` is for people hacking the indexer. Different game I won't get into.

## What I actually use this for

Every day I ask the graph two different kinds of question.

The "operator" wants runtime code for the loop, the workers/subagents, and for the configs it is not allowed to guess. That index is the default `serve --mcp --path`. I pin it on purpose for the operator. `${workspaceFolder}` is a trap when the IDE opened the architect home. Explore looks healthy and still never saw the process that I may of changed or ran overnight. I thought initially CodeGraph was broken. but for me it was indexed on the wrong root.

The "architect" (myself and my IDE) wants skills, rules, hooks, and the notes I leave for the next session I have with it. That tree is always `projectPath`. No live watcher. If I forget to sync, yesterday's rule is dead. I do not run `codegraph sync` from an IDE hook. Two writers, one WAL, and a "flaky" timer that was not flaky 😆.

When the IDE or my idiot self (the "architects") typed `codegraph sync` on the operators tree (`/home/operator), SQLite would error readonly. And a leftover `*.db-wal` owned by the wrong user made the job codegraph just did look possessed. Essentially the writer UID equaled the SQLite UID. That is not in the "how to index a repo" pamphlet [ColbyMcHenry](https://github.com/colbymchenry/codegraph) had. It is however in this [mod 02](mods/02-writer-uid-fence/PRODUCT.md).

I also tested and tried `include` as a whitelist on a home directory. First `--force` started eating a dump of stale agent Python script. The fix is `include` addsand `exclude` fences in [Mod 03](mods/03-non-git-home-fence/PRODUCT.md).

Another thing with running AI is that it **loves* scripts and markdown which codegraph natively have zero symbols for after the 1.6.0 extension shim. This causes `explore` commands to go quiet. The fix I found for this are in [Mod 05](mods/05-empty-explore-cli/PRODUCT.md) and is `horizon-node`. I stopped querying `language:bash`.

I hid my operator identity YAML with a chown "for security." Then the next agent could not **find** the file. with my rabbit hole deep dive, keys belong in codegraph and the values do not belong in chat. [Mod 09](mods/09-findability-not-fear/PRODUCT.md) fixes this. Live `*.db` is not an Abstract Syntax Tree. [Mod 10](mods/10-blob-exclude/PRODUCT.md) explains this.

A third thing showed up most recently which led me to eventually start writing and documenting which turned into this repo. What happened was... I almost ran `codegraph init /`. yes the root. 😅 serve still has one `--path`. The extras are unwatched `projectPath`. [Mod 11](mods/11-n-root-unwatched/PRODUCT.md). First `--force` on a slow old HDD disk died under the watchdog and left a lock. If this happens unlock only if that PID is dead. [Mod 12](mods/12-slow-disk-first-index/PRODUCT.md). Another dumb find for me was 'CIFS'. A CIFS share of another computer is **not** a local codegraph. [Mod 13](mods/13-foreign-mount-fence/PRODUCT.md). If you close the session the operator watcher dies with the IDE. The architect timer (06) does not cover that tree. [Mod 14](mods/14-operator-own-sync/PRODUCT.md).

None of this replaces Colby's CodeGraph. I installed **his** binary. And I run it and my own `./horizon.sh`. I pick one mod. `--dry-run` until I can get it the way I want it. Here is an example if you or one of your own AI agents reading this want a starting place.

```bash
./horizon.sh list
./horizon.sh info 00-split-horizon-core
./horizon.sh install 00-split-horizon-core --dry-run \
  --operator-root /tmp/horizon-op --architect-home /tmp/horizon-arch
```

Ten minutes, including `codegraph init`: [START_HERE.md](START_HERE.md).

The full [CodeGraph](https://github.com/colbymchenry/codegraph) engine README (after this overlay sits on a fork) lives at [docs/ENGINE.md](docs/ENGINE.md). Read that for `codegraph_explore` itself. Read this page for the mods and DLC split to continue helping.

## Credit

MIT engine: Copyright (c) 2026 Colby Mchenry. I keep his `LICENSE`. I explicitly do not republish `@colbymchenry/codegraph` under another npm name and neither should you. Do not patch CodeGraph `src/` either. What [ColbyMcHenry](https://github.com/colbymchenry/codegraph) built is phenomenal IMHO. I just hope to be able to add to it as a humble observer who likes mods and gaming DLC's that enhance upon and tweak to other standards that others may have. 
