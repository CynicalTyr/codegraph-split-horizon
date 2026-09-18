# Install 04-extension-shims

Works on a single git root too (`--operator-root` is just "the tree").

```bash
./horizon.sh install 04-extension-shims --dry-run --operator-root /opt/operator
./horizon.sh install 04-extension-shims --apply --operator-root /opt/operator
codegraph index --force /opt/operator
./horizon.sh verify 04-extension-shims --operator-root /opt/operator
```

You messed up if you also mapped `.env` "so agents can see names." Use 09 for findability of YAML config. Leave env files on disk, out of the graph.
