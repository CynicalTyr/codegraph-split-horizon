# Install 02-writer-uid-fence

```bash
./horizon.sh install 02-writer-uid-fence --dry-run --operator-root /opt/operator
./horizon.sh install 02-writer-uid-fence --apply --operator-root /opt/operator
chmod +x /opt/operator/bin/codegraph-as-owner.sh

# must fail
/opt/operator/bin/codegraph-as-owner.sh /tmp || echo "exit $? (want 2)"

# as the owner user, against the operator root only
sudo -u operator /opt/operator/bin/codegraph-as-owner.sh /opt/operator
```

Architect habit: never `codegraph sync /opt/operator` as yourself. Never `codegraph files --path` / `node --file` the operator tree as the architect user (or the reverse). Call the wrapper, or don't touch that tree from the IDE at all (mod 07).

Colby's 1.6.0 MCP daemon likes one watcher and one SQLite. Two UIDs sharing one daemon is how you get SQLITE_BUSY. Pin distinct `serve --path`. `CODEGRAPH_NO_DAEMON=1` is a researched option, not a silent default.

`./horizon.sh verify 02-writer-uid-fence --operator-root /opt/operator`

You messed up if the wrapper's ALLOW_ROOT was edited to `$HOME`. That is how you eat the architect index.
