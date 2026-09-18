# Two graphs

We ran one CodeGraph against the folder the CLI IDE opened. The unattended operator — the local autonomous/ML process that actually lives on the box — keeps its source in a different tree. Explore looked healthy and still missed operator runtime modules, or it drowned in architect dump (plugin caches, old plans, nested checkouts).

The counterintuitive bit: **two SQLite files is cheaper than one clever index.** 1.6.0 gives you one `serve --mcp --path`. Everything else is `projectPath` (MCP) or `--path` (CLI). There is no multi-`--path`. Merge the DBs and you cannot tell whose WAL you just corrupted.

We named the two consumers:

- **Operator** — persistent local process. Indexes the corpus it must not guess.
- **Architect** — Cursor (or any IDE harness). Indexes skills, rules, hooks, runbooks. Must not sit in the operator inner loop.

If you only have one git repo and one Unix user, skip this pack. Install 04/05/10 if scripts and databases still bite you.

What this will not do: start the MCP server, pick your paths, or teach you what an AST is.

Ten-minute outcome: two directories, two `codegraph.json` skeletons, a tiny Python file in the operator tree and a markdown note in the architect tree. `horizon.sh doctor` sees both configs.
