# Install 14-operator-own-sync

Need mod 02 first (`codegraph-as-owner.sh`).

```bash
./horizon.sh install 02-writer-uid-fence --apply --operator-root /opt/operator
./horizon.sh install 14-operator-own-sync --dry-run --operator-root /opt/operator
./horizon.sh install 14-operator-own-sync --apply --operator-root /opt/operator
# as the owner user:
mkdir -p ~/.config/systemd/user
cp /opt/operator/.horizon/systemd/*.{service,timer} ~/.config/systemd/user/
systemctl --user daemon-reload
systemctl --user enable --now horizon-operator-sync.timer
# linger checklist: loginctl show-user "$USER" | grep Linger
./horizon.sh verify 14-operator-own-sync --operator-root /opt/operator
```

You messed up if this timer calls bare `codegraph sync` as the architect.
