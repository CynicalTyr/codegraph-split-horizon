# Uninstall 06

```bash
systemctl --user disable --now horizon-architect-sync.timer || true
rm -f ~/.config/systemd/user/horizon-architect-sync.{service,timer}
systemctl --user daemon-reload
```

Leave `$ARCHITECT/.horizon/systemd/` or delete it. Do not `rm -rf` the architect index.
