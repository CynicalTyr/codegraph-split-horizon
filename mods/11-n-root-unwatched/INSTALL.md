# Install 11-n-root-unwatched

```bash
./horizon.sh install 11-n-root-unwatched --dry-run --operator-root /opt/operator
./horizon.sh install 11-n-root-unwatched --apply --operator-root /opt/operator
# edit /opt/operator/.horizon/NROOT.md — your extra paths, not ours
./horizon.sh verify 11-n-root-unwatched --operator-root /opt/operator
```

You messed up if you started a second `serve --mcp` for the extra tree instead of `projectPath`.
