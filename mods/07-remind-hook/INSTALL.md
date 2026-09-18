# Install 07-remind-hook

```bash
./horizon.sh install 07-remind-hook --dry-run --architect-home "$HOME/architect"
./horizon.sh install 07-remind-hook --apply --architect-home "$HOME/architect"
# copy the script into your Cursor hooks dir, then add the json line from
# $HOME/architect/.horizon/hooks/hooks.snippet.json
./horizon.sh verify 07-remind-hook --architect-home "$HOME/architect"
```

You messed up if the script contains `exec codegraph` or `codegraph sync`.
