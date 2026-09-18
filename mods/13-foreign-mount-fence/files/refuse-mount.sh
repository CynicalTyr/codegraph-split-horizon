#!/usr/bin/env bash
# Refuse CodeGraph on another host's network filesystem.
set -euo pipefail
ROOT="${1:?usage: refuse-mount.sh ROOT}"
ROOT="$(cd "$ROOT" && pwd)"
if ! command -v findmnt >/dev/null 2>&1; then
  echo "refuse-mount: findmnt missing; cannot prove the mount type" >&2
  exit 2
fi
fstype="$(findmnt -n -o FSTYPE -T "$ROOT" 2>/dev/null || true)"
case "$fstype" in
  cifs|nfs|nfs4|fuse.sshfs|fuse.rclone|smbfs)
    echo "refuse: $ROOT is $fstype (another host's disk). index it on that host. exit 2" >&2
    exit 2
    ;;
esac
echo "ok: $ROOT fstype=${fstype:-unknown}"
exit 0
