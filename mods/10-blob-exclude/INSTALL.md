# Install 10-blob-exclude

```bash
./horizon.sh install 10-blob-exclude --dry-run --operator-root /opt/operator
./horizon.sh install 10-blob-exclude --apply --operator-root /opt/operator
# edit exclude if your vector files use another suffix
codegraph index --force /opt/operator
./horizon.sh verify 10-blob-exclude --operator-root /opt/operator
```
