# Pin the serve

CodeGraph 1.6.0 will happily serve whatever directory you handed `serve --mcp --path`. Cursor defaults people to `${workspaceFolder}`. On a split box that folder is the architect home. Every explore then answers from skills and misses the operator.

We watched agents conclude "CodeGraph is broken" for a week. The graph was fine. It was indexed on the wrong root.

`projectPath` still works for the architect tree. It has **no live watcher**. That is a different mod (06). This one only fixes the default.

The sudo variant exists because WAL is not a shared toy. If a service user owns the operator DB, the MCP child must run as that user. The snippet is argv (`command` + `args`). It does not wrap the path in `bash -lc`.

Every MCP client on the box must pin the same path and the same owner UID. Cursor, Claude, a stack sidecar — one serve root. A second client pointed at the architect home is how explore "breaks" again.

What this will not do: invent your MCP schema (Cursor vs Claude vs other). We write a stdio block under key `codegraph`. You paste if `--mcp-file` is the wrong shape. Apply without `--mcp-file` still writes the sidecar under the operator `.horizon/` directory. Existing pins that mention `codegraph` but point at the wrong path are refused unless `--replace-mcp`.

Ten-minute outcome: a snippet file plus, with `--apply --mcp-file`, a merged server entry whose args `--path` **equals** the operator root and does not contain `${workspaceFolder}` or `bash -lc`.
