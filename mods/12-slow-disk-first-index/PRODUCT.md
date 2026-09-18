# Slow disk, first index

The first `index --force` on USB, SD, or NFS can sit in a watchdog long enough that CodeGraph SIGKILLs itself and leaves a stale lock. The next run looks cursed. It is a censored census, not a flaky engine.

`CODEGRAPH_NO_WATCHDOG=1` for that first pass. `codegraph unlock` only if the lock PID is **dead**. A live owner `serve --mcp` is not a stale lock (mod 02).

What this will not do: tune your filesystem. It will not enable linger. It is not the architect timer (06).

Ten-minute outcome: `bin/first-index.sh` in the operator root. You run it as the DB owner.
