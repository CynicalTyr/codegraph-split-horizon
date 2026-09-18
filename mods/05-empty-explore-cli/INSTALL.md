# Install 05-empty-explore-cli

```bash
./horizon.sh install 05-empty-explore-cli --dry-run --operator-root /opt/operator
./horizon.sh install 05-empty-explore-cli --apply --operator-root /opt/operator
/opt/operator/bin/horizon-node /opt/operator sample_probe.py
# after 00+04, also:
/opt/operator/bin/horizon-node "$HOME/architect" ARCHITECT_NOTES.md
./horizon.sh verify 05-empty-explore-cli --operator-root /opt/operator
```

You messed up if you queried `language:bash` and then told the user CodeGraph cannot see shell.
