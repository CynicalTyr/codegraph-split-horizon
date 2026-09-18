# Install 13-foreign-mount-fence

```bash
./horizon.sh install 13-foreign-mount-fence --dry-run --operator-root /opt/operator
./horizon.sh install 13-foreign-mount-fence --apply --operator-root /opt/operator
/opt/operator/bin/refuse-mount.sh /opt/operator
./horizon.sh verify 13-foreign-mount-fence --operator-root /opt/operator
```

You messed up if you `codegraph init` a `/media/...` share of another computer from this host.
