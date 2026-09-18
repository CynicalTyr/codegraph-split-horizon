# Install 06-architect-sync-timer

```bash
./horizon.sh install 06-architect-sync-timer --dry-run \
  --architect-home "$HOME/architect"

./horizon.sh install 06-architect-sync-timer --apply \
  --architect-home "$HOME/architect"

# then, as the architect user:
mkdir -p ~/.config/systemd/user
cp "$HOME/architect/.horizon/systemd/"*.{service,timer} ~/.config/systemd/user/
systemctl --user daemon-reload
systemctl --user enable --now horizon-architect-sync.timer
# Linger checklist (do not enable unless you mean it):
#   loginctl show-user "$USER" | grep Linger
#   loginctl enable-linger "$USER"   # only if sync must run after logout
./horizon.sh verify 06-architect-sync-timer --architect-home "$HOME/architect"
```

Cron fallback is in the same directory (`cron.stanza`). Prefer systemd if you have it.

You messed up if the timer runs `codegraph sync` on the **operator** tree as the architect user. That is mod 02's disaster.
