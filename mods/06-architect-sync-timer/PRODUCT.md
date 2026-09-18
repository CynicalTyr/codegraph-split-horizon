# No watcher on projectPath

The operator corpus can have `serve --mcp` plus a timer. The architect tree, queried only through `projectPath`, does **not**. Skills and rules you edited this morning stay invisible until someone runs `codegraph sync` as the architect UID.

We added a user-bus timer. Same cadence as the operator job is fine (twice a day is enough if you also have a remind-hook). Do not also spawn sync from a Cursor hook. Two writers, one WAL.

`Linger=yes` if you want it after logout. SD cards and USB: first index with `CODEGRAPH_NO_WATCHDOG=1`. `unlock` only when the lock PID is dead.

Ten-minute outcome: unit templates under the architect home `.horizon/systemd/`. You copy them into `~/.config/systemd/user/` yourself. The installer does not enable lingering on your machine.
