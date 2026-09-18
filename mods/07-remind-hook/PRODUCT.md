# Remind only

We almost put `codegraph sync` in a Cursor hook. Two processes, one WAL, a locked database that looked like a crash.

The hook should **print**. The architect still runs sync (or the timer in mod 06) as themselves, on their tree, when they mean to.

Ten-minute outcome: `codegraph-sync-remind.sh` plus a one-line snippet for `hooks.json`. You wire the event. We do not overwrite your whole hooks file.
