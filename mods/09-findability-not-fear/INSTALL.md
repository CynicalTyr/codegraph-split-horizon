# Install 09-findability-not-fear

```bash
./horizon.sh install 09-findability-not-fear --dry-run --operator-root /opt/operator
./horizon.sh install 09-findability-not-fear --apply --operator-root /opt/operator
codegraph index --force /opt/operator
./horizon.sh verify 09-findability-not-fear --operator-root /opt/operator
```

Optional: `HORIZON_KEEP_YAML=ledger.yaml,routing.yaml` on install strips those basenames from exclude if you had cargo-culted them there.

You messed up if the identity-ledger YAML (your filename) is in `exclude` and agents keep asking where the file lives.
