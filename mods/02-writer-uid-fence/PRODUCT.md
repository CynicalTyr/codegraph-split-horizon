# Writer UID = SQLite UID

The architect edited files as themselves, then typed `codegraph sync` on the operator tree. SQLite answered `attempt to write a readonly database`. A leftover `*.db-wal` owned by the wrong user made the operator timer look flaky. It wasn't flaky. We had two writers.

NAS-style hosts where one login both edits and indexes never see this. Split-horizon hosts do, every time someone "just syncs it."

Fail closed:

- Refuse a ROOT that is not the allowlisted operator path (exit 2). Pointing the operator wrapper at the architect `.codegraph` smashes CLI version caches.
- Never `pkill` a live `serve --mcp` owned by the operator. That is the Cursor/MCP watcher. Kill it and the architect thinks CodeGraph crashed.
- If this UID is not the database owner, exit 2. Writer UID equals SQLite UID.
- If owner `serve --mcp` is already live for ALLOW_ROOT, **skip** (exit 0). Do not `exec sync` as someone else.
- Never `files --path` / `node --file` the **other** tree as the wrong UID. That steals the unwatched WAL the same way `sync` does.
- Repair foreign WAL only with `--repair-wal`. Default is talk, not smash. Unlock only if the lock PID is dead.

Colby also has a shared MCP daemon. Two `serve --mcp --path` processes on one box can surprise you. Research `CODEGRAPH_NO_DAEMON` / one serve per corpus before you invent a second daemon. This wrapper does not change his default.

What this will not do: sudoers policy, setuid, or chown of an existing DB. You still `chown` the index to the service user once, by hand, after you understand which files are yours.

Ten-minute outcome: `bin/codegraph-as-owner.sh` in the operator root. Dry-run a wrong ROOT and watch exit 2.
