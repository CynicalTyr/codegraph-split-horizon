# Do not index live databases

We considered leaving `*.db` in so agents could "find the memory store." They found a multi-gigabyte SQLite file that is not an AST. Chat DBs, live memory stores, vector indexes — none of that belongs in CodeGraph.

1.6.0 skips files over 1 MB. Still exclude. A future grammar should not get a second chance to ingest them.

The graph is a messenger: symbols and callers. Lexical FTS and ANN/vector search are other instruments. Pair them. Do not substitute. Append your ANN suffix (`*.ann`, `*.faiss`, or whatever you actually have) to exclude yourself.

Ten-minute outcome: operator `codegraph.json` exclude list unions in db/wal/shm/sqlite.
