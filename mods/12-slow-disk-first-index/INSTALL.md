# Install 12-slow-disk-first-index

```bash
./horizon.sh install 12-slow-disk-first-index --dry-run --operator-root /opt/operator
./horizon.sh install 12-slow-disk-first-index --apply --operator-root /opt/operator
# as the owner UID, after codegraph init:
/opt/operator/bin/first-index.sh /opt/operator
./horizon.sh verify 12-slow-disk-first-index --operator-root /opt/operator
```

If a lock file remains: `ps` the PID. Dead → `codegraph unlock --path /opt/operator`. Alive → that is a live serve. Do not unlock. Do not pkill (mod 02).
