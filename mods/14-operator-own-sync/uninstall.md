# Uninstall 14

`systemctl --user disable --now horizon-operator-sync.timer` if you enabled it. Delete the copies under `~/.config/systemd/user/` and `$OPERATOR/.horizon/systemd/horizon-operator-sync.*`.
